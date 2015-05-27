//
//  LocationInfo.m
//  LocationAlarmAmap
//
//  Created by albert on 15/5/12.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import "ZHLocationInfo.h"

@interface ZHLocationInfo()<NSCoding>

@end

@implementation ZHLocationInfo

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.latitude = [[aDecoder decodeObjectForKey:@"latitude"] floatValue];
        self.longtitude = [[aDecoder decodeObjectForKey:@"longtitude"] floatValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:@(self.latitude) forKey:@"latitude"];
    [aCoder encodeObject:@(self.longtitude) forKey:@"longtitude"];
    
}

@end
