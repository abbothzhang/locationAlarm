//
//  AlarmDistanceSetViewController.m
//  LocationAlarmAmap
//
//  Created by albert on 15/5/14.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import "AlarmDistanceSetViewController.h"

@interface AlarmDistanceSetViewController ()

@end

@implementation AlarmDistanceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];

}

-(void)initView{
    UITextField *distanceFiled = [[UITextField alloc] initWithFrame:CGRectMake(50, 180, self.view.frame.size.width - 100, 50)];
    distanceFiled.delegate = self;
//    [distanceFiled sizeToFit];
    distanceFiled.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    distanceFiled.backgroundColor = [UIColor grayColor];
    distanceFiled.placeholder = @"距离多少米时提醒您?";

    distanceFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:distanceFiled];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
