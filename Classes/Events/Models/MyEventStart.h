//
//  MyEventStart.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/2/28.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "BaseModel.h"

@interface MyEventStart : BaseModel

/* 状态编码*/
@property (nonatomic, copy) NSString *resultCode;
/* 状态描述*/
@property (nonatomic, copy) NSString *resultMessage;
/* 赛事编码*/
@property (nonatomic, copy) NSString *tGameId;
/* 赛事名称*/
@property (nonatomic, copy) NSString *tGameName;
/* 分享标题*/
@property (nonatomic, copy) NSString *tTitle;
/* 赛事图片*/
@property (nonatomic, copy) NSString *tImgPath;
/* 赛事成绩显示Url*/
@property (nonatomic, copy) NSString *tGamesResultUrl;
/* 赛后成绩证书*/
@property (nonatomic, copy) NSString *tGamesCertificateImg;
/* 分享内容*/
@property (nonatomic, copy) NSString *tInfo;
@end
