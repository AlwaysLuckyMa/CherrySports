//
//  CZCountDownView.m
//  countDownDemo
//
//  Created by 孔凡列 on 15/12/9.
//  Copyright © 2015年 czebd. All rights reserved.
//

#import "CZCountDownView.h"
#import <CoreText/CoreText.h>
// label数量
#define labelCount 3
#define separateLabelCount 2
#define padding 5
@interface CZCountDownView (){
    // 定时器
    NSTimer *timer;
}
// day
@property (nonatomic, strong) UIImageView *dayImage;
@property (nonatomic, strong) UILabel *dayLabel;
// hour
@property (nonatomic, strong) UIImageView *hourImage;
@property (nonatomic, strong) UILabel *hourLabel;
// minues
@property (nonatomic, strong) UIImageView *minuesImage;
@property (nonatomic, strong) UILabel *minuesLabel;
// seconds
@property (nonatomic, strong) UIImageView *secondsImage;
@property (nonatomic, strong) UILabel *secondsLabel;

// 冒号及天数
@property (nonatomic, strong) UILabel *colonUnit;
@property (nonatomic, strong) UILabel *dayUnit;
@end

@implementation CZCountDownView
// 创建单例
//+ (instancetype)shareCountDown{
//    static id instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[CZCountDownView alloc] init];
//    });
//    return instance;
//}

//+ (instancetype)countDown{
//    return [[self alloc] init];
//}

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
//        [self addSubview:self.secondsLabel];
    }
    return self;
}

// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
    if (_timestamp != 0) {
        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_timestamp == 0) {
        [timer invalidate];
        timer = nil;
        // 执行block回调
        self.timerStopBlock();
    }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    NSlog(@"%zd日:%zd时:%zd分:%zd秒",day,hour,minute,second);
    int number = 5.0f;
    if (day == 0) {
        _dayImage.image = [UIImage imageNamed:@"evevts_home_countdown_zero"];
    }else{
        _dayImage.image = [UIImage imageNamed:@"evevts_home_countdown"];
    }
    if (hour == 0) {
        _hourImage.image = [UIImage imageNamed:@"evevts_home_countdown_zero"];
    }else{
        _hourImage.image = [UIImage imageNamed:@"evevts_home_countdown"];
    }
    if (day < 10) {
        NSString *days = [NSString stringWithFormat:@"0%zd",day];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:days];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        _dayLabel.attributedText = attributedString;
    }else{
        NSString *days = [NSString stringWithFormat:@"%zd",day];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:days];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        _dayLabel.attributedText = attributedString;
    }
    if (hour < 10) {
        NSString *hours = [NSString stringWithFormat:@"0%zd",hour];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:hours];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        _hourLabel.attributedText = attributedString;
        
    }else{
        NSString *hours = [NSString stringWithFormat:@"%zd",hour];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:hours];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        _hourLabel.attributedText = attributedString;
    }
    if (minute < 10) {
        NSString *minues = [NSString stringWithFormat:@"0%zd",minute];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:minues];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        _minuesLabel.attributedText = attributedString;
    }else{
        NSString *minues = [NSString stringWithFormat:@"%zd",minute];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:minues];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        _minuesLabel.attributedText = attributedString;
    }
    self.secondsLabel.text = [NSString stringWithFormat:@"%zd",second];
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
        make.width.mas_equalTo(33.5);
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

- (UILabel *)secondsLabel{
    if (!_secondsLabel) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.font = [UIFont fontWithName:@"Swis721 BlkCn BT" size:19];
        _secondsLabel.textAlignment = NSTextAlignmentLeft;
        _secondsLabel.textColor = [UIColor whiteColor];
        
//        _secondsLabel.backgroundColor = [UIColor yellowColor];
    }
    return _secondsLabel;
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
