//
//  MineViewController.m
//  CherrySports
//
//  Created by dkb on 16/10/26.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineViewController.h"
#import "HomeViewController.h"
#import "MineMessageViewController.h"
#import "MineSettingViewController.h"
#import "PersonalSettingsViewController.h"
#import "MineCollectViewController.h"
#import "MineChangePasswordViewController.h"
#import "MineEventsViewController.h"
#import "MineScoreViewController.h"
#import "WonderfulCollectionViewController.h"

#import "AliImageReshapeController.h"
#import "BarcodeViewController.h"

//#import "MineHeaderCell.h"
#import "MineHeaderNewCell.h"
//#import "MyHeaderCell.h"
#import "MineSecondCell.h"
// 线View
#import "LineView.h"
// 登录页
#import "LoginVC.h"

#import "LoginModel.h"

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL YES
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certificate @"lxtyssl"

@interface MineViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    MineHeaderDelegate,
    ALiImageReshapeDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIActionSheetDelegate
>
{
    NSString *messageState;
}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)NSArray *settingArray;
@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic, strong)UIColor *bc;

// 背景图片
@property (nonatomic, strong)UIImage *backImage;
@property (strong,nonatomic) NSData* imageData;

@end

@implementation MineViewController

- (void)dealloc
{
    _myTableView.delegate = nil;
    _myTableView.dataSource = nil;
    
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    STATUS_WIHTE
    [self setNavigationController];
    if (self.myTableView != nil) {
        [_myTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
    
    if (!LOGINCHANNEL) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"LoginChannel"];
    }
    
    if (USERID) {
        [self getData];
    }else{
        
        [self getNoLoginData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Reload) name:@"MyRefiersh" object:nil];
}

// 接收通知重新请求数据
- (void)Reload
{
    if (!LOGINCHANNEL) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"LoginChannel"];
    }
    NSlog(@"接收通知重新请求用户数据");
    if (USERID) {
        [self getData];
    }else{
        [self getNoLoginData];
    }
}

- (void)createViews
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _myTableView.dataSource =self;
        _myTableView.delegate =self;
        _myTableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        //不显示分割线
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0);
        }];
    }
    //注册cell
    [_myTableView registerClass:[MineHeaderNewCell class] forCellReuseIdentifier:@"headerCell"];
    [_myTableView registerClass:[SecondCell class] forCellReuseIdentifier:@"listCell"];
    
}

#pragma mark --懒加载数组
-(NSArray *)settingArray
{
    if (!_settingArray) {
        _settingArray =[NSArray arrayWithObjects:@"消息", @"收藏", @"我的赛事", @"成绩查询", @"修改密码", @"我的二维码" ,nil];
    }return _settingArray;
}

-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray =[NSArray arrayWithObjects:@"message", @"collection", @"myplay", @"mine_mycj_icon", @"mine_icon_red", @"mine_erweima", nil];
    }return _imageArray;
}

#pragma mark --tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.settingArray.count;
    }else
        return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *iden = @"headerCell";
        MineHeaderNewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (USERDIC != nil) {
            NSMutableDictionary *dic = USERDIC;
            cell.dic = dic;
        }else{
            cell.avatar.image = PLACEHOLDNV;
            cell.backImage.image = [UIImage imageNamed:@"mine_backImg"]; //
            cell.name.text = @"昵称";
            cell.dic = USERDIC;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
        [cell.backImage addGestureRecognizer:tap];
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        static NSString *identify = @"listCell";
        
        SecondCell *listCell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        listCell.Label.text = self.settingArray[indexPath.row];
        listCell.leftImage.contentMode = UIViewContentModeScaleAspectFit;
        listCell.leftImage.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
        
        if (indexPath.row == 0) {
            
            if ([messageState isEqualToString:@"0"]) {
                
                listCell.smallButton.hidden = NO;
                
            }else{
                
                listCell.smallButton.hidden = YES;
                
            }
        }
        
        return listCell;
    }else
    {
        static NSString *identifyThird = @"listCell";
        SecondCell *settingCell = [tableView dequeueReusableCellWithIdentifier:identifyThird];
        
        settingCell.Label.text = @"设置";
        settingCell.leftImage.image = [UIImage imageNamed:@"setting"];
        
        return settingCell;
    }
}

#pragma mark - 更换背景图片
- (void)changeImage
{
    if (USERID) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更换封面", nil];
        [sheet showInView:self.view];
    }else{
        NSLog(@"跳登录页");
        LoginVC *loginVC = [LoginVC new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark - actionSheet & delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        // 相册选取
        [self chooseImageFromLibary];
    }else{
        // 取消
    }
}

// 选择相册
- (void)chooseImageFromLibary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO; // 设置为NO 直接跳到裁剪
    [self presentViewController:picker animated:YES completion:^{
        // 改变状态栏的颜色  为正常  这是这个独有的地方需要处理的
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}
#pragma mark - UIImagePickerControllerDelegate 相册回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // 不裁剪的话是在这取到图片
    
    AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
    vc.sourceImage = image;
    vc.reshapeScale = 750./420.;
    vc.delegate = self;
    [picker pushViewController:vc animated:YES];
}
// 取消选择照片回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        // 改变状态栏的颜色  改变为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

#pragma mark - ALiImageReshapeDelegate 裁剪回调
- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    // 网络请求刷新tableView
    self.backImage = image;
    [self saveImage:image WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".jpg"]];
    
    [reshaper dismissViewControllerAnimated:YES completion:^{
        // 显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        // 改变状态栏的颜色  改变为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
// 取消裁剪回调
- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    [reshaper dismissViewControllerAnimated:YES completion:^{
        // 显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        // 改变状态栏的颜色  改变为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 0.56 * SCREEN_WIDTH + 46;
//        return 0.56 * SCREEN_WIDTH;
    }else if (indexPath.section == 1){
        return 50;
    }else
        return 50;
}
// 每个区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 2) {
        LineView *view = [LineView new];
        
        return view;
    }
    return nil;
}

#pragma mark --delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (USERID) {
            if (indexPath.row == 0) {
                MineMessageViewController *mymessageVC = [MineMessageViewController new];
                [self.navigationController pushViewController:mymessageVC animated:YES];
            }else if (indexPath.row == 1){
                MineCollectViewController *mycollectVC = [MineCollectViewController new];
                [self.navigationController pushViewController:mycollectVC animated:YES];
            }else if (indexPath.row == 2){
                MineEventsViewController *myeventsVC = [MineEventsViewController new];
                [self.navigationController pushViewController:myeventsVC animated:YES];
            }else if (indexPath.row == 3){
                MineScoreViewController *scoreVC = [MineScoreViewController new];
                
                [self.navigationController pushViewController:scoreVC animated:YES];
            }else if (indexPath.row == 4){
                MineChangePasswordViewController *myPasswordVC = [MineChangePasswordViewController new];
                [self.navigationController pushViewController:myPasswordVC animated:YES];
            }if (indexPath.row == 5){
                BarcodeViewController *barCodeVC = [BarcodeViewController new];
                [self.navigationController pushViewController:barCodeVC animated:YES];
             
            }else if(indexPath.row == 6){
                WonderfulCollectionViewController *myPasswordVC = [WonderfulCollectionViewController new];
                [self.navigationController pushViewController:myPasswordVC animated:YES];
            }
        }else{
            NSLog(@"跳登录页");
            LoginVC *loginVC = [LoginVC new];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else if (indexPath.section == 2) {
        MineSettingViewController *settingControler =[[MineSettingViewController alloc]init];
        [self.navigationController pushViewController:settingControler animated:YES];
    }
    // 松手取消选中色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - headerCellDelegate
- (void)cenderSettingImage
{
    if (USERID) {
        // 跳转到设个人置页
        PersonalSettingsViewController *personSVC = [PersonalSettingsViewController new];
        
        [self.navigationController pushViewController:personSVC animated:YES];
    }else{
        NSLog(@"跳登录页");
        LoginVC *loginVC = [LoginVC new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"个人中心" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
}


#pragma mark - 有登录请求数据
- (void)getData{
//    NSLog(@"%@", LOGINCHANNEL);
    NSDictionary *userIdDic = @{@"dicKey":@"tAppUserId", @"data":USERID};
    NSDictionary *installTimeDic = @{@"dicKey":@"installTime", @"data":SYSTIME};
    NSDictionary *channelDic = @{@"dicKey":@"tLoginChannel", @"data":LOGINCHANNEL};
    
    NSArray *postArray = @[userIdDic, installTimeDic, channelDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/my/selectMy", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"已登录请求的数据obj = %@", obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                LoginModel *model = [LoginModel mj_objectWithKeyValues:obj];
                
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [userDic setObject:model.tAlias forKey:@"tAlias"];
                [userDic setObject:model.tPhone forKey:@"tPhone"];
                [userDic setObject:model.tHeadPicture forKey:@"tHeadPicture"];
                [userDic setObject:model.tBackgroundImg forKey:@"tBackgroundImg"];
                [userDic setObject:model.tGender forKey:@"tGender"];
                [userDic setObject:model.tNickname forKey:@"tNickname"];
                [userDic setObject:model.tBirthday forKey:@"tBirthday"];
                [userDic setObject:model.tHeight forKey:@"tHeight"];
                [userDic setObject:model.tWeight forKey:@"tWeight"];
                [userDic setObject:model.tDynamic forKey:@"tDynamic"];
                [userDic setObject:model.tAttention forKey:@"tAttention"];
                [userDic setObject:model.tFansCount forKey:@"tFansCount"];
                [[NSUserDefaults standardUserDefaults] setValue:userDic forKey:@"UserDic"];
                
                messageState = [obj objectForKey:@"messageState"];
                
                [self.myTableView reloadData];
            }else{
//                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"%@",error);
//            [self showHint:@"亲，网络开小差了"];
        }
    }];
}

#pragma mark - 没登录请求数据
- (void)getNoLoginData{
    NSDictionary *installTimeDic;
    if (SYSTIME) {
        installTimeDic = @{@"dicKey":@"installTime", @"data":SYSTIME};
    }else{
        installTimeDic = @{@"dicKey":@"installTime", @"data":@""};
    }
    NSArray *postArray = @[installTimeDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/my/selectMy", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"没登录请求数据obj = %@", obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                messageState = [obj objectForKey:@"messageState"];
                
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"UserDic"];
                
                [self.myTableView reloadData];
            }else{
//                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"%@",error);
//            [self showHint:@"亲，网络开小差了"];
        }
    }];
}


/**
 *  上传图片
 *
 *  @param tempImage 要上传的图片
 *  @param imageName imageName description
 */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    _imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [_imageData writeToFile:fullPathToFile atomically:NO];
    
    NSString *urlPath = [NSString stringWithFormat:@"%@/upload/upload",SERVER_URL];
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    if(openHttpsSSL)
    {
        [managers setSecurityPolicy:[self customSecurityPolicy]];
    }
    //开始上传
    MBProgressHUD * hud = [[MBProgressHUD alloc]init];
    [self.view addSubview: hud];
    [hud show:YES];
    [managers POST:urlPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:_imageData name:@"img" fileName:imageName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud removeFromSuperview];
        NSLog(@"%@",responseObject);
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]) {
            
            [self updateheadImg:[responseObject objectForKey:@"uploadPath"]];
        }else{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbp.detailsLabelText = [obj objectForKey:@"resultMessage"];
            mbp.detailsLabelFont = TEXT_FONT_BIG;
            mbp.mode = MBProgressHUDModeText;
            [mbp hide:YES afterDelay:2.00];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud removeFromSuperview];
        NSLog(@"Error%@",error);
    }];
}

- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // to the autorelease pool
    
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}




-(void)updateheadImg:(NSString *)headImg
{
    NSDictionary *userIdDic = @{@"dicKey":@"tId",@"data":USERID};
    NSDictionary *headImgDic = @{@"dicKey":@"tBackgroundImg",@"data":headImg};
    NSDictionary *channelDic = @{@"dicKey":@"tLoginChannel", @"data":LOGINCHANNEL};
    
    NSArray *postArray = [[NSArray alloc] init];;
    postArray = @[userIdDic, headImgDic, channelDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/updateAppUser",SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.myTableView finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            NSLog(@"修改成功 = %@",obj);
            if ([[obj objectForKey:@"resultCode"]isEqualToString:@"0000"]) {
                //修改成功
                //                if (![[obj objectForKey:@"headImg"] isEqual:[NSNull null]]) {
                //
                //                }
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
                [[NSUserDefaults standardUserDefaults] setValue:userDic forKey:@"UserDic"];
                
                NSLog(@"tBackgroundImg = %@", [USERDIC objectForKey:@"tBackgroundImg"]);
                [self.myTableView reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *setCer = [[NSSet alloc] initWithObjects:certData, nil];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要f验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    //    securityPolicy.pinnedCertificates = @[certData];
    securityPolicy.pinnedCertificates = setCer;
    
    return securityPolicy;
}


@end
