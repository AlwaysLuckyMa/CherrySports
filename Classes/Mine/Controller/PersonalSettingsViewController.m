//
//  PersonalSettingsViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/17.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "PersonalSettingsViewController.h"
#import "LineView.h"
#import "PersonalAvatarSettingsCell.h"
#import "AliImageReshapeController.h"
#import "NickNameViewController.h"
#import "DKBDataPickView.h"
#import "DKBGenderPickView.h"
#import <CoreText/CoreText.h>
#import "LoginModel.h"

#define proportion (16./9.)

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

@interface PersonalSettingsViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate, ALiImageReshapeDelegate, UIActionSheetDelegate, DKBDataDelegate, DKBgenderDelegate, NicknameDelegate>
{
    /** 头像url*/
    NSString *avatalUrl;
}
/** tableView*/
@property (nonatomic, strong) UITableView *mytableView;
/** 日期选择器*/
@property (nonatomic, strong) DKBDataPickView *dataPick;
@property (nonatomic, strong) DKBGenderPickView *genderPick;

/** 选择的日期*/
@property (nonatomic, copy) NSString *dataStr;
/** 选择的性别*/
@property (nonatomic, strong) NSString *gender;
/** 记录昵称*/
@property (nonatomic, strong) NSString *nickName;
/** 头像*/
@property (nonatomic, strong) UIImage *avatalImage;

@property (strong,nonatomic) NSData* imageData;

@end

@implementation PersonalSettingsViewController

-(void)dealloc
{
    _dataPick.dkbDelegate = nil;
    _genderPick.dkbGenderDelegate = nil;
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    [self setNavigationController];
    // 取值
    if ([[USERDIC objectForKey:@"tHeadPicture"] isEqualToString:@""]) {
        _avatalImage = nil;
    }else{
        avatalUrl = [USERDIC objectForKey:@"tHeadPicture"];
    }
    _nickName = [USERDIC objectForKey:@"tNickname"];
    _gender = [USERDIC objectForKey:@"tGender"];
    _dataStr = [USERDIC objectForKey:@"tBirthday"];
}

- (void)isPop
{
    [_mytableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUi];
}

- (void)createUi
{
    if (!_mytableView) {
        _mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mytableView.dataSource =self;
        _mytableView.delegate =self;
        _mytableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        //不显示分割线
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_offset(0);
        }];
    }
    [_mytableView registerClass:[PersonalAvatarSettingsCell class] forCellReuseIdentifier:@"cell"];
}


#pragma mark --tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    PersonalAvatarSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            cell.leftLabel.attributedText = [AppTools labelNumber:1.5 String:@"昵称"];
            cell.rightLabel.hidden = NO;
            cell.rightImageV.hidden = YES;
            cell.wireView.hidden = NO;
            cell.lineView.hidden = YES;
            
            cell.rightLabel.text = _nickName;
        }else{
            cell.leftLabel.attributedText = [AppTools labelNumber:1.5 String:@"头像"];
            cell.wireView.hidden = NO;
            cell.lineView.hidden = YES;
            cell.rightImageV.hidden = NO;
            cell.rightLabel.hidden = YES;
            
            if (USERDIC != nil) {
                NSString *urlStr = [USERDIC objectForKey:@"tHeadPicture"];
                NSString *gender = [USERDIC objectForKey:@"tGender"];
                if (urlStr.length > 0) {
                    NSURL *url;
                    if([urlStr rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
                    {
                        url = [NSURL URLWithString:urlStr];
                    }else{
                        url = [NSURL URLWithString:[AppTools httpsWithStr:urlStr]];
                    }
                    if ([gender isEqualToString:@"0"]) {
                        [cell.rightImageV sd_setImageWithURL:url placeholderImage:PLACEHOLDNV options:SDWebImageAllowInvalidSSLCertificates];
                    }else{
                        [cell.rightImageV sd_setImageWithURL:url placeholderImage:PLACEHOLDNAN options:SDWebImageAllowInvalidSSLCertificates];
                    }
                }else{
                    if (gender.length == 0) {
                        cell.rightImageV.image = PLACEHOLDNAN;// [UIImage imageNamed:@"mine_nan"]
                    }else if ([gender isEqualToString:@"0"]){
                        cell.rightImageV.image = PLACEHOLDNV;//  [UIImage imageNamed:@"mine_nan"]
                    }else{
                        cell.rightImageV.image = PLACEHOLDNAN;// [UIImage imageNamed:@"mine_nan"]
                    }
                }
            }else{
                cell.rightImageV.image = PLACEHOLDNV;
            }
        }
    }else if (indexPath.section == 1){
        cell.rightLabel.hidden = NO;
        cell.rightImageV.hidden = YES;
        if (indexPath.row == 0) {
            cell.leftLabel.attributedText = [AppTools labelNumber:1.5 String:@"性别"];
            cell.wireView.hidden = NO;
            cell.lineView.hidden = YES;
            if ([_gender isEqualToString:@"0"]) {
                cell.rightLabel.text = @"女";
            }else if ([_gender isEqualToString:@"1"]){
                cell.rightLabel.text = @"男";
            }else{
                cell.rightLabel.text = @"男";
            }
        }else{
            cell.leftLabel.attributedText = [AppTools labelNumber:1.5 String:@"出生年月"];
            cell.wireView.hidden = YES;
            cell.lineView.hidden = NO;
            
            cell.rightLabel.text = _dataStr;
            cell.rightLabel.font = [UIFont fontWithName:@"Arial" size:12];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 78;
        }else if (indexPath.row == 1){
            return 40;
        }
    }
    return 40;
}
// 每个区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LineView *view = [LineView new];
        
    return view;
}

#pragma mark -- table&delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册选取", nil];
            [sheet showInView:self.view];
        }else{
            // 昵称页
            NickNameViewController *nickNameVC = [NickNameViewController new];
            nickNameVC.delegate = self;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            // 选择性别
            _genderPick = nil;
            if (_genderPick == nil) {
                [self genderPick];
            }
        }else{
            // 选择出生年月日
            _dataPick = nil;
            if (_dataPick == nil) {
                [self dataPick];
            }
        }
    }
    
    // 松手取消选中色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 选择日期View
- (DKBDataPickView *)dataPick
{
    if (!_dataPick) {
        _dataPick = [DKBDataPickView new];
        _dataPick.dkbDelegate = self;
        [self.view addSubview:_dataPick];
        [_dataPick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _dataPick;
}
#pragma mark - 选择日期delegate
- (void)dataWithString:(NSString *)str
{
    [self updateGender:@"" headImg:@"" Birthday:str Nickname:@""];
}

// 选择性别View
- (DKBGenderPickView *)genderPick
{
    if (!_genderPick) {
        _genderPick = [DKBGenderPickView new];
        _genderPick.dkbGenderDelegate = self;
        [self.view addSubview:_genderPick];
        [_genderPick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _genderPick;
}

- (void)GenderWithString:(NSString *)str
{
    NSLog(@"sex = %@", str);
    if ([str isEqualToString:@"男"]) {
        str = @"1";
    }else{
        str = @"0";
    }
    [self updateGender:str headImg:@"" Birthday:@"" Nickname:@""];
}


#pragma mark - actionSheet & delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 拍照
        [self takePhoto];
    }else if (buttonIndex == 1){
        // 相册选取
        [self chooseImageFromLibary];
    }else{
        // 取消
    }
}
// 拍照
- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:^{
        // 改变状态栏的颜色  为正常  这是这个独有的地方需要处理的
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}
// 选择相册
- (void)chooseImageFromLibary //1994
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

#pragma mark - ALiImageReshapeDelegate
- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    // 网络请求刷新tableView 裁剪后回调
    self.avatalImage = image;
    
    // 调用裁剪图片方法
    _avatalImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width/2, image.size.height/2)];
    NSLog(@"image.size = %f, height = %f", _avatalImage.size.width, _avatalImage.size.height);
    
    [self saveImage:image WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".jpg"]];
    
    [reshaper dismissViewControllerAnimated:YES completion:^{
        // 显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        // 改变状态栏的颜色  改变为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    [reshaper dismissViewControllerAnimated:YES completion:^{
        // 显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        // 改变状态栏的颜色  改变为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        // 改变状态栏的颜色  改变为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // 裁剪前的图片 1996
    
    AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
    vc.sourceImage = image;
    vc.reshapeScale = 3./3.;
    vc.delegate = self;
    [picker pushViewController:vc animated:YES];
}

-(void)updateGender:(NSString *)gender headImg:(NSString *)headImg Birthday:(NSString *)birthday Nickname:(NSString *)nickname
{
    NSDictionary *userIdDic = @{@"dicKey":@"tId",@"data":USERID};
    NSDictionary *genderDic = @{@"dicKey":@"tGender",@"data":gender};
    NSDictionary *headImgDic = @{@"dicKey":@"tHeadPicture",@"data":headImg};
    NSDictionary *birthdayDic = @{@"dicKey":@"tBirthday",@"data":birthday};
    NSDictionary *nicknameDic = @{@"dicKey":@"tNickname",@"data":nickname};
    NSDictionary *channelDic = @{@"dicKey":@"tLoginChannel", @"data":LOGINCHANNEL};
    
    NSArray *postArray = [[NSArray alloc] init];;
    postArray = @[userIdDic, genderDic, headImgDic, birthdayDic, nicknameDic, channelDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/updateAppUser",SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.mytableView finish:^(NSData *data, NSDictionary *obj, NSError *error) {
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
                
                if ([[USERDIC objectForKey:@"tHeadPicture"] isEqualToString:@""]) {
                    _avatalImage = nil;
                }else{
                    avatalUrl = model.tHeadPicture;
                }
                _nickName = [USERDIC objectForKey:@"tNickname"];
                _gender = [USERDIC objectForKey:@"tGender"];
                _dataStr = [USERDIC objectForKey:@"tBirthday"];
                
                NSLog(@"dic = %@", [userDic objectForKey:@"tHeadPicture"]);
                NSLog(@"USERDIC = %@", [USERDIC objectForKey:@"tHeadPicture"]);
                [self.mytableView reloadData];
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


/**
 *  上传图片
 *
 *  @param tempImage 要上传的图片
 *  @param imageName imageName description
 */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
//    _imageData = UIImagePNGRepresentation(tempImage);
    _imageData = [AppTools imageData:tempImage];
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
  
    [managers POST:urlPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        [formData appendPartWithFileData:_imageData name:@"img" fileName:imageName mimeType:@"image/jpg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud removeFromSuperview];
        NSLog(@"%@",responseObject);
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]) {
            
            [self updateGender:@"" headImg:[responseObject objectForKey:@"uploadPath"] Birthday:@"" Nickname:@""];
            
        }else
        {
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

// 裁剪图片
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
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




- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 导航栏标题（用图片）
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"个人设置" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(back)];
}

- (void)back
{
    // 发通知让我的页面重新请求数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRefiersh" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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


- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *setCer = [[NSSet alloc] initWithObjects:certData, nil];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
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
