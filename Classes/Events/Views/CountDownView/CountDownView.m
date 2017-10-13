//
//  CountDownView.m
//  CherrySports
//
//  Created by dkb on 16/11/15.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "CountDownView.h"

@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.minuesImage];
        [self addSubview:self.minuesLabel];
        [self addSubview:self.colonUnit];
        [self addSubview:self.hourImage];
        [self addSubview:self.hourLabel];
        [self addSubview:self.dayUnit];
        [self addSubview:self.dayImage];
        [self addSubview:self.dayLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(data:) name:@"dayWidth" object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)data:(NSNotification *)data
{
    NSlog(@"不走啦");
//    NSDictionary *dic = data.object;
//    NSString *str = [dic objectForKey:@"dayWidth"];
//    _dayImage.contentMode = UIViewContentModeScaleAspectFit;
////    [_dayImage mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(str.floatValue);
//    }];
//    if (str.floatValue < (98/2)) {
//        [[NSNotificationCenter defaultCenter]removeObserver:self];
//    }
}

- (void)layoutSubviews{
    WS(weakSelf);
    [_minuesImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(weakSelf);
        make.width.mas_equalTo(33.5);
        make.height.mas_equalTo(25);
    }];
    
    [_hourImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(_minuesImage.mas_left).offset(-6);
        make.width.mas_equalTo(33.5);
        make.height.mas_equalTo(25);
    }];
    
    [_colonUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_hourImage.mas_right);
        make.right.equalTo(_minuesImage.mas_left);
        make.centerY.equalTo(weakSelf).offset(-1);
    }];
    
    [_dayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(_hourImage.mas_left).offset(-11);
        make.height.mas_equalTo(25);
    }];
    
    [_dayUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(_dayImage.mas_right);
        make.right.equalTo(_hourImage.mas_left);
    }];
    
    [_minuesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_minuesImage.mas_left).offset(2.5);
        make.right.equalTo(_minuesImage.mas_right).offset(2.5);
        make.top.equalTo(_minuesImage);
        make.bottom.equalTo(_minuesImage);
    }];
    
    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_hourImage.mas_left).offset(2.5);
        make.right.equalTo(_hourImage.mas_right).offset(2.5);
        make.top.bottom.equalTo(_hourImage);
    }];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dayImage.mas_left).offset(2.5);
        make.right.equalTo(_dayImage.mas_right).offset(2.5);
        make.top.bottom.equalTo(_dayImage);
    }];
    [super layoutSubviews];
}

#pragma mark - setter & getter
- (UIImageView *)dayImage
{
    if (!_dayImage) {
        _dayImage = [AppTools CreateImageViewImageName:@"evevts_home_countdown"];
        _dayImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _dayImage;
}

- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont fontWithName:@"Swis721 BlkCn BT" size:19];
        _dayLabel.textColor = [UIColor whiteColor];
        //        _dayLabel.backgroundColor = [UIColor grayColor];
    }
    return _dayLabel;
}

- (UIImageView *)hourImage
{
    if (!_hourImage) {
        _hourImage = [AppTools CreateImageViewImageName:@"evevts_home_countdown"];
    }
    return _hourImage;
}

- (UILabel *)hourLabel{
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.font = [UIFont fontWithName:@"Swis721 BlkCn BT" size:19];
        _hourLabel.textColor = [UIColor whiteColor];
        //        _hourLabel.backgroundColor = [UIColor redColor];
    }
    return _hourLabel;
}

- (UIImageView *)minuesImage
{
    if (!_minuesImage) {
        _minuesImage = [AppTools CreateImageViewImageName:@"evevts_home_countdown"];
    }
    return _minuesImage;
}

- (UILabel *)minuesLabel{
    if (!_minuesLabel) {
        _minuesLabel = [[UILabel alloc] init];
        _minuesLabel.font = [UIFont fontWithName:@"Swis721 BlkCn BT" size:19];
        _minuesLabel.textAlignment = NSTextAlignmentCenter;
        _minuesLabel.textColor = [UIColor whiteColor];
        
        //        _minuesLabel.backgroundColor = [UIColor orangeColor];
    }
    return _minuesLabel;
}

- (UILabel *)colonUnit
{
    if (!_colonUnit) {
        _colonUnit = [AppTools createLabelText:@":" Color:UIColorFromRGB(0x1e272d) Font:13 TextAlignment:NSTextAlignmentCenter];
    }
    return _colonUnit;
}

- (UILabel *)dayUnit
{
    if (!_dayUnit) {
        _dayUnit = [AppTools createLabelText:@"天" Color:UIColorFromRGB(0x1e272d) Font:7 TextAlignment:NSTextAlignmentCenter];
    }
    return _dayUnit;
}

@end
