//
//  UserLocationViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "MapViewController.h"
#import "UserLocationInfo.h"
#import "LocationInfo.h"
#import "ZHHint.h"

#define ANIM_TIME_TABLEVIEW     0.2

@interface MapViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain)UISegmentedControl *showSegment;
@property (nonatomic, retain)UISegmentedControl *modeSegment;

@property (nonatomic,strong) UITableView        *searchResultTableView;
@property (nonatomic,strong) NSMutableArray     *tableArray;

@end

@implementation MapViewController
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
    self.title = @"位置闹钟";
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomLevel = 13.5;
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
    self.searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 99, self.view.bounds.size.width, 0)];
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    [self.view addSubview:self.searchResultTableView];
    
    self.tableArray = [[NSMutableArray alloc] initWithCapacity:5];
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

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];

    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = searchBar.text;
    NSString *city = [UserLocationInfo sharedInstance].city;
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
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
//        [self addPointToMapWithTitle:p.name subTitle:p.address latitude:p.location.latitude longtitude:p.location.longitude];
        LocationInfo *locInfo = [[LocationInfo alloc] init];
        locInfo.name = p.name;
        locInfo.address = p.address;
        locInfo.latitude = p.location.latitude;
        locInfo.longtitude = p.location.longitude;
        [self.tableArray addObject:locInfo];
    }
    MapViewController __weak *weakSelf = self;
    [UIView animateWithDuration:ANIM_TIME_TABLEVIEW animations:^{
        weakSelf.searchResultTableView.frame = CGRectMake(0, 99, weakSelf.view.frame.size.width, 300);
    }];
    
    [self.searchResultTableView reloadData];
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

//根据信息将标注添加到地图上
-(void)addPointToMapWithTitle:(NSString*)title subTitle:(NSString*)subTitle latitude:(CGFloat)latitude longtitude:(CGFloat)longtitude  {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    pointAnnotation.title = title;
    pointAnnotation.subtitle = subTitle;
    [self.mapView addAnnotation:pointAnnotation];
     [self.mapView selectAnnotation:pointAnnotation animated:YES];
}

//定位后发起逆地理编码，在这里实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil) {
        //处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode:%@",response.regeocode];
        NSLog(@"ReGeo: %@", result);
        [UserLocationInfo sharedInstance].city = response.regeocode.addressComponent.city;
        
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
        [UserLocationInfo sharedInstance].latitude = userLocation.location.coordinate.latitude;
        [UserLocationInfo sharedInstance].longtitude = userLocation.location.coordinate.longitude;
        
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
    LocationInfo *locInfo = [self.tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = locInfo.name;
    cell.detailTextLabel.text = locInfo.address;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationInfo *locInfo = [self.tableArray objectAtIndex:indexPath.row];
    [self addPointToMapWithTitle:locInfo.name subTitle:locInfo.address latitude:locInfo.latitude longtitude:locInfo.longtitude];
    
    MapViewController __weak *weakSelf = self;
    [UIView animateWithDuration:ANIM_TIME_TABLEVIEW animations:^{
        weakSelf.searchResultTableView.frame = CGRectMake(0, 99, weakSelf.view.frame.size.width, 0);
        weakSelf.mapView.zoomLevel = 11;
    }];
}



#pragma mark - Action Handle

- (void)showsSegmentAction:(UISegmentedControl *)sender
{
    self.mapView.showsUserLocation = !sender.selectedSegmentIndex;
}

- (void)modeAction:(UISegmentedControl *)sender
{
    self.mapView.userTrackingMode = sender.selectedSegmentIndex;
}

-(void)popClick:(id)sender{
    [ZHHint showToast:@"pop click"];
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
    
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
    
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];
}



@end
