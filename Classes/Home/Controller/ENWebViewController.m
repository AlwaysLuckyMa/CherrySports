//
//  ENWebViewController.m
//  CherrySports
//
//  Created by dkb on 16/12/14.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "ENWebViewController.h"
#import "LoginVC.h"
#import "ApplyPayWebViewController.h"
#import "FailedlWebView.h"
#import "NewUrlViewController.h"
#import "AppDelegate.h"

@interface ENWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, WXApiDelegate, WXApiManagerDelegate, aliPayDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
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

@end

@implementation ENWebViewController

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

//设置样式  只在info.plist 设置为YES时候有效
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏  只在info.plist 设置为YES时候有效
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    return NO;
}

//设置隐藏动画  只在info.plist 设置为YES时候有效
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
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
    _progressView.progress = 0;
    
//    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
    
    [self settingWebView];
    
    if (USERID) {
        [self CollectYesorNoUserId:USERID];
    }else{
        [self CollectYesorNoUserId:@""];
    }
    
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}


//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

-(void) settingWebView {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[AppTools httpsWithStrUser:_htmlUrl]]];
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
    if (![_tType isEqualToString:@"0"]) {
        _applyBtn.hidden = YES;
    }
    return _applyBtn;
}

#pragma mark - 立即报名点击按钮
- (void)applyCender:(UIButton *)cender
{
    if (USERID)
    {
        NSLog(@"已登录 跳转立即报名web页面");
        
        /** 是否多人报名 0 显示*/
        if ([self.tIsManyPeopleEnter isEqualToString:@"0"] ) {
            //20177199.41
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet] ;
            
            [alert addAction:[UIAlertAction actionWithTitle:@"自己报名" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"自己报名button 被点击了");
                
                if ([_tIsLink isEqualToString:@"0"]) {
                    NSlog(@"外链");
                    NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", _tLink]];
                    [[UIApplication sharedApplication] openURL:cleanURL];
                }else{
                    NSlog(@"系统内部");
                    ApplyPayWebViewController *payVC = [ApplyPayWebViewController new];
//                    payVC.tEnterUrl = _tEnterUrl;
                    payVC.tName = @"自己报名";
                    payVC.tEnterUrl = [NSString stringWithFormat:@"%@&enterType=%@",_tEnterUrl,@"1"];
                    [self.navigationController pushViewController:payVC animated:YES];
                }
                
            }]];
            //给多人报名
            [alert addAction:[UIAlertAction actionWithTitle:@"多人报名" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"给他人报名button 被点击了");
                ApplyPayWebViewController *payVC = [ApplyPayWebViewController new];
                payVC.tName = @"多人报名";
                payVC.tEnterUrl = [NSString stringWithFormat:@"%@&enterType=%@",_tEnterUrl,@"2"];
                [self.navigationController pushViewController:payVC animated:YES];
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"取消button 被点击了");
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else
        {
            if ([_tIsLink isEqualToString:@"0"]) {
                NSlog(@"外链");
                NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", _tLink]];
                [[UIApplication sharedApplication] openURL:cleanURL];
            }else{
                NSlog(@"系统内部");
                ApplyPayWebViewController *payVC = [ApplyPayWebViewController new];
                payVC.tEnterUrl = _tEnterUrl;
                [self.navigationController pushViewController:payVC animated:YES];
            }

        }
        
        
        
        
    }
    else
    {
        NSLog(@"跳登录页");
        LoginVC *loginVC = [LoginVC new];
        loginVC.isWeb = @"1";
        [self.navigationController pushViewController:loginVC animated:YES];
    }
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
        UILabel *titleLabel = [AppTools createLabelText:@"资讯详情" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.frame = CGRectMake(0, 0, 100, 30);
        titleLabel.userInteractionEnabled = YES;
        self.navigationItem.titleView = titleLabel;
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(leftbtn)];
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
-(void)leftbtn{
    NSlog(@"left");
    if ([self.delegate respondsToSelector:@selector(cancelCollectionAndRefresh)]) {
        [self.delegate cancelCollectionAndRefresh];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSDictionary *tTypeDic = @{@"dicKey":@"tType", @"data":_tType};
    NSDictionary *tIdDic = @{@"dicKey":@"tCollectionId", @"data":_tId};
    NSDictionary *userIdDic =@{@"dicKey":@"tAppUserId", @"data":userId};
    
    NSArray *postArr = @[tTypeDic, tIdDic, userIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/collection/checkCollection", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"查询此项目收藏状态 obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]) {
                NSString *str = [obj objectForKey:@"isCollection"];
                if (str.length > 0) {
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
                            _colorId = @"5";
                            _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
                            _applyBtn.userInteractionEnabled = NO;
                        }
                    }
                    if (![isEnter isEqualToString:@"0"]) {
                        _tGameState = [obj objectForKey:@"tGameState"];
                        if (_tGameState.length > 0)
                        {
                            if ([_tGameState isEqualToString:@"0"])
                            {
                                [self.applyBtn setTitle:@"报名未开始" forState:UIControlStateNormal];
                                _applyBtn.backgroundColor = UIColorFromRGB(0x343434);
                                _applyBtn.userInteractionEnabled = NO;
                                _colorId = @"0";
                            }else if ([_tGameState isEqualToString:@"1"]){
                                [self.applyBtn setTitle:@"立即报名" forState:UIControlStateNormal];
                                _applyBtn.backgroundColor = TEXT_COLOR_RED;
                                _applyBtn.userInteractionEnabled = YES;
                                _colorId = @"1";
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
                    if (![_tType isEqualToString:@"0"]) {
                        _applyBtn.hidden = YES;
                    }
                }
            }else{
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
//    return YES;
//}



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
    
    if (_colorId > 0 && [_colorId isEqualToString:@"1"]) {
        self.applyBtn.backgroundColor = TEXT_COLOR_RED;
    }else if (_colorId > 0 && ![_colorId isEqualToString:@"1"]){
        self.applyBtn.backgroundColor = UIColorFromRGB(0x343434);
    }
    if (_colorId.length == 0) {
        self.applyBtn.hidden = YES;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
