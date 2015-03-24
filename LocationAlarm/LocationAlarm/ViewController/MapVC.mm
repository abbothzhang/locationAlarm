//
//  MainViewController.m
//  LocationAlarm
//
//  Created by 张辉 on 15-3-23.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "MapVC.h"
#import "BMapKit.h"

@interface MapVC ()<BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic,strong) BMKMapManager      *mapManager;
@property (nonatomic,strong) BMKMapView         *mapView;
@property (nonatomic,strong) BMKLocationService *locService;

@property (nonatomic) BOOL                      fristSetCenter;

@end

@implementation MapVC

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

-(void)viewWillAppear:(BOOL)animated{
    
    [self.mapView viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.mapView];
    _fristSetCenter = NO;
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
    
}

-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    return _mapView;
}


#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    if (!_fristSetCenter) {
        _mapView.centerCoordinate = userLocation.location.coordinate;
        _fristSetCenter = YES;
    }
    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}





#pragma mark - BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


-(void)dealloc{
    NSLog(@"MainVC dealloc");
}

@end
