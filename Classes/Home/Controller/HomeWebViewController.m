//
//  HomeWebViewController.m
//  CherrySports
//
//  Created by dkb on 16/12/5.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeWebViewController.h"
#import "EventsModel.h"
#import "NewsListModel.h"
#import "AppDelegate.h"

@interface HomeWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, WXApiDelegate, WXApiManagerDelegate, aliPayDelegate>{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
/** htmlStr*/
@property (nonatomic, copy) NSString *htmlStr;
/** <#注释#>*/
@property (nonatomic, strong) UIWebView *webView;

/** 记录此数据是否被收藏*/
@property (nonatomic, assign) BOOL collectYes;
/** 收藏用Id*/
@property (nonatomic, copy) NSString *tId;
/** 收藏类型 0 赛事 1资讯*/
@property (nonatomic, copy) NSString *type;

@end

@implementation HomeWebViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_tType isEqualToString:@"0"]) {
        [self getEventWebDataEventsId:_tNewOrGameId];
    }else{
        [self getDataNewstId:_tNewOrGameId];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
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
    _progressView.progress = 0.2;
    [UIView animateWithDuration:1.5f animations:^{
        _progressView.progress = 2;
    }];
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

- (void)setHtml
{
    NSString *HTMLData = [AppTools httpsWithStr:_htmlStr];
    [_webView loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
}

/** 分页查询赛事接口*/
- (void)getEventWebDataEventsId:(NSString *)eventsId{
    
    NSDictionary *pageDic = @{@"dicKey":@"page", @"data":@"1"};
    NSDictionary *tIdDic = @{@"dicKey":@"tId", @"data":eventsId};
    
    NSArray *postArr = @[pageDic, tIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/games/selectGames", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
                        NSLog(@"Events成功----> obj = %@", obj);
            //            NSLog(@"code = %@", [obj objectForKey:@"resultCode"]);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"gamesPoList"] != nil) {
                
                // 赛事集合
                if (![[obj objectForKey:@"gamesPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"gamesPoList"]) {
                        EventsModel *eventModel = [EventsModel mj_objectWithKeyValues:dic];
                        _htmlStr = eventModel.tInfoUrl;
                        _tId = eventModel.tId;
                        [self CollectYesorNo];
                        [self setHtml];
                    }
                }
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else {
            NSLog(@"%@",error);
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}

/** 分页查询资讯接口*/
- (void)getDataNewstId:(NSString *)tId{
    
    NSDictionary *pageDic = @{@"dicKey":@"page", @"data":@"1"};
    NSDictionary *tIdDic = @{@"dicKey":@"tId", @"data":tId};
    
    NSArray *postArr = @[pageDic, tIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/news/selectNews", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"NewsList成功----> obj = %@", obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"newsPoList"] != nil) {
                
                // 赛事集合
                if (![[obj objectForKey:@"newsPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"newsPoList"]) {
                        NewsListModel *model = [NewsListModel mj_objectWithKeyValues:dic];
                        _htmlStr = model.tNewsInfoUrl;
                        _tId = model.tId;
                        
                        [self CollectYesorNo];
                        [self setHtml];
                    }
                }
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else {
            NSLog(@"%@",error);
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}

#pragma mark - NJKWebViewProgressDelegate - webView进度条代理
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}


- (void)setNavigationController
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_progressView];
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    // 收藏按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_collection_web" highImage:@"icon_collection_web" target:self action:@selector(collection:)];
    // 导航栏标题（用图片）
    if ([_tType isEqualToString:@"0"]) {
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigation_title_eventsdetail"]];
        _type = @"0";
    }else{
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigation_title_newsdetail"]];
        _type = @"1";
    }
    
    //    [self settingWebView];
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

- (void)collection:(UIButton *)btnCender
{
    if (_tId.length > 0) {
        if (btnCender.selected == NO) {
            if (USERID) {
                // 请求收藏数据
                [self getDataCollectionId:_tId type:_type];
                NSLog(@"添加收藏");
            }else{
                [self showHint:@"请先登录"];
            }
        }else{
            [self cancelCollectionTid:_tId];
            NSLog(@"删除收藏");
        }
        btnCender.selected = !btnCender.selected;
    }
}


#pragma mark - 查询此项目是否已收藏
-(void)CollectYesorNo{
    
    NSDictionary *tIdDic = @{@"dicKey":@"tCollectionId", @"data":_tId};
    NSDictionary *userIdDic =@{@"dicKey":@"tAppUserId", @"data":USERID};
    
    NSArray *postArr = @[userIdDic,tIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/collection/checkCollection", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"查询此项目收藏状态 obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]) {
                NSString *str = [obj objectForKey:@"isCollection"];
                if (str.length > 0) {
                    if ([str isEqualToString:@"0"]) {
                        _collectYes = YES;
                        NSLog(@"已收藏");
                    }else{
                        _collectYes = NO;
                        NSLog(@"未收藏");
                    }
                }
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"error");
            [self showHint:@"亲，网络开小差了"];
        }
    }];
}

#pragma mark - 添加赛事收藏
- (void)getDataCollectionId:(NSString *)collectId type:(NSString *)type
{
    NSDictionary *userIdDic = @{@"dicKey":@"tAppUserId", @"data":USERID};
    NSDictionary *typeDic = @{@"dicKey":@"tType", @"data":type};
    NSDictionary *collectIdDic = @{@"dicKey":@"tCollectionId", @"data":collectId};
    
    NSArray *postArray = @[userIdDic, typeDic, collectIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/collection/insertUserCollection", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:self.view finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"添加%@收藏成功 obj = %@", _type, obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {
                [self showHint:[obj objectForKey:@"resultMessage"]];
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
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
        }else{
            NSLog(@"error");
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
