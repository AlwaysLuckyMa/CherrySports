//
//  EventAddress.h
//  CherrySports
//
//  Created by dkb on 17/1/20.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "BaseModel.h"

@interface EventAddress : BaseModel

/** 城市编码*/
@property (nonatomic, copy) NSString *tId;
/** 城市名称*/
@property (nonatomic, copy) NSString *tName;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *regionPoList;

@end
