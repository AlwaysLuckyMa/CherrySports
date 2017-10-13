//
//  StartModel.h
//  CherrySports
//
//  Created by dkb on 17/2/15.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartModel : BaseModel

/** 版本*/
@property (nonatomic, copy) NSString *tVersion;
/** 视频播放时间*/
@property (nonatomic, copy) NSString *tPlayTime;
/** 下载地址*/
@property (nonatomic, copy) NSString *tDownloadUrl;
/** 是否外链*/
@property (nonatomic, copy) NSString *tIsLink;
/** 链接地址*/
@property (nonatomic, copy) NSString *tLink;

/** 本地图片地址*/
@property (nonatomic, copy) NSString *localImageUrl;

/** 第几张图*/
@property (nonatomic, copy) NSString *number;


/** 文件名*/
@property (nonatomic, copy) NSString *fileName;

/** 赛事报名Url地址*/
@property (nonatomic, copy) NSString *tEnterUrl;

/** 首页图片*/
@property (nonatomic, copy) NSString *tImgPath;

/** 简介*/
@property (nonatomic, copy) NSString *tIntroduction;

/** 赛事or资讯*/
@property (nonatomic, copy) NSString *tLinkType;

/** 分享标题*/
@property (nonatomic, copy) NSString *tName;

/** 链接编码*/
@property (nonatomic, copy) NSString *tNewOrGameId;


@end
