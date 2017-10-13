//
//  MineScoreViewController.m
//  CherrySports
//
//  Created by dkb on 17/1/3.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "MineScoreViewController.h"
#import "FailedlWebView.h"
#import "NewUrlViewController.h"

@interface MineScoreViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong)FailedlWebView *backView;
@property (nonatomic, assign) BOOL isBackView;

@end

@implementation MineScoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _webView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.userInteractionEnabled = YES;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    
    // webView 加载进度条
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0;
    
    [self settingWebView];
}

-(void) settingWebView {
    
    //            网址
    //    NSString *httpStr = @"http://192.168.1.132:8081/cherryitf/v1/enter/jumpPay?orderId=19b5202f-e096-41a6-a425-ef3ad77ba306&totalPrice=20.00&payChannel=0";
    
    int value = arc4random() % 1000;
    NSString *string;
    NSString *url = [NSString stringWithFormat:@"%@/games/gamesResultQuery", SERVER_URL];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locationJD"] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"locationWD"] != nil) {
        string = [NSString stringWithFormat:@"%@?tAppUserId=%@&appcode=iOS&longitude=%@&latitude=%@&sJis=%zd", url, USERID, LOCATIONJD, LOCATIONWD, value];
    }else{
        string = [NSString stringWithFormat:@"%@?tAppUserId=%@&appcode=iOS&sJis=%zd", url, USERID, value];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    [_webView loadRequest:request];
}

#pragma mark - NJKWebViewProgressDelegate - webView进度条代理
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
    if (progress == 1.0) {
        if (_bridge) { return; }
    }
    
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

// 获取当前所有URL 是否超链接的url在这判断
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSURL *url = request.URL;
//    NSString *str = [NSString stringWithFormat:@"%@",url];
//    if (!([str rangeOfString:@"cherryitf.shenzhoucheng.com"].location != NSNotFound)) {
//        //        NSString *textURL = @"https://www.baidu.com/";
//        //        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", textURL]];
//        [[UIApplication sharedApplication] openURL:url];
//        return NO;
//    }
//    return YES;
//}

- (void)setNavigationController
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_progressView];
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    // 导航栏标题（用图片）
    UILabel *titleLabel = [AppTools createLabelText:@"成绩查询" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    //    [self settingWebView];
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
