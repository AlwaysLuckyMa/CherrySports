//
//  MyEventWebViewController.m
//  CherrySports
//
//  Created by dkb on 17/1/7.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "MyEventWebViewController.h"
#import "LoginVC.h"
#import "ApplyPayWebViewController.h"
#import "FailedlWebView.h"
#import "MyNewUrlViewController.h"
#import "AppDelegate.h"

#import "PhotoAlbumList.h"
#import "PhotoAlbumDetailViewController.h"
#import "shareArr.h"
@interface MyEventWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, WXApiDelegate, WXApiManagerDelegate, aliPayDelegate,UITextViewDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic , strong) UILabel * lb; //提示框占位符
@property (nonatomic , strong) UIView * tView; //提示框
@property (nonatomic , strong) UIView * wtView; //提示框
@property (nonatomic, copy) NSString *contentStr; //退赛原因
@property (nonatomic , strong) UIWindow *window;
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, copy) NSString *collectYes;
/** 收藏按钮*/
@property (nonatomic, strong) UIButton *collectBtn;

/** 立即报名按钮*/
@property (nonatomic, strong) UIButton *applyBtn;
/** 如果是1可以报名*/
@property (nonatomic, copy) NSString *tGameState;

@property (nonatomic, strong)FailedlWebView *backView;

@property (nonatomic, assign) BOOL isBackView;

/** 记录颜色编码*/
@property (nonatomic, copy) NSString *colorId;

@property (nonatomic, copy) NSString *biSai_Str;
@end

@implementation MyEventWebViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    STATUS_WIHTE
    [self setNavigationController];
    if (USERID) {
        [self CollectYesorNoUserId:USERID];
    }else{
        [self CollectYesorNoUserId:@""];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [alialiPay sharedManager].delegate = self;
    [weChatPay sharedManager].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    // webView 加载进度条
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0.1;
    
    //    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
    
    [self settingWebView];
    
//    [self createViewA];
//    _window.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    // 检测键盘将要弹出的状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma - mark  进入全屏
-(void)begainFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}
#pragma - mark 退出全屏
-(void)endFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
    
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

-(void) settingWebView {
    
    //    int num = [self getRandomNumber:1 to:100+1];
    //    NSString *urlStr = [NSString stringWithFormat:@"%@=%d", _htmlUrl, num];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.132:8081/cherryitf/v1/pay/getWeChatCode"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[AppTools httpsWithMyEventStrUser:_htmlUrl]]];
    
    [_webView loadRequest:request];
    //    _webView.delegate = self;
    
    // 是赛事才显示报名按钮
//    if ([_tType isEqualToString:@"0"]) {
//        [self applyBtn];
//    }
}

#pragma mark - NJKWebViewProgressDelegate - webView进度条代理
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
    if (progress == 1.0) {
        if (_bridge) { return; }
        //        [self settingWebView];
        // html交互 正常可以卸载页面即将加载里面，写在这里是因为进度条工具吧webView的代理占用了
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        //html js调用接受
        
        [_bridge registerHandler:@"showPhoto" handler:^(id data, WVJBResponseCallback responseCallback) {
            responseCallback(@"Response from ActivityCallback");
            NSlog(@"相册按钮 ： %@", data);
            // 由于是id类型所以这么转
            NSData *photoData = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:photoData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"obj = %@", obj);
            
        }];
        
        [_bridge registerHandler:@"myWebTouch" handler:^(id data, WVJBResponseCallback responseCallback) {
            //            NSLog(@"我收到了 ： %@", data);
            responseCallback(@"Response from ActivityCallback");
            
            // 由于是id类型所以这么转  2017071211.23
            NSData *dataaa = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:dataaa options:NSJSONReadingMutableContainers error:nil];
            NSlog(@"obj = %@", obj);
            if ([[obj objectForKey:@"type"] isEqualToString:@"1"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if ([[obj objectForKey:@"type"] isEqualToString:@"2"]){
                
                [_webView reload];
                
            }else if ([[obj objectForKey:@"type"] isEqualToString:@"3"]){
                
                MyNewUrlViewController *newWebVC = [MyNewUrlViewController new];
                newWebVC.titleName = [obj objectForKey:@"title"];
                newWebVC.urlNew = [obj objectForKey:@"url"];
                [self.navigationController pushViewController:newWebVC animated:YES];
            }
        }];
    }
}

// 获取当前所有URL 是否超链接的url在这判断
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//
//    NSURL *url = request.URL;
//    NSString *str = [NSString stringWithFormat:@"%@",url];
//    if (!([str rangeOfString:@"cherryitf.shenzhoucheng.com"].location != NSNotFound)) {
//        NSString *textURL = @"https://www.baidu.com/";
//        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", textURL]];
//        [[UIApplication sharedApplication] openURL:url];
//        return NO;
//    }
//    
//    return YES;
//}


#pragma mark 懒加载
-(UIWebView *) webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [_webView setOpaque:NO];//opaque是不透明的意思
        [_webView setScalesPageToFit:YES];//自动缩放以适应屏幕
        _webView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.userInteractionEnabled = YES;
        [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            if ([_tType isEqualToString:@"0"]) {
                make.bottom.mas_equalTo(-40);
            }else{
                make.bottom.mas_equalTo(0);
            }
        }];
    }
    
    return _webView;
}

- (UIButton *)applyBtn
{
    if (!_applyBtn) {
        _applyBtn = [[UIButton alloc] init];
        [_applyBtn setBackgroundColor:TEXT_COLOR_RED];
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_applyBtn addTarget:self action:@selector(applyCender:) forControlEvents:UIControlEventTouchUpInside];
        _applyBtn.hidden = YES;
        [self.view addSubview:_applyBtn];
        [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }
    return _applyBtn;
}

#pragma mark - 立即报名点击按钮
- (void)applyCender:(UIButton *)cender
{
    if (USERID) {
        if ([self.tTitleName isEqualToString:@"我的赛事"])
        {
            [self createViewA];
        }
        else
        {
            NSLog(@"已登录 跳转立即报名web页面"); //http
            ApplyPayWebViewController *payVC = [ApplyPayWebViewController new];
            payVC.tEnterUrl = _tEnterUrl;
            [self.navigationController pushViewController:payVC animated:YES];
        }
    
    }else{
        NSLog(@"跳登录页");
        LoginVC *loginVC = [LoginVC new];
        loginVC.isWeb = @"1";
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

////////////////////////////////////////////////////////////////////////////////
- (void)createViewA
{
    CGFloat W_W = SCREEN_WIDTH - 80;
    
//    _window = [[UIApplication sharedApplication].windows lastObject];
    
    _wtView = [[UIView alloc]initWithFrame:CGRectMake(
                                                     0,
                                                     0,
                                                     SCREEN_WIDTH,
                                                     SCREEN_HEIGHT)];
    _wtView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
//    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouchesRequired = 1;
//    [_window addGestureRecognizer:tap];

    _tView = [[UIView alloc]initWithFrame:CGRectMake(
                                                     (SCREEN_WIDTH - (W_W))/2,
                                                     120,
                                                     W_W,
                                                     W_W)];
    _tView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:_tView];
    [_wtView addSubview:_tView];
    [self.view addSubview:_wtView];
    //    [_window addSubview:_wtView];
    UILabel * tlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, W_W, 30)];
    tlabel.text = @"退赛原因";
    tlabel.textAlignment = NSTextAlignmentCenter;
    tlabel.textColor = [UIColor blackColor];
    [_tView addSubview:tlabel];
    
    UITextView * ttview = [[UITextView alloc]initWithFrame:CGRectMake(
                                                                      ((W_W) - (SCREEN_WIDTH - 120))/2,
                                                                      40,
                                                                      SCREEN_WIDTH - 120,
                                                                      (SCREEN_WIDTH - 120) - 30 - 35)];
    
    ttview.pagingEnabled = YES;
    ttview.clipsToBounds = YES;
    ttview.delegate = self;//将代理设置给本类
    [_tView addSubview:ttview];
    
    self.lb = [[UILabel alloc] initWithFrame:CGRectMake(((W_W) - (SCREEN_WIDTH - 120))/2, 40, SCREEN_WIDTH - 120, 50)];
    self.lb.text = @"请填写您的退赛原因";
    self.lb.enabled = NO;
    self.lb.font = [UIFont systemFontOfSize:14];
    self.lb.backgroundColor = [UIColor whiteColor];
    [_tView addSubview:self.lb];
    
    
    UIButton * tLbtn = [[UIButton alloc]initWithFrame:CGRectMake(
                                                                 ((W_W)/4) / 2,
                                                                 W_W - 35,
                                                                 (W_W)/4,
                                                                 25)];
    [tLbtn setTitle:@"取消" forState:UIControlStateNormal];
    [tLbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tLbtn setBackgroundColor:[UIColor redColor]];
    [tLbtn addTarget:self action:@selector(tLClick) forControlEvents:UIControlEventTouchUpInside];
    [_tView addSubview:tLbtn];
    
    UIButton * tFbtn = [[UIButton alloc]initWithFrame:CGRectMake(
                                                                 ((W_W)/4)* 2+(((W_W)/4)/2),
                                                                 W_W - 35,
                                                                 (W_W)/4,
                                                                 25)];
    [tFbtn setTitle:@"确定" forState:UIControlStateNormal];
    [tFbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tFbtn setBackgroundColor:[UIColor redColor]];
    [tFbtn addTarget:self action:@selector(tFClick) forControlEvents:UIControlEventTouchUpInside];
    [_tView addSubview:tFbtn];
    
    
}
- (void)hideKeyBoard:(NSNotification *)sender
{
    NSLog(@"键盘退出");
    // 还原
    _tView.transform = CGAffineTransformIdentity;
    
}

- (void)showKeyBoard:(NSNotification *)sender
{
    //NSLog(@"%@",sender.userInfo);
    // 获取键盘高度
    CGRect rect = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardH = rect.size.height;
    
    _tView.transform = CGAffineTransformMakeTranslation(0, - keyBoardH+SCREEN_WIDTH - 80);
    
}
//#pragma mark - 点击手势
//- (void)onTap:(UITapGestureRecognizer*)tap
//{
//    NSLog(@"单击");
//    [self.view endEditing:YES];
//    _window.hidden = YES;
//    
//}

//取消
- (void)tLClick
{
    [self.view  endEditing:YES];
    [_wtView removeFromSuperview];
//    _window.hidden = YES;
}
//确定
- (void)tFClick
{
    NSString * ConStr = [shareArr getURLArrShare].contStr;
    
    if (ConStr == nil || ConStr == NULL) {
        [self showHint:@"退赛原因不能为空"];
        return ;
    }
    if ([ConStr isKindOfClass:[NSNull class]]) {
        [self showHint:@"退赛原因不能为空"];
        return;
    }
    if ([[ConStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self showHint:@"退赛原因不能为空"];
        return;
    }
    NSString *newStr = [ConStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //处理字符串中的空格
    
    NSDictionary * userIdDic   = @{@"dicKey":@"tAppUserId",
                                   @"data":USERID}; //用户ID
    
    NSDictionary * tIdDic      = @{@"dicKey":@"tGamesId",
                                   @"data":self.tId};
    
    NSDictionary * EnterUserId = @{@"dicKey":@"tEnterUserId",
                                   @"data":self.tEnterUserId};
    
    NSDictionary * OrderId      = @{@"dicKey":@"tOrderId",
                                    @"data":self.tOrderId};
    
    NSDictionary * tRefund      = @{@"dicKey":@"tRefundDescribe",
                                    @"data":newStr};
    
    NSLog(@"_+_+_+_+_+_+----%@",[shareArr getURLArrShare].contStr);
    
    NSArray *postArr = @[userIdDic, tIdDic,EnterUserId,OrderId,tRefund];
    
    NSString *url = [NSString stringWithFormat:@"%@/games/insertRefundGames", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {//201707136.33 星期五
            
            _biSai_Str = obj[@"resultMessage"];
            [self showHint:_biSai_Str];
            [_wtView removeFromSuperview];
            [self.applyBtn setTitle:@"申请已提交" forState:UIControlStateNormal];
            _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
            _applyBtn.userInteractionEnabled = NO; //要改
            _colorId = @"4";
            [shareArr getURLArrShare].contStr = nil;
        }
    }];

}

//UITextView中的内容的获取方式：
-(void)textViewDidChange:(UITextView *)textView{
  
    if ([self isEmpty:textView.text]) {
        [self showHint:@"不能输入空格"];
        textView.text = nil;
        return;
    };
    if (textView.text == nil || textView.text == NULL) {
        return ;
    }
    if ([textView.text isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return;
    }
    
    if ([textView.text isEqualToString:@"\n"])
    {
        return ;
    } else if(textView.text.length >= 100)//如果输入超过规定的字数20，就不再让输入
    {
        [self showHint:@"字数不能再多了"];
        return ;
    }
    [shareArr getURLArrShare].contStr = textView.text;
    NSLog(@"======%@========",[shareArr getURLArrShare].contStr);
}
- (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        
        return true;
        
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            
            return true;
            
        } else {
            
            return false;
            
        }
        
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.lb.alpha = 0;//开始编辑时
    return YES;
}

////////////////////////////////////////////////////////////////////////////////

- (void)setNavigationController
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_progressView];
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    // 导航栏标题（用图片）
    if ([_tType isEqualToString:@"0"]) {
        // 标题
        UILabel *titleLabel = [AppTools createLabelText:@"赛事详情" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.frame = CGRectMake(0, 0, 100, 30);
        titleLabel.userInteractionEnabled = YES;
        self.navigationItem.titleView = titleLabel;
    }else{
        UILabel *titleLabel = [AppTools createLabelText:@"资讯详情" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.frame = CGRectMake(0, 0, 100, 30);
        titleLabel.userInteractionEnabled = YES;
        self.navigationItem.titleView = titleLabel;
    }

    // 收藏
    _collectBtn = [[UIButton alloc] init];
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_collection_web"] forState:UIControlStateNormal];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_collection_web"] forState:UIControlStateHighlighted];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_collection_Click"] forState:UIControlStateSelected];
    _collectBtn.size = _collectBtn.currentBackgroundImage.size;
    [_collectBtn addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scBtn = [[UIBarButtonItem alloc] initWithCustomView:_collectBtn];
    
    // 分享
    UIBarButtonItem *fxBtn = [UIBarButtonItem itemDoubleWithImage:@"navigation_rightBtn_fenxiang" highImage:@"navigation_rightBtn_fenxiang" target:self action:@selector(fenxiangBtn)];
    self.navigationItem.rightBarButtonItems = @[fxBtn, scBtn];
}

// 收藏按钮逻辑
- (void)collection:(UIButton *)btnCender
{
    if (USERID) {
        if (_tId.length > 0) {
            if (btnCender.selected == NO) {
                // 请求收藏数据
                [self getDataCollectionId:_tId type:_tType];
                NSLog(@"添加收藏");
            }else{
                [self cancelCollectionTid:_tId];
                NSLog(@"删除收藏");
            }
            btnCender.selected = !btnCender.selected;
        }
    }else{
        [self showHint:@"请先登录"];
    }
}

- (void)fenxiangBtn
{
    // 定义分享面板的内容
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    // 调用分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSlog(@"标题=%@，内容=%@，图片=%@，url=%@", _fxTitle, _content, _fxImg, _htmlUrl);
        if (platformType == 0) {
            [self sharePlatform:0 Title:_fxTitle Content:_content Image:[AppTools httpsWithStr:_fxImg] Url:_htmlUrl];
        }else if (platformType == 1){
            [self sharePlatform:1 Title:_fxTitle Content:_content Image:[AppTools httpsWithStr:_fxImg] Url:_htmlUrl];
        }else if (platformType == 2){
            [self sharePlatform:2 Title:_fxTitle Content:_content Image:[AppTools httpsWithStr:_fxImg] Url:_htmlUrl];
        }else if (platformType == 4){
            [self sharePlatform:4 Title:_fxTitle Content:_content Image:[AppTools httpsWithStr:_fxImg] Url:_htmlUrl];
        }
        
    }];
}


- (void)sharePlatform:(UMSocialPlatformType)platform Title:(NSString *)title Content:(NSString *)content Image:(NSString *)image Url:(NSString *)url
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // web分享类 标题 内容 图片 url
    UMShareWebpageObject *webObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:image];
    webObject.webpageUrl = url;
    messageObject.shareObject = webObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (!error) {
            [self showHint:@"分享成功"];
        } else {
            NSLog(@"error = %@", error);;
//            message = [NSString stringWithFormat:@"分享失败Code: %d\n",(int)error.code];
            [self showHint:message];
        }
    }];
}

- (UIImage *) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark - 查询此项目是否已收藏
-(void)CollectYesorNoUserId:(NSString *)userId{
    
    NSDictionary *tTypeDic =  @{@"dicKey":@"tType", @"data":_tType};
    NSDictionary *tIdDic =    @{@"dicKey":@"tCollectionId", @"data":_tId};
    NSDictionary *userIdDic = @{@"dicKey":@"tAppUserId", @"data":userId};
    
    NSArray *postArr = @[tTypeDic, tIdDic, userIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/collection/checkCollection", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            //            NSlog(@"查询此项目收藏状态 obj = %@", obj);
            NSLog(@"查询此项目收藏状态 obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                NSString *str = [obj objectForKey:@"isCollection"];
                if (str.length > 0)
                {
                    if ([str isEqualToString:@"0"]) {
                        _collectYes = @"0";
                        _collectBtn.selected = YES;
                        NSLog(@"已收藏");
                    }else{
                        _collectYes = @"1";
                        NSLog(@"未收藏");
                        _collectBtn.selected = NO;
                    }
                    
                    NSString *isEnter = [obj objectForKey:@"isEnter"];
                    if (isEnter.length > 0) {
                        if ([isEnter isEqualToString:@"0"]) {
                            [self.applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
                            _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
                            _applyBtn.userInteractionEnabled = NO;
                            _colorId = @"5";
                        }
                    }
                    

                    if (![isEnter isEqualToString:@"0"]) { //201707105.59
                        _tGameState = [obj objectForKey:@"tGameState"];
                        if (_tGameState.length > 0)
                        {
                            if ([_tGameState isEqualToString:@"0"])
                            {
                                [self.applyBtn setTitle:@"报名未开始" forState:UIControlStateNormal];
                                _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
                                _applyBtn.userInteractionEnabled = NO;
                                _colorId = @"0";
                            }else if ([_tGameState isEqualToString:@"1"]){  //申请退赛 退赛
                                if ([self.tTitleName isEqualToString: @"我的赛事"])
                                {
                                    [self.applyBtn setTitle:@"申请退赛" forState:UIControlStateNormal];
                                    _applyBtn.backgroundColor = TEXT_COLOR_RED;
                                    _applyBtn.userInteractionEnabled = YES;
                                    _colorId = @"1";
                                    
                                    if ([[obj objectForKey:@"isAuditRefund"] isEqualToString:@"0"])
                                    {
                                        //6.33
                                        [self.applyBtn setTitle:@"申请已提交" forState:UIControlStateNormal];
                                        _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
                                        _applyBtn.userInteractionEnabled = NO ;//NO; 要改
                                        _colorId = @"4";
                                    };
                                    
                                }else{
                                    [self.applyBtn setTitle:@"立即报名" forState:UIControlStateNormal];
                                    _applyBtn.backgroundColor = TEXT_COLOR_RED;
                                    _applyBtn.userInteractionEnabled = YES;
                                    _colorId = @"1";
                                }
                            }else if ([_tGameState isEqualToString:@"2"]){
                                [self.applyBtn setTitle:@"报名已结束" forState:UIControlStateNormal];
                                _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
                                _applyBtn.userInteractionEnabled = NO;
                                _colorId = @"2";
                            }else if ([_tGameState isEqualToString:@"3"]){
                                [self.applyBtn setTitle:@"赛事进行中" forState:UIControlStateNormal];
                                _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
                                _applyBtn.userInteractionEnabled = NO;
                                _colorId = @"3";
                            }else{
                                [self.applyBtn setTitle:@"赛事结束" forState:UIControlStateNormal];
                                _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
                                _applyBtn.userInteractionEnabled = NO;
                                _colorId = @"4";
                            }
                        }
                    }
                    _applyBtn.hidden = NO;
                }
            }
            else
            {
                //                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"error");
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}

#pragma mark - 添加收藏
- (void)getDataCollectionId:(NSString *)collectId type:(NSString *)type
{
    NSDictionary *userIdDic = @{@"dicKey":@"tAppUserId", @"data":USERID};
    NSDictionary *typeDic = @{@"dicKey":@"tType", @"data":_tType};
    NSDictionary *collectIdDic = @{@"dicKey":@"tCollectionId", @"data":collectId};
    
    NSArray *postArray = @[userIdDic, typeDic, collectIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/collection/insertUserCollection", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"添加%@收藏成功 obj = %@", _tType, obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                [self showHint:[obj objectForKey:@"resultMessage"]];
                _collectBtn.selected = YES;
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"%@",error);
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}

#pragma mark --请求删除收藏接口
-(void)cancelCollectionTid:(NSString *)tId{
    
    NSDictionary *tIdDic = @{@"dicKey":@"tCollectionId", @"data":tId};
    NSDictionary *userIdDic =@{@"dicKey":@"tAppUserId", @"data":USERID};
    
    NSArray *postArr = @[userIdDic,tIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/collection/deleteUserCollection", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"删除收藏 obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]) {
                [self showHint:@"取消收藏成功"];
                _collectBtn.selected = NO;
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"error");
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}

// 失败时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error != nil && _isBackView == NO) {
        if (!_backView) {
            _applyBtn.backgroundColor = [UIColor whiteColor];
            _backView = [FailedlWebView new];
            _backView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_backView];
            [_webView bringSubviewToFront:_backView];
            [_backView.excptionRefreshButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            _progressView.progress = 0;
            [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.mas_equalTo(0);
                make.top.mas_equalTo(-20);
            }];
        }
    }
}
// 开始加载调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_backView) {
        [_backView removeFromSuperview];
        _backView = nil;
        _isBackView = NO;
    }
}
// 完成加载调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _isBackView = YES;
    [_backView removeFromSuperview];
    _backView = nil;
    if ([_colorId isEqualToString:@"1"]) {
        self.applyBtn.backgroundColor = TEXT_COLOR_RED;
    }else{
        self.applyBtn.backgroundColor = UIColorFromRGB(0x343434);
    }
}
// 重新加载
- (void)btnAction
{
    [self settingWebView];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];

//    _window.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// 测试相册
//if (USERID) {
//    NSString *userId = USERID;
//    [self PhotoUserId:userId];
//}

//MARK: 相册网络请求
-(void)PhotoUserId:(NSString *)userId{
    
    NSDictionary *tIdDic = @{@"dicKey":@"tGamesId", @"data":@"123"};
    NSDictionary *userIdDic =@{@"dicKey":@"tAppUserId", @"data":@"123"};
    
    NSArray *postArr = @[tIdDic, userIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/selectUserGamesPhoto", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"查询相册图片 obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"userGamesPhotoPoList"] != nil) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [obj objectForKey:@"userGamesPhotoPoList"]) {
                    PhotoAlbumList *model = [PhotoAlbumList mj_objectWithKeyValues:dic];
                    [array addObject:model];
                }
                PhotoAlbumDetailViewController *photoAlbumDetailVC = [PhotoAlbumDetailViewController new];
                photoAlbumDetailVC.dataArray = [NSMutableArray arrayWithArray:array];
                photoAlbumDetailVC.index = 1;
                // 设置不同的模态效果
                [photoAlbumDetailVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [self presentViewController:photoAlbumDetailVC animated:YES completion:^{
                    
                    
                }];
                NSLog(@"照片详情");
                
            }else{
                
            }
        }else{
            NSLog(@"error");
            [self showHint:@"亲，网络开小差了"];
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
