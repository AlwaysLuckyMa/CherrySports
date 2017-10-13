//
//  MineMessageCell.h
//  CherrySports
//
//  Created by dkb on 16/11/16.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMessageModel.h"
#import "MyMessageModel.h"
@interface MineMessageCell : UITableViewCell

/** model*/
@property (nonatomic, strong) MyMessageModel *myModel;

@end
