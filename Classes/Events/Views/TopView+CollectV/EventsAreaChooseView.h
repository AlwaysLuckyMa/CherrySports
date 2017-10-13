//
//  EventsAreaChooseView.h
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventsAreaDelegate <NSObject>

- (void)AreadidSelectTId:(NSString *)tId;

- (void)AreaCollectBackStatus:(NSString *)status;

@end

@interface EventsAreaChooseView : UIView
/** 国内*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 国外*/
@property (nonatomic, strong) NSMutableArray *WArray;

/** 背景View高度*/
@property (nonatomic, assign) CGFloat areaHeight;
/** 代理*/
@property (nonatomic, assign) id<EventsAreaDelegate> areaDelegate;

@end
