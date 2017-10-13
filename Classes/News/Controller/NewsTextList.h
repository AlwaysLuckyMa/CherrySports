//
//  NewsTextList.h
//  CherrySports
//
//  Created by dkb on 16/12/18.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsTypeModel.h"

#import "ZJScrollPageViewDelegate.h"

@interface NewsTextList : BaseViewController<ZJScrollPageViewChildVcDelegate>

/** typeModel*/
@property (nonatomic, strong) NewsTypeModel *model;

@property (nonatomic, strong) NSMutableArray *btnArr;

@end
