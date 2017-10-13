//
//  CommunityViewController.m
//  CherrySports
//
//  Created by dkb on 16/10/26.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "CommunityViewController.h"
#import "DKBSearchViewController.h"
#import "FailedlWebView.h"
#import "MyNewUrlViewController.h"
#import "AppDelegate.h"

@interface CommunityViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, copy) NSString *collectYes;
@property (nonatomic, strong)FailedlWebView *backView;

@property (nonatomic, assign) BOOL isBackView;

/** 记录颜色编码*/
@property (nonatomic, copy) NSString *colorId;

@end

@implementation CommunityViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    // webView 加载进度条
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    // 自己写的进度条
    UIProgressView *pro1=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
    //但slider滑动控件：设置的高度对slider也没影响，但整个高度=设置的高度，可以设置背景来检验
    pro1.frame=CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    //设置进度条颜色
    pro1.trackTintColor = [UIColor whiteColor];
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    pro1.progress = 0;
    //设置进度条上进度的颜色
    pro1.progressTintColor = [UIColor blueColor];
    //设置进度值并动画显示
    [self.view addSubview:pro1];
    [pro1 setProgress:0.4 animated:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [UIView animateWithDuration:3.0f animations:^{
            [pro1 setProgress:1.0 animated:YES];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            pro1.hidden = YES;
        });
    });
    
    [self settingWebView];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

-(void) settingWebView {
    
    int value = [self getRandomNumber:2 to:100];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://sports.cctv.com/H5/CCTV5plus/index.shtml?from=singlemessage&isappinstalled=0&s=mkyt%d", value]]];
    [_webView loadRequest:request];
}

#pragma mark - NJKWebViewProgressDelegate - webView进度条代理
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
    if (progress == 1.0) {
        if (_bridge) { return; }
    }
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    //html js调用接受
    [_bridge registerHandler:@"myWebTouch" handler:^(id data, WVJBResponseCallback responseCallback) {
        //            NSLog(@"我收到了 ： %@", data);
        responseCallback(@"Response from ActivityCallback");
        
        // 由于是id类型所以这么转
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
            make.bottom.mas_equalTo(0);

        }];
    }
    
    return _webView;
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

// 失败时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error != nil && _isBackView == NO) {
        if (!_backView) {
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
    [_webView reload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    
}


- (void)setNavigationController
{
    // 导航栏颜色
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"樱桃体育" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    // 设置导航栏左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_navigation_left" highImage:@"news_navigation_left" target:self action:@selector(SearchClick)];
    // 设置导航栏右侧按钮
    //    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"news_navgation_right" highImage:@"news_navgation_right" target:self action:@selector(SettingClick)];
}

#pragma mark - 搜索按钮
- (void)SearchClick
{
    DKBSearchViewController *searchVC =[[DKBSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    NSLog(@"资讯搜索");
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
