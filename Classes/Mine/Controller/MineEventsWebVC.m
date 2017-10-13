//
//  MineEventsWebVC.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/2/28.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "MineEventsWebVC.h"
#import "LoginVC.h"
#import "ApplyPayWebViewController.h"
#import "FailedlWebView.h"
#import "MyNewUrlViewController.h"
#import "AppDelegate.h"

#import "PhotoAlbumList.h"
#import "PhotoAlbumDetailViewController.h"

#import "WonderfulCollectionViewController.h"

//#import <JavaScriptCore/JavaScriptCore.h>

@interface MineEventsWebVC ()<UIWebViewDelegate, NJKWebViewProgressDelegate, WXApiDelegate, WXApiManagerDelegate, aliPayDelegate>
{
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

@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong) NSString * isShowShare;
@end

@implementation MineEventsWebVC

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
    
}
- (void)getDataPage{//我的赛事 分享不显示
    
    NSDictionary * appIdDic  = @{@"dicKey":@"tAppUserId",    @"data":USERID};
    NSDictionary * selectDic = @{@"dicKey":@"isSelectEnter", @"data":@"0"};
    NSDictionary * pageDic   = @{@"dicKey":@"page",          @"data":@"1"};
    
    NSArray *postArr = @[pageDic, appIdDic, selectDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/games/selectGamesByUser", SERVER_URL];
    __weak typeof(self)weak_self = self;
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        NSLog(@"News成功 obj = %@", obj);
        
        if ([[obj objectForKey:@"isShowShare"] isEqualToString:@"1"]) { //1隐藏
            
            weak_self.navigationItem.rightBarButtonItem = nil;
            
            NSLog(@"_isShowShare = %@", _isShowShare);
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDataPage];
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
    [_bridge callHandler:@"showPhoto" data:@{}];
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
    
    int value = [self getRandomNumber:2 to:100];  //赛事集锦
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@&tAppUserId=%@&appcode=iOS&jumpPosition=2&sJ=%d", _htmlUrl, USERID,value]]];

    [_webView loadRequest:request];
}

#pragma mark - NJKWebViewProgressDelegate - webView进度条代理
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    __weak typeof(self)weak_self = self;
    if (progress == 1.0) {
        if (_bridge) { return; }else{
            [UIView animateWithDuration:0.2 animations:^{
                _progressView.progress += 0.1;
            }];
        }
        //        [self settingWebView];
        // html交互 正常可以写在页面即将加载里面，写在这里是因为进度条工具吧webView的代理占用了
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
       
        //html js调用接受
        [_bridge registerHandler:@"showPhotoPersonal" handler:^(id data, WVJBResponseCallback responseCallback) {
            responseCallback(@"Response from ActivityCallback");

            NSLog(@"js调用接受--------%@",data);
            [_webView reload];
            WonderfulCollectionViewController * WonderfulCollection = [[WonderfulCollectionViewController alloc]init];
            WonderfulCollection.tGameId = data;
            [weak_self.navigationController pushViewController:WonderfulCollection animated:YES];

            
        }];
        
        [_bridge registerHandler:@"showPhotoOther" handler:^(id data, WVJBResponseCallback responseCallback) {
            responseCallback(@"Response from ActivityCallback");  //201707139.24
            [_webView reload];
            NSLog(@"js-2调用接受--------%@",data);
            [_webView reload];
            WonderfulCollectionViewController * WonderfulCollection = [[WonderfulCollectionViewController alloc]init];
            WonderfulCollection.tGameId = data;
            [weak_self.navigationController pushViewController:WonderfulCollection animated:YES];
            
            
        }];

        
        [_bridge registerHandler:@"myWebTouch" handler:^(id data, WVJBResponseCallback responseCallback) {
            //            NSLog(@"我收到了 ： %@", data);
            responseCallback(@"Response from ActivityCallback");
            
            // 由于是id类型所以这么转
            NSData *dataaa = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:dataaa options:NSJSONReadingMutableContainers error:nil];
      
            NSLog(@"obj------------%@",obj);
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
        UILabel *titleLabel = [AppTools createLabelText:_content Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.frame = CGRectMake(0, 0, 100, 30);
        titleLabel.userInteractionEnabled = YES;
        self.navigationItem.titleView = titleLabel;
    }
    
    // 分享
    UIBarButtonItem *fxBtn = [UIBarButtonItem itemDoubleWithImage:@"navigation_rightBtn_fenxiang" highImage:@"navigation_rightBtn_fenxiang" target:self action:@selector(fenxiangBtn)];
    self.navigationItem.rightBarButtonItem = fxBtn;
}

- (void)fenxiangBtn
{
    // 定义分享面板的®内容
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    // 调用分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSlog(@"标题=%@，内容=%@，图片=%@，url=%@", _fxTitle, _content, _fxImg, _htmlUrl);
        NSString *urlStr = [NSString stringWithFormat:@"%@&isShowPhoto&tAppUserId=%@", _htmlUrl, USERID];
        if (platformType == 0) {
            [self sharePlatform:0 Title:_fxTitle Content:_tInfo Image:[AppTools httpsWithStr:_fxImg] Url:urlStr];
        }else if (platformType == 1){
            [self sharePlatform:1 Title:_fxTitle Content:_tInfo Image:[AppTools httpsWithStr:_fxImg] Url:urlStr];
        }else if (platformType == 2){
            [self sharePlatform:2 Title:_fxTitle Content:_tInfo Image:[AppTools httpsWithStr:_fxImg] Url:urlStr];
        }else if (platformType == 4){
            [self sharePlatform:4 Title:_fxTitle Content:_tInfo Image:[AppTools httpsWithStr:_fxImg] Url:urlStr];
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
//            [self showHint:message];
        }
    }];
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
    
}

// 测试相册
//if (USERID) {
//    NSString *userId = USERID;
//    [self PhotoUserId:userId];
//}

//MARK: 相册网络请求
-(void)PhotoUserId:(NSString *)userId tId:(NSString *)tId{
    
    NSDictionary *tIdDic =    @{@"dicKey":@"tGamesId",   @"data":tId};
    NSDictionary *userIdDic = @{@"dicKey":@"tAppUserId", @"data":userId};
    
    NSDictionary *pageDic =   @{@"dicKey":@"page",       @"data":@"1"};
    
    NSArray *postArr = @[tIdDic, userIdDic,pageDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/selectUserGamesPhoto", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"查询相册图片 obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"UserGamesPhotoPo"] != nil) {
                _photoArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [obj objectForKey:@"UserGamesPhotoPo"]) {
                    PhotoAlbumList *model = [PhotoAlbumList mj_objectWithKeyValues:dic];
                    [_photoArray addObject:model];
                }
                PhotoAlbumDetailViewController *photoAlbumDetailVC = [PhotoAlbumDetailViewController new]; //精彩瞬间controll
                photoAlbumDetailVC.dataArray = [NSMutableArray arrayWithArray:_photoArray];
                photoAlbumDetailVC.index = 0;
                // 设置不同的模态效果
                [photoAlbumDetailVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [self presentViewController:photoAlbumDetailVC animated:YES completion:^{
                    
                    
                }];
                NSLog(@"照片详情");
                
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"error");
            [self showHint:@"亲，网络开小差了"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
