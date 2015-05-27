//
//  AlarmListViewController.m
//  LocationAlarmAmap
//
//  Created by albert on 15/5/17.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import "ZHAlarmListViewController.h"
#import "ZHAlarmInfo.h"
#import "ZHAlarmDistanceSetViewController.h"

@interface ZHAlarmListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray     *tableArray;
@property (nonatomic,strong) UITableView        *tableView;

@property (nonatomic,strong) UILabel            *tableEmptyTipsLabel;
@property (nonatomic,strong) UIButton           *addAlarmBtn;

@end

@implementation ZHAlarmListViewController

-(void)viewWillAppear:(BOOL)animated{
    [self initTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - init

-(void)initTableView{
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else{
        [self.tableView reloadData];
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tableArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:USER_DEFAULT_ALARM_ARRAY_KEY]];
    if (!self.tableArray || self.tableArray.count == 0) {
        [self.view addSubview:self.tableEmptyTipsLabel];
        [self.view addSubview:self.addAlarmBtn];
        return;
    }else{
        [self.view addSubview:self.tableView];
    }
    

}

#pragma mark - lazy init

-(UILabel *)tableEmptyTipsLabel{
    if (!_tableEmptyTipsLabel) {
        _tableEmptyTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30*HEIGHT_SCALE)];
        _tableEmptyTipsLabel.center = CGPointMake(self.view.frame.size.width/2, 180*HEIGHT_SCALE);
        _tableEmptyTipsLabel.textAlignment = NSTextAlignmentCenter;
        _tableEmptyTipsLabel.text = @"还没有闹钟，快去添加吧";
    }
    return _tableEmptyTipsLabel;
}

-(UIButton *)addAlarmBtn{
    if (!_addAlarmBtn) {
        _addAlarmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100*WITH_SCALE, 40*HEIGHT_SCALE)];
        _addAlarmBtn.center = CGPointMake(self.view.frame.size.width/2, 260*HEIGHT_SCALE);
        
        [_addAlarmBtn primaryStyle];
        [_addAlarmBtn addTarget:self action:@selector(addAlarmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addAlarmBtn setTitle:@"添加闹钟" forState:UIControlStateNormal];
        
    }
    return _addAlarmBtn;
}

#pragma mark - action
-(void)addAlarmBtnClick:(id)sender{
    self.tabBarController.selectedIndex = 0;
}


#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*HEIGHT_SCALE;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"AlarmListViewControllerCellIden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    if (self.tableArray) {
        NSData *alarmData = [self.tableArray objectAtIndex:indexPath.row];
        ZHAlarmInfo *alarmInfo = [NSKeyedUnarchiver unarchiveObjectWithData:alarmData];
        ZHLocationInfo *locInfo = alarmInfo.locationInfo;
        cell.textLabel.text = locInfo.name;
        cell.detailTextLabel.text = locInfo.address;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableArray) {
        NSData *alarmData = [self.tableArray objectAtIndex:indexPath.row];
        ZHAlarmInfo *alarmInfo = [NSKeyedUnarchiver unarchiveObjectWithData:alarmData];
        ZHLocationInfo *locInfo = alarmInfo.locationInfo;

        ZHAlarmDistanceSetViewController *alarmDistanceVC = [[ZHAlarmDistanceSetViewController alloc] initWithAlarmLocationInfo:locInfo];
        [self presentViewController:alarmDistanceVC animated:YES completion:^{
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
