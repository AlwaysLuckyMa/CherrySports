//
//  MineCollectHeaderView.h
//  CherrySports
//
//  Created by dkb on 16/11/23.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectHeaderDelegate <NSObject>

- (void)ClickButtonNumber:(NSString *)num;

@end

@interface MineCollectHeaderView : UIView

@property (nonatomic, assign) id<CollectHeaderDelegate>delegate;

/** 赛事收藏*/
@property (nonatomic, strong) UIButton *eventsBtn;
/** 咨询收藏*/
@property (nonatomic, strong) UIButton *newsBtn;

@end
