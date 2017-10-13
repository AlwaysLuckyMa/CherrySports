//
//  NewsWebCommentsViewController.h
//  CherrySports
//
//  Created by dkb on 17/1/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "BaseViewController.h"

//@class NewsWebCommentsViewController;
@protocol CancelCollectionDelegate <NSObject>

-(void)CancelNewsCollectionAndRefresh;

@end

@interface NewsWebCommentsViewController : BaseViewController

/** htmlUrl*/
@property (nonatomic, copy) NSString *htmlUrl;

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

@property (nonatomic, assign)id <CancelCollectionDelegate>delegate;

@end
