//
//  MainViewController.m
//  LocationAlarm
//
//  Created by 张辉 on 15-3-23.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "MainVC.h"
#import "BMapKit.h"

@interface MainVC ()<BMKGeneralDelegate>

@property (nonatomic,strong) BMKMapManager *mapManager;

@end

@implementation MainVC

-(id)init{
    self = [super init];
    if (self) {
        [self initMap];
    }
    return self;
}

-(void)initMap{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"OIXcyU6HLb634ZPbZynRv3DS" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = mapView;
}

#pragma mark - BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError{
    
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError{
    
}

-(void)dealloc{
    NSLog(@"MainVC dealloc");
}

@end
