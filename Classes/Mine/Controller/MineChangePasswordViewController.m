//
//  MineChangePasswordViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/17.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineChangePasswordViewController.h"
#import "ChangePasswordCell.h"
#import "ChangePasswordView.h"
#import "LoginVC.h"
@interface MineChangePasswordViewController ()<ChangePasswordDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSString *passOld;
    NSString *passNew;
    NSString *passOk;
}

@property (nonatomic, strong)UITableView *mytableView;
@end

@implementation MineChangePasswordViewController

-(void)dealloc
{
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enable = YES;
    [self createUi];
}

- (void)createUi
{
    
    if (!_mytableView) {
        _mytableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.scrollEnabled = NO;
        [self.view addSubview:_mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(230);
        }];
        [_mytableView registerClass:[ChangePasswordCell class] forCellReuseIdentifier:@"cell"];
    }
}

#pragma mark -- tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ChangePasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.passView.delegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT;
}





#pragma mark - cell && delegate
- (void)OkpostDataOldPass:(NSString *)old Newpass:(NSString *)newPass
{
    // 请求更改密码数据
    if (passOld.length == 0) {
        [self showHint:@"请输入旧的密码"];
    }else if (passNew.length == 0){
        [self showHint:@"请输入新的密码"];
    }else if (passOk.length == 0){
        [self showHint:@"请再次确认新密码"];
    }else if (passOld.length < 6 || passNew.length < 6 || passOk.length < 6){
        [self showHint:@"密码长度不得小于6位"];
    }else if (![passNew isEqualToString:passOk]) {
        [self showHint:@"两次密码不一致，请重新输入"];
    }else{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self getDataUserId:USERID PasswordNew:passNew PasswordOld:passOld];
    }
}

- (void)PasswordNewText:(NSString *)passwordnew OldPasswordText:(NSString *)oldPassword OkPassword:(NSString *)okPassword
{
    passNew = passwordnew;
    passOld = oldPassword;
    passOk = okPassword;
}

#pragma mark - 请求数据
- (void)getDataUserId:(NSString *)userId PasswordNew:(NSString *)passwordNew PasswordOld:(NSString *)passwordOld
{
    NSDictionary *userIdDic = @{@"dicKey":@"tId", @"data":userId};
    NSDictionary *passNewDic = @{@"dicKey":@"tPassword", @"data":passwordNew};
    NSDictionary *passOldDic = @{@"dicKey":@"OldPassword", @"data":passwordOld};
    
    NSArray *postArray = @[userIdDic, passNewDic, passOldDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/modifyPassword", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"注册页面请求下来的数据obj = %@", obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                // 修改成功退出登录
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"UserID"];
                // 修改成功跳到登录页面
                LoginVC *loginvc = [LoginVC new];
                [self.navigationController pushViewController:loginvc animated:YES];
                NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [tempMarr removeObject:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRefiersh" object:nil];
                [self.navigationController setViewControllers:tempMarr animated:YES];
                
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
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
    UILabel *titleLabel = [AppTools createLabelText:@"修改密码" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
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
