//
//  HomeEventsModel.h
//  CherrySports
//
//  Created by dkb on 16/11/30.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseModel.h"

@interface HomeEventsModel : BaseModel

/** 赛事编码*/
@property (nonatomic, copy) NSString *tId;
/** 首页图片*/
@property (nonatomic, copy) NSString *tImgPath;
/** 首页标题*/
@property (nonatomic, copy) NSString *tTitle;
/** 首页详情介绍*/
@property (nonatomic, copy) NSString *tIndexInfo;
/** 赛事编码*/
@property (nonatomic, copy) NSString *tGameId;
/** 赛事开始日期*/
@property (nonatomic, copy) NSString *tGameBegin;
/** 赛事结束日期*/
@property (nonatomic, copy) NSString *tGameEnd;
/** webId*/
@property (nonatomic, copy) NSString *tInfoUrl;
/** 报名Url*/
@property (nonatomic, copy) NSString *tEnterUrl;

/** 是否外链 0.是*/
@property (nonatomic, copy) NSString *tIsLink;
/** 外链地址*/
@property (nonatomic, copy) NSString *tLink;

@end
