//
//  MineCollectNewsCell.m
//  CherrySports
//
//  Created by dkb on 16/11/23.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineCollectNewsCell.h"

@interface MineCollectNewsCell ()
/** 图片边框*/
@property (nonatomic, strong) UIView *backView;
/** 图片*/
@property (nonatomic, strong) UIImageView *imageV;
/** 标题*/
@property (nonatomic, strong) UILabel *title;
/** 内容*/
@property (nonatomic, strong) UILabel *content;
/** 日期*/
@property (nonatomic, strong) UILabel *time;
/** 置顶*/
@property (nonatomic, strong) UIImageView *top;
/** 底部线*/
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation MineCollectNewsCell

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
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.imageV];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.selectButton];
}
-(UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [UIButton new];
        _selectButton.hidden = YES;
        _selectButton.userInteractionEnabled = NO;
    }return _selectButton;
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

- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [AppTools CreateImageViewImageName:@"003.png"];
    }
    return _imageV;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [AppTools createLabelText:@"豪取四连胜，霍村主帅：漂亮的客场胜利！" Color:TEXT_COLOR_DARK Font:16 TextAlignment:NSTextAlignmentLeft];
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
        _time = [AppTools createLabelText:@"2016-10-24" Color:TEXT_COLOR_LIGHT Font:9 TextAlignment:NSTextAlignmentRight];
        if (IS_IPHONE_5 || IS_IPHONE_4) {
            _time.font = [UIFont fontWithName:@"Arial" size:12*SCREEN_WIDTH/375];
        }else{
            _time.font = [UIFont fontWithName:@"Arial" size:12];
        }
    }
    return _time;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [AppTools createViewBackground:LINE_COLOR];
    }
    return _bottomLine;
}


- (void)setNewsModel:(MyCollectNews *)newsModel
{
    NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:newsModel.tImgPath]];
    [_imageV sd_setImageWithURL:url placeholderImage:PLACEHOLDW options:SDWebImageAllowInvalidSSLCertificates];
    
    _title.text = newsModel.tNewsName;
    _content.text = newsModel.tIndexInfo;
    _time.text = newsModel.tCreateTime;
    // 按钮颜色
    if (newsModel.isGreen == NO) {
        [_selectButton setImage:[UIImage imageNamed:@"mine_collection_gouGray"] forState:UIControlStateNormal];
    }else{
        [_selectButton setImage:[UIImage imageNamed:@"mine_collection_gouGreen"] forState:UIControlStateNormal];
    }
    
}


- (void)layoutSubviews
{
    WS(weakSelf);
    //删除选中按钮
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.width.and.height.mas_equalTo(25);
    }];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(103);
        make.height.mas_equalTo(71);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [super layoutSubviews];
}


@end
