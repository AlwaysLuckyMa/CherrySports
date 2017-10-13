//
//  NewUrlViewController.h
//  CherrySports
//
//  Created by dkb on 17/1/7.
//  Copyright © 2017年 dkb. All rights reserved.
//
#pragma mark - 其他web页跳新URL页
#import "BaseViewController.h"

@interface NewUrlViewController : BaseViewController

/** 新页面Url*/
@property (nonatomic, copy) NSString *urlNew;

/** 标题*/
@property (nonatomic, copy) NSString *titleName;

@end
