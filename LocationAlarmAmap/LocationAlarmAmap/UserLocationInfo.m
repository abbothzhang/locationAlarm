//
//  UserLocationInfo.m
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "UserLocationInfo.h"



@interface UserLocationInfo()

@end

@implementation UserLocationInfo

+(instancetype)sharedInstance{
    static  UserLocationInfo  *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserLocationInfo alloc] init];
    });
    return instance;
}




@end
