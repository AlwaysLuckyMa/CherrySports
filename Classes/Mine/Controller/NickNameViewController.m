//
//  NickNameViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/21.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "NickNameViewController.h"
#import "LoginModel.h"

@interface NickNameViewController ()<UITextFieldDelegate>
/** textfeild*/
@property (nonatomic, strong) CustomTextField *nickName;
/** 水印*/
@property (nonatomic, strong) UILabel *blackLabel;
@end

@implementation NickNameViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.nickName becomeFirstResponder];
    // 布局导航控制器
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubViews];
}

- (void)createSubViews
{
    WS(weakSelf);
    UIImageView *redLine = [AppTools CreateImageViewImageName:@"mine_changepass_redline"];
    redLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:redLine];
    [redLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(60);
    }];
    
    _nickName = [CustomTextField new];
    _nickName.placeholder = @"";
    _nickName.font = [UIFont systemFontOfSize:15];
//    _nickName.backgroundColor = [UIColor yellowColor];
    _nickName.delegate = self;
    NSDictionary *attrsDictionary =@{
                                     NSFontAttributeName: _nickName.font,
                                     NSKernAttributeName:[NSNumber numberWithFloat:0.3f]//这里修改字符间距
                                     };
    _nickName.attributedText = [[NSAttributedString alloc]initWithString:@"" attributes:attrsDictionary];
    [self.view addSubview:_nickName];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redLine.mas_left).offset(5);
        make.right.equalTo(redLine.mas_right).offset(-5);
        make.bottom.equalTo(redLine.mas_top).offset(-2);
        make.height.mas_equalTo(25);
    }];
    
    _blackLabel = [AppTools createLabelText:@"可以在上方输入您想要修改的昵称：" Color:TEXT_COLOR_LIGHT Font:13 TextAlignment:NSTextAlignmentLeft Number:0.3f];
    _blackLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.blackLabel];
    [_blackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redLine.mas_left).offset(5);
        make.right.equalTo(redLine.mas_right).offset(-5);
        make.top.equalTo(redLine.mas_bottom).offset(5);
    }];
}


-(void)updateNickname:(NSString *)nickname
{
    NSDictionary *userIdDic = @{@"dicKey":@"tId",@"data":USERID};
    NSDictionary *nicknameDic = @{@"dicKey":@"tNickname",@"data":nickname};
    NSDictionary *channelDic = @{@"dicKey":@"tLoginChannel", @"data":LOGINCHANNEL};
    
    NSArray *postArray = [[NSArray alloc] init];;
    postArray = @[userIdDic, nicknameDic, channelDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/updateAppUser",SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
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
                
                [self.navigationController popViewControllerAnimated:YES];
                NSLog(@"dic = %@", userDic);
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







- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"昵称修改" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    // 设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"save_nickName" highImage:@"save_nickName" target:self action:@selector(saveClick)];
}

- (void)saveClick
{
    NSLog(@"保存昵称");
    [self updateNickname:_nickName.text];
    [self.delegate isPop];
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
