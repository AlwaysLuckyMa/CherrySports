//
//  QuickLoginTableViewCell.h
//  CherrySports
//
//  Created by dkb on 16/11/25.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuickLoginDelegate <NSObject>

- (void)quickLogin;

- (void)getVerificaCode;

- (void)quickPhone:(NSString *)phone Code:(NSString *)code;

@end

@interface QuickLoginTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, assign) id<QuickLoginDelegate>delegate;

/** setPhone*/
@property (nonatomic, strong) CustomTextField *phoneFeild;

/** set验证码*/
@property (nonatomic, strong) CustomTextField *verificationCode;

/** countDown*/
@property (nonatomic, strong) UIButton *countDownBtn;

@property (nonatomic, strong) UIButton *okBtn;


@end
