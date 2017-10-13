//
//  MineCollectNewsCell.h
//  CherrySports
//
//  Created by dkb on 16/11/23.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectNews.h"

@interface MineCollectNewsCell : UITableViewCell

/** <#注释#>*/
@property (nonatomic, strong) MyCollectNews *newsModel;
/** 删除按钮 **/
@property (nonatomic,strong)UIButton *selectButton;

@end
