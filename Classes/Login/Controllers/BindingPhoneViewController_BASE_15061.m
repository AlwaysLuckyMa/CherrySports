

#import "BindingPhoneViewController.h"
#import "QuickLoginTableViewCell.h"
#import "LoginModel.h"

@interface BindingPhoneViewController ()<UITableViewDelegate, UITableViewDataSource, QuickLoginDelegate>{
    NSMutableArray *dataArray;
    NSString *userPhone;
    NSString *userCode;
}
@property (nonatomic, strong) UITableView *mytableView;
@end

@implementation BindingPhoneViewController

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
    [cell.okBtn setTitle:@"绑 定" forState:UIControlStateNormal];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT-64;
}

#pragma mark - cellDelegate;
- (void)quickLogin
{
    if (userPhone.length == 0 || userPhone.length != 11) {
        [self showHint:@"请输入正确的手机号"];
    }else if (userCode.length != 6){
        [self showHint:@"请输入正确的验证码"];
    }else{
        // 收回键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        NSLog(@"绑定手机号请求数据");
        [self quickPhone:userPhone Code:userCode];
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


-(void)TheBindingPhone:(NSString *)phone Code:(NSString *)code
{
    NSDictionary *userIdDic = @{@"dicKey":@"tId",@"data":_tid};
    NSDictionary *phoneDic = @{@"dicKey":@"tPhone",@"data":phone};
    NSDictionary *codeDic = @{@"dicKey":@"verifyCode", @"data":code};
    
    
    NSArray *postArray = [[NSArray alloc] init];;
    postArray = @[userIdDic, phoneDic, codeDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/updateAppUser",SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            NSLog(@"修改成功 = %@",obj);
            if ([[obj objectForKey:@"resultCode"]isEqualToString:@"0000"]) {
                //修改成功
                LoginModel *model = [LoginModel mj_objectWithKeyValues:obj];
                
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
                
                NSLog(@"dic = %@", userDic);
                // 修改成功则登录
                [[NSUserDefaults standardUserDefaults] setValue:model.tId forKey:@"UserID"];
                [[NSUserDefaults standardUserDefaults] setValue:userDic forKey:@"UserDic"];
                
                if ([self.delegate respondsToSelector:@selector(popToSettingController:)]) {
                    [self.delegate popToSettingController:self];
                }
            }
            else
            {
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }
        else
        {
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}



#pragma mark - **************** 获取短信验证码
- (void)getDataVerifyCodePhone:(NSString *)phone{
    
    NSDictionary *phoneDic = @{@"dicKey":@"tPhone", @"data":phone}; /** 手机号 */
    //    NSDictionary *typeDic = @{@"dicKey":@"type", @"data":@"01"}; /** 01-注册 02-登陆 03-改密 */
    
    
    NSArray *postArr = @[phoneDic];
    
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
//    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quicklogin_title"]];
    self.navigationItem.title = @"绑定手机号";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(back)];
}

//- (void)back
//{
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self.navigationController popViewControllerAnimated:YES];
//        //取消模态视图
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    });
//}
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
