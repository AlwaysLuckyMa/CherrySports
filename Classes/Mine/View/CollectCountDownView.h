//
//  CollectCountDownView.h
//  CherrySports
//
//  Created by dkb on 16/11/24.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectCountDownView : UIView

/** 倒计时字样*/
@property (nonatomic, strong) UILabel *countDownLabel;
// day
@property (nonatomic, strong) UILabel *dayLabel;
// hour
@property (nonatomic, strong) UILabel *hourLabel;
// minues
@property (nonatomic, strong) UILabel *minuesLabel;

// 冒号及天数
@property (nonatomic, strong) UILabel *colonUnit;
@property (nonatomic, strong) UILabel *dayUnit;

@property (nonatomic, assign) CGFloat dayWidth;

@end
