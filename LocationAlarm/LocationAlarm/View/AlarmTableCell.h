//
//  AlarmTableCell.h
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlarmInfo;
@interface AlarmTableCell : UITableViewCell

-(void)setData:(AlarmInfo*)alarmInfo;

@end
