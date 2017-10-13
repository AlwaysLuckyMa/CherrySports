//
//  ForgotPasswordCell.m
//  CherrySports
//
//  Created by dkb on 16/11/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "ForgotPasswordCell.h"

@interface ForgotPasswordCell ()
@property (nonatomic, assign)NSInteger secondsCountDown; //倒计时总时长
@property (nonatomic, strong)NSTimer *countDownTimer;
@property (nonatomic, strong)UILabel *countNum;

@end

@implementation ForgotPasswordCell

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
    UIImageView *redLine = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:redLine];
    [redLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(64);
    }];
    
    UIImageView *redLineOne = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:redLineOne];
    [redLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(104);
    }];
    
    UIImageView *redLineTwo = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:redLineTwo];
    [redLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(144);
    }];
    
    UIImageView *redLineThree = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLineThree.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:redLineThree];
    [redLineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(184);
    }];
    
    UILabel *phone = [AppTools createLabelText:@"手机号：" Color:TEXT_COLOR_DARK Font:14 TextAlignment:NSTextAlignmentLeft Number:0.3f];
    //    phone.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:phone];
    //    _oldPassword.backgroundColor = [UIColor greenColor];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(redLine.mas_left).offset(10);
        if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
            make.bottom.equalTo(redLine.mas_top).offset(-9.5);
            make.width.mas_equalTo(60);
        }else{
            make.bottom.equalTo(redLine.mas_top).offset(-11);
            make.width.mas_equalTo(53);
        }
        
    }];
    
    _phoneFeild = [CustomTextField new];
    _phoneFeild.placeholder = @"请输入您的手机号码";
    _phoneFeild.delegate = self;
    [_phoneFeild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //    _phoneFeild.backgroundColor = [UIColor yellowColor];
    NSDictionary *attrsDictionary =@{
                                     NSFontAttributeName: _phoneFeild.font,
                                     NSKernAttributeName:[NSNumber numberWithFloat:0.3f]//这里修改字符间距
                                     };
    _phoneFeild.attributedText = [[NSAttributedString alloc]initWithString:@"" attributes:attrsDictionary];
    [self.contentView addSubview:_phoneFeild];
    [_phoneFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phone.mas_right).offset(1);
        make.right.equalTo(redLine.mas_right).offset(-10);
        make.bottom.equalTo(redLine.mas_top).offset(-1);
        make.height.mas_equalTo(38);
    }];
    
    UILabel *verificationCode = [AppTools createLabelText:@"验证码：" Color:TEXT_COLOR_DARK Font:14 TextAlignment:NSTextAlignmentLeft Number:0.3f];
    [self.contentView addSubview:verificationCode];
    [verificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
            make.bottom.equalTo(redLineOne.mas_top).offset(-8);
        }else if (IS_IPHONE_4){
            make.bottom.equalTo(redLineOne.mas_top).offset(-9.5);
        }else {
            make.bottom.equalTo(redLineOne.mas_top).offset(-10);
        }
        
        make.left.equalTo(phone);
        make.width.equalTo(phone);
    }];
    
    
    _verificationCode = [CustomTextField new];
    _verificationCode.delegate = self;
    _verificationCode.placeholder = @"请输入验证码";
    [_verificationCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //        _verificationCode.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_verificationCode];
    [_verificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneFeild);
        make.top.equalTo(redLine.mas_bottom).offset(1);
        make.right.equalTo(_phoneFeild.mas_right).offset(-72);
        make.height.mas_equalTo(38);
    }];
    
    // 获取验证码按钮 （倒计时按钮）
    _countDownBtn = [[UIButton alloc]init];
    [_countDownBtn setImage:[UIImage imageNamed:@"get_verification_gray"] forState:UIControlStateNormal];
    _countDownBtn.userInteractionEnabled = NO;
    _countDownBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -2, 0);
    [_countDownBtn imageForState:UIControlStateNormal];
    [_countDownBtn addTarget:self action:@selector(countDown) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_countDownBtn];
    [_countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(redLineOne.mas_right).offset(-10);
        make.top.equalTo(redLine.mas_bottom).offset(1);
        make.bottom.equalTo(redLineOne.mas_top);
        make.width.mas_equalTo(75);
    }];
    
    _countNum = [[UILabel alloc] init];
    _countNum.text = @"";
    _countNum.textColor = TEXT_COLOR_LIGHT;
    //    _countNum.backgroundColor = [UIColor yellowColor];
    _countNum.textAlignment = NSTextAlignmentCenter;
    _countNum.font = [UIFont fontWithName:@"Arial" size:10];
    [self.countDownBtn addSubview:_countNum];
    [_countNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-7);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(12);
    }];
    
    UILabel *passNew = [AppTools createLabelText:@"新密码：" Color:TEXT_COLOR_DARK Font:14 TextAlignment:NSTextAlignmentLeft Number:0.3f];
    //    passNew.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:passNew];
    [passNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phone);
        make.width.equalTo(phone);
        if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
            make.bottom.equalTo(redLineTwo.mas_top).offset(-8);
        }else if (IS_IPHONE_4){
            make.bottom.equalTo(redLineTwo.mas_top).offset(-9.5);
        }else{
            make.bottom.equalTo(redLineTwo.mas_top).offset(-10);
        }
    }];
    
    _passwordNew = [CustomTextField new];
    _passwordNew.placeholder = @"请输入您要设定的密码";
    _passwordNew.delegate = self;
    _passwordNew.secureTextEntry = YES;
    [_passwordNew addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_passwordNew];
    [_passwordNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneFeild);
        make.top.equalTo(redLineOne.mas_bottom).offset(1);
        make.right.equalTo(_phoneFeild);
        make.height.mas_equalTo(38);
    }];
    
    UILabel *okPassword = [AppTools createLabelText:@"确认密码：" Color:TEXT_COLOR_DARK Font:14 TextAlignment:NSTextAlignmentLeft];
    //    okPassword.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:okPassword];
    [okPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phone);
        if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
            make.bottom.equalTo(redLineThree.mas_top).offset(-8);
            make.width.mas_equalTo(71.5);
        }else if (IS_IPHONE_4){
            make.bottom.equalTo(redLineThree.mas_top).offset(-9.5);
            make.width.mas_equalTo(63);
        }else{
            make.bottom.equalTo(redLineThree.mas_top).offset(-10);
            make.width.mas_equalTo(63);
        }
    }];
    
    _okPassword = [CustomTextField new];
    _okPassword.placeholder = @"请输入您要设定的密码";
    _okPassword.delegate = self;
    _okPassword.secureTextEntry = YES;
    [_okPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_okPassword];
    [_okPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(okPassword.mas_right).offset(1);
        make.top.equalTo(redLineTwo.mas_bottom).offset(1);
        make.right.equalTo(_phoneFeild);
        make.height.mas_equalTo(38);
    }];
    
    UIButton *okBtn = [AppTools createButtonTitle:@"确 定" TitleColor:[UIColor whiteColor] Font:13 Background:TEXT_COLOR_RED];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 5;
    [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(redLine);
        make.top.equalTo(redLineThree.mas_bottom).offset(16);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - textFeild && Delegate
// 限制手机号和密码长度最多几位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneFeild) {
        if (range.location == 11 && ![string isEqualToString:@""]) {
            
            return NO;
        }
        return [AppTools validateNumber:string validateStr:@"0123456789"];
    }else if (textField == _verificationCode) {
        if (range.location == 6 && ![string isEqualToString:@""]) {
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
    NSLog(@"asdasdasd = %@", theTextFeild.text);
    if (theTextFeild == _phoneFeild) {
        if (theTextFeild.text.length == 11 && _countNum.text.length == 0) {
            [_countDownBtn setImage:[UIImage imageNamed:@"get_verification_red"] forState:UIControlStateNormal];
            [_countDownBtn setImage:[UIImage imageNamed:@"get_verification_red"] forState:UIControlStateHighlighted];
            _countDownBtn.userInteractionEnabled = YES;
            
        }else{
            if (_countNum.text.length == 0) {
                _countDownBtn.userInteractionEnabled = NO;
                [_countDownBtn setImage:[UIImage imageNamed:@"get_verification_gray"] forState:UIControlStateNormal];
            }
        }
    }
    [self.delegate TextFeildText:_phoneFeild.text CodeText:_verificationCode.text PasswordNewText:_passwordNew.text OkPasswordText:_okPassword.text];
}


#pragma mark - 获取验证码点击事件
- (void)countDown
{
    NSLog(@"获取验证码");
    _countNum.hidden = NO;
    //设置倒计时总时长
    _secondsCountDown = 60;//60秒倒计时
    //开始倒计时
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启
    //设置倒计时显示的时间
    [_countDownBtn setImage:[UIImage imageNamed:@"get_verification_countDown"] forState:UIControlStateNormal];
    _countNum.text = [NSString stringWithFormat:@"%ld",(long)_secondsCountDown];
    _countDownBtn.enabled = NO;
    
    [self.delegate getVerificaCode];
}

#pragma mark - **************** 倒计时执行的方法
-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown--;
    //修改倒计时标签现实内容
    _countNum.text = [NSString stringWithFormat:@"%ld",(long)_secondsCountDown];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown == 0){
        [_countDownTimer invalidate];
        _countNum.text = @"";
        _countNum.hidden = YES;
        if (_phoneFeild.text.length == 11) {
            _countDownBtn.enabled = YES;
            [_countDownBtn setImage:[UIImage imageNamed:@"get_verification_red"] forState:UIControlStateNormal];
        }else{
            [_countDownBtn setImage:[UIImage imageNamed:@"get_verification_gray"] forState:UIControlStateNormal];
        }
    }
}

- (void)ok
{
    NSLog(@"确定修改");
    [self.delegate ForgotPassword];
}


@end
