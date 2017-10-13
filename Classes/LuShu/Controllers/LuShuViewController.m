//
//  LuShuViewController.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/19.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "LuShuViewController.h"

#import "daTouZenVC.h"
#import "RecommendView.h"
#import "MyLuShu.h"

@interface LuShuViewController ()
{
    RecommendView * _recommendView;
    MyLuShu       * _luShu;
}
@end

@implementation LuShuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationController];
    
    [self initView];
    
}

#pragma mark - 设置导航控制器
- (void)setNavigationController
{
    self.view.backgroundColor                     = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO; // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR]
                                                  forBarMetrics:UIBarMetricsDefault];
    UILabel *titleLabel                           = [AppTools createLabelText:@"路书" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter]; // 标题
    titleLabel.font                               = [UIFont systemFontOfSize:16];
    titleLabel.frame                              = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled             = YES;
    self.navigationItem.titleView                 = titleLabel;
    
    UIBarButtonItem * multiItem                   = [UIBarButtonItem itemWithImage:@"determine@2x" // 设置导航栏左侧按钮
                                                                         highImage:@"determine@2x"
                                                                            target:self
                                                                            action:@selector(createLuShu)];
    
    self.navigationItem.rightBarButtonItems       = @[multiItem];
    
    [self createSegment];
}

- (void)createLuShu
{
    daTouZenVC * lushuVC = [[daTouZenVC alloc]init];
    [self.navigationController pushViewController: lushuVC animated:YES];
}

#pragma mark 多段选择视图
- (void)createSegment
{
    NSArray * arr                = @[@"推荐",@"我的"];
    UISegmentedControl * segment = [[UISegmentedControl alloc] initWithItems:arr];
    segment.frame                = CGRectMake(0, 0, 150, 30);
    segment.layer.masksToBounds  = YES;                           // 默认为no，不设置则下面一句无效
    segment.layer.cornerRadius   = 15;                            // 设置圆角大小，同UIView
    segment.layer.borderWidth    = 1;                             // 边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    segment.layer.borderColor    = [UIColor whiteColor].CGColor;  // 边框颜色
    segment.selectedSegmentIndex = 0;                             //设置哪一个Index是选中态
    segment.tintColor            = [UIColor whiteColor];          //设置tint color 默认颜色蓝色
    segment.momentary            = NO;                            //YES只有高亮，没有选择态，默认是NO
    [segment addTarget:self action:@selector(onSegment:) forControlEvents:UIControlEventValueChanged];//事件驱动型基本控件
    [self.navigationController.navigationBar.topItem setTitleView:segment];  // 添加到navigationController
}

- (void)onSegment:(UISegmentedControl *)seg
{
    NSlog(@"index:%ld",seg.selectedSegmentIndex);
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            [self.view bringSubviewToFront:_recommendView];
        }
            break;
        case 1:
        {
            [self.view bringSubviewToFront:_luShu];
        }
            break;
            
        default:
            break;
    }
}

- (void)initView
{
    _luShu = [[MyLuShu alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
    [self.view addSubview:_luShu];
    
    _recommendView = [[RecommendView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
    [self.view addSubview:_recommendView];

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
