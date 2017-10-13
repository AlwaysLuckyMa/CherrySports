//
//  LineView.m
//  CherrySports
//
//  Created by dkb on 16/11/7.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    self.backgroundColor = BACK_GROUND_COLOR;
    UIView *view = [AppTools createViewBackground:LINE_COLOR];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

@end
