//
//  EventsCountDown.h
//  CherrySports
//
//  Created by dkb on 16/11/15.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsCountDown : BaseModel

// 计时器用
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *count;

@end
