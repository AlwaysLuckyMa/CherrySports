//
//  BindingPhoneViewController.h
//  CherrySports
//
//  Created by 吴庭宇 on 2016/12/8.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark -绑定手机号页面
#import "BaseViewController.h"
@class BindingPhoneViewController;
@protocol BindingPhoneDelegate <NSObject>

-(void)popToSettingController:(BindingPhoneViewController *)bindingController;

@end


@interface BindingPhoneViewController : BaseViewController
@property (nonatomic,weak)id <BindingPhoneDelegate> delegate;

/** 三方登录用户id*/
@property (nonatomic, copy) NSString *tid;
/** 登录渠道*/
@property (nonatomic, copy) NSString *channel;
/** 男女*/
@property (nonatomic, copy) NSString *gender;

@end
