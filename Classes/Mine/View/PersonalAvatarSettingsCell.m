//
//  PersonalAvatarSettingsCell.m
//  CherrySports
//
//  Created by dkb on 16/11/17.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "PersonalAvatarSettingsCell.h"

@interface PersonalAvatarSettingsCell ()

@end

@implementation PersonalAvatarSettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUi];
    }
    return self;
}

- (void)createUi
{
    WS(weakSelf);
    _leftLabel = [AppTools createLabelText:@"" Color:TEXT_COLOR_DARK Font:12 TextAlignment:NSTextAlignmentLeft];
    _leftLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(15);
    }];
    
    _rightImageV = [AppTools CreateImageViewImageName:@""];
    _rightImageV.backgroundColor = [UIColor greenColor];
    _rightImageV.backgroundColor = [UIColor greenColor];
    _rightImageV.layer.borderWidth = 0.5;
    _rightImageV.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    _rightImageV.hidden = YES;
    [self.contentView addSubview:_rightImageV];
    [_rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(65);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
    }];
    
    _rightLabel = [AppTools createLabelText:@"" Color:TEXT_COLOR_LIGHT Font:12 TextAlignment:NSTextAlignmentRight];
    _rightLabel.hidden = YES;
    _rightLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(150);
        make.centerY.equalTo(weakSelf);
        make.height.mas_equalTo(15);
    }];
    
    _lineView = [AppTools createViewBackground:LINE_COLOR];
    _lineView.hidden = YES;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    _wireView = [AppTools createViewBackground:LINE_COLOR];
    _wireView.hidden = YES;
    [self.contentView addSubview:_wireView];
    [_wireView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}




@end
