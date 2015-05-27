//
//  LocationInfo.h
//  LocationAlarmAmap
//  高德地图有 AMapGeoPoint 和这个类很像，后续看可以直接用AMapGeoPoint
//  Created by albert on 15/5/12.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHLocationInfo : NSObject

@property(nonatomic,strong) NSString            *city;
@property(nonatomic,strong) NSString            *name;
@property(nonatomic,strong) NSString            *address;
@property(nonatomic) CGFloat                     latitude;
@property(nonatomic) CGFloat                     longtitude;

@end
