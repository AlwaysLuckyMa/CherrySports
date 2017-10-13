//
//  MineHeaderNewCell.h
//  CherrySports
//
//  Created by dkb on 16/11/7.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - 头部cell
#import <UIKit/UIKit.h>

@protocol MineHeaderDelegate <NSObject>

- (void)cenderSettingImage;

@end

@interface MineHeaderNewCell : UITableViewCell

/** 跳转设置页代理*/
@property (nonatomic, assign) id<MineHeaderDelegate> delegate;

/** 背景图片*/
@property (nonatomic, strong) UIImageView *backImage;
/** 名字*/
@property (nonatomic, strong) UILabel *name;
/** 头像*/
@property (nonatomic, strong) UIImageView *avatar;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *dic;

@end
