//
//  QuickLoginViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/25.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "QuickLoginViewController.h"
#import "QuickLoginTableViewCell.h"
#import "LoginModel.h"
#import "ENWebViewController.h"

@interface QuickLoginViewController ()<UITableViewDelegate, UITableViewDataSource, QuickLoginDelegate>{
    NSMutableArray *dataArray;
    NSString *userPhone;
    NSString *userCode;
}
@property (nonatomic, strong) UITableView *mytableView;
@end

@implementation QuickLoginViewController

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
        [_mytableView registerClass:[QuickLoginTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    QuickLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT-64;
}

#pragma mark - cellDelegate;
- (void)quickLogin
{
    NSLog(@"快捷登录请求数据");
    if (userPhone.length == 0 || userPhone.length != 11) {
        [self showHint:@"请输入正确的手机号"];
    }else if (userCode.length != 6){
        [self showHint:@"请输入正确的验证码"];
    }else{
        // 收回键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self getDataUserName:userPhone PassWord:@"" VerifyCode:userCode tLoginChannel:@"0"];
    }
}

// 实时获取text
- (void)quickPhone:(NSString *)phone Code:(NSString *)code
{
    userPhone = phone;
    userCode = code;
}

// 获取验证码
- (void)getVerificaCode
{
    [self getDataVerifyCodePhone:userPhone];
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
                [[NSUserDefaults standardUserDefaults] setValue:tLoginChannel forKey:@"LoginChannel"];
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
    NSDictionary *typeDic = @{@"dicKey":@"verifyType", @"data":@"02"}; /** 01-注册 02-快捷登陆 03-改密*/
    
    
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
    UILabel *titleLabel = [AppTools createLabelText:@"快捷登录" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
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
