//
//  MineAboutAsViewController.h
//  CherrySports
//
//  Created by dkb on 16/11/10.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - 关于我们 
#import "BaseViewController.h"

@interface MineAboutAsViewController : BaseViewController

/** 简介*/
@property (nonatomic, copy) NSString *synopsis;
/** 微信公众号*/
@property (nonatomic, copy) NSString *wechatPublicNumber;
/** 新浪微博*/
@property (nonatomic, copy) NSString *microBlogSina;
/** 官网*/
@property (nonatomic, copy) NSString *officialWebsite;

@end
