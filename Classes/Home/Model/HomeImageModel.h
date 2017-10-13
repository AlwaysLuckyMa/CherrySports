//
//  HomeImageModel.h
//  CherrySports
//
//  Created by dkb on 16/11/30.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseModel.h"

@interface HomeImageModel : BaseModel
/** 轮播图编码*/
@property (nonatomic, copy) NSString *tId;
/** 首页图片地址*/
@property (nonatomic, copy) NSString *tImgPath;
/** 0 外链 1 系统内部*/
@property (nonatomic, copy) NSString *tIsLink;
/** 链接地址*/
@property (nonatomic, copy) NSString *tLink;
/** 类型*/
@property (nonatomic, copy) NSString *tType;
/** 链接编码*/
@property (nonatomic, copy) NSString *tNewOrGameId;
/** 小图片*/
@property (nonatomic, copy) NSString *tNavigationImg;
/** url*/
@property (nonatomic, copy) NSString *tInfoUrl;
/** 标题*/
@property (nonatomic, copy) NSString *tName;
/** 简介*/
@property (nonatomic, copy) NSString *tIntroduction;

/** 用来报名的Url*/
@property (nonatomic, copy) NSString *tEnterUrl;

@end
