//
//  UserLocationViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "ZHMapViewController.h"
#import "ZHUserLocationInfo.h"
#import "ZHLocationInfo.h"
#import "ZHHint.h"
#import "ZHAlarmDistanceSetViewController.h"
#import "ZHHUDActivityView.h"
#import "Utils.h"
#import "ZHAlarmInfo.h"
#import <Foundation/Foundation.h>


#define ANIM_TIME_TABLEVIEW     0.2

@interface ZHMapViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ZHHUDActivityView                  *hudView;

@property (nonatomic, retain)UISegmentedControl                 *showSegment;
@property (nonatomic, retain)UISegmentedControl                 *modeSegment;

@property (nonatomic,strong) UITableView                        *searchResultTableView;
@property (nonatomic,strong) UIView                             *tableBgView;
@property (nonatomic,strong) UITapGestureRecognizer             *tableBgTapGes;
@property (nonatomic,strong) NSMutableArray                     *tableArray;
@property (nonatomic,strong) ZHLocationInfo                       *addAlarmLocationInfo;

@end

@implementation ZHMapViewController
@synthesize showSegment, modeSegment;

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initObservers];
    [self.mapView setCompassImage:[UIImage imageNamed:@"compass"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self initToolBar];
    [self initSearchBar];
    [self initSearchResultTableView];
    [self addAlarmPoint];
    self.title = @"位置闹钟";
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomLevel = 13.5;
    
    _hudView = [[ZHHUDActivityView alloc] initWithFrame:CGRectMake(0, 0, 150*WITH_SCALE, 150*WITH_SCALE) showTip:YES];
    _hudView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);

}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.mapView setCompassImage:nil];
}

#pragma mark - init

-(void)initSearchResultTableView{
    
    self.tableBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 399, self.view.bounds.size.width, self.view.frame.size.height - 99)];
    self.tableBgView.backgroundColor = [UIColor blackColor];
    self.tableBgView.alpha = 0.8;
    self.tableBgTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTableView)];
    [self.tableBgView addGestureRecognizer:self.tableBgTapGes];
    
    self.searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 99, self.view.bounds.size.width, 0)];
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    [self.view addSubview:self.searchResultTableView];
    

    
    self.tableArray = [[NSMutableArray alloc] initWithCapacity:8];
}

-(void)initSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 35)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索要添加的地点";
    [self.view addSubview:searchBar];
    
}

- (void)initToolBar
{
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    self.showSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Start", @"Stop", nil]];
    self.showSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.showSegment addTarget:self action:@selector(showsSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.showSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithCustomView:self.showSegment];
    
    self.modeSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"None", @"Follow", @"Head", nil]];
    self.modeSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.modeSegment addTarget:self action:@selector(modeAction:) forControlEvents:UIControlEventValueChanged];
    self.modeSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *modeItem = [[UIBarButtonItem alloc] initWithCustomView:self.modeSegment];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, showItem, flexble, modeItem, flexble, nil];
}

- (void)initObservers
{
    /* Add observer for showsUserLocation. */
    [self.mapView addObserver:self forKeyPath:@"showsUserLocation" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)addAlarmPoint{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:USER_DEFAULT_ALARM_ARRAY_KEY]];
    for (NSData *alarmData in array) {
        ZHAlarmInfo *alarmInfo = [NSKeyedUnarchiver unarchiveObjectWithData:alarmData];
        ZHLocationInfo *locInfo = alarmInfo.locationInfo;
        [self addPointToMapWithTitle:locInfo.name subTitle:locInfo.address latitude:locInfo.latitude longtitude:locInfo.longtitude selected:NO];
    }

}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    _hudView.textLabel.text = @"正在搜索...";
    [_hudView animateShowInView:self.view];
    
    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = searchBar.text;
    NSString *city = [ZHUserLocationInfo sharedInstance].city;
    if (city) {poiRequest.city = @[city];}
    
    poiRequest.requireExtension = YES;
    [self.search AMapPlaceSearch:poiRequest];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

#pragma mark - AMapSearchDelegate

//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    [self.tableArray removeAllObjects];
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        ZHLocationInfo *locInfo = [[ZHLocationInfo alloc] init];
        locInfo.name = p.name;
        locInfo.address = p.address;
        locInfo.latitude = p.location.latitude;
        locInfo.longtitude = p.location.longitude;
        [self.tableArray addObject:locInfo];
    }
    ZHMapViewController __weak *weakSelf = self;
    [UIView animateWithDuration:ANIM_TIME_TABLEVIEW animations:^{
        [weakSelf.view addSubview:weakSelf.tableBgView];
        weakSelf.searchResultTableView.frame = CGRectMake(0, 99, weakSelf.view.frame.size.width, 300);
        
    }];
    
    [self.searchResultTableView reloadData];
    [_hudView animateToHide];
    
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

//根据信息将标注添加到地图上
-(void)addPointToMapWithTitle:(NSString*)title subTitle:(NSString*)subTitle latitude:(CGFloat)latitude longtitude:(CGFloat)longtitude  selected:(BOOL)selected{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    pointAnnotation.title = title;
    pointAnnotation.subtitle = subTitle;
    [self.mapView addAnnotation:pointAnnotation];
    if (selected) {
        [self.mapView selectAnnotation:pointAnnotation animated:YES];
    }

}

//定位后发起逆地理编码，在这里实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil) {
        //处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode:%@",response.regeocode];
        NSLog(@"ReGeo: %@", result);
        [ZHUserLocationInfo sharedInstance].city = response.regeocode.addressComponent.city;
        
    }
}


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    self.modeSegment.selectedSegmentIndex = mode;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [ZHUserLocationInfo sharedInstance].latitude = userLocation.location.coordinate.latitude;
        [ZHUserLocationInfo sharedInstance].longtitude = userLocation.location.coordinate.longitude;
        
        //构造 AMapReGeocodeSearchRequest 对象,location 为必选项,radius 为可选项
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.searchType = AMapSearchType_ReGeocode;
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeoRequest.radius = 10000; regeoRequest.requireExtension = YES;
        //发起逆地理编码
        [self.search AMapReGoecodeSearch: regeoRequest];
    }
}

//设置标注样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES; //设置气泡可以弹出,默认为 NO
        annotationView.animatesDrop = YES;  //设置标注动画显示,默认为 NO
//        annotationView.draggable = YES; //设置标注可以拖动,默认为 NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        rightBtn.backgroundColor = [UIColor clearColor];
        [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(popClick:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightBtn;
        
        return annotationView;
    }
    return nil;
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"cellIden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIden];
    }
    ZHLocationInfo *locInfo = [self.tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = locInfo.name;
    cell.detailTextLabel.text = locInfo.address;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHLocationInfo *locInfo = [self.tableArray objectAtIndex:indexPath.row];
    _addAlarmLocationInfo = locInfo;
    [self addPointToMapWithTitle:locInfo.name subTitle:locInfo.address latitude:locInfo.latitude longtitude:locInfo.longtitude selected:YES];
    
    ZHMapViewController __weak *weakSelf = self;
    [UIView animateWithDuration:ANIM_TIME_TABLEVIEW animations:^{
        [weakSelf hideTableView];
        CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake(locInfo.latitude, locInfo.longtitude);
        [weakSelf.mapView setCenterCoordinate:centerPoint animated:YES];
        
    }];
}



#pragma mark - Action Handle
-(void)hideTableView{
    ZHMapViewController __weak *weakSelf = self;
    [weakSelf.tableBgView removeFromSuperview];
    weakSelf.searchResultTableView.frame = CGRectMake(0, 99, weakSelf.view.frame.size.width, 0);
    
}

- (void)showsSegmentAction:(UISegmentedControl *)sender
{
    self.mapView.showsUserLocation = !sender.selectedSegmentIndex;
}

- (void)modeAction:(UISegmentedControl *)sender
{
    self.mapView.userTrackingMode = sender.selectedSegmentIndex;
}

-(void)popClick:(id)sender{
    if (!_addAlarmLocationInfo) {
        return;
    }
    ZHAlarmDistanceSetViewController *disVC = [[ZHAlarmDistanceSetViewController alloc] initWithAlarmLocationInfo:_addAlarmLocationInfo];
    if (!disVC) {
        return;
    }
    
    [self presentViewController:disVC animated:YES completion:^{
        
    }];
    
}

#pragma mark - NSKeyValueObservering

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"showsUserLocation"])
    {
        NSNumber *showsNum = [change objectForKey:NSKeyValueChangeNewKey];
        
        self.showSegment.selectedSegmentIndex = ![showsNum boolValue];
    }
}



#pragma mark - returnAction
- (void)returnAction
{
    [super returnAction];
    [self.tableBgView removeGestureRecognizer:self.tableBgTapGes];
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
    
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];
}



@end
