//
//  NewsTitleCell.m
//  CherrySports
//
//  Created by dkb on 17/1/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "NewsTitleCell.h"

@interface NewsTitleCell ()
/** 评论*/
@property (nonatomic, strong) UIImageView *borderBack;
/** 红线*/
@property (nonatomic, strong) UIView *buttomRed;
/** 标题左边竖线*/
@property (nonatomic, strong) UIImageView *titleLeft;
/** 标题*/
@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *comment;
/** 评论数*/
@property (nonatomic, strong) UILabel *commentNum;

@property (nonatomic, strong) UILabel *join;
/** 参加数*/
@property (nonatomic, strong) UILabel *joinNum;

/** 底部线*/
@property (nonatomic, strong) UIView *buttomLine;

@end

@implementation NewsTitleCell

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
    [self.contentView addSubview:self.borderBack];
    [self.contentView addSubview:self.buttomRed];
    [self.contentView addSubview:self.titleLeft];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.comment];
    [self.contentView addSubview:self.commentNum];
    [self.contentView addSubview:self.join];
    [self.contentView addSubview:self.joinNum];
//    [self.contentView addSubview:self.buttomLine];
}

// 圆角线back
- (UIImageView *)borderBack
{
    if (!_borderBack) {
        _borderBack = [AppTools CreateImageViewImageName:@"web_red_back1"];
        _borderBack.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _borderBack;
}

// 平铺下阴影
- (UIView *)buttomRed
{
    if (!_buttomRed)
    {
        UIImage *backImage = [UIImage imageNamed:@"web_red_line"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        _buttomRed = [UIView new];
        _buttomRed.backgroundColor = bc;
    }
    return _buttomRed;
}

- (UIImageView *)titleLeft
{
    if (!_titleLeft)
    {
        _titleLeft = [AppTools CreateImageViewImageName:@"web_title_leftLine"];
        _titleLeft.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _titleLeft;
}

- (UILabel *)title
{
    if (!_title)
    {
        _title = [AppTools createLabelText:@"最新评论" Color:UIColorFromRGB(0xe60012) Font:12 TextAlignment:NSTextAlignmentLeft];
        _title.font = [UIFont systemFontOfSize:12];
    }
    return _title;
}

- (UILabel *)comment
{
    if (!_comment) {
        _comment = [AppTools createLabelText:@"条评论" Color:UIColorFromRGB(0xe60012) Font:12 TextAlignment:NSTextAlignmentRight];
        _comment.font = [UIFont systemFontOfSize:12];
    }
    return _comment;
}

- (UILabel *)commentNum
{
    if (!_commentNum) {
        _commentNum = [AppTools createLabelText:@"256" Color:UIColorFromRGB(0xe60012) Font:18 TextAlignment:NSTextAlignmentRight];
        _commentNum.font = [UIFont fontWithName:@"Berlin Sans FB" size:18];
    }
    return _commentNum;
}

- (UILabel *)join
{
    if (!_join) {
        _join = [AppTools createLabelText:@"人参加，" Color:UIColorFromRGB(0xe60012) Font:12 TextAlignment:NSTextAlignmentRight];
        _join.font = [UIFont systemFontOfSize:12];
    }
    return _join;
}

- (UILabel *)joinNum
{
    if (!_joinNum) {
        _joinNum = [AppTools createLabelText:@"751" Color:UIColorFromRGB(0xe60012) Font:18 TextAlignment:NSTextAlignmentRight];
        _joinNum.font = [UIFont fontWithName:@"Berlin Sans FB" size:18];
    }
    return _joinNum;
}

- (UIView *)buttomLine
{
    if (!_buttomLine) {
        _buttomLine = [AppTools createViewBackground:UIColorFromRGB(0xc1c1c1)];
    }
    return _buttomLine;
}
- (void)layoutSubviews
{
    WS(weakSelf);
    [_borderBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
    }];
    
    [_buttomRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_borderBack.mas_right).offset(-0.5);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(_borderBack);
    }];
    
    [_titleLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_borderBack.mas_left);
        make.top.equalTo(_borderBack.mas_bottom).offset(9);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLeft.mas_right).offset(5);
        make.centerY.equalTo(_titleLeft);
    }];
    
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.5);
        make.bottom.equalTo(_buttomRed.mas_top).offset(-2);
    }];
    
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_comment.mas_left);
        make.bottom.equalTo(_comment.mas_bottom).offset(2);
    }];
    
    [_join mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentNum.mas_left);
        make.bottom.equalTo(_comment);
    }];
    
    [_joinNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_join.mas_left);
        make.bottom.equalTo(_commentNum);
    }];
    
    [_buttomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(0.5);
    }];

    [super layoutSubviews];
}



@end
