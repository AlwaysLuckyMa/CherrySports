//
//  HomeNewsCell.h
//  CherrySports
//
//  Created by dkb on 16/10/31.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewsModel.h"

@interface HomeNewsCell : UICollectionViewCell

/** 图片边框*/
@property (nonatomic, strong) UIView *backView;
/** 图片*/
@property (nonatomic, strong) UIImageView *imageView;
/** 标题*/
@property (nonatomic, strong) UILabel *title;
/** 内容*/
@property (nonatomic, strong) UILabel *content;
/** 时间*/
@property (nonatomic, strong) UILabel *time;

/** 线*/
@property (nonatomic, strong) UIView *line;

/** model*/
@property (nonatomic, strong) HomeNewsModel *homeNewsmodel;

@end
