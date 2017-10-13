//
//  MineHeaderNewCell.m
//  CherrySports
//
//  Created by dkb on 16/11/7.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineHeaderNewCell.h"

@interface MineHeaderNewCell ()

/** 名字背景图*/
@property (nonatomic, strong) UIImageView *nameBack;

/** 头像边框*/
@property (nonatomic, strong) UIView *backView;

@end

@implementation MineHeaderNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self addViews];
    }
    return self;
}

- (void)addViews
{
    [self.contentView addSubview:self.backImage];
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.name];
}

- (UIImageView *)backImage
{
    if (!_backImage) {
        _backImage = [AppTools CreateImageViewImageName:@"mine_backImg"];
        _backImage.userInteractionEnabled = YES;
    }
    return _backImage;
}

- (UIView *)backView
{
    if (!_backView)
    {
        _backView = [AppTools createViewBackground:[UIColor whiteColor]];
        _backView.layer.borderWidth = 0.5;
        _backView.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    }
    return _backView;
}

- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [AppTools CreateImageViewImageName:@"mine_nv"];
        _avatar.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_avatar addGestureRecognizer:tap];
    }
    return _avatar;
}
// 为图片和头像图片添加轻拍手势
- (void)tapAction:(UITapGestureRecognizer *)cender
{
    [self.delegate cenderSettingImage];
}

//- (UIImageView *)nameBack
//{
//    if (!_nameBack) {
//        _nameBack = [AppTools CreateImageViewImageName:@"mine_name_back"];
//    }
//    return _nameBack;
//}

- (UILabel *)name
{
    if (!_name) {
        _name = [AppTools createLabelText:@"昵称" Color:TEXT_COLOR_DARK Font:12 TextAlignment:NSTextAlignmentRight];
        _name.font = [UIFont systemFontOfSize:12];
//        _name.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
//        _name.shadowOffset = CGSizeMake(1.0, 1.0);
        _name.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_name addGestureRecognizer:tap];
    }
    return _name;
}

- (void)setDic:(NSMutableDictionary *)dic
{
    WS(weakSelf);
    NSString *urlStr = [dic objectForKey:@"tHeadPicture"];
    NSString *gender = [dic objectForKey:@"tGender"];
    if (urlStr.length > 0) {
        NSURL *url;
        if([urlStr rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
        {
            url = [NSURL URLWithString:urlStr];
        }else{
            url = [NSURL URLWithString:[AppTools httpsWithStr:urlStr]];
        }
        if ([gender isEqualToString:@"0"]) {
            [_avatar sd_setImageWithURL:url placeholderImage:PLACEHOLDNV options:SDWebImageAllowInvalidSSLCertificates];
        }else{
            [_avatar sd_setImageWithURL:url placeholderImage:PLACEHOLDNAN options:SDWebImageAllowInvalidSSLCertificates];
        }
    }else{
        if (gender.length == 0) {
            _avatar.image = PLACEHOLDNAN;
        }else if ([gender isEqualToString:@"0"]){
            _avatar.image = PLACEHOLDNV;
        }else{
            _avatar.image = PLACEHOLDNAN;
        }
    }
    
    NSString *urlhStr = [dic objectForKey:@"tBackgroundImg"];
    if (urlhStr.length > 0) {
        NSURL *urlH = [NSURL URLWithString:[AppTools httpsWithStr:[dic objectForKey:@"tBackgroundImg"]]];
        [_backImage sd_setImageWithURL:urlH placeholderImage:[UIImage imageNamed:@"mine_backImg"] options:SDWebImageAllowInvalidSSLCertificates];
    }else{
        _backImage.image = [UIImage imageNamed:@"mine_backImg"];
    }
    
    NSString *nameStr = [dic objectForKey:@"tNickname"];
    if (nameStr.length > 0) {
        _name.text = nameStr;
    }else{
        _name.text = @"昵称";
    }
    if (_name.text.length > 2) {
        CGFloat backWidth;
        backWidth = [AppTools labelRectWithLabelSize:CGSizeMake(10000, 18) LabelText:_name.text Font:[UIFont systemFontOfSize:13]].width;
        
        [_nameBack mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(backWidth+20);
            make.centerX.equalTo(weakSelf);
        }];
    }else{
        [_nameBack mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(43);
            make.centerX.equalTo(weakSelf);
        }];
    }
}


- (void)layoutSubviews
{
    [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(0.56 * SCREEN_WIDTH);
    }];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-29);
        make.bottom.mas_equalTo(-4);
        make.width.height.mas_equalTo(65.5);
    }];
    
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_backView).offset(0.5);
        make.right.bottom.equalTo(_backView).offset(-0.5);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_avatar.mas_left).offset(-13);
        make.bottom.mas_equalTo(-12);
    }];
    
    [super layoutSubviews];
}


@end
