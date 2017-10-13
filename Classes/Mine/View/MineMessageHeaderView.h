//
//  MineMessageHeaderView.h
//  CherrySports
//
//  Created by dkb on 16/11/16.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineMessageDelegate <NSObject>

- (void)ClickButtonNum:(NSString *)num;

@end

@interface MineMessageHeaderView : UIView
/** 点*/
@property (nonatomic, strong) UIImageView *eventsImageV;
@property (nonatomic, strong) UIImageView *systemImageV;
@property (nonatomic, strong) UIImageView *commentImageV;

@property (nonatomic, assign) id<MineMessageDelegate>delegate;
@end
