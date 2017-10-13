//
//  MyHeaderCell.h
//  CherrySports
//
//  Created by dkb on 16/12/19.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyHeaderDelegate <NSObject>

- (void)cenderSettingImage;

@end

@interface MyHeaderCell : UITableViewCell

/** 跳转设置页代理*/
@property (nonatomic, assign) id<MyHeaderDelegate> delegate;

/** 背景图片*/
@property (nonatomic, strong) UIImageView *backImage;
/** 名字*/
@property (nonatomic, strong) UILabel *name;
/** 头像*/
@property (nonatomic, strong) UIImageView *avatar;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *dic;

@end
