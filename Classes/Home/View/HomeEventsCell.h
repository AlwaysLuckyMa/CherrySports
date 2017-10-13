//
//  HomeEventsCell.h
//  CherrySports
//
//  Created by dkb on 16/10/31.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - 赛事专区Cell

#import <UIKit/UIKit.h>
#import "HomeEventsModel.h"

@interface HomeEventsCell : UICollectionViewCell

/** 图片*/
@property (nonatomic, strong) UIImageView *backImage;
/** 时间*/
@property (nonatomic, strong) UILabel *time;
/** 时间阴影*/
@property (nonatomic, strong) UIImageView *timeImage;
/** title*/
@property (nonatomic, strong) UILabel *title;
/** titleImage*/
@property (nonatomic, strong) UIImageView *titleImage;


/** model*/
@property (nonatomic, strong) HomeEventsModel *homeEventModel;

@end
