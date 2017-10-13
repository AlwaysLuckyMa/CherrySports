//
//  NewsListTableViewCell.h
//  CherrySports
//
//  Created by dkb on 16/11/7.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"

@interface NewsListTableViewCell : UITableViewCell

/** model*/
@property (nonatomic, strong) NewsListModel *model;

/** 置顶*/
@property (nonatomic, strong) UIImageView *top;

@end
