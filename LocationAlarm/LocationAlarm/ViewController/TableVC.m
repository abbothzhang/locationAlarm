//
//  TableVC.m
//  LocationAlarm
//
//  Created by albert on 15/3/24.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "TableVC.h"
#import "ZHHint.h"
#import "AlarmTableCell.h"
#import "AlarmInfo.h"
#import "SelectLocationVC.h"
#import "MapVC.h"


@interface TableVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView        *mTableView;
@property (nonatomic,strong) NSMutableArray     *tableArray;

@end

@implementation TableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"闹钟列表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addAlarm:)];
    
    //initTableView
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mTableView];
    
    _tableArray = [[NSMutableArray alloc] initWithCapacity:5];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _tableArray = [NSMutableArray arrayWithArray:[userDefault arrayForKey:USERDEFAULT_KEY_ALARMTABLE_ARRAY]];
    
}

-(void)addAlarm:(id)sender{
    [ZHHint showToast:@"you click add"];
//    SelectLocationVC *selectVC = [[SelectLocationVC alloc] init];
//    [self.navigationController pushViewController:selectVC animated:YES];
    MapVC *mapVC = [[MapVC alloc] init];
    [self.navigationController pushViewController:mapVC animated:NO];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"alarmTableCell";
    AlarmTableCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[AlarmTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    id alarmInfo = [_tableArray objectAtIndex:indexPath.row];
    if ([alarmInfo isKindOfClass:[AlarmInfo class]]) {
        [cell setData:alarmInfo];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 20;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
