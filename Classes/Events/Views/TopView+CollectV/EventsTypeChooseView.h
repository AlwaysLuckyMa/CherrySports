//
//  EventsTypeChooseView.h
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - 赛事类型
#import <UIKit/UIKit.h>

@protocol EventsTypeDelegate <NSObject>

- (void)TypedidSelectTId:(NSString *)tId;

- (void)TypeCollectBackStatus:(NSString *)status;

@end

@interface EventsTypeChooseView : UIView
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 背景View高度*/
@property (nonatomic, assign) CGFloat typeHeight;
/** 代理*/
@property (nonatomic, assign) id<EventsTypeDelegate> typeDelegate;

@end
