//
//  LoginModel.h
//  CherrySports
//
//  Created by dkb on 16/11/29.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : BaseModel

/** userId*/
@property (nonatomic, copy) NSString *tId;
/** 别名Id*/
@property (nonatomic, copy) NSString *tAlias;
/** 手机号*/
@property (nonatomic, copy) NSString *tPhone;
/** 头像*/
@property (nonatomic, copy) NSString *tHeadPicture;
/** 背景图*/
@property (nonatomic, copy) NSString *tBackgroundImg;
/** 昵称*/
@property (nonatomic, copy) NSString *tNickname;
/** 生日*/
@property (nonatomic, copy) NSString *tBirthday;
/** 身高cm*/
@property (nonatomic, copy) NSString *tHeight;
/** 体重kg*/
@property (nonatomic, copy) NSString *tWeight;
/** 动态*/
@property (nonatomic, copy) NSString *tDynamic;
/** 关注*/
@property (nonatomic, copy) NSString *tAttention;
/** 粉丝数*/
@property (nonatomic, copy) NSString *tFansCount;
/** 性别 0女 1男*/
@property (nonatomic, copy) NSString *tGender;

@end
