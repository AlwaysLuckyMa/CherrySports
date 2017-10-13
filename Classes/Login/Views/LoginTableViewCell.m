//
//  LoginTableViewCell.m
//  CherrySports
//
//  Created by dkb on 16/11/24.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    WS(weakSelf);
    if (!_logoImage) {
        _logoImage = [AppTools CreateImageViewImageName:@"login_logo"];
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImage];
        if (IS_IPHONE_4) {
            [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(34);
                make.centerX.equalTo(weakSelf);
            }];
        }else{
            [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(86);
                make.centerX.equalTo(weakSelf);
            }];
        }
    }
    
    UIImageView *redLine = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:redLine];
    [redLine mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_4) {
            make.top.equalTo(_logoImage.mas_bottom).offset(39);
        }else{
            make.top.equalTo(_logoImage.mas_bottom).offset(69);
        }
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(250);
        make.centerX.equalTo(weakSelf);
    }];
    
    // 第二条红线
    UIImageView *redLineTwo = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLineTwo.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:redLineTwo];
    [redLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redLine.mas_bottom).offset(40);
        make.left.right.equalTo(redLine);
        make.height.mas_equalTo(1);
    }];
    
    if (!_phoneIcon) {
        _phoneIcon = [AppTools CreateImageViewImageName:@"login_icon_phone"];
        _phoneIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_phoneIcon];
        [_phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(redLine.mas_top).offset(-7);
            make.left.equalTo(redLine.mas_left).offset(12);
            make.width.mas_equalTo(14);
        }];
    }
    // 手机号码
    if (!_phone) {
        _phone = [CustomTextField new];
        _phone.placeholder = @"请输入手机号码";
//        _phone.backgroundColor = [UIColor yellowColor];
        _phone.delegate = self;
        [_phone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_phone];
        [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_phoneIcon.mas_right).offset(12);;
            make.right.equalTo(redLine.mas_right).offset(-24);
            make.bottom.equalTo(redLine.mas_top);
            make.height.mas_equalTo(36);
        }];
    }
    
    if (!_lockIcon) {
        _lockIcon = [AppTools CreateImageViewImageName:@"login_icon_locks"];
        _lockIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_lockIcon];
        [_lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_phoneIcon);
            make.bottom.equalTo(redLineTwo.mas_top).offset(-7);
            make.width.mas_equalTo(14);
        }];
    }
    
    // 密码
    if (!_password) {
        _password = [CustomTextField new];
        _password.placeholder = @"请输入密码";
//        _password.backgroundColor = [UIColor yellowColor];
        _password.secureTextEntry = YES;
        _password.delegate = self;
        [_password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_password];
        [_password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_phone);
            make.height.mas_equalTo(36);
            make.bottom.equalTo(redLineTwo.mas_top);
        }];
    }
    
    // 确定按钮
    if (!_okBtn) {
        _okBtn = [AppTools createLabelText:@"确定" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter Number:5.0f];
        _okBtn.backgroundColor = TEXT_COLOR_RED;
        _okBtn.layer.masksToBounds = YES;
        _okBtn.layer.cornerRadius = 5;
        [self.contentView addSubview:_okBtn];
        _okBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(okAction:)];
        [_okBtn addGestureRecognizer:tap];
        [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(redLineTwo);
            make.top.equalTo(redLineTwo.mas_bottom).offset(16);
            make.height.mas_equalTo(40);
        }];
    }
    
    // 快捷登录
    if (!_quickLoginBtn) {
        _quickLoginBtn = [AppTools createLabelText:@"快捷登录 >" Color:TEXT_COLOR_RED Font:14 TextAlignment:NSTextAlignmentCenter Number:1.0f];
        _quickLoginBtn.userInteractionEnabled = YES;
        [self.contentView addSubview:_quickLoginBtn];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quickLogin:)];
        [_quickLoginBtn addGestureRecognizer:tap];
        [_quickLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redLineTwo.mas_left).offset(2);
            make.top.equalTo(_okBtn.mas_bottom).offset(6);
            make.height.mas_equalTo(30);
        }];
    }
    
    if (!_forgotPassword) {
        _forgotPassword = [AppTools createLabelText:@"忘记密码" Color:TEXT_COLOR_RED Font:14 TextAlignment:NSTextAlignmentCenter Number:1.0f];
        _forgotPassword.userInteractionEnabled = YES;
        [self.contentView addSubview:_forgotPassword];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassWd:)];
        [_forgotPassword addGestureRecognizer:tap];
        [_forgotPassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_quickLoginBtn);
            make.right.equalTo(redLineTwo.mas_right).offset(-2);
            make.height.mas_equalTo(30);
        }];
    }
    
    // 底部
    UIImageView *quickLogin = [AppTools CreateImageViewImageName:@"login_onekey"];
    quickLogin.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:quickLogin];
    [quickLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.mas_equalTo(-72);
    }];
    
    if (!_weixinBtn) {
        _weixinBtn = [[UIButton alloc] init];
        [_weixinBtn setImage:[UIImage imageNamed:@"login_icon_weixin"] forState:UIControlStateNormal];
        [_weixinBtn setImage:[UIImage imageNamed:@"login_icon_weixin"] forState:UIControlStateHighlighted];
//        _weixinBtn.backgroundColor = [UIColor redColor];
        [_weixinBtn imageForState:UIControlStateNormal];
        [_weixinBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_weixinBtn];
        [_weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(quickLogin.mas_left).offset(10);
            make.bottom.mas_equalTo(-10);
            make.width.height.mas_equalTo(50);
        }];
    }
    
    if (!_qqBtn) {
        _qqBtn = [[UIButton alloc] init];
        [_qqBtn setImage:[UIImage imageNamed:@"login_logo_qq"] forState:UIControlStateNormal];
        [_qqBtn setImage:[UIImage imageNamed:@"login_logo_qq"] forState:UIControlStateHighlighted];
        [_qqBtn imageForState:UIControlStateNormal];
        [_qqBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_qqBtn];
        [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(_weixinBtn.mas_bottom);
            make.width.height.mas_equalTo(50);
        }];
    }
    
    if (!_sinaBtn) {
        _sinaBtn = [[UIButton alloc] init];
        [_sinaBtn setImage:[UIImage imageNamed:@"login_icon_sina"] forState:UIControlStateNormal];
        [_sinaBtn setImage:[UIImage imageNamed:@"login_icon_sina"] forState:UIControlStateHighlighted];
        [_sinaBtn imageForState:UIControlStateNormal];
        [_sinaBtn addTarget:self action:@selector(sinaLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sinaBtn];
        [_sinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(quickLogin.mas_right).offset(-10);
            make.bottom.equalTo(_weixinBtn.mas_bottom);
            make.width.height.mas_equalTo(50);
        }];
    }
}

#pragma mark - textFeild && Delegate
// 限制手机号和密码长度最多几位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phone) {
        if (textField.text.length == 11 && ![string isEqualToString:@""]) {
            return NO;
        }
        return [AppTools validateNumber:string validateStr:@"0123456789"];
    }else{
        if (range.location == 20 && ![string isEqualToString:@""]) {
            return NO;
        }
        return YES;
    }
}

- (void)textFieldDidChange:(UITextField *)theTextFeild
{
    [self.loginDelegate Phone:_phone.text PassWord:_password.text];
}


- (void)okAction:(UITapGestureRecognizer *)loginClick
{
    [self.loginDelegate okLogin];
    NSLog(@"点击了确定登录按钮");
}

- (void)quickLogin:(UITapGestureRecognizer *)quickClick
{
    [self.loginDelegate quickLogin];
    NSLog(@"点击了快捷登录按钮");
}

- (void)forgotPassWd:(UITapGestureRecognizer *)forgotClick
{
    [self.loginDelegate forgotPass];
    NSLog(@"点击了忘记密码按钮");
}

- (void)weixinLogin
{
    [self.loginDelegate weixinLogin];
    NSLog(@"点击了微信登录按钮");
}

- (void)qqLogin
{
    [self.loginDelegate qqLogin];
    NSLog(@"点击了qq登录按钮");
}

- (void)sinaLogin
{
    [self.loginDelegate sinaLogin];
    NSLog(@"点击了sina登录按钮");
}

@end
