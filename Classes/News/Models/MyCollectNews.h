//
//  MyCollectNews.h
//  CherrySports
//
//  Created by dkb on 16/12/5.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseModel.h"

@interface MyCollectNews : BaseModel

/** 资讯编码*/
@property (nonatomic, copy) NSString *tId;
/** 名称*/
@property (nonatomic, copy) NSString *tNewsName;
/** 城市*/
@property (nonatomic, copy) NSString *tCity;
/** 资讯类型*/
@property (nonatomic, copy) NSString *tNewsType;
/** 图片*/
@property (nonatomic, copy) NSString *tImgPath;
/** 是否显示在首页*/
@property (nonatomic, copy) NSString *tIsIndex;
/** 录入时间*/
@property (nonatomic, copy) NSString *tCreateTime;
/** 首页简介*/
@property (nonatomic, copy) NSString *tIndexInfo;
/** 详情*/
@property (nonatomic, copy) NSString *tNewsInfoUrl;
/** 报名Url*/
@property (nonatomic, copy) NSString *tEnterUrl;


/** 判断是否绿色勾选图片**/
@property (nonatomic,assign) BOOL isGreen;


@end
