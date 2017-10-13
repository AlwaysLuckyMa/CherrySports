//
//  ChangePasswordView.h
//  CherrySports
//
//  Created by dkb on 16/11/17.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - 修改密码View
#import <UIKit/UIKit.h>

@protocol ChangePasswordDelegate <NSObject>

- (void)OkpostDataOldPass:(NSString *)old Newpass:(NSString *)newPass;

- (void)PasswordNewText:(NSString *)passwordnew OldPasswordText:(NSString *)oldPassword OkPassword:(NSString *)okPassword;

@end
@interface ChangePasswordView : UIView

/** 原始密码*/
@property (nonatomic, strong) UILabel *oldPassword;
/** 原始密码feild*/
@property (nonatomic, strong) CustomTextField *oldPassFeild;

/** 新密码*/
@property (nonatomic, strong) UILabel *passwordNew;
/** 新密码feild*/
@property (nonatomic, strong) CustomTextField *feildNew;

/** 确认密码*/
@property (nonatomic, strong) UILabel *okPass;
/** 确认密码feild*/
@property (nonatomic, strong) CustomTextField *okfeild;

/** okBtn*/
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, assign) id<ChangePasswordDelegate> delegate;

@end
