//
//  HomeNewsCell.m
//  CherrySports
//
//  Created by dkb on 16/10/31.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeNewsCell.h"

@implementation HomeNewsCell

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
    [self.contentView addSubview:self.backView];
    [self.backView    addSubview:self.imageView];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.line];
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [AppTools createViewBackground:[UIColor whiteColor]];
        _backView.layer.borderWidth = 2;
        _backView.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    }
    return _backView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [AppTools CreateImageViewImageName:@"002.png"];
    }
    return _imageView;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [AppTools createLabelText:@"争取四连胜，霍村主帅：漂亮的客场胜利！" Color:TEXT_COLOR_DARK Font:16 TextAlignment:NSTextAlignmentLeft];
    }
    return _title;
}

- (UILabel *)content
{
    if (!_content) {
        _content = [AppTools createLabelText:@"在本周末的德甲联赛中，霍芬海姆客场3-0" Color:TEXT_COLOR_LIGHT Font:12 TextAlignment:NSTextAlignmentLeft];
    }
    return _content;
}

- (UILabel *)time
{
    if (!_time) {
        _time = [AppTools createLabelText:@"2016-10-24" Color:TEXT_COLOR_LIGHT Font:12 TextAlignment:NSTextAlignmentRight];
        if (IS_IPHONE_5 || IS_IPHONE_4) {
            _time.font = [UIFont fontWithName:@"Arial" size:12*SCREEN_WIDTH/375];
        }else{
            _time.font = [UIFont fontWithName:@"Arial" size:12];
        }
    }
    return _time;
}

- (UIView *)line
{
    if (!_line) {
        _line = [AppTools createViewBackground:UIColorFromRGB(0xd3d3d3)];
    }
    return _line;
}

- (void)setHomeNewsmodel:(HomeNewsModel *)homeNewsmodel
{
    NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:homeNewsmodel.tImgPath]];
    [_imageView sd_setImageWithURL:url placeholderImage:PLACEHOLDW options:SDWebImageAllowInvalidSSLCertificates];
    
    _title.text = homeNewsmodel.tNewsName;
    _content.text = homeNewsmodel.tIndexInfo;
    NSString *string = [homeNewsmodel.tCreateTime substringToIndex:16];
//    NSLog(@"str = %@",string);
    _time.text = string;
}


- (void)layoutSubviews
{
    WS(weakSelf);
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(103);
        make.height.mas_equalTo(71);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(2);
        make.right.bottom.mas_equalTo(-2);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView.mas_right).offset(10);
        make.top.equalTo(_backView.mas_top).offset(8);
        make.right.mas_equalTo(-10);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title);
        make.right.equalTo(_title.mas_right).offset(-15);
        make.top.equalTo(_title.mas_bottom).offset(2);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(_backView.mas_bottom).offset(-1);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(1);
    }];
    [super layoutSubviews];
}

// 选中变色
- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.contentView.backgroundColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }];
}

@end
