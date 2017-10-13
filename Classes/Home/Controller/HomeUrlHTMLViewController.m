//
//  HomeUrlHTMLViewController.m
//  CherrySports
//
//  Created by dkb on 16/12/5.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeUrlHTMLViewController.h"
#import "FailedlWebView.h"
#import "NewUrlViewController.h"
#import "AppDelegate.h"

@interface HomeUrlHTMLViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, WXApiDelegate, WXApiManagerDelegate, aliPayDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong)FailedlWebView *backView;
@property (nonatomic, assign) BOOL isBackView;

@end

@implementation HomeUrlHTMLViewController

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
//    [self settingWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [alialiPay sharedManager].delegate = self;
    //    [weChatPay sharedManager].delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
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
    _progressView.progress = 0;
    
    //    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
    
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
}

-(void) settingWebView {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[AppTools httpsWithStrUser:_htmlUrl]]];
    [_webView loadRequest:request];
    //    _webView.delegate = self;
}

#pragma mark - NJKWebViewProgressDelegate - webView进度条代理
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
    if (progress == 1.0) {
        if (_bridge) { return; }
        
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
                NewUrlViewController *newWebVC = [NewUrlViewController new];
                newWebVC.titleName = [obj objectForKey:@"title"];
                newWebVC.urlNew = [obj objectForKey:@"url"];
                [self.navigationController pushViewController:newWebVC animated:YES];
            }
        }];
    }
}

//-(void)aliPayResult:(int)result{
//    if (result == 9000) {
//        NSLog(@"支付成功");
//    } else if (result == 8000) {
//        // 不退款  "8000"代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
//        NSLog(@"111");
//    } else {
//        // 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统 返回的错误
//        NSLog(@"支付失败");
//    }
//}

//
//-(void)wxPayResult:(int)result{
//    if (result == 0) {
//        CardShouQuanSuccessVC *cardSQSVC = [CardShouQuanSuccessVC new];
//        cardSQSVC.buyModel = _cardBuyModel;
//        [self.navigationController pushViewController:cardSQSVC animated:YES];
//    } else if (result == -2 || result == -1) {
//        // -1 错误  -2 取消
//    }
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

//// 获取当前所有URL 是否超链接的url在这判断
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSURL *url = request.URL;
//    NSString *str = [NSString stringWithFormat:@"%@",url];
//    if (!([str rangeOfString:@"cherryitf.shenzhoucheng.com"].location != NSNotFound)) {
////        NSString *textURL = @"https://www.baidu.com/";
////        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", textURL]];
//        [[UIApplication sharedApplication] openURL:url];
//        return NO;
//    }
//    return YES;
//}


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

- (void)btnAction
{
    [self settingWebView];
}


- (void)setNavigationController
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_progressView];
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    // 导航栏标题（用图片）
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"樱桃体育" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
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
