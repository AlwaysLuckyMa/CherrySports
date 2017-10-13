//
//  HomeWebViewController.h
//  CherrySports
//
//  Created by dkb on 16/12/5.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeWebViewController : BaseViewController


/** 连接编码 用来请求数据查询Html信息*/
@property (nonatomic, copy) NSString *tNewOrGameId;
/** type*/
@property (nonatomic, copy) NSString *tType;

@end
