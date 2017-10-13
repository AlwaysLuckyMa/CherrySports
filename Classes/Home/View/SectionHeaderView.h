//
//  SectionHeaderView.h
//  CherrySports
//
//  Created by dkb on 16/10/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#pragma mark - 区头视图
#import <UIKit/UIKit.h>

@interface SectionHeaderView : UICollectionReusableView

/** 平铺报名下的阴影*/
@property (nonatomic, strong) UIView *applyDown;

/** 标题图片*/
@property (nonatomic, strong) UIImageView *titleImage;
/** 更多*/
@property (nonatomic, strong) UIButton *moreBtn;

/** 标题*/
@property (nonatomic, strong) UILabel *titleName;


@end
