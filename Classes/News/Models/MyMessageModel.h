//
//  MyMessageModel.h
//  CherrySports
//
//  Created by dkb on 16/12/2.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseModel.h"

@interface MyMessageModel : BaseModel

/** 消息编码*/
@property (nonatomic, copy) NSString *tId;
/** 消息标题*/
@property (nonatomic, copy) NSString *tTitle;
/** 消息内容*/
@property (nonatomic, copy) NSString *tContent;
/** app 用户编码*/
@property (nonatomic, copy) NSString *tAppUserId;
/** 消息类型*/
@property (nonatomic, copy) NSString *tType;
/** 是否已读*/
@property (nonatomic, copy) NSString *tReadState;
/** 跳转编码*/
@property (nonatomic, copy) NSString *tJumpId;
/** 创建时间*/
@property (nonatomic, copy) NSString *tCreateTime;

/** label高度*/
@property (nonatomic, assign) CGFloat labelHeight;

@end
