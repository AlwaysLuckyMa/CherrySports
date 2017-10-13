//
//  MineCollectHeaderView.m
//  CherrySports
//
//  Created by dkb on 16/11/23.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineCollectHeaderView.h"

@interface MineCollectHeaderView ()
/** 赛事收藏*/
@property (nonatomic, strong) UILabel *eventsLabel;
/** 咨询收藏*/
@property (nonatomic, strong) UILabel *newsLabel;
@end

@implementation MineCollectHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    return self;
}

- (void)addViews
{
    if (!_eventsLabel) {
        _eventsLabel = [AppTools createLabelText:@"" Color:[UIColor whiteColor] Font:15 TextAlignment:NSTextAlignmentCenter];
//        _eventsLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:12];
        _eventsLabel.font = [UIFont systemFontOfSize:15];
        _eventsLabel.backgroundColor = TEXT_COLOR_RED;
        _eventsLabel.attributedText = [AppTools labelNumber:1 String:@"赛事收藏"];
        // 单边圆角或者单边框 不设置frame取不到bounds
        _eventsLabel.frame = CGRectMake(0, 10, (SCREEN_WIDTH-107)/2, 30);
        _eventsLabel.userInteractionEnabled = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_eventsLabel.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _eventsLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _eventsLabel.layer.mask = maskLayer;
        [self addSubview:_eventsLabel];
        [_eventsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(107/2);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo((SCREEN_WIDTH-107)/2);
        }];
    }
    
    if (!_eventsBtn) {
        _eventsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _eventsBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        [_eventsBtn addTarget:self action:@selector(_eventsAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_eventsBtn];
        [_eventsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_eventsLabel);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    
    if (!_newsLabel) {
        _newsLabel = [AppTools createLabelText:@"资讯收藏" Color:TEXT_COLOR_DARK Font:15 TextAlignment:NSTextAlignmentCenter];
//        _newsLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:12];
        _newsLabel.font = [UIFont systemFontOfSize:15];
        _newsLabel.attributedText = [AppTools labelNumber:1 String:@"资讯收藏"];
        _newsLabel.backgroundColor = BACK_GROUND_COLOR;
        _newsLabel.userInteractionEnabled = YES;
        // 单边圆角或者单边框 不设置frame取不到bounds
        _newsLabel.frame = CGRectMake(0, 10, (SCREEN_WIDTH-107)/2, 30);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_newsLabel.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _newsLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _newsLabel.layer.mask = maskLayer;
        [self addSubview:_newsLabel];
        [_newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-107/2);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo((SCREEN_WIDTH-107)/2);
        }];
    }
    
    if (!_newsBtn) {
        _newsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _newsBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        [_newsBtn addTarget:self action:@selector(newsAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_newsBtn];
        [_newsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_newsLabel);
            make.top.bottom.mas_equalTo(0);
        }];
    }
}

- (void)_eventsAction
{
    _eventsLabel.backgroundColor = TEXT_COLOR_RED;
    _eventsLabel.textColor = [UIColor whiteColor];
     
    _newsLabel.backgroundColor = BACK_GROUND_COLOR;
    _newsLabel.textColor = TEXT_COLOR_DARK;
    
    [self.delegate ClickButtonNumber:@"0"];
}

- (void)newsAction
{
    _newsLabel.backgroundColor = TEXT_COLOR_RED;
    _newsLabel.textColor = [UIColor whiteColor];
    
    _eventsLabel.backgroundColor = BACK_GROUND_COLOR;
    _eventsLabel.textColor = TEXT_COLOR_DARK;
    
    [self.delegate ClickButtonNumber:@"1"];
}



@end
