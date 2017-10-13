//
//  CountDownView.h
//  CherrySports
//
//  Created by dkb on 16/11/15.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownView : UIView

// day
@property (nonatomic, strong) UIImageView *dayImage;
@property (nonatomic, strong) UILabel *dayLabel;
// hour
@property (nonatomic, strong) UIImageView *hourImage;
@property (nonatomic, strong) UILabel *hourLabel;
// minues
@property (nonatomic, strong) UIImageView *minuesImage;
@property (nonatomic, strong) UILabel *minuesLabel;

// 冒号及天数
@property (nonatomic, strong) UILabel *colonUnit;
@property (nonatomic, strong) UILabel *dayUnit;

@property (nonatomic, assign) CGFloat dayWidth;

@end
