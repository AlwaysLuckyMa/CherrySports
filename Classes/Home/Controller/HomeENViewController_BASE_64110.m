//
//  HomeENViewController.m
//  CherrySports
//
//  Created by dkb on 16/12/5.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeENViewController.h"

@interface HomeENViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, WXApiDelegate, WXApiManagerDelegate, aliPayDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property WebViewJavascriptBridge *bridge;
@end

@implementation HomeENViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    STATUS_WIHTE
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    _progressView.progress = 0.2;
}

-(void) settingWebView {
    
    //        [_webView loadHTMLString:_htmlStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    //        网址
    NSString *httpStr = @"http://192.168.1.132:8081/cherryitf/v1/enter/jumpPay?orderId=19b5202f-e096-41a6-a425-ef3ad77ba306&totalPrice=20.00&payChannel=2";
    NSURL *httpUrl = [NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest = [NSURLRequest requestWithURL:httpUrl];
    [_webView loadRequest:httpRequest];
}

#pragma mark - NJKWebViewProgressDelegate - webView进度条代理
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
    if (progress == 1.0) {
        if (_bridge) { return; }
        [self settingWebView];
        // html交互 正常可以卸载页面即将加载里面，写在这里是因为进度条工具吧webView的代理占用了
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        //html js调用接受
        [_bridge registerHandler:@"myPay" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"我收到了 ： %@", data);
            responseCallback(@"Response from ActivityCallback");
            
            // 由于是id类型所以这么转
            NSData *dataaa = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:dataaa options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"obj = %@", obj);
//            [alialiPay sharedManager] aliPayPayInfo:<#(NSString *)#> Sign:<#(NSString *)#>
//            [weChatPay sharedManager] wechatPayPartnerId:<#(NSString *)#> PrepayId:<#(NSString *)#> NonceStr:<#(NSString *)#> TumeStamp:<#(NSString *)#> Package:<#(NSString *)#> Sign:<#(NSString *)#>
        }];
    }
}

//-(void)aliPayResult:(int)result{
//    if (result == 9000) {
//        CardShouQuanSuccessVC *cardSQSVC = [CardShouQuanSuccessVC new];
//        cardSQSVC.buyModel = _cardBuyModel;
//        [self.navigationController pushViewController:cardSQSVC animated:YES];
//    } else if (result == 8000) {
//        // 不退款  "8000"代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
//    } else {
//        // 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统 返回的错误
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
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.userInteractionEnabled = YES;
        [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0);
        }];
    }
    
    return _webView;
}


- (void)setNavigationController
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_progressView];
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    // 导航栏标题（用图片）
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine-title"]];
    [self settingWebView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
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


#pragma mark -- webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 网页加载之前会调用此方法
    // return YES 表示正常加载网页 返回NO 将停止网页加载
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 开始加载网页调用此方法
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 网页加载完成调用此方法
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    // 网页加载失败调用此方法
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
