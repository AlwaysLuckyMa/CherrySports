//
//  PaySuccessViewController.m
//  CherrySports
//
//  Created by 吴庭宇 on 2016/12/22.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "PaySuccessViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationController];
    [self addViews];
}
- (void)setNavigationController
{
    self.navigationController.navigationBarHidden = NO;
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"交易详情" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(backHone)];
}

- (void)backHone
{
    NSlog(@"aaaa");
    // 回到首页
    UIViewController *homeVC = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:homeVC animated:YES];
}


-(void)addViews{
    _checkImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_success"]];
    _checkImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_checkImage];
    WS(weakSelf);
    [_checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.centerX.equalTo(weakSelf.view);
    }];
     _payLabel = [AppTools createLabelText:@"支付成功" Color:UIColorFromRGB(0x498d01) Font:16 TextAlignment:NSTextAlignmentCenter];
    _payLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_payLabel];
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_checkImage.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(100);
        make.centerX.equalTo(weakSelf.view);
    }];
    _yintaoLabel = [AppTools createLabelText:@"该订单由樱桃体育提供" Color:TEXT_COLOR_LIGHT Font:12 TextAlignment:NSTextAlignmentCenter];
    _payLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_yintaoLabel];
    [_yintaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(200);
        make.centerX.equalTo(weakSelf.view);
    }];
//    _moneyLabel = [AppTools createLabelText:@"0" Color:TEXT_COLOR_DARK Font:25 TextAlignment:NSTextAlignmentCenter];
//    _moneyLabel.font = [UIFont systemFontOfSize:25];
//    [self.view addSubview:_moneyLabel];
//    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_yintaoLabel.mas_bottom).mas_offset(20);
//        make.width.mas_equalTo(200);
//        make.centerX.equalTo(weakSelf.view);
//    }];
    _completeButton = [[UIButton alloc]init];
    _completeButton.backgroundColor = UIColorFromRGB(0x55a500);
    _completeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_completeButton setTitle:@"完 成" forState:UIControlStateNormal];
    _completeButton.tintColor = [UIColor whiteColor];
    _completeButton.layer.cornerRadius = 5;
    [self.view addSubview:_completeButton];
    [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yintaoLabel).mas_offset(40);
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(40);
    }];
    [_completeButton addTarget:self action:@selector(completeButton:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)completeButton:(UIButton *)btn
{
    UIViewController *homeVC = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:homeVC animated:YES];
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
