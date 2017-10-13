//
//  HomeApplyModel.h
//  CherrySports
//
//  Created by dkb on 16/12/1.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeApplyModel : BaseModel

/** 赛事编码*/
@property (nonatomic, copy) NSString *tGameId;
/** 赛事名称*/
@property (nonatomic, copy) NSString *tGameName;
/** 赛事图标*/
@property (nonatomic, copy) NSString *tIconPath;
/** 赛事开始日期*/
@property (nonatomic, copy) NSString *tGameBegin;
/** 赛事结束日期*/
@property (nonatomic, copy) NSString *tGameEnd;
/** 赛事状态信息*/
@property (nonatomic, copy) NSString *tGameStateInfo;
/** 报名Url*/
@property (nonatomic, copy) NSString *tEnterUrl;


/** 系统时间*/
@property (nonatomic, copy) NSString *systemTime;

@end
