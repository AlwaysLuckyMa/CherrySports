//
//  CollectCountDownView.m
//  CherrySports
//
//  Created by dkb on 16/11/24.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "CollectCountDownView.h"

@implementation CollectCountDownView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.dayLabel];
        [self addSubview:self.colonUnit];
        [self addSubview:self.minuesLabel];
        [self addSubview:self.dayUnit];
        [self addSubview:self.hourLabel];
        [self addSubview:self.countDownLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    WS(weakSelf);
    
    [_minuesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_colonUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_minuesLabel.mas_left).offset(0.5);
        make.centerY.equalTo(weakSelf).offset(0.2);
    }];
    
    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_colonUnit.mas_left).offset(-0.3);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_dayUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf).offset(0.8);
        make.right.equalTo(_hourLabel.mas_left).offset(-1.5);
    }];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dayUnit.mas_left).offset(-2);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dayLabel.mas_left).offset(-5);
        make.centerY.equalTo(weakSelf);
    }];
    
    [super layoutSubviews];
}

#pragma mark - setter & getter

- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont fontWithName:@"Bell MT" size:18];
        _dayLabel.textColor = TEXT_COLOR_DARK;
//        _dayLabel.backgroundColor = [UIColor redColor];
    }
    return _dayLabel;
}

- (UILabel *)hourLabel{
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.font = [UIFont fontWithName:@"Bell MT" size:18];
        _hourLabel.textColor = TEXT_COLOR_DARK;
//        _hourLabel.backgroundColor = [UIColor yellowColor];
    }
    return _hourLabel;
}

- (UILabel *)minuesLabel{
    if (!_minuesLabel) {
        _minuesLabel = [[UILabel alloc] init];
        _minuesLabel.font = [UIFont fontWithName:@"Bell MT" size:18];
        _minuesLabel.textAlignment = NSTextAlignmentCenter;
        _minuesLabel.textColor = TEXT_COLOR_DARK;
        
//        _minuesLabel.backgroundColor = [UIColor blueColor];
    }
    return _minuesLabel;
}

- (UILabel *)colonUnit
{
    if (!_colonUnit) {
        _colonUnit = [[UILabel alloc] init];
        _colonUnit.font = [UIFont fontWithName:@"Bell MT" size:18];
        _colonUnit.text = @":";
        _colonUnit.textAlignment = NSTextAlignmentCenter;
    }
    return _colonUnit;
}

- (UILabel *)dayUnit
{
    if (!_dayUnit) {
        _dayUnit = [AppTools createLabelText:@"天" Color:TEXT_COLOR_DARK Font:8 TextAlignment:NSTextAlignmentCenter];
    }
    return _dayUnit;
}

- (UILabel *)countDownLabel
{
    if (!_countDownLabel) {
        _countDownLabel = [AppTools createLabelText:@"" Color:TEXT_COLOR_DARK Font:10.5 TextAlignment:NSTextAlignmentRight];
        _countDownLabel.attributedText = [AppTools labelNumber:1.0f String:@"倒计时"];
//        UIColorFromRGB(0x1e272d)
    }
    return _countDownLabel;
}


@end
