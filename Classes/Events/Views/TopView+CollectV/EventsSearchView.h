//
//  EventsSearchView.h
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventsSearchDelegate <NSObject>

- (void)SearchdidSelectTId:(NSString *)tId;

- (void)SearchCollectBackStatus:(NSString *)status;

@end

@interface EventsSearchView : UIView

/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 背景View高度*/
@property (nonatomic, assign) CGFloat searchHeight;
/** 代理*/
@property (nonatomic, assign) id<EventsSearchDelegate> searchDelegate;

@end
