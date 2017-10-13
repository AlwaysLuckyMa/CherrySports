//
//  BackView.m
//  CherrySports
//
//  Created by dkb on 16/12/6.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BackView.h"

@implementation BackView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        [self createViews];
    }
    return self;
}

- (void)createViews
{
    WS(weakSelf);
    // 创建红色背景图标
    _corView = [AppTools createViewBackground:NAVIGATIONBAR_COLOR];
    _corView.layer.masksToBounds = YES;
    _corView.layer.cornerRadius = 11;
    //                _corView.image = [UIImage imageNamed:@"news_back_rect"];
    //                UIEdgeInsets insets = UIEdgeInsetsMake(20, 13, 20, 13);
    //                _corView.image = [_corView.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self addSubview:_corView];
    [_corView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5.5);
        make.top.mas_equalTo(0.5);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    
    _jianView = [AppTools CreateImageViewImageName:@"news_back_jian"];
    _jianView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_jianView];
    [_jianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(_corView.mas_bottom);
    }];
    
}





@end
