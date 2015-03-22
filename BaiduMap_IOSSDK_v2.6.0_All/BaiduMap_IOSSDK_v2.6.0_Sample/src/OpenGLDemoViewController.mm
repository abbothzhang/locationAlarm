//
//  OpenGLDemoViewController.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-14.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "OpenGLDemoViewController.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

typedef struct {
    GLfloat x;
    GLfloat y;
}GLPoint;

@interface OpenGLDemoViewController () {
    GLPoint glPoint[4];
    BOOL mapDidFinishLoad;
    
    CLLocationCoordinate2D coords[4];
}

@end

@implementation OpenGLDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mapDidFinishLoad = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark - BMKMapViewDelegate

/**
 *地图初始化完毕时会调用此接口
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    
    coords[0].latitude = 39.965;
    coords[0].longitude = 116.604;
    coords[1].latitude = 39.865;
    coords[1].longitude = 116.604;
    coords[2].latitude = 39.865;
    coords[2].longitude = 116.704;

    coords[3].latitude = 39.965;
    coords[3].longitude = 116.704;
    
    mapDidFinishLoad = YES;
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapview 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    NSLog(@"onDrawMapFrame");
    /*
     *do openGL render
     */
    if (mapDidFinishLoad) {
        [self glRender:status];
    }
}

- (void)glRender:(BMKMapStatus *)status {
    BMKMapPoint centerPoint = BMKMapPointForCoordinate(status.targetGeoPt);
    const CGFloat *components = CGColorGetComponents([UIColor redColor].CGColor);
    CGFloat red,green,blue,alpha;
    red = components[0];
    green = components[1];
    blue = components[2];
    alpha = components[3];
    //坐标系原点为地图中心点，此处转换坐标为相对坐标
    for (NSInteger i = 0; i < 4; i++) {
        BMKMapPoint pt = BMKMapPointForCoordinate(coords[i]);
        GLPoint glpt;
        glpt.x = pt.x - centerPoint.x;
        glpt.y = -pt.y + centerPoint.y;
        glPoint[i] = glpt;
    }
    //获取缩放比例，18级比例尺为1:1基准
    float fZoomUnites = pow(2.f, 18.f - status.fLevel );
    
    glPushMatrix();
    glRotatef(status.fOverlooking, 1.0f, 0.0f, 0.0f);
    glRotatef(status.fRotation, 0.0f, 0.0f, 1.0f);
    
    fZoomUnites = 1/fZoomUnites;
    //缩放使随地图放大或缩小
    glScalef( fZoomUnites, fZoomUnites, fZoomUnites );
    glEnableClientState (GL_VERTEX_ARRAY);
    glEnable( GL_BLEND );
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

    glColor4f(red, green, blue, alpha);
    glVertexPointer(2, GL_FLOAT, 0, glPoint);
    //绘制的点个数
    glDrawArrays( GL_TRIANGLE_FAN, 0, 4);

    glDisable( GL_BLEND );
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
    glColor4f( 1.0, 1.0, 1.0, 1.0 );
}

@end
