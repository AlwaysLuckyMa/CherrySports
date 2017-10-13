//
//  FailedlWebView.m
//  CherrySports
//
//  Created by dkb on 16/12/29.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "FailedlWebView.h"

@implementation FailedlWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    [self addSubview:self.excptionImageView];
    [self addSubview:self.excptionLabel];
    [self addSubview:self.excptionRefreshButton];
}

-(UIImageView *) excptionImageView {
    if (!_excptionImageView) {
        _excptionImageView = [[UIImageView alloc] init];
        _excptionImageView.image = [UIImage imageNamed:@"excption"];
        _excptionImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _excptionImageView;
}
-(UILabel *) excptionLabel {
    if (!_excptionLabel) {
        _excptionLabel = [[UILabel alloc] init];
        _excptionLabel.textAlignment = NSTextAlignmentCenter;
        _excptionLabel.textColor = TEXT_COLOR_LIGHT;
        _excptionLabel.font = [UIFont systemFontOfSize:14];
        _excptionLabel.text = @"服务器好像开小差了，请稍后重试";
    }
    return _excptionLabel;
}
-(UIButton *) excptionRefreshButton{
    if (!_excptionRefreshButton) {
        _excptionRefreshButton = [[UIButton alloc] init];
        [_excptionRefreshButton setTitle:@"点击刷新" forState:UIControlStateNormal];
        [_excptionRefreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _excptionRefreshButton.layer.cornerRadius = 15;
        _excptionRefreshButton.layer.masksToBounds = YES;
        _excptionRefreshButton.backgroundColor = NAVIGATIONBAR_COLOR;
        _excptionRefreshButton.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:14];
    }
    return _excptionRefreshButton;
}

- (void)layoutSubviews
{
    WS(weakSelf);

    [_excptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        //        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [_excptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.excptionImageView.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 20));
    }];
    [_excptionRefreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.excptionLabel.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [super layoutSubviews];
}



@end
