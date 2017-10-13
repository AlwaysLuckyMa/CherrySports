//
//  MyEventWebViewController.h
//  CherrySports
//
//  Created by dkb on 17/1/7.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "BaseViewController.h"

@interface MyEventWebViewController : BaseViewController

/** htmlUrl*/
@property (nonatomic, copy) NSString *htmlUrl;
/** 报名Url*/
@property (nonatomic, copy) NSString *tEnterUrl;


/** type*/
@property (nonatomic, copy) NSString *tType;
/** 查询收藏用Id*/
@property (nonatomic, copy) NSString *tId;

/** 我的赛事*/
@property (nonatomic, copy) NSString *tTitleName;

/** 分享内容*/
@property (nonatomic, copy) NSString *content;
/** 分享图片*/
@property (nonatomic, copy) NSString *fxImg;
/** 分享标题*/
@property (nonatomic, copy) NSString *fxTitle;

@property (nonatomic, copy) NSString *tEnterUserId;//用户id

@property (nonatomic, copy) NSString *tOrderId; //订单id

@end
