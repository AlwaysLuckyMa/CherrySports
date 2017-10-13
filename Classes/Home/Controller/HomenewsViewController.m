//
//  HomenewsViewController.m
//  CherrySports
//
//  Created by MaTsonga on 2017/8/14.
//  Copyright © 2017年 MC. All rights reserved.

#import "HomenewsViewController.h"

@interface HomenewsViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UIScrollViewDelegate,
    ClickStartImageDelegate,
    StartVideoDelegate,
    MapLocationDelegate,
    YLDroagViewDelegate
>

@property (nonatomic, strong) StartVideoView      * aview;           // 视频开机页
@property (nonatomic, strong) StartImageView      * iView;           // 图片开机页
@property (nonatomic, strong) DialogView          * dialogView;      // 页面加载图

@property (nonatomic, strong) UITableView         * tableView;
@property (nonatomic, strong) NSMutableArray      * scroArray;       // 轮播图数据
@property (nonatomic, strong) NSMutableArray      * scrollArray;     // 轮播图图片链接数据
@property (nonatomic, strong) NSMutableArray      * HomeCenterArr;   // 0段数组
@property (nonatomic, strong) NSMutableArray      * imageCountArr;   // 广告页数组
@property (nonatomic, strong) NSMutableArray      * HomeContentArr;  // 1段数组
@property (nonatomic, strong) NSMutableArray      * startImageArray; // 启动图片数组

@property (nonatomic, strong) YLDragZoomCycleView * dragView;        // 轮播视图

@property (nonatomic, assign) NSInteger             imageCount;
@property (nonatomic, assign) NSInteger             initPage;        // 加载数据页码
@property (nonatomic, assign) BOOL                  isFalse;         // 是否下载完成
@property (nonatomic, assign) BOOL                  isStart;         // 记录是否点击广告页
@property (nonatomic, assign) BOOL                  isPus;           // 记录页面是否有跳转

@end

@implementation HomenewsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self Other];
    [self CreateInitArr];      // 初始化数组
    [self createTableView];
    
    [kCountDownManager start]; // 启动倒计时管理
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self getData];
        [self tableViewRefresh];
        
    });
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"GetFirst"] == nil)
    {                         // 记录是不是第一次启动
        [self getFirst];
    }
    
    [self createLoadBg];      // 创建无数据时背景图
}

#pragma mark - 搜索按钮
- (void)SearchClick
{
    DKBSearchViewController * searchVC = [[DKBSearchViewController alloc]init];
    _isPus                             = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 初始化基本参数
- (void)Other
{
    _initPage = 1;
    [MapLocation shareMapLocation].locationDelegate = self;// 定位
}

#pragma mark - 初始化数组
- (void)CreateInitArr
{
    _scroArray      = [[NSMutableArray alloc] init];
    _HomeCenterArr  = [[NSMutableArray alloc] init];
    _HomeContentArr = [[NSMutableArray alloc] init];
    _scrollArray    = [[NSMutableArray alloc] init];
}

#pragma mark - 创建轮播图
- (void)createScroll
{
    //创建轮播图
    _dragView                  = [[YLDragZoomCycleView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 157)
                                                              andDataSource:_scrollArray
                                                                 autoScroll:YES
                                                             scrollInterval:5];
    _dragView.delegate         = self;
    _tableView.tableHeaderView = _dragView;
}

#pragma mark 正在拖拽的时候停止自动滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_dragView stopScroll];
}

#pragma mark  停止滑动开启自动滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_dragView startScroll];
}

#pragma mark 点击scrollView的Image
- (void)didSelectedItem:(NSInteger)item
{
    [self ClickScrollImage:_scroArray[item]];
}

#pragma mark 获取到点击图片的model
- (void)ClickScrollImage:(HomeImageModel *)webModel
{
    if ([webModel.tIsLink isEqualToString:@"0"])
    {
        NSLog(@"外链");
        if ([webModel.tIsLink isEqualToString:@"0"])
        {
            // 外链
            NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", webModel.tInfoUrl]];
            [[UIApplication sharedApplication] openURL:cleanURL];
            _isPus = YES;
        }
    }
    else
    {
        NSLog(@"内链");
        if (webModel.tNewOrGameId.length != 0)
        {
            ENWebViewController * webView = [ENWebViewController new];
            webView.htmlUrl               = webModel.tInfoUrl;
            webView.tType                 = webModel.tType;
            webView.tId                   = webModel.tNewOrGameId;
            // 分享用属性
            webView.fxTitle               = webModel.tName;
            webView.content               = webModel.tIntroduction;
            webView.fxImg                 = webModel.tImgPath;
            // 是否外链
            webView.tIsLink               = webModel.tIsLink;
            webView.tLink                 = webModel.tLink;
            
            if (webModel.tEnterUrl.length > 0)
            {
                webView.tEnterUrl         = webModel.tEnterUrl;
            }
            else
            {
                webView.tEnterUrl         = @"";
            }
            
            [self.navigationController pushViewController:webView animated:YES];
            _isPus                        = YES;
        }
    }
}

#pragma mark - 创建tableView
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64)
                                             style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    [self.view addSubview:_tableView];
    
    //第0段cell
    [_tableView registerNib:[UINib nibWithNibName:@"HomeNewSectionCenter1Cell" bundle:nil]
     forCellReuseIdentifier:@"HomeNewSectionCenter1Cell"]; //左上 右上 圆角
    [_tableView registerNib:[UINib nibWithNibName:@"HomeNewSectionCenterCell" bundle:nil]
     forCellReuseIdentifier:@"HomeNewSectionCenterCell"];  //无圆角
    [_tableView registerNib:[UINib nibWithNibName:@"HomeNewSectionCenter2Cell" bundle:nil]
     forCellReuseIdentifier:@"HomeNewSectionCenter2Cell"]; //左下 右下 圆角
    
    [_tableView registerNib:[UINib nibWithNibName:@"HomeNewSectionAllCell" bundle:nil]
     forCellReuseIdentifier:@"HomeNewSectionAllCell"];     //全圆角cell
    
    //第一段cell
    [_tableView registerNib:[UINib nibWithNibName:@"HomeNewSectionTabCell" bundle:nil]
     forCellReuseIdentifier:@"HomeNewSectionCell"];
    
}

#pragma mark 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark 每段行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _HomeCenterArr.count;
    }
    return _HomeContentArr.count;
}

#pragma mark 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 99;
    }
    return 198;
}

#pragma mark Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark Footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark 加载cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //数组元素 >= 3
        if (_HomeCenterArr.count > 3)
        {
            if (indexPath.row == 0)
            {
                static NSString           * cellIDa = @"HomeNewSectionCenter1Cell";
                HomeNewSectionCenter1Cell * cell   = [tableView dequeueReusableCellWithIdentifier:cellIDa];
                HomeNewCenterModel        * model  = _HomeCenterArr[indexPath.row];
                cell.backgroundColor               = [UIColor clearColor];
                cell.selectionStyle                = UITableViewCellSelectionStyleNone;
                [cell AssignmentCell:model];
                return cell;
            }
            
            if (indexPath.row == (_HomeCenterArr.count -1))
            {
            
                static NSString           * cellIDb = @"HomeNewSectionCenter2Cell";
                HomeNewSectionCenter2Cell * cell   = [tableView dequeueReusableCellWithIdentifier:cellIDb];
                HomeNewCenterModel        * model  = _HomeCenterArr[indexPath.row];
                cell.backgroundColor               = [UIColor clearColor];
                cell.selectionStyle                = UITableViewCellSelectionStyleNone;
                [cell AssignmentCell:model];                return cell;
            }
            
            static NSString          * cellIDc = @"HomeNewSectionCenterCell";
            HomeNewSectionCenterCell * cell   = [tableView dequeueReusableCellWithIdentifier:cellIDc];
            HomeNewCenterModel       * model  = _HomeCenterArr[indexPath.row];
            [cell AssignmentCell:model];
            cell.backgroundColor              = [UIColor clearColor];
            cell.selectionStyle               = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        //数组元素 = 2
        if (_HomeCenterArr.count ==2)
        {
            if (indexPath.row == 0)
            { //HomeNewSectionAllCell
                static NSString           * cellIDd = @"HomeNewSectionCenter1Cell";
                HomeNewSectionCenter1Cell * cell   = [tableView dequeueReusableCellWithIdentifier:cellIDd];
                HomeNewCenterModel        * model  = _HomeCenterArr[indexPath.row];
                cell.backgroundColor               = [UIColor clearColor];
                cell.selectionStyle                = UITableViewCellSelectionStyleNone;
                [cell AssignmentCell:model];                return cell;
            }
            
            if (indexPath.row == (_HomeCenterArr.count -1))
            {
                static NSString           * cellIDe = @"HomeNewSectionCenter2Cell";
                HomeNewSectionCenter2Cell * cell   = [tableView dequeueReusableCellWithIdentifier:cellIDe];
                HomeNewCenterModel        * model  = _HomeCenterArr[indexPath.row];
                cell.backgroundColor               = [UIColor clearColor];
                cell.selectionStyle                = UITableViewCellSelectionStyleNone;
                [cell AssignmentCell:model];                return cell;
            }

        }
        
        //数组元素 = 1
        if (_HomeCenterArr.count == 1)
        {
            static NSString       * cellIDf = @"HomeNewSectionAllCell";
            HomeNewSectionAllCell * cell   = [tableView dequeueReusableCellWithIdentifier:cellIDf];
            HomeNewCenterModel    * model  = _HomeCenterArr[indexPath.row];
            [cell AssignmentCell:model];
            cell.backgroundColor           = [UIColor clearColor];
            cell.selectionStyle            = UITableViewCellSelectionStyleNone; //取消cell的选中效果
            return cell;
        }
        
    }
    
    static NSString       * cellID  = @"HomeNewSectionCell";
    HomeNewSectionTabCell * cell    = [tableView dequeueReusableCellWithIdentifier:cellID];
    HomeNewCenterModel    * model   = _HomeContentArr[indexPath.row];
    [cell AssignmentCell:model]; 
    cell.model                      = model;
    cell.backgroundColor            = [UIColor clearColor];
    cell.selectionStyle             = UITableViewCellSelectionStyleNone; //取消cell的选中效果
    
    return cell;

}

#pragma mark 选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HomeNewCenterModel *model = [_HomeCenterArr objectAtIndex:indexPath.row];
        
        [self ClickCell:model];
        
    }
    
    if (indexPath.section == 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HomeNewCenterModel  * model = [_HomeContentArr objectAtIndex:indexPath.row];
        
        ENWebViewController * webVC = [ENWebViewController new];
        webVC.htmlUrl               = model.tInfoUrl;
        webVC.tEnterUrl             = model.tEnterUrl;
        webVC.tId                   = model.tGameId;
        webVC.tType                 = @"0";
        webVC.tIsLink               = model.tIsLink;
        webVC.tLink                 = model.tLink;
        webVC.tIsManyPeopleEnter    = model.isManyPeopleEnter;
        
        // 分享用属性
        webVC.fxTitle               = model.tGameName;
        NSString            * str   = [NSString stringWithFormat:@"%@%@",SERVER_URLL,model.tIconPath];
        webVC.content               = [NSString stringWithFormat:@"%@%@",model.tGameName,model.tIntroduction];
        webVC.fxImg                 = model.tImgPath;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark 0段cell点击判断
- (void)ClickCell:(HomeNewCenterModel *)model
{
    NSlog(@"0段cell点击判断系统内部");
    if ([model.tIsLink isEqualToString:@"0"])
    {
        // 外链
        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", model.tLink]];
        [[UIApplication sharedApplication] openURL:cleanURL];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _iView.hidden =YES;
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [_iView removeFromSuperview];
        });
        _isStart = YES;
    }
    else if ([model.tIsLink isEqualToString:@"1"])
    {
        // 内链
        ENWebViewController * webVC = [ENWebViewController new];
        webVC.htmlUrl               = model.tInfoUrl;
        webVC.tEnterUrl             = model.tEnterUrl;
        webVC.tId                   = model.tGameId;
        webVC.tType                 = @"0";
        webVC.tIsLink               = model.tIsLink;
        webVC.tLink                 = model.tLink;
        webVC.tIsManyPeopleEnter    = model.isManyPeopleEnter;
        
        // 分享用属性
        webVC.fxTitle               = model.tGameName;
        NSString            * str   = [NSString stringWithFormat:@"%@%@",SERVER_URLL,model.tIconPath];
        webVC.content               = [NSString stringWithFormat:@"%@%@",model.tGameName,model.tIntroduction];
        webVC.fxImg                 = model.tImgPath;
        [self.navigationController pushViewController:webVC animated:YES];
        _isStart                    = YES;
    }
    else if ([model.tIsLink isEqualToString:@"2"])
    {
        // 内链
        ENWebViewController * webVC = [ENWebViewController new];
        webVC.htmlUrl               = model.tNewsInfoUrl;
        webVC.tEnterUrl             = model.tEnterUrl;
        webVC.tId                   = model.tGameId;
        webVC.tType                 = @"1";
        webVC.tIsLink               = model.tIsLink;
        webVC.tLink                 = model.tLink;
        webVC.tIsManyPeopleEnter    = model.isManyPeopleEnter;
        
        // 分享用属性
        webVC.fxTitle               = model.tGameName;
        NSString            * str   = [NSString stringWithFormat:@"%@%@",SERVER_URLL,model.tIconPath];
        webVC.content               = [NSString stringWithFormat:@"%@%@",model.tGameName,model.tIntroduction];
        webVC.fxImg                 = model.tImgPath;
        [self.navigationController pushViewController:webVC animated:YES];
        _isStart                    = YES;

    }
}

#pragma mark - 创建上下拉刷新
- (void)tableViewRefresh
{
    WS(weakSelf);
    MJRefreshGifHeader *header = [MyRefresh headerWithRefreshingBlock:^{
        [_scroArray       removeAllObjects];
        [_HomeCenterArr   removeAllObjects];
        [_HomeContentArr  removeAllObjects];
        [_scrollArray     removeAllObjects];
        _tableView.mj_footer.hidden    = NO;
        
        _initPage                      = 1;
        [weakSelf getData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;    // 隐藏时间
    header.stateLabel.hidden           = YES;    // 隐藏状态
    _tableView.mj_header               = header; // 设置header
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _initPage++;
        [weakSelf getDataPage:[NSString stringWithFormat:@"%zi", _initPage]];
    }];
}

#pragma mark - 设置nav
- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel                   = [AppTools createLabelText:@"樱桃体育"
                                                                Color:[UIColor whiteColor]
                                                                 Font:16
                                                        TextAlignment:NSTextAlignmentCenter];
    titleLabel.font                       = [UIFont systemFontOfSize:16];
    titleLabel.frame                      = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled     = YES;
    self.navigationItem.titleView         = titleLabel;
    // 设置导航栏左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_navigation_left"
                                                                 highImage:@"news_navigation_left"
                                                                    target:self
                                                                    action:@selector(SearchClick)];
}

- (void)addwindowView
{
    BOOL             isFirstOpen            = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpen"] boolValue];
    NSMutableArray * isImageArray           = [[KBDataBaseSingle sharDataBase] selectFeaturedAllData];
    if (!isFirstOpen)
    {
        //是第一次 则让启动时间为3秒
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"tPlayTime"];
        _aview                              = [[StartVideoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _aview.delegate                     = self;
        _aview.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"intro"ofType:@"mp4"]];
        // 改变状态为不是第一次登录
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirstOpen"];
        // 万一网络请求不成功，则让下次进入的时候播放本地视频
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"startType"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"tVersion"];
        // 视频不用隐藏tabbar navigation
        UIWindow  * window                  = [[UIApplication sharedApplication].windows lastObject];
        // 添加到窗口
        [window addSubview:_aview];
        
    }
    else
    {
        // 视频
        NSlog(@"type = %@, version = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"startType"], [[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"]);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"startType"] isEqualToString:@"0"])
        {
            _aview = [[StartVideoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _aview.delegate = self;
            
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"] isEqualToString:@"0"])
            {
                //不是首次启动,并且tVersion ！=0 就不播放工程中的视频，从沙盒获取
                //                _aview.delegate = self;
                NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"isVideo"];
                if (name.length > 0)
                {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDic = [paths objectAtIndex:0];
                    //                    _aview.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForAuxiliaryExecutable:[NSString stringWithFormat:@"%@/%@", documentsDic, name]]];
                    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDic, name];
                    _aview.movieURL = [NSURL fileURLWithPath:fullPath];
                    
                }
                else
                {
                    _aview.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"intro"ofType:@"mp4"]];
                }
                //                _aview.isFirst = NO;
            }
            else
            {
                _aview.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"intro"ofType:@"mp4"]];
            }
            
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [window addSubview:_aview]; // 添加到窗口
            
        }else if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"startType"] isEqualToString:@"0"]){
            
            if (isImageArray.count > 0)
            {
                NSLog(@"图片数组有东西");
                _iView           = [[StartImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _iView.delegate  = self;
                _iView.dataArray = isImageArray;
                [self.view addSubview:_iView];
                 self.tabBarController.tabBar.hidden = YES;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }
            else
            {
                NSLog(@"正常走");
            }
        }
        else
        {
            NSLog(@"正常走");
        }
    }
    
    // 查询视频版本有无更新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self selectVideo];
    });
    
}

- (void)selectVideo
{
    NSString *url = [NSString stringWithFormat:@"%@/system/selectAppVideo", SERVER_URL];
    
    [ServerUtility POSTAction:url param:nil target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error)
    {
        if (error == nil)
        {
            NSlog(@"请求视频状态接口成功----> obj = %@", obj);
            _isFalse = NO;
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"appExcessiveVideoPoList"] != nil)
            {
                // 如果是视频
                if ([[obj objectForKey:@"tFileType"] isEqualToString:@"0"])
                {
                    for (NSDictionary *dic in [obj objectForKey:@"appExcessiveVideoPoList"])
                    {
                        NSString *versionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"];
                        NSlog(@"版本号=%@，type=%@，", [obj objectForKey:@"tVersion"],[obj objectForKey:@"tFileType"]);
                        if (![versionStr isEqualToString:[obj objectForKey:@"tVersion"]])
                        {
                            // 版本号不一致 则更新视频
                            [self getVideoUrlStr:[dic objectForKey:@"tDownloadUrl"] Version:[obj objectForKey:@"tVersion"] ExcessivePlayTime:[dic objectForKey:@"tPlayTime"] type:[obj objectForKey:@"tFileType"] status:@"0"];
                            NSlog(@"播放时间=%@", [obj objectForKey:@"tPlayTime"]);
                        }
                        else
                        {
                            NSLog(@"版本号一致");
                        }
                    }
                }
                else
                {
                    // 如果是图片
                    _startImageArray      = [NSMutableArray array];
                    _imageCountArr        = [[NSMutableArray alloc] init];
                    _imageCountArr        = [obj objectForKey:@"appExcessiveVideoPoList"];
                    int i                 = 0;
                    NSString * versionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"];
                    // 版本号不一致则更新图片
                    if (![versionStr isEqualToString:[obj objectForKey:@"tVersion"]])
                    {
                        for (NSDictionary *dic in [obj objectForKey:@"appExcessiveVideoPoList"])
                        {
                            StartModel *newsModel = [StartModel mj_objectWithKeyValues:dic];
                            i++;
                            [self getImageDataModel:newsModel
                                            Version:[obj objectForKey:@"tVersion"]
                                          imageName:[NSString stringWithFormat:@"%d", i]
                                               type:[obj objectForKey:@"tFileType"]];
                        }
                    }
                }
            }
            
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - 广告页点击代理
- (void)ClickStartModel:(StartModel *)webModel
{
    NSlog(@"系统内部");
    if ([webModel.tIsLink isEqualToString:@"0"])
    {
        // 外链
        NSURL * cleanURL                        = [NSURL URLWithString:[NSString stringWithFormat:@"%@", webModel.tLink]];
        [[UIApplication sharedApplication] openURL:cleanURL];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _iView.hidden                       =YES;
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [_iView removeFromSuperview];
        });
        _isStart = YES;
        
    }
    else if ([webModel.tIsLink isEqualToString:@"1"])
    {
        // 内链
        ENWebViewController * webVC = [ENWebViewController new];
        webVC.htmlUrl               = webModel.tLink;
        webVC.tEnterUrl             = webModel.tEnterUrl;
        webVC.tId                   = webModel.tNewOrGameId;
        webVC.tType                 = webModel.tLinkType;
        
        webVC.tLink                 = webModel.tEnterUrl;
        webVC.tIsLink               = webModel.tIsLink;
        // 分享用属性
        webVC.fxTitle               = webModel.tName;
        webVC.content               = webModel.tIntroduction;
        webVC.fxImg                 = webModel.tImgPath;
        _isPus                      = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        _isStart                    = YES;
    }
    else
    {
        [self ClickTapImage];
    }
}

#pragma mark  广告页点击了跳过
- (void)ClickTapImage
{
    NSlog(@"图片导航点击了跳过");
    _iView.hidden = YES;
    [_iView removeFromSuperview];
    _iView        = nil;
    _isStart      = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 请求首页数据
- (void)getData
{
    NSlog(@"jd = %@, wd = %@",LOCATIONJD,  LOCATIONWD);
    NSArray *postArr = [NSArray array];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locationJD"] != nil
        &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"locationWD"] != nil)
    {
        NSDictionary *jdDic = @{@"dicKey":@"longitude", @"data":LOCATIONJD};
        NSDictionary *wdDic = @{@"dicKey":@"latitude", @"data":LOCATIONWD};
        postArr = @[jdDic, wdDic];
    }
    else
    {
        NSDictionary *jdDic = @{@"dicKey":@"longitude", @"data":@""};
        NSDictionary *wdDic = @{@"dicKey":@"latitude", @"data":@""};
        postArr = @[jdDic, wdDic];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/index/selectIndexInfo_2", SERVER_URL];

    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error)
     {
        if (error == nil)
        {
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"])
            {

                NSArray *picArr = [obj objectForKey:@"routineGameList"];
                if (picArr.count<=1)
                {  //隐藏刷新
                    [_tableView.mj_footer endRefreshing];
                     _tableView.mj_footer.hidden = YES;
                }
                
                [_dialogView removeFromSuperview]; // 成功remove
               
                // 保存后台接口的系统时间 用来阅读消息的时候传后台
                [[NSUserDefaults standardUserDefaults] setValue:[obj objectForKey:@"systemTime"] forKey:@"isMessageTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 轮播图
                if (![[obj objectForKey:@"indexSlideImgPoList"] isEqual:[NSNull null]])
                {
                    for (NSDictionary *dic in [obj objectForKey:@"indexSlideImgPoList"])
                    {
                        HomeImageModel * imageModel = [HomeImageModel mj_objectWithKeyValues:dic];
                        [_scroArray   addObject:imageModel];
                        [_scrollArray addObject:imageModel.tImgPath];
                        
                    }
                    // 将第一个model取出放在数组最后，将最后一个model插入到数组第一张图
//                    HomeImageModel *imageModel = [self.scroArray objectAtIndex:0];
//                    [self.scroArray insertObject:self.scroArray.lastObject atIndex:0];
//                    [self.scroArray addObject:imageModel];
                }
                
                //  raiGameList  0段 的cell
                if (![[obj objectForKey:@"raiGameList"] isEqual:[NSNull null]])
                {
                    for (NSDictionary *dic in [obj objectForKey:@"raiGameList"])
                    {
                        HomeNewCenterModel *applyModel = [HomeNewCenterModel mj_objectWithKeyValues:dic];
                        [_HomeCenterArr addObject:applyModel];
                    }
                }
                
                // routineGameList  1段 的cell
                if (![[obj objectForKey:@"routineGameList"] isEqual:[NSNull null]])
                {
                    for (NSDictionary *dic in [obj objectForKey:@"routineGameList"])
                    {
                        HomeNewCenterModel *applyModel = [HomeNewCenterModel mj_objectWithKeyValues:dic];
                        [_HomeContentArr addObject:applyModel];
                    }
                }
                
            }
            else
            {
                // 程序异常时
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_dragView removeFromSuperview];  //防止重复创建ScrollView
            [self createScroll];

            [self reloadData];
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
        }
        else
        {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
            if (error.code == 100)
            {
                [_dialogView bringSubviewToFront:_dialogView.noNetworkView];
                NSLog(@"100");
                [_dialogView.noNetworkRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                NSLog(@"200");
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
}

#pragma mark  分页查询资讯接口   下拉刷新
- (void)getDataPage:(NSString *)page
{
    NSDictionary * pageDic = @{@"dicKey":@"page", @"data":page};
    NSArray      * postArr = @[pageDic];
    NSString     * url     = [NSString stringWithFormat:@"%@/index/selectIndexGames", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error)
    {
        if (error == nil)
        {
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"routineGameList"] != nil)
            {
                [_dialogView removeFromSuperview];// 成功remove
                
                NSArray *picArr = [obj objectForKey:@"routineGameList"];
                if (picArr.count<=0)
                {  //隐藏刷新
                    [_tableView.mj_footer endRefreshing];
                     _tableView.mj_footer.hidden = YES;
                    return ;
                }
                
                // 1段 下拉加载
                if (![[obj objectForKey:@"routineGameList"] isEqual:[NSNull null]])
                {
                    for (NSDictionary *dic in [obj objectForKey:@"routineGameList"])
                    {
                        HomeNewCenterModel *applyModel = [HomeNewCenterModel mj_objectWithKeyValues:dic];
                        [_HomeContentArr addObject:applyModel];
                    }
                }
                
            }
            else
            {
                
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self
                                                      action:@selector(btn)
                                            forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
        }
        else
        {
            NSLog(@"%@",error);
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
            if (error.code == 100)
            {
                [_dialogView bringSubviewToFront:_dialogView.noNetworkView];
                [_dialogView.noNetworkRefreshButton addTarget:self
                                                       action:@selector(btn)
                                             forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self
                                                      action:@selector(btn)
                                            forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
}

#pragma mark - 刷新数据 同时 使倒计时的计数器置0
- (void)reloadData
{
    // 调用[kCountDownManager reload]
    [kCountDownManager reload];
    // 刷新
    [_tableView reloadData];
}

- (void)btn
{
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    [self getData];  // 请求数据
}

#pragma mark - 第一次安装应用传后台手机型号和系统版本
- (void)getFirst
{
    // 获取到手机具体型号 要导入#include <sys/types.h> 和#include <sys/sysctl.h>
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine                 = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform            = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    //手机型号
    NSString *phoneModel          = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@, %@", phoneModel, platform);
    //手机系统版本
    NSString *phoneVersion        = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    platform = [NSString stringWithFormat:@"%@|%@",platform,phoneVersion];
    // 设备id
    NSString *identifierForVendor = [AppTools udid];
    NSLog(@"手机唯一标识: %@", identifierForVendor);
    // 当前应用软件版本  比如：1.0.1
    NSDictionary *infoDictionary  = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    NSDictionary *phoneModelDict  = @{@"dicKey":@"tPhoneModel",@"data":platform};
    NSDictionary *uuidDict        = @{@"dicKey":@"tUuid",@"data":identifierForVendor};
    NSDictionary *versionDict     = @{@"dicKey":@"tClientVersion",@"data":appCurVersion};
    NSArray *postArray            = @[phoneModelDict, uuidDict, versionDict];
    
    NSString *url                 = [NSString stringWithFormat:@"%@/system/installAppPhone", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArray target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error)
    {
        if (error == nil)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"GetFirst"];
            NSlog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"GetFirst"]);
        }
    }];
}

#pragma mark -  定位
-(void)userLocationCoooor:(CLLocationCoordinate2D)coooor
{
    NSLog(@"didUpdateUserLocation lat %f,long %f", coooor.latitude,coooor.longitude);
}

#pragma mark -  图片下载 参数.model*
- (void)getImageDataModel:(StartModel *)model Version:(NSString *)version imageName:(NSString *)imageName type:(NSString *)type
{
    [ServerUtility downloadFileWithUrl:model.tDownloadUrl status:@"2" Version:imageName DownloadProgress:^(CGFloat progress, CGFloat total, CGFloat current)
    {
        NSlog(@"下载图片线程---%@", [NSThread currentThread]);
    } DownloadCompletion:^(BOOL state, NSString *message, NSString *filePath, NSString *response)
    {
        NSLog(@"消息：%@", message);
        NSLog(@"路径:%@", filePath);
        
        if (state == YES)
        {
            NSLog(@"下载完成");
            if (_isFalse == NO)
            {
                if (_imageCount != _imageCountArr.count)
                {
                    model.localImageUrl = response;
                    model.number        = imageName;
                    [_startImageArray addObject:model];
                    _imageCount ++;
                }
                
                if (_imageCount == _imageCountArr.count)
                {
                    
                    NSLog(@"model = %@", model.localImageUrl);
                    
                    [[KBDataBaseSingle sharDataBase] dropTable]; // 删除数据库现在的表
                    
                    for (int i = 0; i<_startImageArray.count; i++)
                    {
                        [[KBDataBaseSingle sharDataBase] insertNewTimeModel:_startImageArray[i]];
                    }
                    NSlog(@"存的字符串 = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"StartImageArray"]);
                    // 查数据库并排序
                    NSMutableArray *array = [[KBDataBaseSingle sharDataBase] selectFeaturedAllData];
                    for (int i = 0; i < array.count; i++)
                    {
                        StartModel *model = array[i];
//                        NSLog(@"查数据库 = %@", model.number);
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"tVersion"];
                    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"startType"];
//                    NSlog(@"版本：%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"tVersion"]);
                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    NSlog(@"图片or视频%@", [[NSUserDefaults standardUserDefaults] objectForKey: @"startType"]);
                }
            }
        }
        else
        {
            NSLog(@"下载失败");
            _isFalse = YES;
        }
    }];
}

#pragma mark  视频下载 参数1.url 参数2.版本号 参数3.播放时长
- (void)getVideoUrlStr:(NSString *)urlStr Version:(NSString *)version ExcessivePlayTime:(NSString *)excessivePlayTime type:(NSString *)type status:(NSString *)status
{
    [ServerUtility downloadFileWithUrl:urlStr
                                status:status
                               Version:version
                      DownloadProgress:^(CGFloat progress, CGFloat total, CGFloat current)
    {
        NSLog(@"当前线程----%@", [NSThread currentThread]);
    }
                    DownloadCompletion:^(BOOL state, NSString *message, NSString *filePath, NSString *response)
    {
        if (state == YES)
        {
            [[NSUserDefaults standardUserDefaults] setObject:version
                                                      forKey:@"tVersion"];
            NSlog(@"版本号%@", [[NSUserDefaults standardUserDefaults] objectForKey: @"tVersion"]);
            
            [[NSUserDefaults standardUserDefaults] setObject:type
                                                      forKey:@"startType"];
            NSlog(@"图片or视频%@", [[NSUserDefaults standardUserDefaults] objectForKey: @"startType"]);
            
            [[NSUserDefaults standardUserDefaults] setObject:excessivePlayTime
                                                      forKey:@"tPlayTime"];
            
            [[NSUserDefaults standardUserDefaults] setObject:response
                                                      forKey:@"isVideo"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSlog(@"name--%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"isVideo"]);
            
            NSlog(@"播放时间=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"tPlayTime"]);
            
        }
        else
        {
            NSlog(@"下载失败");
        }
    }];
}


#pragma mark - 视频代理
- (void)StartVideoDelegate
{
    NSlog(@"视频代理");
    _isStart = YES;
    //    self.tabBarController.tabBar.hidden = NO;
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_aview removeFromSuperview];
         _aview = nil;
    });
}

#pragma mark - 创建无内容时背景
- (void)createLoadBg
{
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_dialogView];
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
}

#pragma mark - 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
   
    if (_isStart == NO) // 关闭导航栏隐藏显示时对collectionView的影响
    {
        [self addwindowView];
    }
    
    STATUS_WIHTE
    
    [self setNavigationController];
    
    if (_isPus == YES)
    {
        _isPus = NO;
    }
}

#pragma mark - 视图即将离开
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _isPus = YES;
    if (_isStart == YES)
    {
        self.tabBarController.tabBar.hidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [_iView removeFromSuperview];
        [_aview removeFromSuperview];
        _iView = nil;
        _aview = nil;
    }
}

- (void)dealloc
{
    _tableView.delegate   = nil;
    _tableView.dataSource = nil;
    [MapLocation shareMapLocation].locationDelegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
