//
//  MineEventsWebVC.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/2/28.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineEventsWebVC : UIViewController
/** htmlUrl*/
@property (nonatomic, copy) NSString *htmlUrl;

/** type*/
@property (nonatomic, copy) NSString *tType;


/* 赛事编码*/
@property (nonatomic, copy) NSString *tGameId;
/** 赛事标题*/
@property (nonatomic, copy) NSString *content;
/** 分享图片*/
@property (nonatomic, copy) NSString *fxImg;
/** 分享标题*/
@property (nonatomic, copy) NSString *fxTitle;

/* 赛事成绩显示Url*/
@property (nonatomic, copy) NSString *tGamesResultUrl;

@property (nonatomic, copy) NSString *tInfo;

@end
