//
//  SetDistanceVC.m
//  LocationAlarm
//
//  Created by albert on 15/3/25.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "SetDistanceVC.h"
#import "AlarmInfo.h"

@interface SetDistanceVC ()<UITextFieldDelegate>

@property (nonatomic,strong) AlarmInfo              *alarmInfo;
@property (nonatomic,strong) UITextField            *distanceTfd;

@end

@implementation SetDistanceVC

-(instancetype)initWithAlarmInfo:(AlarmInfo*)alarmInfo{
    self = [super init];
    if (self) {
        _alarmInfo = alarmInfo;
        [self setUpView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置提醒距离";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
}

-(void)setUpView{
//    UILabel *tipLabel = [UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    _distanceTfd = [[UITextField alloc] initWithFrame:CGRectMake(80, 80, self.view.frame.size.width - 80*2, 60)];
    _distanceTfd.backgroundColor = [UIColor clearColor];
    _distanceTfd.keyboardType = UIKeyboardTypeNumberPad;
    
//    _distanceTfd.text = @"2000";
    _distanceTfd.placeholder = @"多少米之内提醒";
    _distanceTfd.delegate = self;
    [self.view addSubview:_distanceTfd];
    
}

-(void)onClickDone{
    if (_distanceTfd.text && _distanceTfd.text.length > 0) {
        _alarmInfo.distance = [_distanceTfd.text intValue];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_alarmInfo];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *alarmArray = [NSMutableArray arrayWithArray:[userDefault arrayForKey:USERDEFAULT_KEY_ALARMTABLE_ARRAY]];
        [alarmArray addObject:data];
        [userDefault setObject:alarmArray forKey:USERDEFAULT_KEY_ALARMTABLE_ARRAY];
        [ZHHint showToast:@"添加成功"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [ZHHint showToast:@"输入为空"];
    }

}

#pragma mark - 
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text && textField.text.length > 0) {
        int distance = [textField.text intValue];
        if (distance < 100) {
            [ZHHint showToast:@"小于100米不准确哦"];
        }
    }
}


@end
