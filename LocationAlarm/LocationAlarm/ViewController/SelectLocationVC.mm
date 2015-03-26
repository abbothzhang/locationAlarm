//
//  SelectLocationVC.m
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "SelectLocationVC.h"
#import "BMapKit.h"
#import "UserLocationInfo.h"
#import "Utils.h"
#import "SetDistanceVC.h"
#import "AlarmInfo.h"

@interface SelectLocationVC ()<BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,UISearchBarDelegate>

@property (nonatomic,strong) BMKMapManager      *mapManager;
@property (nonatomic,strong) BMKMapView         *mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKPoiSearch       *poiSearch;

@property (nonatomic) BOOL                      fristSetCenter;

@end

@implementation SelectLocationVC

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
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _poiSearch.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择闹钟提醒的地方";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:nil target:self action:@selector()];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.mapView.delegate = self;//记得不用的时候需要置nil，否则影响内存的释放
    [self.view addSubview:self.mapView];
    _fristSetCenter = NO;
    _locService = [[BMKLocationService alloc]init];
    //定位
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
    //设置缩放，数值越大，代表显示的越细
    self.mapView.zoomLevel = 14;
    
    //init poiSearch
    _poiSearch = [[BMKPoiSearch alloc] init];
    _poiSearch.delegate = self;
    //init searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 35)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    [self.view addSubview:searchBar];
    
}

//-(BMKMapView *)mapView{
//    if (!_mapView) {
//        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 700)];
//        _mapView.delegate = self;//记得不用的时候需要置nil，否则影响内存的释放
//    }
//    return _mapView;
//}

#pragma mark - BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorGreen;
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        // 设置可拖拽
        annotationView.draggable = NO;
    }
    return annotationView;
}
/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{

}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    AlarmInfo *alarmInfo = [[AlarmInfo alloc] init];
    alarmInfo.locationName = view.annotation.title;
    alarmInfo.latitude = view.annotation.coordinate.latitude;
    alarmInfo.longtitude = view.annotation.coordinate.longitude;
    
    SetDistanceVC *distanceVC = [[SetDistanceVC alloc] initWithAlarmInfo:alarmInfo];
    [self.navigationController pushViewController:distanceVC animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.city= [UserLocationInfo sharedInstance].city;
    citySearchOption.keyword = searchBar.text;
    BOOL flag = [_poiSearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}




#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle = @"点击跳转设置提醒距离";
            [_mapView addAnnotation:item];
            if(i == 0){
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
                double userLon = [UserLocationInfo sharedInstance].longtitude;
                double userLat = [UserLocationInfo sharedInstance].latitude;
                double distance = [Utils distanceBetweenOrderByLat1:userLat lng1:userLon lat2:poi.pt.latitude lng2:poi.pt.longitude];
                
            }
        }
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    
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
        
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error)
         {
             CLPlacemark *mark=[placemark objectAtIndex:0];
             //             place.title=@"没有当前位置的详细信息";
             //             place.subTitle=@"详细信息请点击‘附近’查看";
             //             place.title=[NSString stringWithFormat:@"%@%@%@",mark.subLocality,mark.thoroughfare,mark.subThoroughfare];
             //             place.subTitle=[NSString stringWithFormat:@"%@",mark.name];//获取subtitle的信息
             //             [self.myMapView selectAnnotation:place animated:YES];
             [UserLocationInfo sharedInstance].city = mark.locality;
             [UserLocationInfo sharedInstance].latitude = userLocation.location.coordinate.latitude;
             [UserLocationInfo sharedInstance].longtitude = userLocation.location.coordinate.longitude;
             
         } ];
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
    if (_poiSearch != nil) {
        _poiSearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

@end
