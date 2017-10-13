//
//  DialogView.h
//  CherrySports
//
//  Created by dkb on 16/11/30.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogView : UIView

/**
 *  加载中
 */
@property (strong,nonatomic) UIView *loadingView;

@property (strong,nonatomic) UIImageView *loadingImageView;
@property (strong,nonatomic) UILabel *loadingLabel;
/**
 *  无网络
 */
@property (strong,nonatomic) UIView *noNetworkView;

@property (strong,nonatomic) UIImageView *noNetworkImageView;
@property (strong,nonatomic) UILabel *noNetworkLabel;
@property (strong,nonatomic) UIButton *noNetworkRefreshButton;
/**
 *  程序异常
 */
@property (strong,nonatomic) UIView *excptionView;

@property (strong,nonatomic) UIImageView *excptionImageView;
@property (strong,nonatomic) UILabel *excptionLabel;
@property (strong,nonatomic) UIButton *excptionRefreshButton;
/**
 *  无数据
 */
@property (strong,nonatomic) UIView *nothingView;

@property (strong,nonatomic) UIImageView *nothingImageView;
@property (strong,nonatomic) UILabel *nothingLabel;
@property (strong,nonatomic) UIButton *nothingRefreshButton;

- (void)runAnimationWithCount:(int)count name:(NSString *)name;
@end
