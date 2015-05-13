//
//  UserLocationInfo.h
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocationInfo : NSObject

@property(nonatomic,strong) NSString            *city;
@property(nonatomic) double                     latitude;
@property(nonatomic) double                     longtitude;

+(instancetype)sharedInstance;
@end
