//
//  NewsTypeModel.h
//  CherrySports
//
//  Created by dkb on 16/12/2.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseModel.h"

@interface NewsTypeModel : BaseModel

/** Id*/
@property (nonatomic, copy) NSString *tId;
/** 名称*/
@property (nonatomic, copy) NSString *tName;

@end
