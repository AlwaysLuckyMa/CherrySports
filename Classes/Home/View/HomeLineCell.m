//
//  HomeLineCell.m
//  CherrySports
//
//  Created by dkb on 16/12/1.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeLineCell.h"

@implementation HomeLineCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bannerDown];
    }
    return self;
}

// 平铺轮播图下阴影
- (UIView *)bannerDown
{
    if (!_bannerDown)
    {
        UIImage *backImage = [UIImage imageNamed:@"bannerDwon"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        _bannerDown = [UIView new];
        _bannerDown.backgroundColor = bc;
        [self.contentView addSubview:_bannerDown];
        [_bannerDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
    }
    return _bannerDown;
}

@end
