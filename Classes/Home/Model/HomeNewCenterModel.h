//
//  HomeNewCenterModel.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeNewCenterModel : BaseModel

@property (nonatomic, copy) NSString *tGameId; // 赛事编码
@property (nonatomic, copy) NSString *tGameName; // 赛事名称
@property (nonatomic, copy) NSString *tGameTypeName; // 赛事类型名称
@property (nonatomic, copy) NSString *tIconPath; // 赛事图标
@property (nonatomic, copy) NSString *tImgPath; // 赛事图片
@property (nonatomic, copy) NSString *tGameBegin; // 赛事开始日期
@property (nonatomic, copy) NSString *tGameEnd; // 赛事结束日期
@property (nonatomic, copy) NSString *countDownTime; // 倒计时时间 格式 dd:hh:mm:ss
@property (nonatomic, copy) NSString *countDownMilli; // 倒计时时间毫秒数
@property (nonatomic, copy) NSString *tGameStateInfo; // 赛事当前状态 0-未开始报名 1-报名进行中 2-报名结束 3-赛事进行中 4-赛事结束
@property (nonatomic, copy) NSString *tIntroduction; // 赛事简介
@property (nonatomic, copy) NSString *isCollection; // 是否已收藏 0-是 1-否
@property (nonatomic, copy) NSString *tEnterUrl; // 赛事报名Url地址
@property (nonatomic, copy) NSString *tInfoUrl; // 赛事简介Url地址
@property (nonatomic, copy) NSString *tIsLink; // 是否是外链 0：外链 1：系统内部
@property (nonatomic, copy) NSString *tLink; // 链接地址
@property (nonatomic, copy) NSString *isManyPeopleEnter; // 是否允许多人报名 0-是 1-否
@property (nonatomic, copy) NSString *tJumpType; // 跳转类型 1-赛事 2-资讯
@property (nonatomic, copy) NSString *tNewsInfoUrl; // 资讯详情url



@end
