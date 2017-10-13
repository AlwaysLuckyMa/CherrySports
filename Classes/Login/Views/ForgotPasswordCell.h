//
//  ForgotPasswordCell.h
//  CherrySports
//
//  Created by dkb on 16/11/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForgotPassDelegate <NSObject>

- (void)ForgotPassword;

- (void)getVerificaCode;

- (void)TextFeildText:(NSString *)text CodeText:(NSString *)code PasswordNewText:(NSString *)passwordnew OkPasswordText:(NSString *)okPassword;

@end

@interface ForgotPasswordCell : UITableViewCell <UITextFieldDelegate>

/** setPhone*/
@property (nonatomic, strong) CustomTextField *phoneFeild;

/** 验证码*/
@property (nonatomic, strong) CustomTextField *verificationCode;

/** newPassword*/
@property (nonatomic, strong) CustomTextField *passwordNew;

/** okPassword*/
@property (nonatomic, strong) CustomTextField *okPassword;

/** countDown*/
@property (nonatomic, strong) UIButton *countDownBtn;

@property (nonatomic, assign) id<ForgotPassDelegate>delegate;

@end
