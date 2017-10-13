//
//  LoginVC.m
//  CherrySports
//
//  Created by dkb on 16/11/18.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "LoginVC.h"
#import "LoginTableViewCell.h"
#import "RegisterViewController.h"
#import "QuickLoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "LoginModel.h"

@interface LoginVC ()<UITableViewDelegate, UITableViewDataSource, LoginCellDelegate, UITextFieldDelegate>{
    NSMutableArray *dataArray;
    NSString *phoneStr;
    NSString *passwordStr;
}
/** <#注释#>*/
@property (nonatomic, strong) UITableView *mytableView;
@end

@implementation LoginVC

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
        [_mytableView registerClass:[LoginTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    LoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.loginDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT-64;
}

#pragma mark - loginCell && delegate
- (void)okLogin
{
    if (phoneStr.length == 0) {
        [self showHint:@"手机号不能为空"];
    }else if (phoneStr.length != 11){
        [self showHint:@"请输入正确的手机号"];
    }else if (passwordStr.length == 0){
        [self showHint:@"密码不能为空"];
    }else if (passwordStr.length < 6){
        [self showHint:@"密码长度不能小于6位"];
    }else{
        // 收回键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self getDataUserName:phoneStr PassWord:passwordStr VerifyCode:@"" tLoginChannel:@"0"];
    }
}

- (void)Phone:(NSString *)phone PassWord:(NSString *)passWord
{
    phoneStr = phone;
    passwordStr = passWord;
    NSLog(@"phone = %@, passWord = %@", phoneStr, passwordStr);
}

- (void)quickLogin
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        QuickLoginViewController *quickLVC = [QuickLoginViewController new];
        [self.navigationController pushViewController:quickLVC animated:YES];
    });
    NSLog(@"跳转快捷登录页");
}

- (void)forgotPass
{
    NSLog(@"跳转忘记密码页");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ForgotPasswordViewController *forgotPVC = [ForgotPasswordViewController new];
        [self.navigationController pushViewController:forgotPVC animated:YES];
    });
}

- (void)weixinLogin
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

- (void)qqLogin
{
    
    [self getUserInfoForPlatform:4 loginChannel:@"1"];
}

- (void)sinaLogin
{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:0 completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"取消sina授权失败");
        }else{
            [self getUserInfoForPlatform:0 loginChannel:@"4"];
        }
    }];
}

#pragma mark - 第三方登录授权
// 在需要进行获取用户信息的UIViewController中加入如下代码
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType loginChannel:(NSString *)channel
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        }else{
            UMSocialUserInfoResponse *userinfo = result;
            
            // 授权信息
            NSLog(@"uid: %@", userinfo.uid);
            NSLog(@"openid: %@", userinfo.openid);
            NSLog(@"accessToken: %@", userinfo.accessToken);
            NSLog(@"refreshToken: %@", userinfo.refreshToken);
            NSLog(@"expiration: %@", userinfo.expiration);
            
            // 用户信息
            NSLog(@"name: %@", userinfo.name);
            NSLog(@"iconurl: %@", userinfo.iconurl);
            NSLog(@"gender: %@", userinfo.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"sina originalResponse: %@", userinfo.originalResponse);
            if ([userinfo.gender isEqualToString:@"m"]) {
                [self getTid:userinfo.uid gender:@"1" image:userinfo.iconurl Name:userinfo.name tLoginChannel:channel];
            }else{
                [self getTid:userinfo.uid gender:@"0" image:userinfo.iconurl Name:userinfo.name tLoginChannel:channel];
            }
        }
    }];
}


#pragma mark - 请求数据
- (void)getDataUserName:(NSString *)userName PassWord:(NSString *)passWord VerifyCode:(NSString *)verifyCode tLoginChannel:(NSString *)tLoginChannel
{
    NSDictionary *userNameDic = @{@"dicKey":@"tPhone", @"data":userName};
    NSDictionary *passWordDic = @{@"dicKey":@"tPassword", @"data":passWord};
    NSDictionary *verifyCodeDic = @{@"dicKey":@"verifyCode", @"data":verifyCode};
    NSDictionary *channelDic = @{@"dicKey":@"tLoginChannel", @"data":tLoginChannel};
    
    NSArray *postArray = @[userNameDic, passWordDic, verifyCodeDic, channelDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/appUserLogin", SERVER_URL];
    
    [ServerUtility indexPOSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"登录页数据obj = %@", obj);
            dataArray = [NSMutableArray array];
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                LoginModel *model = [LoginModel mj_objectWithKeyValues:obj];
                [dataArray addObject:model];
                
                //在这里登陆的时候储存userID
                [[NSUserDefaults standardUserDefaults] setValue:model.tId forKey:@"UserID"];
                
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [userDic setObject:model.tAlias forKey:@"tAlias"];
                [userDic setObject:model.tPhone forKey:@"tPhone"];
                [userDic setObject:model.tHeadPicture forKey:@"tHeadPicture"];
                [userDic setObject:model.tBackgroundImg forKey:@"tBackgroundImg"];
                [userDic setObject:model.tNickname forKey:@"tNickname"];
                [userDic setObject:model.tBirthday forKey:@"tBirthday"];
                [userDic setObject:model.tHeight forKey:@"tHeight"];
                [userDic setObject:model.tWeight forKey:@"tWeight"];
                [userDic setObject:model.tDynamic forKey:@"tDynamic"];
                [userDic setObject:model.tAttention forKey:@"tAttention"];
                [userDic setObject:model.tFansCount forKey:@"tFansCount"];
                [userDic setObject:model.tGender forKey:@"tGender"];

                [[NSUserDefaults standardUserDefaults] setValue:userDic forKey:@"UserDic"];
                
                //                [self dismissViewControllerAnimated:YES completion:^{
                //                    [[JPushTagAndAlias shareJPush] setTagsAlias:model.uAlias];
                //                }];
                // 请求成功返回上页
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"%@",error);
            [self showHint:[obj objectForKey:@"亲，网络开小差了"]];
        }
    }];
}



- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 导航栏标题（用图片）
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_title"]];
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"login_leftbar" highImage:@"login_leftbar" target:self action:@selector(backAction)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"login_rightbar" highImage:@"login_rightbar" target:self action:@selector(registerAction)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem LoginLeftbarWithImage:@"login_leftbar" highImage:@"login_leftbar" target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem LoginRightbarWithImage:@"login_rightbar" highImage:@"login_rightbar" target:self action:@selector(registerAction)];
}

- (void)backAction
{
    NSLog(@"取消 pop");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)registerAction
{
    NSLog(@"跳注册页");
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RegisterViewController *registVC = [RegisterViewController new];
        [self.navigationController pushViewController:registVC animated:YES];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 三方登录请求
- (void)getTid:(NSString *)tId gender:(NSString *)gender image:(NSString *)image Name:(NSString *)name tLoginChannel:(NSString *)tLoginChannel
{
    NSDictionary *tIdDic = @{@"dicKey":@"tId", @"data":tId};
    NSDictionary *genderDic = @{@"dicKey":@"tGender", @"data":gender};
    NSDictionary *imageDic = @{@"dicKey":@"tHeadPicture", @"data":image};
    NSDictionary *nameDic = @{@"dicKey":@"tNickname", @"data":name};
    NSDictionary *channelDic = @{@"dicKey":@"tLoginChannel", @"data":tLoginChannel};
    
    NSArray *postArray = @[tIdDic, genderDic, imageDic, nameDic, channelDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/appUserLogin", SERVER_URL];
    
    [ServerUtility indexPOSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"第三方登录后请求的数据 = %@", obj);
            dataArray = [NSMutableArray array];
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                LoginModel *model = [LoginModel mj_objectWithKeyValues:obj];
                [dataArray addObject:model];
                
                //在这里登陆的时候储存userID
                [[NSUserDefaults standardUserDefaults] setValue:model.tId forKey:@"UserID"];
                
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [userDic setObject:model.tAlias forKey:@"tAlias"];
                [userDic setObject:model.tPhone forKey:@"tPhone"];
                [userDic setObject:model.tHeadPicture forKey:@"tHeadPicture"];
                [userDic setObject:model.tBackgroundImg forKey:@"tBackgroundImg"];
                [userDic setObject:model.tNickname forKey:@"tNickname"];
                [userDic setObject:model.tBirthday forKey:@"tBirthday"];
                [userDic setObject:model.tHeight forKey:@"tHeight"];
                [userDic setObject:model.tWeight forKey:@"tWeight"];
                [userDic setObject:model.tDynamic forKey:@"tDynamic"];
                [userDic setObject:model.tAttention forKey:@"tAttention"];
                [userDic setObject:model.tFansCount forKey:@"tFansCount"];
                [userDic setObject:model.tGender forKey:@"tGender"];
                
                [[NSUserDefaults standardUserDefaults] setValue:userDic forKey:@"UserDic"];
                
                //                [self dismissViewControllerAnimated:YES completion:^{
                //                    [[JPushTagAndAlias shareJPush] setTagsAlias:model.uAlias];
                //                }];
                // 登录成功返回我的页
                UIViewController *mineVC = self.navigationController.viewControllers[0];
                [self.navigationController popToViewController:mineVC animated:YES];
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"%@",error);
            [self showHint:[obj objectForKey:@"亲，网络开小差了"]];
        }
    }];
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
