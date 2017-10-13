//
//  SectionHeaderView.m
//  CherrySports
//
//  Created by dkb on 16/10/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

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
    [self addSubview:self.applyDown];
    [self addSubview:self.titleImage];
    [self addSubview:self.titleName];
    [self addSubview:self.moreBtn];
}

// 平铺报名下阴影
- (UIView *)applyDown
{
    if (!_applyDown)
    {
        UIImage *backImage = [UIImage imageNamed:@"ApplyDown"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        _applyDown = [UIView new];
        _applyDown.backgroundColor = bc;
    }
    return _applyDown;
}

- (UIImageView *)titleImage
{
    if (!_titleImage)
    {
        _titleImage = [AppTools CreateImageViewImageName:@"home_shuline_red"];
        //自适应图片宽高比例
//        _titleImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _titleImage;
}

- (UILabel *)titleName
{
    if (!_titleName) {
        _titleName = [AppTools createLabelText:@"" Color:TEXT_COLOR_RED Font:12 TextAlignment:NSTextAlignmentLeft];
        _titleName.font = [UIFont systemFontOfSize:14];
    }
    return _titleName;
}

- (UIButton *)moreBtn
{
    if (!_moreBtn)
    {
        _moreBtn = [AppTools createButtonTitle:@"更多＞" TitleColor:TEXT_COLOR_RED Font:14 Background:[UIColor whiteColor]];
        _moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moreBtn;
}


- (void)layoutSubviews
{
    WS(weakSelf);
    [_applyDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(19);
        make.height.mas_equalTo(14);
    }];
    
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleImage.mas_right).offset(8);
        make.top.equalTo(_titleImage).offset(-1.6);
        make.width.mas_equalTo(120);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.top.equalTo(_titleImage).offset(-7);
        make.width.mas_equalTo(45);
    }];
    [super layoutSubviews];
}

@end
