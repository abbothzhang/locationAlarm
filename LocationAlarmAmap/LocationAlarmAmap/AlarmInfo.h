//
//  AlarmInfo.h
//  LocationAlarm
//
//  Created by albert on 15/3/24.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationInfo.h"

#define USER_DEFAULT_ALARM_ARRAY_KEY    @"USER_DEFAULT_ALARM_ARRAY_KEY"

@interface AlarmInfo : NSObject

@property (nonatomic) BOOL                  alarmOpened;
@property (nonatomic) double                distance;
@property (nonatomic,strong) LocationInfo   *locationInfo;

//@property (nonatomic,strong)NSString        *name;
//@property (nonatomic) double                latitude;
//@property (nonatomic) double                longtitude;

@end
