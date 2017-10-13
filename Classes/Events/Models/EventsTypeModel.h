//
//  EventsTypeModel.h
//  CherrySports
//
//  Created by dkb on 16/12/1.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsTypeModel : BaseModel

/** 类型编码*/
@property (nonatomic, copy) NSString *tId;
/** 类型名称*/
@property (nonatomic, copy) NSString *tName;
/** 类型图标*/
@property (nonatomic, copy) NSString *tImgPath;

@property (nonatomic, assign) BOOL isSelect;

@end
