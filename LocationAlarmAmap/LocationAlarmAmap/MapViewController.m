//
//  UserLocationViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic, retain)UISegmentedControl *showSegment;

@property (nonatomic, retain)UISegmentedControl *modeSegment;

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
    [self initToolBar];
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
    }
    
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

#pragma mark - NSKeyValueObservering

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"showsUserLocation"])
    {
        NSNumber *showsNum = [change objectForKey:NSKeyValueChangeNewKey];
        
        self.showSegment.selectedSegmentIndex = ![showsNum boolValue];
    }
}

#pragma mark - init

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

#pragma mark - returnAction
- (void)returnAction
{
    [super returnAction];
    
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
    
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];
}



@end
