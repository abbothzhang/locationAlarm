//
//  Utils.h
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define USERDEFAULT_KEY_ALARMTABLE_ARRAY    @"USERDEFAULT_KEY_ALARMTABLE_ARRAY"

@interface Utils : NSObject
+(double)distanceBetweenOrderByLat1:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2;
@end
