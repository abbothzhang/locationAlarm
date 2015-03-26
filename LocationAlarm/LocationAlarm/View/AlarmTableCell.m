//
//  AlarmTableCell.m
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "AlarmTableCell.h"
#import "AlarmInfo.h"

@interface AlarmTableCell()

@property (nonatomic,strong) AlarmInfo          *alarmInfo;

@end

@implementation AlarmTableCell

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setData:(AlarmInfo*)alarmInfo{
    _alarmInfo = alarmInfo;
}

-(void)setUpView{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
