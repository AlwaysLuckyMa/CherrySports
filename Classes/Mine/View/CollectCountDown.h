//
//  CollectCountDown.h
//  CherrySports
//
//  Created by dkb on 16/11/24.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectCountDown : NSObject

/// 使用单例
#define kCollectCountDown [CollectCountDown manager]
/// 倒计时的通知
#define kCollectCountDownNotification @"CollectCountDownNotification"

/// 时间差(单位:秒)
@property (nonatomic, assign) NSInteger timeInterval;

/// 使用单例
+ (instancetype)manager;
/// 开始倒计时
- (void)start;
/// 刷新倒计时
- (void)reload;

@end
