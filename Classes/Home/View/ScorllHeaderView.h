//
//  ScorllHeaderView.h
//  CherrySports
//
//  Created by dkb on 16/10/27.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - header视图（轮播图）
#import <UIKit/UIKit.h>
#import "HomeImageModel.h"

@protocol ClickSliderImageIdDelegate <NSObject>

- (void)ClickSliderWebModel:(HomeImageModel *)webModel;

@end

@interface ScorllHeaderView : UICollectionReusableView <UIScrollViewDelegate>
/** scro*/
@property (nonatomic, strong) UIScrollView *myScrollView;
/** 右侧scro*/
@property (nonatomic, strong) UIScrollView *btnScrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;
/** 图片数组*/
//@property (nonatomic, strong) NSMutableArray *imageArr;
//@property (nonatomic, strong) HomeImageModel *model;
/** 右侧图片数组（不需要前后加图片）*/
@property (nonatomic, strong) NSMutableArray *btnArr;
/** 定时器*/
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,strong) UIPageControl *pageControl;

/** 点击slider代理*/
@property (nonatomic, assign) id<ClickSliderImageIdDelegate> delegate;

@end
