//
//  NewsCommentsCell.m
//  CherrySports
//
//  Created by dkb on 17/1/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "NewsCommentsCell.h"

@interface NewsCommentsCell ()

/** 头像*/
@property (nonatomic, strong) UIImageView *imageV;

/** 名字*/
@property (nonatomic, strong) UILabel *titleName;

/** content*/
@property (nonatomic, strong) UILabel *content;

/** <#注释#>*/
@property (nonatomic, strong) UIView *buttomLine;

@end

@implementation NewsCommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleName];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.buttomLine];
    [self.contentView addSubview:self.time];
}

- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [AppTools CreateImageViewImageName:@""];
        _imageV.backgroundColor = [UIColor greenColor];
        _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = 28/2;
    }
    return _imageV;
}

- (UILabel *)titleName
{
    if (!_titleName) {
        _titleName = [AppTools createLabelText:@"芭比娃娃" Color:UIColorFromRGB(0x2991fb) Font:11 TextAlignment:NSTextAlignmentLeft];
        _titleName.font = [UIFont systemFontOfSize:11];
    }
    return _titleName;
}

- (UILabel *)content
{
    if (!_content) {
        _content = [AppTools createLabelText:@"LZSB，加油加油" Color:UIColorFromRGB(0x464646) Font:11 TextAlignment:NSTextAlignmentLeft];
        _content.font = [UIFont systemFontOfSize:11];
    }
    return _content;
}

// 平铺下阴影
- (UIView *)buttomLine
{
    if (!_buttomLine)
    {
        UIImage *backImage = [UIImage imageNamed:@"web_xvline"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        _buttomLine = [UIView new];
        _buttomLine.backgroundColor = bc;
    }
    return _buttomLine;
}

- (UILabel *)time
{
    if (!_time) {
        _time = [AppTools createLabelText:@"11-12 11:30" Color:UIColorFromRGB(0xc1c1c1) Font:10 TextAlignment:NSTextAlignmentRight];
        _time.font = [UIFont fontWithName:@"Arial" size:10];
    }
    return _time;
}

- (void)layoutSubviews
{
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(28);
    }];
    
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageV.mas_right).offset(8);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleName);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-20);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(_titleName);
    }];
    
    [_buttomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    [super layoutSubviews];
}

@end
