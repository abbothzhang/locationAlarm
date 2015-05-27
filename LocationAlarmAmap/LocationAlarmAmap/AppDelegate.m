//
//  AppDelegate.m
//  LocationAlarmAmap
//
//  Created by albert on 15/5/4.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHMainViewController.h"
#import "ZHMapViewController.h"
#import "ZHAlarmListViewController.h"
#import "ZHSettiongViewController.h"
#import "ImageUtil.h"
#import "ZHMyTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [MAMapServices sharedServices].apiKey = @"2e661c0d2f8ac10f653a37c6221c1714";
    
    //init VC
    ZHMapViewController *mapVc = [[ZHMapViewController alloc] init];
    ZHAlarmListViewController *alarmListVC = [[ZHAlarmListViewController alloc] init];
    ZHSettiongViewController *settiongVC = [[ZHSettiongViewController alloc] init];
    
    //set VC
    UIImage *img1Nor = [UIImage imageNamed:@"img1.png"];
    img1Nor = [ImageUtil scaleImg:img1Nor toScale:0.3];
    

    mapVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"地图"image:img1Nor selectedImage:img1Nor];
    mapVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"地图" image:img1Nor tag:0];
    alarmListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"列表"image:img1Nor selectedImage:img1Nor];
    settiongVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"image:img1Nor selectedImage:img1Nor];
//    mapVc.tabBarItem.title = @"home";
//    [mapVc.tabBarItem setFinishedSelectedImage:img1Nor withFinishedUnselectedImage:img1Nor];
    
    //set nav
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:mapVc];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:alarmListVC];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:settiongVC];
    
    NSArray *vcArray = @[nav1,nav2,nav3];
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    tabBarVC.viewControllers = vcArray;
    tabBarVC.selectedIndex = 0;
    self.window.rootViewController = tabBarVC;
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
