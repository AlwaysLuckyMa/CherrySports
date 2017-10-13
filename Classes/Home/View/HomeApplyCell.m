//
//  HomeApplyCell.m
//  CherrySports
//
//  Created by dkb on 16/10/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeApplyCell.h"

@implementation HomeApplyCell

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
    [self.contentView addSubview:self.apply];
    [self.contentView addSubview:self.backBall];
    [self.contentView addSubview:self.ballImage];
    [self.contentView addSubview:self.applyBtn];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.status];
    [self.contentView addSubview:self.line];
//    [self addSubview:self.applyDown];
}

// 报名View
- (UIView *)apply
{
    if (!_apply) {
        _apply = [[UIView alloc] init];
        _apply.backgroundColor = [UIColor whiteColor];
    }
    return _apply;
}

// 球~
- (UIImageView *)backBall
{
    if (!_backBall)
    {
        _backBall = [AppTools CreateImageViewImageName:@"home_apply_icon"];
        // 图片自适应大小
        _backBall.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _backBall;
}

- (UIImageView *)ballImage
{
    if (!_ballImage)
    {
        _ballImage = [AppTools CreateImageViewImageName:@""];
        _ballImage.backgroundColor = [UIColor yellowColor];
        _ballImage.layer.masksToBounds = YES;
        _ballImage.layer.cornerRadius = 34.5/2;
    }
    return _ballImage;
}

// 标题
- (UILabel *)title
{
    if (!_title)
    {
        _title = [AppTools createLabelText:@"" Color:TEXT_COLOR_DARK Font:16.0f TextAlignment:NSTextAlignmentLeft];
    }
    return _title;
}

// 时间
- (UILabel *)time
{
    if (!_time)
    {
        _time = [AppTools createLabelText:@"" Color:TEXT_COLOR_LIGHT Font:12.0f TextAlignment:NSTextAlignmentLeft];
    }
    return _time;
}

- (UILabel *)status
{
    if (!_status) {
        _status = [AppTools createLabelText:@"" Color:TEXT_COLOR_RED Font:12.0f TextAlignment:NSTextAlignmentLeft];
    }
    return _status;
}

- (void)setApplyModel:(HomeApplyModel *)applyModel
{
    _applyModel = applyModel;
    NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:applyModel.tIconPath]];
    [_ballImage sd_setImageWithURL:url placeholderImage:PLACEHOLDH options:SDWebImageAllowInvalidSSLCertificates];
    _title.text = applyModel.tGameName;
    _time.text = [NSString stringWithFormat:@"比赛时间：%@", applyModel.tGameBegin];
}


// 报名按钮
- (UIButton *)applyBtn
{
    if (!_applyBtn)
    {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.backgroundColor = NAVIGATIONBAR_COLOR;
        _applyBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_applyBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [AppTools createLabelText:@"立即报名" Color:[UIColor whiteColor] Font:13 TextAlignment:NSTextAlignmentCenter Number:2.5];
        label.font = [UIFont systemFontOfSize:15];
        _applyBtn.layer.masksToBounds = YES;
        _applyBtn.layer.cornerRadius = 5;
        [_applyBtn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_applyBtn);
            make.centerY.equalTo(_applyBtn);
        }];
    }
    return _applyBtn;
}
// btn点击时间 用代理传Url
- (void)applyAction:(UIButton *)apply
{
    [self.delegate applyDelegateUrl:_applyModel.tEnterUrl];
}

- (UIView *)line
{
    if (!_line) {
        _line = [AppTools createViewBackground:LINE_COLOR];
        _line.hidden = YES;
    }
    return _line;
}


- (void)layoutSubviews
{
    [_apply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.mas_equalTo(0);
    }];
    
    [_backBall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_apply);
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            make.left.mas_equalTo(10);
        }else{
            make.left.mas_equalTo(20);
        }
    }];
    
    [_ballImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(34.5);
        make.centerY.equalTo(_backBall.mas_centerY);
        make.centerX.equalTo(_backBall.mas_centerX);
    }];
    
    [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_apply);
        make.width.mas_equalTo(92);
        make.height.mas_equalTo(40);
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            make.right.mas_equalTo(-10);
        }else{
            make.right.mas_equalTo(-20);
        }
        
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5 || IS_IPHONE_4) {
            make.left.equalTo(_ballImage.mas_right).offset(10);
        }else{
            make.left.equalTo(_ballImage.mas_right).offset(20);
        }
        make.right.equalTo(_applyBtn.mas_left).offset(-5);
        make.top.equalTo(_apply.mas_top).offset(13);
        
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title);
        make.bottom.equalTo(_apply.mas_bottom).offset(-12);
    }];
    
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            make.left.equalTo(_time.mas_right).offset(7);
        }else{
            make.left.equalTo(_time.mas_right).offset(15);
        }
        make.top.equalTo(_time.mas_top);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [super layoutSubviews];
}



@end
