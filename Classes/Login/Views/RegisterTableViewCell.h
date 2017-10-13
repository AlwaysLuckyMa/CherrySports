//
//  RegisterTableViewCell.h
//  CherrySports
//
//  Created by dkb on 16/11/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterDelegate <NSObject>
/** 点击登录按钮代理方法 */
- (void)Register;

- (void)qqlogin;

- (void)weixinlogin;

- (void)sinalogin;

- (void)getVerificaCode;

- (void)Code:(NSString *)code Phone:(NSString *)phone Password:(NSString *)password;

@end

@interface RegisterTableViewCell : UITableViewCell <UITextFieldDelegate>


@property (nonatomic, assign) id<RegisterDelegate>delegate;

/** setPhone*/
@property (nonatomic, strong) CustomTextField *phoneFeild;

/** set验证码*/
@property (nonatomic, strong) CustomTextField *verificationCode;

/** countDown*/
@property (nonatomic, strong) UIButton *countDownBtn;

/** passWord*/
@property (nonatomic, strong) CustomTextField *password;


/** 微信btn*/
@property (nonatomic, strong) UIButton *weixinBtn;
/** QQbtn*/
@property (nonatomic, strong) UIButton *qqBtn;
/** 新浪btn*/
@property (nonatomic, strong) UIButton *sinaBtn;

@end
