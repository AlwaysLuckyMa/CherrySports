//
//  EventsSelectModel.h
//  CherrySports
//
//  Created by dkb on 16/12/1.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsSelectModel : BaseModel

/** 查询类型编码*/
@property (nonatomic, copy) NSString *tId;
/** 查询名称*/
@property (nonatomic, copy) NSString *tName;

@property (nonatomic, assign) BOOL isSelect;

@end
