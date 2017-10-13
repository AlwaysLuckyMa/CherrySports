//
//  PersonalAvatarSettingsCell.h
//  CherrySports
//
//  Created by dkb on 16/11/17.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalAvatarSettingsCell : UITableViewCell

/** 底线*/
@property (nonatomic, strong) UIView *lineView;
/** 底线*/
@property (nonatomic, strong) UIView *wireView;

/** title*/
@property (nonatomic, strong) UILabel *leftLabel;

/** 头像*/
@property (nonatomic, strong) UIImageView *rightImageV;
/** 右侧label*/
@property (nonatomic, strong) UILabel *rightLabel;
@end
