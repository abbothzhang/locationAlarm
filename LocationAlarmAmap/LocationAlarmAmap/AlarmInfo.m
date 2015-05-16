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
        self.alarmOpened = [aDecoder decodeObjectForKey:@"alarmOpened"];
        self.distance = [[aDecoder decodeObjectForKey:@"distance"] doubleValue];
        
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.latitude = [[aDecoder decodeObjectForKey:@"latitude"] doubleValue];
//        self.longtitude = [[aDecoder decodeObjectForKey:@"longtitude"] doubleValue];
        self.locationInfo = [aDecoder decodeObjectForKey:@"locationInfo"];
//        self.locationInfo.name = [aDecoder decodeObjectForKey:@"name"];
//        self.locationInfo.latitude = [[aDecoder decodeObjectForKey:@"latitude"] doubleValue];
//        self.locationInfo.longtitude = [[aDecoder decodeObjectForKey:@"longtitude"] doubleValue];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(self.alarmOpened) forKey:@"alarmOpened"];
    [aCoder encodeObject:@(self.distance) forKey:@"distance"];
    
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:@(self.latitude) forKey:@"latitude"];
//    [aCoder encodeObject:@(self.longtitude) forKey:@"longtitude"];
    
    [aCoder encodeObject:self.locationInfo forKey:@"locationInfo"];
//    [aCoder encodeObject:self.locationInfo.name forKey:@"name"];
//    [aCoder encodeObject:@(self.locationInfo.latitude) forKey:@"latitude"];
//    [aCoder encodeObject:@(self.locationInfo.longtitude) forKey:@"longtitude"];
    
}

@end
