//
//  AlarmInfo.m
//  LocationAlarm
//
//  Created by albert on 15/3/24.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "AlarmInfo.h"

@interface AlarmInfo()<NSCoding>

@end

@implementation AlarmInfo

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.alarmOpened = [aDecoder decodeObjectForKey:@""];
        self.locationName = [aDecoder decodeObjectForKey:@""];
        self.latitude = [[aDecoder decodeObjectForKey:@"latitude"] doubleValue];
        self.longtitude = [[aDecoder decodeObjectForKey:@"longtitude"] doubleValue];
        self.distance = [[aDecoder decodeObjectForKey:@"distance"] intValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(self.alarmOpened) forKey:@"alarmOpened"];
    [aCoder encodeObject:self.locationName forKey:@"locationName"];
    [aCoder encodeObject:@(self.latitude) forKey:@"latitude"];
    [aCoder encodeObject:@(self.longtitude) forKey:@"longtitude"];
    [aCoder encodeObject:@(self.distance) forKey:@"distance"];
    
}

@end
