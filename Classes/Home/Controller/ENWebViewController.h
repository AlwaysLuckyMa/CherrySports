//
//  ENWebViewController.h
//  CherrySports
//
//  Created by dkb on 16/12/14.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - 不是外链
#import "BaseViewController.h"

@class ENWebViewController;
@protocol cancelCollectionDelegate <NSObject>

-(void)cancelCollectionAndRefresh;

@end

@interface ENWebViewController : BaseViewController
/** htmlUrl*/
@property (nonatomic, copy) NSString *htmlUrl;
/** 报名Url*/
@property (nonatomic, copy) NSString *tEnterUrl;


/** type*/
@property (nonatomic, copy) NSString *tType;
/** 查询收藏用Id*/
@property (nonatomic, copy) NSString *tId;


/** 分享内容*/
@property (nonatomic, copy) NSString *content;
/** 分享图片*/
@property (nonatomic, copy) NSString *fxImg;
/** 分享标题*/
@property (nonatomic, copy) NSString *fxTitle;

/** 是否外链 0.是*/
@property (nonatomic, copy) NSString *tIsLink;
/** 外链地址*/
@property (nonatomic, copy) NSString *tLink;

/** 是否显示多人报名*/
@property (nonatomic, copy) NSString *tIsManyPeopleEnter;

@property (nonatomic,weak)id <cancelCollectionDelegate> delegate;

@end
