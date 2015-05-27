//
//  UserLocationInfo.m
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "ZHUserLocationInfo.h"



@interface ZHUserLocationInfo()

@end

@implementation ZHUserLocationInfo

+(instancetype)sharedInstance{
    static  ZHUserLocationInfo  *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZHUserLocationInfo alloc] init];
    });
    return instance;
}




@end
