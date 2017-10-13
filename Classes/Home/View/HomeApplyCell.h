//
//  HomeApplyCell.h
//  CherrySports
//
//  Created by dkb on 16/10/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#pragma mark - 立即报名Cell
#import <UIKit/UIKit.h>
#import "HomeApplyModel.h"

@protocol HomeapplyDelegate <NSObject>

- (void)applyDelegateUrl:(NSString *)url;

@end

@interface HomeApplyCell : UICollectionViewCell

/** */
@property (nonatomic, assign) id<HomeapplyDelegate> delegate;

/** 报名白色View*/
@property (nonatomic, strong) UIView *apply;
/** 球*/
@property (nonatomic, strong) UIImageView *ballImage;
/** 球背景*/
@property (nonatomic, strong) UIImageView *backBall;
/** title*/
@property (nonatomic, strong) UILabel *title;
/** time*/
@property (nonatomic, strong) UILabel *time;
/** 状态*/
@property (nonatomic, strong) UILabel *status;
/** 报名按钮*/
@property (nonatomic, strong) UIButton *applyBtn;

/** 报名model*/
@property (nonatomic, strong) HomeApplyModel *applyModel;

/** 线*/
@property (nonatomic, strong) UIView *line;


@end
