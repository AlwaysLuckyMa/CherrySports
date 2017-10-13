//
//  MineMessageHeaderView.m
//  CherrySports
//
//  Created by dkb on 16/11/16.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineMessageHeaderView.h"

@interface MineMessageHeaderView ()
/** 赛事按钮*/
@property (nonatomic, strong) UIButton *eventsBtn;
/** 系统按钮*/
@property (nonatomic, strong) UIButton *systemBtn;
/** 评论按钮*/
@property (nonatomic, strong) UIButton *commentBtn;
@end

@implementation MineMessageHeaderView

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
    [self addSubview:self.eventsBtn];
    [self addSubview:self.systemBtn];
    [self addSubview:self.commentBtn];
    [self.eventsBtn addSubview:self.eventsImageV];
    [self.systemBtn addSubview:self.systemImageV];
    [self.commentBtn addSubview:self.commentImageV];
}

- (UIButton *)eventsBtn
{
    if (!_eventsBtn) {
        _eventsBtn = [AppTools createButtonTitle:@"赛事" TitleColor:[UIColor whiteColor] Font:15 Background:TEXT_COLOR_RED];
        // 单边圆角或者单边框 不设置frame取不到bounds
        _eventsBtn.frame = CGRectMake(0, 10, 178/2, 30);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_eventsBtn.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _eventsBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _eventsBtn.layer.mask = maskLayer;
        [_eventsBtn addTarget:self action:@selector(eventsAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eventsBtn;
}

- (UIButton *)systemBtn
{
    if (!_systemBtn) {
        _systemBtn = [AppTools createButtonTitle:@"系统" TitleColor:TEXT_COLOR_DARK Font:15 Background:[UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00]];
        [_systemBtn addTarget:self action:@selector(systemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _systemBtn;
}

- (UIButton *)commentBtn
{
    if (!_commentBtn) {
        _commentBtn = [AppTools createButtonTitle:@"评论" TitleColor:TEXT_COLOR_DARK Font:15 Background:[UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00]];
        // 单边圆角或者单边框
        _commentBtn.frame = CGRectMake(0, 10, 178/2, 30);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_commentBtn.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _commentBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _commentBtn.layer.mask = maskLayer;
        [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UIImageView *)eventsImageV
{
    if (!_eventsImageV) {
        _eventsImageV = [AppTools CreateImageViewImageName:@"mine_message_whitepoint"];
        _eventsImageV.contentMode = UIViewContentModeScaleAspectFit;
        _eventsImageV.hidden = YES;
    }
    return _eventsImageV;
}

- (UIImageView *)systemImageV
{
    if (!_systemImageV) {
        _systemImageV = [AppTools CreateImageViewImageName:@"mine_message_redpoint"];
        _systemImageV.contentMode = UIViewContentModeScaleAspectFit;
        _systemImageV.hidden = YES;
    }
    return _systemImageV;
}

- (UIImageView *)commentImageV
{
    if (!_commentImageV) {
        _commentImageV = [AppTools CreateImageViewImageName:@"mine_message_redpoint"];
        _commentImageV.contentMode = UIViewContentModeScaleAspectFit;
        _commentImageV.hidden = YES;
    }
    return _commentImageV;
}

- (void)eventsAction
{
    [_eventsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_eventsBtn setBackgroundColor:TEXT_COLOR_RED];
    [_systemBtn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
    [_systemBtn setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00]];
    [_commentBtn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
    [_commentBtn setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00]];
    
    _eventsImageV.image = [UIImage imageNamed:@"mine_message_whitepoint"];
    _systemImageV.image = [UIImage imageNamed:@"mine_message_redpoint"];
    _commentImageV.image = [UIImage imageNamed:@"mine_message_redpoint"];
    // 点击第0个按钮
    [self.delegate ClickButtonNum:@"0"];
}

- (void)systemAction
{
    [_systemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_systemBtn setBackgroundColor:TEXT_COLOR_RED];
    [_eventsBtn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
    [_eventsBtn setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00]];
    [_commentBtn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
    [_commentBtn setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00]];
    
    _systemImageV.image = [UIImage imageNamed:@"mine_message_whitepoint"];
    _eventsImageV.image = [UIImage imageNamed:@"mine_message_redpoint"];
    _commentImageV.image = [UIImage imageNamed:@"mine_message_redpoint"];
    // 点击第1个按钮
    [self.delegate ClickButtonNum:@"1"];
}

- (void)commentAction
{
    [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commentBtn setBackgroundColor:TEXT_COLOR_RED];
    [_eventsBtn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
    [_eventsBtn setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00]];
    [_systemBtn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
    [_systemBtn setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.91 alpha:1.00]];
    
    _commentImageV.image = [UIImage imageNamed:@"mine_message_whitepoint"];
    _systemImageV.image = [UIImage imageNamed:@"mine_message_redpoint"];
    _eventsImageV.image = [UIImage imageNamed:@"mine_message_redpoint"];
    // 点击第2个按钮
    [self.delegate ClickButtonNum:@"2"];
}

- (void)layoutSubviews
{
    WS(weakSelf);
    [_systemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.width.mas_equalTo(178/2);
        make.height.mas_equalTo(30);
    }];
    
    [_eventsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_systemBtn.mas_left).offset(-0.5);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(178/2);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_systemBtn.mas_right).offset(0.5);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(178/2);
    }];
    
    [_eventsImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_eventsBtn.mas_right).offset(-_eventsBtn.width/3 + 5);
        make.top.mas_equalTo(6);
    }];
    
    [_systemImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-_eventsBtn.width/3 + 5);
        make.top.mas_equalTo(6);
    }];
    
    [_commentImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentBtn.mas_right).offset(-_commentBtn.width/3 + 5);
        make.top.mas_equalTo(6);
    }];
    
    [super layoutSubviews];
}













@end
