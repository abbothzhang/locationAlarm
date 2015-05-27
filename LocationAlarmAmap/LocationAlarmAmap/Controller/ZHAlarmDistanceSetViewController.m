//
//  AlarmDistanceSetViewController.m
//  LocationAlarmAmap
//
//  Created by albert on 15/5/14.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import "ZHAlarmDistanceSetViewController.h"
#import "ZHLocationInfo.h"
#import "ZHAlarmInfo.h"


@interface ZHAlarmDistanceSetViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) ZHLocationInfo           *locationInfo;
@property (nonatomic) double                        distance;

@property (nonatomic,strong) UITextField *distanceFiled;
//@property (nonatomic,strong) UIButton               *addAlarmBtn;

@end

@implementation ZHAlarmDistanceSetViewController


-(instancetype)initWithAlarmLocationInfo:(ZHLocationInfo*)locationInfo{
    if (!locationInfo) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.locationInfo = locationInfo;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];

}

#pragma mark - init

-(void)initView{
    //init textField
    _distanceFiled = [[UITextField alloc] initWithFrame:CGRectMake(50, 180, self.view.frame.size.width - 100, 50)];
    _distanceFiled.delegate = self;
    _distanceFiled.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 460*HEIGHT_SCALE);
    _distanceFiled.placeholder = @"距离多少米时提醒您?";
    _distanceFiled.borderStyle = UITextBorderStyleRoundedRect;
    _distanceFiled.textAlignment = NSTextAlignmentCenter;
    _distanceFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_distanceFiled];
   
    //initBtn
    UIButton *_addAlarmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    _addAlarmBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height- 390*HEIGHT_SCALE);
    [_addAlarmBtn setTitle:@"添加闹钟" forState:UIControlStateNormal];
    [_addAlarmBtn addTarget:self action:@selector(addAlarmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _addAlarmBtn.alpha = 0.6;
    [_addAlarmBtn primaryStyle];
    [self.view addSubview:_addAlarmBtn];
    
}

-(void)testBlock{
    
    void(^zhblock)() = ^{
        
    };
    
    zhblock();

}

#pragma action
//
-(void)addAlarmBtnClick:(id)sender{
    if (_distanceFiled) {
        [_distanceFiled resignFirstResponder];
    }
    
    if (self.distance < 0) {
        [ZHHint showToast:@"距离不能小于0哦"];
        return;
    }
    if (self.distance > 2000) {
        [ZHHint showToast:@"距离不能大于2000米哦"];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ZHAlarmInfo *alarmInfo = [[ZHAlarmInfo alloc] init];
    alarmInfo.alarmOpened = YES;
    alarmInfo.distance = self.distance;
    alarmInfo.locationInfo = self.locationInfo;
    
//    alarmInfo.name = self.locationInfo.name;
//    alarmInfo.latitude = self.locationInfo.latitude;
//    alarmInfo.longtitude = self.locationInfo.longtitude;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:alarmInfo];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:USER_DEFAULT_ALARM_ARRAY_KEY]];
    if (!array) {
        array = [[NSMutableArray alloc] initWithObjects:data, nil];
    }else{
        [array addObject:data];
    }
    [defaults setValue:array forKey:USER_DEFAULT_ALARM_ARRAY_KEY];
    [ZHHint showToast:@"添加成功!"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.distance = [textField.text doubleValue];
    if (self.distance < 0) {
        [ZHHint showToast:@"距离不能小于0哦"];
    }
    if (self.distance > 2000) {
        [ZHHint showToast:@"距离不能大于2000米哦"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
