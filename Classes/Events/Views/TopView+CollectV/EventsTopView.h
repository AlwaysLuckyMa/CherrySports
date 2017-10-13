//
//  EventsTopView.h
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

- (void)AreaClickDelegateSelected:(NSString *)str;
- (void)TypeClickDelegateSelected:(NSString *)str;
- (void)SearchClickDelegateSelected:(NSString *)str;

@end

@interface EventsTopView : UIView

/** 地区选择*/
@property (nonatomic,strong)UIButton *areaButton;
@property (nonatomic,strong)UIImageView *areaImage;
/** 赛事类型*/
@property (nonatomic,strong)UIButton *eventTypeButton;
@property (nonatomic,strong)UIImageView *eventImage;
/** 快捷查询*/
@property (nonatomic,strong)UIButton *searchButton;
@property (nonatomic,strong)UIImageView *searchImage;

/** 阴影*/
@property (nonatomic, strong) UIView *lineColor;
/** 三角*/
@property (nonatomic, strong) UIImageView *jiansj;

@property (nonatomic, assign)id<TopViewDelegate>delegate;


// 判断颜色
- (void)Area:(NSString *)area;

- (void)Type:(NSString *)type;

- (void)Search:(NSString *)search;

@end
