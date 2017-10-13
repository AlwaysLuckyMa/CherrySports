//
//  MineFeedBackViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/10.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineFeedBackViewController.h"
#import "UIPlaceHolderTextView.h"
@interface MineFeedBackViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UIPlaceHolderTextView *FeedBackView;
/** <#注释#>*/
@property (nonatomic, strong) UILabel *desLabel;
@property(nonatomic,strong)UIButton *submitButton;

@end

@implementation MineFeedBackViewController

-(void)dealloc
{
    _FeedBackView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 取消工具条
//    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationController];
    [self createView];
}

- (void)createView
{
    UIView *backView = [AppTools createViewBackground:[UIColor whiteColor]];
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = [UIColor colorWithRed:209/255 green:209/255 blue:209/255 alpha:0.1].CGColor;
    backView.layer.borderWidth = 1.0;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(13);
        make.height.mas_equalTo(150);
    }];
    
    self.FeedBackView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(20, 13, SCREEN_WIDTH-40, 150)];
    self.FeedBackView.delegate = self;
    self.FeedBackView.font = [UIFont systemFontOfSize:13];
    self.FeedBackView.placeholder = @"请写下您的宝贵建议... ...";
    [backView addSubview:self.FeedBackView];
    [_FeedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-13);
        make.bottom.mas_equalTo(-10);
    }];
    
    // 下面字
    _desLabel =[AppTools createLabelText:@"请在您的反馈内容里留下您的手机、QQ或者邮箱，以便我们与您取得联系" Color:UIColorWithRGBA(69, 69, 69, 1) Font:12 TextAlignment:NSTextAlignmentLeft];
    _desLabel.font = [UIFont systemFontOfSize:12];
    _desLabel.text = @"请在您的反馈内容里留下您的手机、QQ或者邮箱，以便我们与您取得联系";
    _desLabel.numberOfLines = 0;
    [self.view addSubview:self.desLabel];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.equalTo(_FeedBackView.mas_bottom).offset(13);
        make.right.mas_equalTo(-35);
    }];
    
    // 提交反馈
    _submitButton = [AppTools createButtonTitle:@"提交反馈" TitleColor:[UIColor whiteColor] Font:14 Background:UIColorFromRGB(0x343434)];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    self.submitButton.userInteractionEnabled = NO;
    [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.height.mas_equalTo(40);
        make.top.equalTo(_desLabel.mas_bottom).offset(11);
    }];
}
//提交按钮
-(void)submitClick
{
    if (USERID) {
        [self getDataContent:_FeedBackView.text userId:USERID];
    }else{
        [self getDataContent:_FeedBackView.text userId:@""];
    }
    
    NSLog(@"%@", _FeedBackView.text);
}
#pragma mark textViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"字数改变了");
    if (textView.text.length != 0) {
        // 改变颜色
        self.submitButton.backgroundColor = UIColorFromRGB(0xbd071d);
        self.submitButton.userInteractionEnabled = YES;
    }else{
        self.submitButton.backgroundColor = UIColorFromRGB(0x343434);
        self.submitButton.userInteractionEnabled = NO;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"意见反馈" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
}


#pragma mark - 反馈数据
- (void)getDataContent:(NSString *)content userId:(NSString *)userId
{
    NSDictionary *userIdDic = @{@"dicKey":@"tAppUserId", @"data":userId};
    NSDictionary *contentDic = @{@"dicKey":@"tContent", @"data":content};
    
    NSArray *postArray = @[userIdDic, contentDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/my/insertFeedback", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"提交数据成功obj = %@", obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                _FeedBackView.text = @"";
                self.submitButton.backgroundColor = UIColorFromRGB(0x343434);
                self.submitButton.userInteractionEnabled = NO;
                [self showHint:[obj objectForKey:@"resultMessage"]];
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
