//
//  EventsAreaCollectCell.h
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsCityModel.h"
#import "EventsSelectModel.h"
#import "EventsTypeModel.h"

@interface EventsAreaCollectCell : UICollectionViewCell

/** 城市model*/
@property (nonatomic, strong) EventsCityModel *eventCityModel;
/** 查询model*/
@property (nonatomic, strong) EventsSelectModel *selectModel;
/** 类型model*/
@property (nonatomic, strong) EventsTypeModel *typeModel;


@property (nonatomic, assign) CGFloat titleWidth;

/** title*/
@property (nonatomic, strong) UILabel *title;

-(void)labelValSelect:(NSString *)isSelect;

@end
