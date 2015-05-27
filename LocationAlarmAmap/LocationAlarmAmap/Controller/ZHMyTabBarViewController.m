//
//  MyTabBarViewController.m
//  LocationAlarmAmap
//
//  Created by albert on 15/5/19.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import "ZHMyTabBarViewController.h"

@interface ZHMyTabBarViewController ()

@end

@implementation ZHMyTabBarViewController

{
    
    UIImageView *_tabBarView; //自定义的覆盖原先的tarbar的控件
    
    GXCustomButton *_previousBtn; //记录前一次选中的按钮
    
}

- ( void )viewDidLoad

{
    
    [ super viewDidLoad ];
    
    
    
    self . tabBar . hidden = YES ; //隐藏原先的tarbar
    
    CGFloat tabBarViewY = self . view . frame . size . height - 49 ;
    
    _tabBarView = [[ UIImageView alloc ] initWithFrame : CGRectMake ( 0 , tabBarViewY, 320 , 49 )];
    
    _tabBarView . userInteractionEnabled = YES ; //这一步一定要设置为YES，否则不能和用户交互
    
    _tabBarView . image = [ UIImage imageNamed : @"背景图片" ];
    
    [ self . view  addSubview : _tabBarView ];
    
    // 下面的方法是调用自定义的生成按钮的方法
    
    [self creatButtonWithNormalName:@"图片1"andSelectName:@"图片2"andTitle:@"消息"andIndex:0];
    
    [self creatButtonWithNormalName:@"图片3"andSelectName:@"图片4"andTitle:@"联系人"andIndex:1];
    
    [self creatButtonWithNormalName:@"图片5"andSelectName:@"图片6"andTitle:@"动态"andIndex:2];
    
    [self creatButtonWithNormalName:@"图片7"andSelectName:@"图片8"andTitle:@"设置"andIndex:3];
    
    GXCustomButton *btn = _tabBarView . subviews [ 0 ];
    
    [ self changeViewController :btn]; //自定义的控件中得按钮被点击了调用的方法，默认进入界面就选中第一个按钮
    
}

#pragma mark 创建一个按钮

- ( void )creatButtonWithNormalName:( NSString *)normal andSelectName:( NSString *)selected andTitle:( NSString *)title andIndex:( int )index

{
    
    /*
     
     GXCustomButton是自定义的一个继承自UIButton的类，自定义该类的目的是因为系统自带的Button可以设置image和title属性，但是默认的image是在title的左边，若想想上面图片中那样，将image放在title的上面，就需要自定义Button，设置一些东西。（具体GXCustomButton设置了什么，放在下面讲）
     
     */
    
    GXCustomButton *button = [ GXCustomButton buttonWithType : UIButtonTypeCustom ];
    
    button. tag = index;
    
    CGFloat buttonW = _tabBarView . frame . size . width / 4 ;
    
    CGFloat buttonH = _tabBarView . frame . size . height ;
    
    button. frame = CGRectMake ( 80 *index, 0 , buttonW, buttonH);
    
    [button setImage :[ UIImage imageNamed :normal] forState : UIControlStateNormal ];
    
    [button setImage :[ UIImage imageNamed :selected] forState : UIControlStateDisabled ];
    
    [button setTitle :title forState : UIControlStateNormal ];
    
    [button addTarget : self action : @selector (changeViewController:) forControlEvents : UIControlEventTouchDown ];
    
    button. imageView . contentMode = UIViewContentModeCenter ; // 让图片在按钮内居中
    
    button. titleLabel . textAlignment = NSTextAlignmentCenter ; // 让标题在按钮内居中
    
    button. font = [ UIFont systemFontOfSize : 12 ]; // 设置标题的字体大小
    
    [ _tabBarView addSubview :button];
    
}

#pragma mark 按钮被点击时调用

- ( void )changeViewController:( GXCustomButton *)sender

{
    
    self . selectedIndex = sender. tag ; //切换不同控制器的界面
    
    
    
    sender. enabled = NO ;
    
    if ( _previousBtn != sender) {
        
        _previousBtn . enabled = YES ;
        
    }
    
    _previousBtn = sender;
    
}

@end

//自定义的GXCustomButton按钮.m中的代码如下：



@implementation GXCustomButton

#pragma mark 设置Button内部的image的范围

- ( CGRect )imageRectForContentRect:( CGRect )contentRect

{
    
    CGFloat imageW = contentRect. size . width ;
    
    CGFloat imageH = contentRect. size . height * 0.6 ;
    
    
    
    return CGRectMake ( 0 , 0 , imageW, imageH);
    
}

#pragma mark 设置Button内部的title的范围

- ( CGRect )titleRectForContentRect:( CGRect )contentRect

{
    
    CGFloat titleY = contentRect. size . height * 0.6 ;
    
    CGFloat titleW = contentRect. size . width ;
    
    CGFloat titleH = contentRect. size . height - titleY;
    
    return CGRectMake ( 0 , titleY, titleW, titleH);
    
}

@end

