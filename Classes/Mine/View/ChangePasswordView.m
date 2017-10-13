//
//  ChangePasswordView.m
//  CherrySports
//
//  Created by dkb on 16/11/17.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "ChangePasswordView.h"

@interface ChangePasswordView ()<UITextFieldDelegate>

@end

@implementation ChangePasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    WS(weakSelf);
    UIImageView *redLine = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLine.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:redLine];
    [redLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(40);
    }];
    
    UIImageView *redLineOne = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLine.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:redLineOne];
    [redLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(80);
    }];
    
    UIImageView *redLineTwo = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLine.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:redLineTwo];
    [redLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(120);
    }];
    
    _oldPassword = [AppTools createLabelText:@"原始密码：" Color:TEXT_COLOR_RED Font:14 TextAlignment:NSTextAlignmentLeft Number:0.3f];
    [self addSubview:_oldPassword];
//    _oldPassword.backgroundColor = [UIColor greenColor];
    [_oldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redLine.mas_left).offset(10);
        if (IS_IPHONE_5 || IS_IPHONE_4) {
            make.bottom.equalTo(redLine.mas_top).offset(-10.5);
            make.width.mas_equalTo(64);
        }else{
            make.bottom.equalTo(redLine.mas_top).offset(-9);
            make.width.mas_equalTo(73);
        }
    }];
    
    _oldPassFeild = [CustomTextField new];
    _oldPassFeild.placeholder = @"请输入原始密码";
    _oldPassFeild.delegate = self;
    _oldPassFeild.secureTextEntry = YES;
    [_oldPassFeild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    _oldPassFeild.backgroundColor = [UIColor yellowColor];
//    NSDictionary *attrsDictionary =@{
//                                     NSFontAttributeName: _oldPassFeild.font,
//                                     NSKernAttributeName:[NSNumber numberWithFloat:0.3f]//这里修改字符间距
//                                     };
//    _oldPassFeild.attributedText = [[NSAttributedString alloc]initWithString:@"原始密码" attributes:attrsDictionary];
    [self addSubview:_oldPassFeild];
    [_oldPassFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oldPassword.mas_right).offset(1);
        make.right.equalTo(redLine.mas_right).offset(-10);
        make.bottom.equalTo(redLine.mas_top).offset(-1);
        make.height.mas_equalTo(38);
    }];
    
    _passwordNew = [AppTools createLabelText:@"新的密码：" Color:TEXT_COLOR_RED Font:14 TextAlignment:NSTextAlignmentLeft Number:0.3f];
    [self addSubview:_passwordNew];
    [_passwordNew mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_4) {
            make.bottom.equalTo(redLineOne.mas_top).offset(-9.5);
        }else if (IS_IPHONE_5) {
            make.bottom.equalTo(redLineOne.mas_top).offset(-10.5);
        }else{
            make.bottom.equalTo(redLineOne.mas_top).offset(-8.5);
        }
        make.left.equalTo(_oldPassword);
        make.width.equalTo(_oldPassword);
    }];
    
    _feildNew = [CustomTextField new];
    _feildNew.delegate = self;
    _feildNew.placeholder = @"请输入新密码";
    [_feildNew addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    _feildNew.backgroundColor = [UIColor yellowColor];
    _feildNew.secureTextEntry = YES;
    [self addSubview:_feildNew];
    [_feildNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oldPassFeild);
        make.top.equalTo(redLine.mas_bottom).offset(1);
        make.right.equalTo(_oldPassFeild);
        make.height.mas_equalTo(38);
    }];
    
    _okPass = [AppTools createLabelText:@"确认密码：" Color:TEXT_COLOR_RED Font:14 TextAlignment:NSTextAlignmentLeft Number:0.3f];
    [self addSubview:self.okPass];
    [_okPass mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_4) {
            make.bottom.equalTo(redLineTwo.mas_top).offset(-9.5);
        }else if (IS_IPHONE_5) {
            make.bottom.equalTo(redLineTwo.mas_top).offset(-10.5);
        }else{
            make.bottom.equalTo(redLineTwo.mas_top).offset(-8.5);
        }
        make.left.equalTo(_oldPassword);;
        make.width.equalTo(_oldPassword);
    }];
    
    _okfeild = [CustomTextField new];
    _okfeild.placeholder = @"请再次确认新密码";
    _okfeild.delegate = self;
    _okfeild.secureTextEntry = YES;
    [_okfeild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_okfeild];
    [_okfeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oldPassFeild);
        make.top.equalTo(redLineOne.mas_bottom).offset(1);
        make.right.equalTo(_oldPassFeild);
        make.height.mas_equalTo(38);
    }];
    
    _okBtn = [AppTools createButtonTitle:@"确 定" TitleColor:[UIColor whiteColor] Font:14 Background:TEXT_COLOR_RED];
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = 5;
    [_okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okBtn];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(redLine);
        make.top.equalTo(redLineTwo.mas_bottom).offset(16);
        make.height.mas_equalTo(40);
    }];
}

- (void)textFieldDidChange:(UITextField *)theTextFeild
{
    [self.delegate PasswordNewText:_feildNew.text OldPasswordText:_oldPassFeild.text OkPassword:_okfeild.text];
}


- (void)ok
{
#warning -- 确认更改密码按钮
//    这里判断密码两次密码是否一致或是否为空等逻辑 然后代理请求接口更改密码
    [self.delegate OkpostDataOldPass:self.oldPassFeild.text Newpass:self.feildNew.text];
}

//限制密码长度最多为11位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 20 && ![string isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}


@end
