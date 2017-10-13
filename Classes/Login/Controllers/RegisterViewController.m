//
//  RegisterViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/25.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTableViewCell.h"
#import "LoginModel.h"
#import "ENWebViewController.h"
#import "BindingPhoneViewController.h"

@interface RegisterViewController ()<UITableViewDelegate, UITableViewDataSource, RegisterDelegate, BindingPhoneDelegate>{
    NSString *userPhone;
    NSString *userPass;
    NSString *usercode;
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) UITableView *mytableView;

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationController];
    [self createViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        [_mytableView registerClass:[RegisterTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT-64;
}

#pragma mark - cellDelegate
- (void)Register
{
    NSLog(@"请求数据注册");
    if (userPhone.length == 0 || userPhone.length != 11) {
        [self showHint:@"请输入正确的手机号"];
    }else if (usercode.length != 6){
        [self showHint:@"请输入正确的验证码"];
    }else if (userPass.length < 6){
        [self showHint:@"密码长度不能小于6位"];
    }else{
        // 收回键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self getDataUserName:userPhone PassWord:userPass VerifyCode:usercode];
    }
}
// 实时获取text
- (void)Code:(NSString *)code Phone:(NSString *)phone Password:(NSString *)password
{
    userPhone = phone;
    usercode = code;
    userPass = password;
}

// 获取验证码
- (void)getVerificaCode
{
    [self getDataVerifyCodePhone:userPhone];
}
// 微信登录
- (void)weixinlogin
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UMSocialManager defaultManager] cancelAuthWithPlatform:1 completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"取消微信登录授权失败 -> error = %@", error);
            }else{
                [self getUserInfoForPlatform:1 loginChannel:@"2"];
            }
        }];
    });
}
// qq登录
- (void)qqlogin
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UMSocialManager defaultManager] cancelAuthWithPlatform:4 completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"取消QQ登录授权失败 -> error = %@", error);
            }else{
                [self getUserInfoForPlatform:4 loginChannel:@"1"];
            }
        }];
    });
}
// 新浪登录
-(void)sinalogin
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UMSocialManager defaultManager] cancelAuthWithPlatform:0 completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"取消sina登录授权失败 -> error = %@", error);
            }else{
                [self getUserInfoForPlatform:0 loginChannel:@"3"];
            }
        }];
    });
}

#pragma mark - 第三方登录授权
// 在需要进行获取用户信息的UIViewController中加入如下代码
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType loginChannel:(NSString *)channel
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSlog(@"error = %@", error);
            if (error.code == 2009) {
                [self showHint:@"登录取消"];
            }else if (error.code == 2010){
                [self showHint:@"网络异常"];
            }else if (error.code == 2008){
                [self showHint:@"应用未安装"];
            }else if (error.code == 2011){
                [self showHint:@"第三方错误"];
            }
        }else{
            //授权成功
            NSlog(@"授权成功");
            [self showHint:@"登录成功"];
            UMSocialUserInfoResponse *userinfo = result;
            NSLog(@"result = %@",result);
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
- (void)getDataUserName:(NSString *)userName PassWord:(NSString *)passWord VerifyCode:(NSString *)verifyCode
{
    NSDictionary *userNameDic = @{@"dicKey":@"tPhone", @"data":userName};
    NSDictionary *passWordDic = @{@"dicKey":@"tPassword", @"data":passWord};
    NSDictionary *verifyCodeDic = @{@"dicKey":@"verifyCode", @"data":verifyCode};
    
    NSArray *postArray = @[userNameDic, passWordDic, verifyCodeDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/appUserRegister", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"注册页面请求下来的数据obj = %@", obj);
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
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"LoginChannel"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[JPushTagAndAlias shareJPush] setTagsAlias:model.tAlias];
                
                // 发通知让我的页面重新请求数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRefiersh" object:nil];
                
                if ([_isWeb isEqualToString:@"1"]) {
                    //pop回web页
                    UIViewController *mineVC = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:mineVC animated:YES];
                }else{
                    //pop回任意页
                    UIViewController *mineVC = self.navigationController.viewControllers[0];
                    [self.navigationController popToViewController:mineVC animated:YES];
                }
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
    NSDictionary *typeDic = @{@"dicKey":@"verifyType", @"data":@"01"}; /** 01-注册 02-快捷登陆 03-改密*/
    
    
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
                
                
                //判断是否绑定过手机号,如果没有跳转到绑定手机号页面
                if (model.tPhone.length > 0) {
                    if ([_isWeb isEqualToString:@"1"]) {
                        //pop回web页
                        UIViewController *mineVC = self.navigationController.viewControllers[1];
                        [[NSUserDefaults standardUserDefaults] setValue:tLoginChannel forKey:@"LoginChannel"];
                        [[NSUserDefaults standardUserDefaults] setValue:model.tId forKey:@"UserID"];
                        [[NSUserDefaults standardUserDefaults] setValue:userDic forKey:@"UserDic"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        // 发通知让我的页面重新请求数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRefiersh" object:nil];
                        [[JPushTagAndAlias shareJPush] setTagsAlias:model.tAlias];
                        [self.navigationController popToViewController:mineVC animated:YES];
                    }else{
                        //pop回任意页
                        // 绑定过 就储存userId 返回我的页
                        [[NSUserDefaults standardUserDefaults] setValue:model.tId forKey:@"UserID"];
                        [[NSUserDefaults standardUserDefaults] setValue:userDic forKey:@"UserDic"];
                        [[NSUserDefaults standardUserDefaults] setValue:tLoginChannel forKey:@"LoginChannel"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[JPushTagAndAlias shareJPush] setTagsAlias:model.tAlias];
                        
                        // 发通知让我的页面重新请求数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRefiersh" object:nil];
                        
                        UIViewController *mineVC = self.navigationController.viewControllers[0];
                        [self.navigationController popToViewController:mineVC animated:YES];
                    }
                }else{
                    // 没绑定过 跳到绑定页
                    BindingPhoneViewController *bindController = [[BindingPhoneViewController alloc]init];
                    bindController.delegate = self;
                    bindController.tid = model.tId;
                    bindController.channel = tLoginChannel;
                    bindController.gender = gender;
                    DKBNavigationController *navigation = [[DKBNavigationController alloc]initWithRootViewController:bindController];
                    [self presentViewController:navigation animated:YES completion:nil];
                }
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"%@",error);
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}

#pragma mark --BindingPhoneDelegate Method
-(void)popToSettingController:(BindingPhoneViewController *)bindingController
{
    if ([_isWeb isEqualToString:@"1"]) {
        // pop回web页
        UIViewController *mineVC = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:mineVC animated:YES];
    }else{
        // pop回我的页
        UIViewController *mineVC = self.navigationController.viewControllers[0];
        [self.navigationController popToViewController:mineVC animated:YES];
    }
}


- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"注册" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter Number:3];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem LoginLeftbarWithTitle:@"取消" target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem LoginRightbarWithTitle:@"登录" target:self action:@selector(loginAction)];
}

- (void)backAction
{
    NSLog(@"取消 pop");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)loginAction
{
    NSLog(@"返回登录 pop");
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
