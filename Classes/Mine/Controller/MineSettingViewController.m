//
//  MineSettingViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/10.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineSettingViewController.h"
#import "MineFeedBackViewController.h"
#import "MineAboutAsViewController.h"
#import "MineSettingCell.h"
#import "MineSettingExitLoginCell.h"

@interface MineSettingViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *mytableView;
@property (nonatomic,strong)NSArray *myArray;

// 缓存
@property (nonatomic,assign)NSInteger cache;
@property (nonatomic,strong)NSString *sizeString;

/** 简介*/
@property (nonatomic, copy) NSString *synopsis;
/** 微信公众号*/
@property (nonatomic, copy) NSString *wechatPublicNumber;
/** 新浪微博*/
@property (nonatomic, copy) NSString *microBlogSina;
/** 官网*/
@property (nonatomic, copy) NSString *officialWebsite;
/** 客服电话*/
@property (nonatomic, copy) NSString *serviceTelephone;

@end

@implementation MineSettingViewController

-(void)dealloc
{
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    STATUS_WIHTE
    // 布局navigation
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self getData];
    
}
-(void)createTableView
{
    if (!_mytableView) {
        _mytableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mytableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        //注册cell
        [_mytableView registerClass:[SettingCell class] forCellReuseIdentifier:@"settingCell"];
        [_mytableView registerClass:[MineSettingExitLoginCell class] forCellReuseIdentifier:@"exitCell"];
    }
}

-(NSArray *)myArray
{
    if (!_myArray) {
        _myArray = [NSArray arrayWithObjects:@"清空缓存", @"客服电话", @"意见反馈", @"关于我们", nil];
    }return _myArray;
}
#pragma mark UItableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (USERID) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.myArray.count;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * identy = @"settingCell";
        SettingCell *cell =[tableView dequeueReusableCellWithIdentifier:identy];
        cell.Label.text = self.myArray[indexPath.row];
        
        if (indexPath.row == 0) {
            self.sizeString =  [self getCache]; //缓存
            if ([_sizeString isEqualToString:@"0B"]||[_sizeString isEqualToString:@"0K"]||[_sizeString isEqualToString:@"0M"]||[_sizeString isEqualToString:@"0G"]) {
                cell.rightLabel.text = @"";
            }else{
                cell.rightLabel.text = self.sizeString;
            }

        }else if (indexPath.row == 1){
            cell.rightLabel.text = _serviceTelephone;
        }else if (indexPath.row == 3){
            // 不显示最下面cell的分割线
            cell.isShow = YES;
        }
        return cell;
    }else{
        static NSString *identifier = @"exitCell";
        MineSettingExitLoginCell *exitCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        return exitCell;
    }
}

//清空缓存
- (NSString *)getCache
{
    NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
    //
    NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
    return currentVolum;
}

//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        return 38;
    }
    return 42;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 11.5;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIImage *backImage = [UIImage imageNamed:@"mine-t"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        UIView *view = [UIView new];
        view.backgroundColor = bc;
        
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIImage *backImage = [UIImage imageNamed:@"Settings-b"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        UIView *view = [UIView new];
        view.backgroundColor = bc;
        
        return view;
    }
    return nil;
}

#pragma mark --delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (_cache == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"缓存已清理" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alert show];
            }else {
                UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"是否清理缓存" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
                alert1.delegate = self;
                
                [alert1 show];
            }
        }else if (indexPath.row == 1){
            // 打电话
            NSMutableString * str = [[NSMutableString alloc] init];
            if (_serviceTelephone.length > 0) {
                str=[[NSMutableString alloc] initWithFormat:@"tel:%@", _serviceTelephone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
        }else if (indexPath.row == 2){
            MineFeedBackViewController *feedbackVC = [[MineFeedBackViewController alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }else if (indexPath.row == 3){
            MineAboutAsViewController *aboutVC = [MineAboutAsViewController new];
            if (_synopsis.length > 0) {
                aboutVC.synopsis = _synopsis;
            }else{
                aboutVC.synopsis = @"";
            }
            if (_wechatPublicNumber.length > 0) {
                aboutVC.wechatPublicNumber = _wechatPublicNumber;
            }else{
                aboutVC.wechatPublicNumber = @"";
            }
            if (_microBlogSina.length > 0) {
                aboutVC.microBlogSina = _microBlogSina;
            }else{
                aboutVC.microBlogSina = @"";
            }
            if (_officialWebsite.length > 0) {
                aboutVC.officialWebsite = _officialWebsite;
            }else{
                aboutVC.officialWebsite = @"";
            }
            
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }else{
        // 退出登录逻辑在这写
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"UserID"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"UserDic"];
        // 发通知让我的页面重新请求数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRefiersh" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    // 松手取消选中色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - alertView 点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[SDImageCache sharedImageCache] clearDisk];
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        
        [[SDImageCache sharedImageCache] clearMemory];//可不写
        [self.mytableView reloadData];
    }else{
        
    }
}

#pragma mark - 布局navigation
- (void)setNavigationController
{
    self.navigationController.navigationBarHidden = NO;
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"设置" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter Number:3];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 查询设置信息
- (void)getData{
    
    NSString *url = [NSString stringWithFormat:@"%@/my/selectMySetUp", SERVER_URL];
    
    [ServerUtility POSTAction:url param:nil target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"设置页数据obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                _synopsis = [obj objectForKey:@"synopsis"];
                _wechatPublicNumber = [obj objectForKey:@"wechatPublicNumber"];
                _microBlogSina = [obj objectForKey:@"microBlogSina"];
                _officialWebsite = [obj objectForKey:@"officialWebsite"];
                _serviceTelephone = [obj objectForKey:@"serviceTelephone"];
                
                [self.mytableView reloadData];
            }else{
//                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"%@",error);
//            [self showHint:@"亲，网络开小差了"];
        }
    }];
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
