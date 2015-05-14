//
//  AlarmDistanceSetViewController.m
//  LocationAlarmAmap
//
//  Created by albert on 15/5/14.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import "AlarmDistanceSetViewController.h"


@interface AlarmDistanceSetViewController ()<UITextFieldDelegate>

@end

@implementation AlarmDistanceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];

}

-(void)initView{
    //init textField
    UITextField *distanceFiled = [[UITextField alloc] initWithFrame:CGRectMake(50, 180, self.view.frame.size.width - 100, 50)];
    distanceFiled.delegate = self;
    distanceFiled.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 460*HEIGHT_SCALE);
    distanceFiled.placeholder = @"距离多少米时提醒您?";
    distanceFiled.borderStyle = UITextBorderStyleRoundedRect;
    distanceFiled.textAlignment = NSTextAlignmentCenter;
    distanceFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:distanceFiled];
   
    //initBtn
    UIButton *addAlarmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    addAlarmBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height- 390*HEIGHT_SCALE);
    [addAlarmBtn setTitle:@"添加闹钟" forState:UIControlStateNormal];
//    addAlarmBtn.backgroundColor = [UIColor grayColor];
    addAlarmBtn.alpha = 0.8;
    [addAlarmBtn primaryStyle];
    [self.view addSubview:addAlarmBtn];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
