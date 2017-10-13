//
//  ForgotPasswordViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/25.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ForgotPasswordCell.h"
#import "LoginModel.h"

@interface ForgotPasswordViewController ()<UITableViewDelegate, UITableViewDataSource, ForgotPassDelegate>{
    NSString *userPhone;
    NSString *userCode;
    NSString *userPasswordNew;
    NSString *userPasswordOk;
}
/** <#注释#>*/
@property (nonatomic, strong) UITableView *mytableView;
@end

@implementation ForgotPasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
}


- (void)createViews
{
    if (!_mytableView) {
        _mytableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [_mytableView registerClass:[ForgotPasswordCell class] forCellReuseIdentifier:@"cell"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ForgotPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT-64;
}

#pragma mark - cellDelegate
- (void)ForgotPassword
{
    if (userPhone.length == 0 || userPhone.length != 11) {
        [self showHint:@"请输入正确的手机号"];
    }else if (userCode.length != 6){
        [self showHint:@"请输入正确的验证码"];
    }else if (userPasswordNew.length == 0 || userPasswordOk.length == 0){
        [self showHint:@"密码不能为空"];
    }else if (userPasswordNew.length < 6 || userPasswordOk.length < 6){
        [self showHint:@"密码长度不能小于6位"];
    }else if (![userPasswordNew isEqualToString:userPasswordOk]){
        [self showHint:@"两次密码不一致，请重新输入"];
    }else{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self getDataUserPhone:userPhone PassWord:userPasswordNew VerifyCode:userCode];
    }
}

// 实时获取text
- (void)TextFeildText:(NSString *)text CodeText:(NSString *)code PasswordNewText:(NSString *)passwordnew OkPasswordText:(NSString *)okPassword
{
    userPhone = text;
    userCode = code;
    userPasswordNew = passwordnew;
    userPasswordOk = okPassword;
    NSLog(@"phone = %@, code = %@, new = %@, old = %@", userPhone, userCode, userPasswordNew, userPasswordOk);
}

// 获取验证码
- (void)getVerificaCode
{
    [self getDataVerifyCodePhone:userPhone];
}


#pragma mark - 请求数据
- (void)getDataUserPhone:(NSString *)userphone PassWord:(NSString *)passWord VerifyCode:(NSString *)verifyCode
{
    NSDictionary *userNameDic = @{@"dicKey":@"tPhone", @"data":userphone};
    NSDictionary *passWordDic = @{@"dicKey":@"tPassword", @"data":passWord};
    NSDictionary *verifyCodeDic = @{@"dicKey":@"verifyCode", @"data":verifyCode};
    
    NSArray *postArray = @[userNameDic, passWordDic, verifyCodeDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/modifyPassword", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"注册页面请求下来的数据obj = %@", obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                // 修改成功退出登录
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"UserID"];
                // 修改成功返回登录页面
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"%@",error);
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}


#pragma mark - **************** 获取短信验证码
- (void)getDataVerifyCodePhone:(NSString *)phone{
    
    NSDictionary *phoneDic = @{@"dicKey":@"tPhone", @"data":phone}; /** 手机号 */
    NSDictionary *typeDic = @{@"dicKey":@"verifyType", @"data":@"03"}; /** 01-注册 02-快捷登陆 03-改密*/
    
    
    NSArray *postArr = @[phoneDic, typeDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/verifyCode/insertVerifyCode", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]) {
                NSLog(@"成功");
            } else {
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        } else {
            NSLog(@"%@",error);
            [self showHint:@"亲，网络开小差了"];
        }
        
    }];
}




- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"忘记密码" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(back)];
}

- (void)back
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
