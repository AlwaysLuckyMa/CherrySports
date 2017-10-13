//
//  EventStateView.m
//  CherrySports
//
//  Created by dkb on 17/1/19.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "EventStateView.h"

@implementation EventStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    [self addSubview:self.title];
}

- (UILabel *)title
{
    if (!_title) {
        _title = [AppTools createLabelText:@"" Color:TEXT_COLOR_LIGHT Font:14 TextAlignment:NSTextAlignmentLeft];
    }
    return _title;
}

- (void)layoutSubviews
{
    WS(weakSelf);
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(weakSelf);
    }];
    
    [super layoutSubviews];
}


@end
