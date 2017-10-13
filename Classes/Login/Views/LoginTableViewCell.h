//
//  LoginTableViewCell.h
//  CherrySports
//
//  Created by dkb on 16/11/24.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginCellDelegate <NSObject>

/** 登录按钮*/
- (void)okLogin;
/** 跳转快捷登录页*/
- (void)quickLogin;
/** 跳转忘记密码页*/
- (void)forgotPass;
/** 跳转微信登录*/
- (void)weixinLogin;
/** 跳转QQ登录*/
- (void)qqLogin;
/** 跳转Sina登录*/
- (void)sinaLogin;

/** 实时监听*/
- (void)Phone:(NSString *)phone PassWord:(NSString *)passWord;
@end

@interface LoginTableViewCell : UITableViewCell <UITextFieldDelegate>

/** logo*/
@property (nonatomic, strong) UIImageView *logoImage;
/** 手机icon*/
@property (nonatomic, strong) UIImageView *phoneIcon;
/** 密码icon*/
@property (nonatomic, strong) UIImageView *lockIcon;
/** 手机号textFeild*/
@property (nonatomic, strong) CustomTextField *phone;
/** 密码textFeild*/
@property (nonatomic, strong) CustomTextField *password;
/** 确定按钮*/
@property (nonatomic, strong) UILabel *okBtn;
/** 快捷登录按钮*/
@property (nonatomic, strong) UILabel *quickLoginBtn;
/** 忘记密码按钮*/
@property (nonatomic, strong) UILabel *forgotPassword;


/** 微信btn*/
@property (nonatomic, strong) UIButton *weixinBtn;
/** QQbtn*/
@property (nonatomic, strong) UIButton *qqBtn;
/** 新浪btn*/
@property (nonatomic, strong) UIButton *sinaBtn;

/** 代理*/
@property (nonatomic, assign) id<LoginCellDelegate> loginDelegate;

@end
