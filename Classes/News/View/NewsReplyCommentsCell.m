//
//  NewsReplyCommentsCell.m
//  CherrySports
//
//  Created by dkb on 17/1/17.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "NewsReplyCommentsCell.h"

@interface NewsReplyCommentsCell ()
/** 头像*/
@property (nonatomic, strong) UIImageView *imageV;

/** 名字*/
@property (nonatomic, strong) UILabel *titleName;

/** 回复谁的n内容*/
@property (nonatomic, strong) UILabel *commentName;

/** 灰色背景*/
@property (nonatomic, strong) UIView *backView;

/** 原始内容content*/
@property (nonatomic, strong) UILabel *content;

/** 底部线*/
@property (nonatomic, strong) UIView *buttomLine;
@end

@implementation NewsReplyCommentsCell

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
    [self.contentView addSubview:self.buttomLine];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.commentName];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.content];
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

- (UILabel *)commentName
{
    WS(weakSelf);
    if (!_commentName) {
        _commentName = [UILabel new];
        _commentName.text = @"回复@芭比娃娃：居然不是一楼~";
        _commentName.textColor = UIColorFromRGB(0x464646);
        _commentName.font = [UIFont systemFontOfSize:11];
        [weakSelf fuwenbenLabel:_commentName FontNumber:[UIFont systemFontOfSize:11] AndRange:NSMakeRange(2, 6) AndColor:UIColorFromRGB(0x2991fb)];
    }
    return _commentName;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [AppTools createViewBackground:UIColorFromRGB(0xededed)];
    }
    return _backView;
}

- (UILabel *)content
{
    WS(weakSelf);
    if (!_content) {
        _content = [AppTools createLabelText:@"芭比娃娃：LZSB，加油加油" Color:UIColorFromRGB(0x8a8a8a) Font:11 TextAlignment:NSTextAlignmentLeft];
        _content.font = [UIFont systemFontOfSize:11];
        [weakSelf fuwenbenLabel:_content FontNumber:[UIFont systemFontOfSize:11] AndRange:NSMakeRange(0, 5) AndColor:UIColorFromRGB(0x464646)];
    }
    return _content;
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
    
    [_commentName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleName);
        make.top.equalTo(_titleName.mas_bottom).offset(7);
    }];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.top.equalTo(_commentName.mas_bottom).offset(7);
        make.left.equalTo(_titleName);
        make.right.mas_equalTo(-20);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(_backView);
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


//设置不同字体颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
}

@end
