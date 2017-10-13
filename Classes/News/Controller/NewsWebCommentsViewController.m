//
//  NewsWebCommentsViewController.m
//  CherrySports
//
//  Created by dkb on 17/1/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "NewsWebCommentsViewController.h"
#import "FailedlWebView.h"
#import "NewUrlViewController.h"
#import "NewsWebCell.h"
#import "NewsTitleCell.h"
#import "NewsCommentsCell.h"
#import "NewsReplyCommentsCell.h"
#import "AppDelegate.h"

@interface NewsWebCommentsViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, copy) NSString *collectYes;
/** 收藏按钮*/
@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, strong) FailedlWebView *backView;

@property (nonatomic, strong) UITableView *mytableView;

/** 页码*/
@property (nonatomic, assign) NSInteger initPage;
/** 是否上啦加载*/
@property (nonatomic, assign) BOOL isUp;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat oneHeight;

@property (nonatomic, assign) BOOL isBackView;

/** textFeild底*/
@property (nonatomic, strong) UIView *textBack;

/** 评论*/
@property (nonatomic, strong) UITextField *textField;

/** 发布按钮*/
@property (nonatomic, strong) UIButton *issueBtn;

@end

@implementation NewsWebCommentsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    STATUS_WIHTE
    [self setNavigationController];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    [self settingWebView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
    // 网络请求相关
    _initPage = 1;
    _isUp = NO;
    _oneHeight = 100;
    [self tableViewRefresh];
    [self mytableView];
    
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
        _webView.backgroundColor = [UIColor whiteColor];
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


-(void) settingWebView {

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[AppTools httpsWithStrUser:_htmlUrl]]];
    [_webView loadRequest:request];
}

- (UITableView *)mytableView
{
    if (!_mytableView)
    {
        _mytableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _mytableView.backgroundColor = BACK_GROUND_COLOR;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        [self.view addSubview:_mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-45);
        }];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mytableView registerClass:[NewsWebCell class] forCellReuseIdentifier:@"webCell"];
        [_mytableView registerClass:[NewsTitleCell class] forCellReuseIdentifier:@"titleCell"];
        [_mytableView registerClass:[NewsCommentsCell class] forCellReuseIdentifier:@"listCell"];
        [_mytableView registerClass:[NewsReplyCommentsCell class] forCellReuseIdentifier:@"listReplyCell"];
    }
    return _mytableView;
}


- (void)addSubViews
{
    if (!_textBack) {
        _textBack = [AppTools createViewBackground:UIColorFromRGB(0xededed)];
        [self.view addSubview:_textBack];
        [_textBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(45);
        }];
        UIView *view = [AppTools createViewBackground:[UIColor whiteColor]];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 10.5;
        [_textBack addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-135/2);
            make.height.mas_equalTo(21);
        }];
    }
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0];
        _textField.font = [UIFont systemFontOfSize:11];
        _textField.placeholder = @"我也来说两句... ...";
        _textField.returnKeyType = UIReturnKeySend;
       [_textField addTarget:self action:@selector(replyDidchange:) forControlEvents:UIControlEventEditingChanged];
        //        _textField.scrollEnabled = NO;
        [_textBack addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-(135/2 + 10));
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(16);
        }];
    }
    
    if (!_issueBtn) {
        _issueBtn = [AppTools createButtonTitle:@"发 布" TitleColor:UIColorFromRGB(0xe60012) Font:14 Background:[[UIColor lightGrayColor] colorWithAlphaComponent:0]];
        [_issueBtn addTarget:self action:@selector(fabuAction) forControlEvents:UIControlEventTouchUpInside];
        [_textBack addSubview:_issueBtn];
        [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(35);
        }];
    }
}

// 实时获取textFeild字符
- (void)replyDidchange:(UITextField *)textField
{
    NSLog(@"asdasdasd = %@", textField.text);
    #pragma mark - 记录点击的字
}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
     [aTextfield resignFirstResponder];//关闭键盘
    #pragma mark - 关闭键盘的同事请求数据
    return YES;
}

// 发布按钮点击
- (void)fabuAction
{
#pragma mark - 发布请求数据
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *textView = object;
    textView.contentOffset = (CGPoint){.x = 0,.y = 0};
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"webCell";
        NewsWebCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [cell.contentView addSubview:_webView];
        return cell;
    }else if (indexPath.section == 1){
        static NSString *identifier = @"titleCell";
        NewsTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        return titleCell;
    }else{
        if (indexPath.row == 1) {
            static NSString *identifier = @"listReplyCell";
            NewsReplyCommentsCell *listReplyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            return listReplyCell;
        }
        static NSString *identifier = @"listCell";
        NewsCommentsCell *listCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        return listCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 119/2;
    }else if (indexPath.section == 2){
        if (indexPath.row == 1) {
            return 48+34;
        }else{
            return 48;
        }
    }
    return _webView.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }else{
        return 0.01;
    }
}

///**
// *  上下拉刷新
// */
- (void)tableViewRefresh
{
//    WS(weakSelf);
    _mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUp = YES;
        
    }];
}


- (void)setNavigationController
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_progressView];
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];

    UILabel *titleLabel = [AppTools createLabelText:@"资讯详情" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(leftbtnAction)];
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

-(void)leftbtnAction{
    NSlog(@"left");
    if ([self.delegate respondsToSelector:@selector(CancelNewsCollectionAndRefresh)]) {
        [self.delegate CancelNewsCollectionAndRefresh];
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
            NSLog(@"error = %@", error);
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
    _webView.scrollView.scrollEnabled = NO;
    if (_backView) {
        [_backView removeFromSuperview];
        _backView = nil;
        _isBackView = NO;
    }
}
// 完成加载调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, SCREEN_WIDTH, height);
    [self.mytableView reloadData];
    [self addSubViews];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
