//
//  BaseViewController.m
//  mqtt_test
//
//  Created by dkb on 16/9/27.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 改变背景色及透明度(这里如果改变的话，改变偏移量显示navigation后 push页面再回来会出现问题)
//    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    // 去掉底部线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
}

//// 隐藏Navigation上面的状态栏
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}


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
