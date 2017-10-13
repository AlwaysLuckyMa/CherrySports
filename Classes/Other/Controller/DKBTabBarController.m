//
//  DKBTabBarController.m
//  CarNetworking
//
//  Created by dkb on 16/9/12.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "DKBTabBarController.h"
#import "HomeViewController.h"
#import "CommunityViewController.h"
#import "NewsViewController.h"
#import "EventsViewController.h"
#import "MineViewController.h"
//#import "VideoWebViewController.h"
//#import "SportViewController.h"
#import "SportsViewController.h" //新版 运动地图
#import "LuShuViewController.h" //新版 路书

#import "NewsTextScro.h"

#import "DKBTabBar.h"
#import "DKBNavigationController.h"
#import <QuartzCore/QuartzCore.h>

//
#import "HomenewsViewController.h"
@interface DKBTabBarController ()

@end

@implementation DKBTabBarController

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法，都可以通过appearance对象来统一设置
    // 改变字体选中状态样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont fontWithName:@"YMicrosoft YaHei" size:10];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x222222);
    // 改变字体取消状态样式
    NSMutableDictionary *selectedAttrs= [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];// 字体一致
    selectedAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0xbd071d);
    
    // 拿到tabBar的外观对象,只要给这个Appearance设置，以后所有的item都是一个效果
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 调用封装方法添加子控制器
    // 原版
//    [self setupChildVc:[[HomeViewController alloc] init] title:@"首页" image:@"HomeClick" selectImage:@"Home"];                      //原版首页
//    [self setupChildVc:[[VideoWebViewController alloc] init] title:@"直播" image:@"community-1" selectImage:@"communityClick-1"];    //原版 需要打开索引
//    [self setupChildVc:[[SportViewController alloc] init] title:@"运动" image:@"NewsClick" selectImage:@"News"];                     //原版 需要打开索引
//    [self setupChildVc:[[NewsTextScro alloc] init] title:@"资讯" image:@"NewsClick" selectImage:@"News"];                            //原版
//    [self setupChildVc:[[MineViewController alloc] init] title:@"我的" image:@"MineClick" selectImage:@"Mine"];                      //原版
    
    [self setupChildVc:[[HomenewsViewController alloc] init] title:@"首页" image:@"HomeClick"   selectImage:@"Home"];
    [self setupChildVc:[[EventsViewController   alloc] init] title:@"赛事" image:@"EventsClick" selectImage:@"Events"];
    [self setupChildVc:[[SportsViewController   alloc] init] title:@"运动" image:@"NewsClick"   selectImage:@"News"];
    [self setupChildVc:[[LuShuViewController    alloc] init] title:@"路书" image:@"NewsClick"   selectImage:@"News"];
    [self setupChildVc:[[MineViewController     alloc] init] title:@"我的" image:@"MineClick"   selectImage:@"Mine"];
    
    // 更换tabBar 必须用KVC语法
    [self setValue:[[DKBTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 *  初始化子控制器
 *  第一个参数是为了在创建时就明确表示控制器是什么类型的，比如tableViewController或ViewController
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    // 设置文字和图片
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    if (![title isEqualToString:@"首页"]) {
//        vc.navigationItem.title = title; // 设置导航栏标题
//    }
    // 包装一个导航控制器，添加导航控制器为tabbarController的子控制器
    DKBNavigationController *nav = [[DKBNavigationController alloc] initWithRootViewController:vc];
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
