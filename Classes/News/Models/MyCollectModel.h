//
//  MyCollectModel.h
//  CherrySports
//
//  Created by dkb on 16/12/5.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseModel.h"

@interface MyCollectModel : BaseModel

/** dd:hh:mm:ss*/
@property (nonatomic, copy) NSString *countDownTime;
/** 毫秒*/
@property (nonatomic, assign) long long int countDownMilli;
/** 记录结束时间*/
@property (nonatomic, assign) long long int endMilli;

/** 赛事编码*/
@property (nonatomic, copy) NSString *tId;
/** 赛事名称*/
@property (nonatomic, copy) NSString *tGameName;
/** 赛事所在城市*/
@property (nonatomic, copy) NSString *tCity;
/** 赛事详细地址*/
@property (nonatomic, copy) NSString *tAdress;
/** 赛事类型*/
@property (nonatomic, copy) NSString *tGameType;
/** 赛事当前状态 （数字）*/
@property (nonatomic, copy) NSString *tGameState;
/** 赛事当前状态信息 （文字）*/
@property (nonatomic, copy) NSString *tGameStateInfo;
/** 报名开始时间*/
@property (nonatomic, copy) NSString *tEnterBegin;
/** 报名结束时间*/
@property (nonatomic, copy) NSString *tEnterEnd;
/** 赛事开始日期*/
@property (nonatomic, copy) NSString *tGameBegin;
/** 赛事结束日期*/
@property (nonatomic, copy) NSString *tGameEnd;
/** 录入时间*/
@property (nonatomic, copy) NSString *tCreateTime;
/** 赛事图片*/
@property (nonatomic, copy) NSString *tImgPath;
/** 赛事简介(html)*/
@property (nonatomic, copy) NSString *tInfoUrl;
/** 赛事简介*/
@property (nonatomic, copy) NSString *gettIntroduction;

/** 是否外链 0.是*/
@property (nonatomic, copy) NSString *tIsLink;
/** 外链地址*/
@property (nonatomic, copy) NSString *tLink;

/** 报名Url*/
@property (nonatomic, copy) NSString *tEnterUrl;

/** 判断是否绿色勾选图片**/
@property (nonatomic,assign) BOOL isGreen;


@end
