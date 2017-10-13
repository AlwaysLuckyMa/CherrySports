//
//  BindingCell.h
//  CherrySports
//
//  Created by dkb on 17/1/19.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BingdingDelegate <NSObject>

- (void)quickLogin;

- (void)getVerificaCode;

- (void)quickPhone:(NSString *)phone Code:(NSString *)code;

@end

@interface BindingCell : UITableViewCell

@property (nonatomic, assign) id<BingdingDelegate>delegate;

/** setPhone*/
@property (nonatomic, strong) CustomTextField *phoneFeild;

/** set验证码*/
@property (nonatomic, strong) CustomTextField *verificationCode;

/** countDown*/
@property (nonatomic, strong) UIButton *countDownBtn;

@property (nonatomic, strong) UIButton *okBtn;

@end
