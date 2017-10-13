//
//  HomeViewController.m
//  CherrySports
//
//  Created by dkb on 16/10/26.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeViewController.h"

#import "SectionHeaderView.h"
#import "HomeScrollHeaderView.h"
#import "HomeApplyCell.h"
#import "HomeEventsCell.h"
#import "HomeNewsCell.h"
#import "HomeLineCell.h"

#import "HomeImageModel.h"
#import "HomeApplyModel.h"
#import "HomeEventsModel.h"
#import "HomeNewsModel.h"
#import "StartModel.h"

#import "LoginModel.h"
//#import "SearchViewController.h"
#import "DKBSearchViewController.h"
#import "MineSettingViewController.h"
//#import "HomeWebViewController.h"
#import "HomeUrlHTMLViewController.h"
#import "ENWebViewController.h"
//#import "EventsWebViewController.h"
//#import "NewsWebViewController.h"
// 测试支付
#import "ApplyPayWebViewController.h"
#import "LoginVC.h"


#import "StartImageView.h"
#import "StartVideoView.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@interface HomeViewController ()
<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ClickScroImageIdDelegate, MapLocationDelegate, HomeapplyDelegate, ClickStartImageDelegate, StartVideoDelegate
>
{
    NSInteger timeCount; // 定时器计数
    NSInteger timeResult; // 计算显示几个字符
}
/** 页面加载图 */
@property (nonatomic, strong)DialogView *dialogView;
/** collection*/
@property (nonatomic, strong) UICollectionView *myCollectionView;
/** scrollHeader*/
@property (nonatomic, strong) HomeScrollHeaderView *hearderView;
/** sectionHeader*/
@property (nonatomic, strong) SectionHeaderView *sectionView;

/** 记录页面是否有跳转*/
@property (nonatomic, assign) BOOL isPus;
/** 定时器*/
//@property (nonatomic, strong) NSTimer *timer;

/** 是否上啦加载*/
@property (nonatomic, assign) BOOL isUp;
/** 轮播图数据*/
@property (nonatomic, strong) NSMutableArray *scroArray;
/** 赛事报名数据*/
@property (nonatomic, strong) NSMutableArray *applyArray;
/** 资讯数据*/
@property (nonatomic, strong) NSMutableArray *newsArray;
/** 赛事数据*/
@property (nonatomic, strong) NSMutableArray *eventsArray;
/** 页码*/
@property (nonatomic, assign) NSInteger initPage;
@property (nonatomic,strong)CAShapeLayer *CurvedLineLayer;

/** 启动图片数组*/
@property (nonatomic, strong) NSMutableArray *startImageArray;
@property (nonatomic, assign) BOOL isFalse;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSMutableArray *imageCountArr;


/** 视频引导页*/
@property (nonatomic, strong) StartVideoView *aview;
/** 图片引导页*/
@property (nonatomic, strong) StartImageView *iView;
/** 记录是否点击广告页*/
@property (nonatomic, assign) BOOL isStart;

@end

@implementation HomeViewController

- (void)dealloc
{
    _myCollectionView.delegate = nil;
    _myCollectionView.dataSource = nil;
    _hearderView.delegate = nil;
    [MapLocation shareMapLocation].locationDelegate = nil;
}

// 定位
-(void)userLocationCoooor:(CLLocationCoordinate2D)coooor{
    NSLog(@"didUpdateUserLocation lat %f,long %f", coooor.latitude,coooor.longitude);
}

- (void)viewWillAppear:(BOOL)animated {
    [ super viewWillAppear:animated];
    // 关闭导航栏隐藏显示时对collectionView的影响
    if (_isStart == NO) {
        [self addwindowView];
    }
    
    STATUS_WIHTE
    [self setNavigationController];
    if (_isPus == YES) {

        _isPus = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    _isPus = YES;
    if (_isStart == YES) {
        self.tabBarController.tabBar.hidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [_iView removeFromSuperview];
        [_aview removeFromSuperview];
        _iView = nil;
        _aview = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addViews];
    // 初始化定时器计数相关
    timeCount = 1;
    timeResult = 1;
    
    // 定位
    [MapLocation shareMapLocation].locationDelegate = self;
    
//    NSLog(@"用户坐标 = %@", USERLOCATION);
    _initPage = 2;
    _isUp = NO;
    _scroArray = [[NSMutableArray alloc] init];
    _applyArray = [[NSMutableArray alloc] init];
    _eventsArray = [[NSMutableArray alloc] init];
    _newsArray = [[NSMutableArray alloc] init];
    
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_dialogView];
    
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getData];
        [self tableViewRefresh];

    });
    
    
    // 记录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"GetFirst"] == nil) {
        [self getFirst];
    }

}

- (void)addViews
{
    if (!_myCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 滚动方向(纵向)
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[HomeLineCell class]   forCellWithReuseIdentifier:@"lineCell"];
        [_myCollectionView registerClass:[HomeApplyCell class]  forCellWithReuseIdentifier:@"applyCell"];
        [_myCollectionView registerClass:[HomeEventsCell class] forCellWithReuseIdentifier:@"eventsCell"];
        [_myCollectionView registerClass:[HomeNewsCell class]   forCellWithReuseIdentifier:@"newsCell"];
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_myCollectionView];
        
        [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        
        [_myCollectionView registerClass:[HomeScrollHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScorllHeader"];
        [_myCollectionView registerClass:[SectionHeaderView class]    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EventsHeader"];
        [_myCollectionView registerClass:[SectionHeaderView class]    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewsHeader"];
       
    }
}

// 获取到点击图片的model
- (void)ClickSliderWebModel:(HomeImageModel *)webModel
{
    if ([webModel.tIsLink isEqualToString:@"0"]) {
        NSLog(@"是外链");
        if ([webModel.tIsLink isEqualToString:@"0"]) {
            // 外链
            NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", webModel.tInfoUrl]];
            [[UIApplication sharedApplication] openURL:cleanURL];
            _isPus = YES;
        }
    }else{
        
        NSLog(@"不是外链");
        if (webModel.tNewOrGameId.length != 0) {
            ENWebViewController *webView = [ENWebViewController new];
            webView.htmlUrl = webModel.tInfoUrl;
            webView.tType = webModel.tType;
            webView.tId = webModel.tNewOrGameId;
            // 分享用属性
            webView.fxTitle = webModel.tName;
            webView.content = webModel.tIntroduction;
            webView.fxImg = webModel.tImgPath;
            // 是否外链
            webView.tIsLink = webModel.tIsLink;
            webView.tLink = webModel.tLink;
            
            if (webModel.tEnterUrl.length > 0) {
                webView.tEnterUrl = webModel.tEnterUrl;
            }else{
                webView.tEnterUrl = @"";
            }
            [self.navigationController pushViewController:webView animated:YES];
            _isPus = YES;
        }
    }
}

#pragma mark - 区头设置
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section == 0) {
            _hearderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ScorllHeader" forIndexPath:indexPath];
            _hearderView.backgroundColor = [UIColor whiteColor];
            _hearderView.delegate = self;
            if (!_isUp) {
                if (_scroArray != nil && _scroArray.count != 0) {
                    _hearderView.dataArray = _scroArray;
                    _isUp = YES;
                }
            }
            
            return _hearderView;
        }else if (indexPath.section == 2){
            _sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"EventsHeader" forIndexPath:indexPath];
            _sectionView.titleName.text = @"赛事推荐";
            [_sectionView.moreBtn addTarget:self action:@selector(eventsMoreBtn) forControlEvents:UIControlEventTouchUpInside];
            
            return _sectionView;
        }else if (indexPath.section == 3){
            _sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"NewsHeader" forIndexPath:indexPath];
            _sectionView.titleName.text = @"资讯专区";
            [_sectionView.moreBtn addTarget:self action:@selector(newsMoreBtn) forControlEvents:UIControlEventTouchUpInside];
            
            return _sectionView;
        }
    }
    return nil;
}
#pragma mark - 设置每个区头宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*9/16);
    }else if (section == 1){
        return CGSizeMake(SCREEN_WIDTH, 0);
    }else if (section == 2){
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
    return CGSizeMake(SCREEN_WIDTH, 30);
}

#pragma mark - 设置不同区的每个cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_applyArray.count != 0) {
            return CGSizeMake(SCREEN_WIDTH, 10);
        }
        return CGSizeMake(SCREEN_WIDTH, 0.5);
    }
    if (indexPath.section == 1) {
        if (_applyArray.count != 0) {
            return CGSizeMake(SCREEN_WIDTH, 65);
        }
        return CGSizeMake(SCREEN_WIDTH, 0);
    }else if (indexPath.section == 2) {
        if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
            return CGSizeMake((SCREEN_WIDTH - 25)/2, 123);
        }else if (IS_IPHONE_5){
            return CGSizeMake((SCREEN_WIDTH - 25)/2, 0.18*SCREEN_HEIGHT);
        }else{
            return CGSizeMake((SCREEN_WIDTH - 25)/2, 0.21*SCREEN_HEIGHT);
        }
    }
    return CGSizeMake(SCREEN_WIDTH, 157);
}
#pragma mark - 列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return 5;
    }
    return 0;
}
#pragma mark - 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return 5;
    }
    return 0;
}
#pragma mark - 上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

#pragma mark - cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return _applyArray.count;
    }else if (section == 2){
        return _eventsArray.count;
    }
    return _newsArray.count;
}

#pragma mark - 布局Item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"lineCell";
        HomeLineCell *lineCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (_applyArray.count == 0) {
            lineCell.bannerDown.hidden = YES;
        }else{
            lineCell.bannerDown.hidden = NO;
        }
        
        return lineCell;
        
    }else if (indexPath.section == 1){
        static NSString *identifier = @"applyCell";
        HomeApplyCell *applyCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        applyCell.delegate = self;
        applyCell.applyModel = [_applyArray objectAtIndex:indexPath.item];
        
        if (indexPath.row == 0) {
            applyCell.line.hidden = YES;
        }else{
            applyCell.line.hidden = NO;
        }
        // 进行中定时器
        applyCell.status.text = @"报名中...";
        return applyCell;
        
    }else if (indexPath.section == 2){
        static NSString *identifier = @"eventsCell";
        HomeEventsCell *eventsCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        eventsCell.homeEventModel = [_eventsArray objectAtIndex:indexPath.item];
        
        return eventsCell;
    }
    
    static NSString *identifier = @"newsCell";
    HomeNewsCell *newsCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    newsCell.homeNewsmodel = [_newsArray objectAtIndex:indexPath.item];
    
    return newsCell;
}

#pragma mark - Collection点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %zd, row = %zd", indexPath.section, indexPath.item);
    if (indexPath.section == 2) {
        HomeEventsModel *eventModel = [_eventsArray objectAtIndex:indexPath.item];
            NSlog(@"系统内部");
            ENWebViewController *webVC = [ENWebViewController new];
            webVC.htmlUrl = eventModel.tInfoUrl;
            webVC.tEnterUrl = eventModel.tEnterUrl;
            webVC.tId = eventModel.tGameId;
            webVC.tType = @"0";
            
            webVC.tLink = eventModel.tLink;
            webVC.tIsLink = eventModel.tIsLink;
            // 分享用属性
            webVC.fxTitle = eventModel.tTitle;
            webVC.content = eventModel.tIndexInfo;
            webVC.fxImg = eventModel.tImgPath;
            _isPus = YES;
            [self.navigationController pushViewController:webVC animated:YES];
    }else if (indexPath.section == 3){
        HomeNewsModel *newsModel = [_newsArray objectAtIndex:indexPath.item];
        ENWebViewController *webVC = [ENWebViewController new];
        webVC.htmlUrl = newsModel.tNewsInfoUrl;//[NSString stringWithFormat:@"%@%@",SERVER_URLL,newsModel.tNewsInfoUrl] ;
        NSLog(@"newsModel.tNewsInfoUrl---%@",webVC.htmlUrl);
        webVC.tId = newsModel.tId;
        webVC.tType = @"1";
        // 分享用属性
        webVC.fxTitle = newsModel.tNewsName;
        webVC.content = newsModel.tIndexInfo;
        webVC.fxImg = newsModel.tImgPath;
        _isPus = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置nav
- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"樱桃体育" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    // 设置导航栏左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_navigation_left" highImage:@"news_navigation_left" target:self action:@selector(SearchClick)];
}

#pragma mark - 设置按钮
- (void)SettingClick
{
    NSLog(@"设置");
    MineSettingViewController *settingVC = [MineSettingViewController new];
    _isPus = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - 搜索按钮
- (void)SearchClick
{
    NSLog(@"搜索");
    DKBSearchViewController *searchVC =[[DKBSearchViewController alloc]init];
    _isPus = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 报名按钮
- (void)applyDelegateUrl:(NSString *)url
{
    if (USERID) {
        ApplyPayWebViewController *applyWebVC = [ApplyPayWebViewController new];
        applyWebVC.tEnterUrl = url;
        [self.navigationController pushViewController:applyWebVC animated:YES];
        _isPus = YES;
        NSLog(@"立即报名");
    }else{
        LoginVC *login = [LoginVC new];
        [self.navigationController pushViewController:login animated:YES];
    }
}


- (void)eventsMoreBtn
{
    NSLog(@"赛事更多");
    self.tabBarController.selectedIndex = 1;
}

- (void)newsMoreBtn
{
    NSLog(@"资讯更多");
    self.tabBarController.selectedIndex = 3;
}

///**
// *  上下拉刷新
// */
- (void)tableViewRefresh
{
    WS(weakSelf);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    MJRefreshGifHeader *header = [MyRefresh headerWithRefreshingBlock:^{
        _initPage = 2;
        _isUp = NO;
        [weakSelf getData];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置header
    self.myCollectionView.mj_header = header;
    
    _myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUp = YES;
        [weakSelf getDataPage:[NSString stringWithFormat:@"%zd", _initPage]];
    }];
//    self.myCollectionView.mj_footer.hidden = YES;
}

#pragma mark - 请求首页数据
- (void)getData{
    NSlog(@"jd = %@, wd = %@",LOCATIONJD,  LOCATIONWD);
    NSArray *postArr = [NSArray array];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locationJD"] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"locationWD"] != nil) {
        NSDictionary *jdDic = @{@"dicKey":@"longitude", @"data":LOCATIONJD};
        NSDictionary *wdDic = @{@"dicKey":@"latitude", @"data":LOCATIONWD};
        postArr = @[jdDic, wdDic];
    }else{
        NSDictionary *jdDic = @{@"dicKey":@"longitude", @"data":@""};
        NSDictionary *wdDic = @{@"dicKey":@"latitude", @"data":@""};
        postArr = @[jdDic, wdDic];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/index/selectIndexInfo", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
//            NSlog(@"请求成功----> obj = %@", obj);
//            NSLog(@"code = %@", [obj objectForKey:@"resultCode"]);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"indexGamePoList"] != nil && [obj objectForKey:@"newsPoList"] != nil && [obj objectForKey:@"indexSlideImgPoList"] != nil && [obj objectForKey:@"indexGameEnterList"] != nil) {
                // 成功remove
                [_dialogView removeFromSuperview];
                //判断如果不是上拉加载，就先清空数据集dataArray
                if (!self.isUp) {
                    [self.scroArray removeAllObjects];
                    [self.applyArray removeAllObjects];
                    [self.newsArray removeAllObjects];
                    [self.eventsArray removeAllObjects];
                }
                // 保存后台接口的系统时间 用来阅读消息的时候传后台
                [[NSUserDefaults standardUserDefaults] setValue:[obj objectForKey:@"systemTime"] forKey:@"isMessageTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 轮播图
                if (![[obj objectForKey:@"indexSlideImgPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"indexSlideImgPoList"]) {
                        HomeImageModel *imageModel = [HomeImageModel mj_objectWithKeyValues:dic];
                        [self.scroArray addObject:imageModel];
                    }
                    // 将第一个model取出放在数组最后，将最后一个model插入到数组第一张图
                    HomeImageModel *imageModel = [self.scroArray objectAtIndex:0];
                    [self.scroArray insertObject:self.scroArray.lastObject atIndex:0];
                    [self.scroArray addObject:imageModel];
                }
                
                // 赛事报名
                if (![[obj objectForKey:@"indexGameEnterList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"indexGameEnterList"]) {
                        HomeApplyModel *applyModel = [HomeApplyModel mj_objectWithKeyValues:dic];
                        [self.applyArray addObject:applyModel];
                    }
                }
                
                // 赛事
                if (![[obj objectForKey:@"indexGamePoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"indexGamePoList"]) {
                        HomeEventsModel *eventModel = [HomeEventsModel mj_objectWithKeyValues:dic];
                        [self.eventsArray addObject:eventModel];
                    }
                }
                // 资讯
                if (![[obj objectForKey:@"newsPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"newsPoList"]) {
                        HomeNewsModel *newsModel = [HomeNewsModel mj_objectWithKeyValues:dic];
                        [self.newsArray addObject:newsModel];
                    }
                }

            }else{
                // 程序异常时
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            [_myCollectionView reloadData];
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_myCollectionView.mj_header endRefreshing];
            [_myCollectionView.mj_footer endRefreshing];
        }else {
            NSLog(@"%@",error);
            [_myCollectionView.mj_header endRefreshing];
            [_myCollectionView.mj_footer endRefreshing];
            if (error.code == 100) {
                [_dialogView bringSubviewToFront:_dialogView.noNetworkView];
                NSLog(@"100");
                [_dialogView.noNetworkRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            } else {
                NSLog(@"200");
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
}

/** 分页查询资讯接口*/  ///下拉刷新
- (void)getDataPage:(NSString *)page{
    
    NSDictionary *pageDic = @{@"dicKey":@"page", @"data":page};
    
    NSArray *postArr = @[pageDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/index/selectIndexNews", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
//            NSLog(@"News成功----> obj = %@", obj);
//            NSLog(@"code = %@", [obj objectForKey:@"resultCode"]);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"newsPoList"] != nil) {
                // 成功remove
                [_dialogView removeFromSuperview];
                
                NSMutableArray *sizeArray = [NSMutableArray array];
                // 资讯
                if (![[obj objectForKey:@"newsPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"newsPoList"]) {
                        HomeNewsModel *newsModel = [HomeNewsModel mj_objectWithKeyValues:dic];
                        [self.newsArray addObject:newsModel];
                        [sizeArray addObject:newsModel];
                    }
                }
                
                if (sizeArray.count < [[obj objectForKey:@"size"] integerValue]) {
                    _myCollectionView.mj_footer.hidden = YES;
                }else{
                    _myCollectionView.mj_footer.hidden = NO;
                    _initPage += 1;
                }
            }else{
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            [UIView performWithoutAnimation:^{
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
                [self.myCollectionView reloadSections:indexSet];
            }];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_myCollectionView.mj_header endRefreshing];
            [_myCollectionView.mj_footer endRefreshing];
        }else {
            NSLog(@"%@",error);
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_myCollectionView.mj_header endRefreshing];
            [_myCollectionView.mj_footer endRefreshing];
            if (error.code == 100) {
                [_dialogView bringSubviewToFront:_dialogView.noNetworkView];
                [_dialogView.noNetworkRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
}

- (void)btn {
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    _isUp = NO;
    // 请求数据
    [self getData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)selectVideo{
    
    NSString *url = [NSString stringWithFormat:@"%@/system/selectAppVideo", SERVER_URL];
    
    [ServerUtility POSTAction:url param:nil target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"请求视频状态接口成功----> obj = %@", obj);
            _isFalse = NO;
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"appExcessiveVideoPoList"] != nil) {
                
                // 如果是视频
                if ([[obj objectForKey:@"tFileType"] isEqualToString:@"0"]) {
                    for (NSDictionary *dic in [obj objectForKey:@"appExcessiveVideoPoList"]) {
                        NSString *versionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"];
                        NSlog(@"版本号=%@，type=%@，", [obj objectForKey:@"tVersion"],[obj objectForKey:@"tFileType"]);
                        if (![versionStr isEqualToString:[obj objectForKey:@"tVersion"]]) {
                            // 版本号不一致 则更新视频
                            [self getVideoUrlStr:[dic objectForKey:@"tDownloadUrl"] Version:[obj objectForKey:@"tVersion"] ExcessivePlayTime:[dic objectForKey:@"tPlayTime"] type:[obj objectForKey:@"tFileType"] status:@"0"];
                            NSlog(@"播放时间=%@", [obj objectForKey:@"tPlayTime"]);
                        }else{
                            NSLog(@"版本号一致");
                        }
                    }
                }else{
                    // 如果是图片
                    _startImageArray = [NSMutableArray array];
                    _imageCountArr = [[NSMutableArray alloc] init];
                    _imageCountArr = [obj objectForKey:@"appExcessiveVideoPoList"];
                    int i = 0;
                    NSString *versionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"];
                    // 版本号不一致则更新图片
                    if (![versionStr isEqualToString:[obj objectForKey:@"tVersion"]]) {
                        for (NSDictionary *dic in [obj objectForKey:@"appExcessiveVideoPoList"]) {
                            StartModel *newsModel = [StartModel mj_objectWithKeyValues:dic];
                            i++;
                            [self getImageDataModel:newsModel Version:[obj objectForKey:@"tVersion"] imageName:[NSString stringWithFormat:@"%d", i] type:[obj objectForKey:@"tFileType"]];
                        }
                    }
                }
            }

        }else {
            NSLog(@"%@",error);
        }
    }];
}

/** 图片下载 参数.model*/
- (void)getImageDataModel:(StartModel *)model Version:(NSString *)version imageName:(NSString *)imageName type:(NSString *)type
{
//    [self sessionDownload];
    
    [ServerUtility downloadFileWithUrl:model.tDownloadUrl status:@"2" Version:imageName DownloadProgress:^(CGFloat progress, CGFloat total, CGFloat current) {
        NSlog(@"下载图片线程---%@", [NSThread currentThread]);
    } DownloadCompletion:^(BOOL state, NSString *message, NSString *filePath, NSString *response) {
        NSLog(@"消息：%@", message);
        NSLog(@"路径:%@", filePath);
        
        if (state == YES) {
            NSLog(@"下载完成");
            if (_isFalse == NO) {
                if (_imageCount != _imageCountArr.count) {
                    model.localImageUrl = response;
                    model.number = imageName;
                    [_startImageArray addObject:model];
                    _imageCount ++;
                }
                if (_imageCount == _imageCountArr.count) {
                    NSLog(@"model = %@", model.localImageUrl);
                    // 删除数据库现在的表
                    [[KBDataBaseSingle sharDataBase] dropTable];
                    for (int i = 0; i<_startImageArray.count; i++) {
                        [[KBDataBaseSingle sharDataBase] insertNewTimeModel:_startImageArray[i]];
                    }
//                    [[NSUserDefaults standardUserDefaults] setObject:Str forKey:@"StartImageArray"];
                    NSlog(@"存的字符串 = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"StartImageArray"]);
                    // 查数据库并排序
                    NSMutableArray *array = [[KBDataBaseSingle sharDataBase] selectFeaturedAllData];
                    for (int i = 0; i < array.count; i++) {
                        StartModel *model = array[i];
                        NSLog(@"查数据库 = %@", model.number);
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"tVersion"];
                    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"startType"];
                    NSlog(@"版本：%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"]);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSlog(@"图片or视频%@", [[NSUserDefaults standardUserDefaults] objectForKey: @"startType"]);
                }
            }
        }else{
            NSLog(@"下载失败");
            _isFalse = YES;
        }
    }];
}

/** 视频下载 参数1.url 参数2.版本号 参数3.播放时长*/
- (void)getVideoUrlStr:(NSString *)urlStr Version:(NSString *)version ExcessivePlayTime:(NSString *)excessivePlayTime type:(NSString *)type status:(NSString *)status{
    [ServerUtility downloadFileWithUrl:urlStr status:status Version:version DownloadProgress:^(CGFloat progress, CGFloat total, CGFloat current) {
        NSLog(@"当前线程----%@", [NSThread currentThread]);
        
    } DownloadCompletion:^(BOOL state, NSString *message, NSString *filePath, NSString *response) {
        NSLog(@"%@", message);
        NSLog(@"%@", filePath);
        if (state == YES) {
            
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"tVersion"];
            NSlog(@"版本号%@", [[NSUserDefaults standardUserDefaults] objectForKey: @"tVersion"]);
            [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"startType"];
            NSlog(@"图片or视频%@", [[NSUserDefaults standardUserDefaults] objectForKey: @"startType"]);
            [[NSUserDefaults standardUserDefaults] setObject:excessivePlayTime forKey:@"tPlayTime"];
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"isVideo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSlog(@"name--%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"isVideo"]);
            
            NSlog(@"播放时间=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"tPlayTime"]);
        }else{
            NSlog(@"下载失败");
        }
    }];
}

#pragma mark - 第一次安装应用传后台手机型号和系统版本
- (void)getFirst {
    // 获取到手机具体型号 要导入#include <sys/types.h> 和#include <sys/sysctl.h>
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    //手机型号
    NSString *phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@, %@", phoneModel, platform);
    //手机系统版本
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    platform = [NSString stringWithFormat:@"%@|%@",platform,phoneVersion];
    // 设备id
    NSString *identifierForVendor = [AppTools udid];
    NSLog(@"手机唯一标识: %@", identifierForVendor);
    // 当前应用软件版本  比如：1.0.1
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    NSDictionary *phoneModelDict = @{@"dicKey":@"tPhoneModel",@"data":platform};
    NSDictionary *uuidDict = @{@"dicKey":@"tUuid",@"data":identifierForVendor};
    NSDictionary *versionDict = @{@"dicKey":@"tClientVersion",@"data":appCurVersion};
    NSArray *postArray = @[phoneModelDict, uuidDict, versionDict];

    NSString *url = [NSString stringWithFormat:@"%@/system/installAppPhone", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"GetFirst"];
            NSlog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"GetFirst"]);
        }
    }];
}


- (void)addwindowView
{
    BOOL isFirstOpen = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpen"] boolValue];
    NSMutableArray *isImageArray = [[KBDataBaseSingle sharDataBase] selectFeaturedAllData];
    if (!isFirstOpen) {
        //是第一次 则让启动时间为3秒
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"tPlayTime"];
        _aview = [[StartVideoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _aview.delegate = self;
        
        _aview.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"intro"ofType:@"mp4"]];
//        _aview.isFirst = YES;
        // 改变状态为不是第一次登录
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirstOpen"];
        // 万一网络请求不成功，则让下次进入的时候播放本地视频
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"startType"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"tVersion"];
        // 视频不用隐藏tabbar navigation
//        self.tabBarController.tabBar.hidden = YES;
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
//        [self.view addSubview:_aview];
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        // 添加到窗口
        [window addSubview:_aview];
    }else{
        // 视频
        NSlog(@"type = %@, version = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"startType"], [[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"]);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"startType"] isEqualToString:@"0"]) {
            _aview = [[StartVideoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _aview.delegate = self;
            
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"] isEqualToString:@"0"]) {
                //不是首次启动,并且tVersion ！=0 就不播放工程中的视频，从沙盒获取
//                _aview.delegate = self;
                NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"isVideo"];
                if (name.length > 0) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDic = [paths objectAtIndex:0];
//                    _aview.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForAuxiliaryExecutable:[NSString stringWithFormat:@"%@/%@", documentsDic, name]]];
                    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDic, name];
                    _aview.movieURL = [NSURL fileURLWithPath:fullPath];

                }else{
                    _aview.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"intro"ofType:@"mp4"]];
                }
            }else{
                _aview.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"intro"ofType:@"mp4"]];
            }
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            // 添加到窗口
            [window addSubview:_aview];
        }else if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"startType"] isEqualToString:@"0"]){

            if (isImageArray.count > 0) {
                NSLog(@"图片数组有东西");
                _iView = [[StartImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _iView.delegate = self;
                _iView.dataArray = isImageArray;
                [self.view addSubview:_iView];
                self.tabBarController.tabBar.hidden = YES;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }else{
                NSLog(@"正常走");
            }
        }else{
            NSLog(@"正常走");
        }
    }
    
    // 查询视频版本有无更新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self selectVideo];
    });
    
}

// 导航图点击代理事件
- (void)ClickStartModel:(StartModel *)webModel
{
    NSlog(@"系统内部");
    if ([webModel.tIsLink isEqualToString:@"0"]) {
        // 外链
        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", webModel.tLink]];
        [[UIApplication sharedApplication] openURL:cleanURL];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _iView.hidden =YES;
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [_iView removeFromSuperview];
        });
        _isStart = YES;
    }else if ([webModel.tIsLink isEqualToString:@"1"]){
        // 内链
        ENWebViewController *webVC = [ENWebViewController new];
        webVC.htmlUrl = webModel.tLink;
        webVC.tEnterUrl = webModel.tEnterUrl;
        webVC.tId = webModel.tNewOrGameId;
        webVC.tType = webModel.tLinkType;
        
        webVC.tLink = webModel.tEnterUrl;
        webVC.tIsLink = webModel.tIsLink;
        // 分享用属性
        webVC.fxTitle = webModel.tName;
        webVC.content = webModel.tIntroduction;
        webVC.fxImg = webModel.tImgPath;
        _isPus = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        _isStart = YES;
    }else{
        [self ClickTapImage];
    }
}

// 视频代理
- (void)StartVideoDelegate{
    NSlog(@"视频代理");
    _isStart = YES;
//    self.tabBarController.tabBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.aview removeFromSuperview];
//        self.aview = nil;
    });
}

- (void)ClickTapImage
{
    NSlog(@"图片导航点击了跳过");
    self.iView.hidden = YES;
    [self.iView removeFromSuperview];
//    self.iView = nil;
    _isStart = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//}else if (indexPath.section == 3){
//    HomeNewsModel *newsModel = [_newsArray objectAtIndex:indexPath.item];
//    ENWebViewController *webVC = [ENWebViewController new];
//    webVC.htmlUrl = newsModel.tNewsInfoUrl;
//    webVC.tId = newsModel.tId;
//    webVC.tType = @"1";
//    // 分享用属性
//    webVC.fxTitle = newsModel.tNewsName;
//    webVC.content = newsModel.tIndexInfo;
//    webVC.fxImg = newsModel.tImgPath;
//    [self.navigationController pushViewController:webVC animated:YES];



@end
