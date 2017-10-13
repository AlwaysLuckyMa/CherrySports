//
//  EventsCityModel.h
//  CherrySports
//
//  Created by dkb on 16/12/1.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsCityModel : BaseModel

/** 城市编码*/
@property (nonatomic, copy) NSString *tId;
/** 城市名称*/
@property (nonatomic, copy) NSString *tName;
/** 所属省份编码*/
@property (nonatomic, copy) NSString *tProvinceId;

@property (nonatomic, assign) BOOL isSelect;

@end
