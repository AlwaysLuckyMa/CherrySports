//
//  MineCollectEventsCell.h
//  CherrySports
//
//  Created by dkb on 16/11/23.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectModel.h"
@interface MineCollectEventsCell : UITableViewCell

@property (nonatomic, strong)MyCollectModel *eventsModel;

/** 可能有的不需要倒计时,如倒计时时间已到, 或者已经过了 */
@property (nonatomic, assign) BOOL needCountDown;
/** 倒计时到0时回调 */
@property (nonatomic, copy) void(^countDownZero)();
/** 删除按钮 **/
@property (nonatomic,strong)UIButton *selectButton;

/** 状态*/
@property (nonatomic, strong) UILabel *status;

/** 结束字样*/
@property (nonatomic, strong) UILabel *theEnd;


@end
