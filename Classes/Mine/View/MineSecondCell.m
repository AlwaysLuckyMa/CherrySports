//
//  SecondCell.m
//  CherrySports
//
//  Created by 吴庭宇 on 2016/10/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineSecondCell.h"


@interface SecondCell ()
/** 底部线*/
@property (nonatomic,strong) UIView *lineView;
/** 图标*/
@property (nonatomic,strong) UIImageView *accessoryTypeImage;

@end
@implementation SecondCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
        
    }
    return self;
}
-(void)makeUI{
    [self.contentView addSubview:self.Label];
    [self addSubview:self.accessoryTypeImage];
    [self addSubview:self.lineView];
    [self.contentView addSubview:self.leftImage];
    [self.contentView addSubview:self.smallButton];
}
#pragma mark --懒加载
-(UIButton *)smallButton
{
    if (!_smallButton) {
        _smallButton =[UIButton new];
        [_smallButton setBackgroundImage:[UIImage imageNamed:@"mine_message_redpoint"] forState:UIControlStateNormal];
        _smallButton.hidden = YES; // 默认隐藏
        _smallButton.userInteractionEnabled = NO;
        _smallButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }return _smallButton;
}
-(UILabel *)Label
{
    if (!_Label) {
        _Label = [AppTools createLabelText:@"" Color:TEXT_COLOR_DARK Font:16 TextAlignment:NSTextAlignmentLeft];
    }
    return _Label;
}

-(UIImageView *)leftImage
{
    if (!_leftImage) {
        _leftImage =[UIImageView new];
    }
    return _leftImage;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView =[AppTools createViewBackground:LINE_COLOR];
    }return _lineView;
}
-(UIImageView *)accessoryTypeImage
{
    if (!_accessoryTypeImage) {
        _accessoryTypeImage = [AppTools CreateImageViewImageName:@"accessoryType.png"];
        _accessoryTypeImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _accessoryTypeImage;
}

- (void)layoutSubviews
{
    WS(weakSelf);
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
    
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.equalTo(weakSelf);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(26);
    }];
    
    [_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImage.mas_right).offset(25);
        make.centerY.equalTo(weakSelf);
        make.width.mas_equalTo(150);
    }];
    [_smallButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_Label.mas_right).offset(-40);
        make.left.mas_equalTo(120);
        make.top.equalTo(_Label.mas_top).offset(2);
    }];
    [_accessoryTypeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-25);
        make.centerY.equalTo(weakSelf);
    }];
    
    [super layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
