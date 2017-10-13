//
//  luShuNavViewController.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/10/11.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "luShuNavViewController.h"

@interface luShuNavViewController ()

@end

@implementation luShuNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationController];
    
}

#pragma mark - 设置导航控制器
- (void)setNavigationController
{
    self.view.backgroundColor                     = [UIColor grayColor];
    // 导航栏颜色
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR]
                                                  forBarMetrics:UIBarMetricsDefault];
    // 标题
    UILabel *titleLabel                           = [AppTools createLabelText:@"运动" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font                               = [UIFont systemFontOfSize:16];
    titleLabel.frame                              = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled             = YES;
    self.navigationItem.titleView                 = titleLabel;
    
    // 设置导航栏左侧按钮
    UIBarButtonItem *multiItem                    = [UIBarButtonItem itemWithImage:@"icon_droplistsetting@2x"
                                                                         highImage:@"icon_droplistsetting@2x"
                                                                            target:self
                                                                            action:@selector(SportClick)];
    
    self.navigationItem.rightBarButtonItems       = @[multiItem];
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
