//
//  AlarmTableCell.h
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHAlarmInfo;
@interface AlarmTableCell : UITableViewCell

-(void)setData:(ZHAlarmInfo*)alarmInfo;

@end
