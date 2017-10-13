//
//  MineEventsViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/17.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineEventsViewController.h"
#import "EventsHomeCell.h"
#import "EventsModel.h"
#import "MyEventWebViewController.h"

#import "PhotoAlbumList.h"
#import "PhotoAlbumDetailViewController.h"
#import "MyEventStart.h"
#import "MineEventsWebVC.h"

@interface MineEventsViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger timeCount; // 定时器计数
    NSInteger timeResult; // 计算显示几个字符
}
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** tableView*/
@property (nonatomic, strong) UITableView *mytableView;
/** 定时器*/
@property (nonatomic, strong) NSTimer *timer;
/** 页面加载图 */
@property (nonatomic, strong)DialogView *dialogView;

/** 页码*/
@property (nonatomic, assign) NSInteger initPage;
/** 是否上啦加载*/
@property (nonatomic, assign) BOOL isUp;

@property (nonatomic, assign)NSString * isShowShare;

@end

@implementation MineEventsViewController //1994

-(void)dealloc
{
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    [self setNavigationController];
    [self timer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    
    timeCount = 1;
    timeResult = 1;
    _initPage = 1;
    _isUp = NO;
    
    [self tableViewRefresh];
    
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_dialogView];
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    
    [self getDataPage:[NSString stringWithFormat:@"%zd", _initPage]];

}

- (UITableView *)mytableView
{
    if (!_mytableView)
    {
        _mytableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.backgroundColor = BACK_GROUND_COLOR;
        [self.view addSubview:_mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0);
        }];
        [_mytableView registerClass:[EventsHomeCell class] forCellReuseIdentifier:@"cell"];
    }
    return _mytableView;
}

#pragma mark - tableView && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    EventsHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.eventsModel = [_dataSource objectAtIndex:indexPath.row];
    
    if ([cell.eventsModel.tGameState isEqualToString:@"4"] || [cell.eventsModel.tGameState isEqualToString:@"3"]) {
        cell.status.text = @"";
        cell.status.hidden = YES;
        cell.theEnd.hidden = NO;
        cell.theEnd.text = cell.eventsModel.tGameStateInfo;
//        NSLog(@"119-----%@",cell.eventsModel.tGameStateInfo);
    }else{
        //        NSString *tempStr = [[NSString stringWithFormat:@"%@... ...", cell.eventsModel.tGameStateInfo] substringWithRange:NSMakeRange(0, timeResult + 5)];
        
        cell.status.text = cell.eventsModel.tGameStateInfo;
        NSLog(@"123-----%@",cell.eventsModel.tGameStateInfo);//据报名结束
        cell.status.hidden = NO;
        cell.theEnd.hidden = YES;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 松手取消选中色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"index = %ld", (long)indexPath.row);
    
    EventsModel *model = [_dataSource objectAtIndex:indexPath.row];
    
    NSLog(@"我的赛世-------%@",model.tGameState);
    
    if ([model.tGameState isEqualToString:@"4"]) { //4
        if (USERID) {
            
            [self SelectUserEvents:USERID tGamesId:model.tId]; //2017071214.53
            
        }
    }else{  //我的赛事
        
        MyEventWebViewController *webVC = [MyEventWebViewController new];
        NSLog(@"152-MyEvent-%@",model) ;
        webVC.htmlUrl = model.tInfoUrl;
        webVC.tEnterUrl = model.tEnterUrl;
        webVC.tId = model.tId;
        webVC.tTitleName = @"我的赛事";
        webVC.tType = @"0";//model.tGameState;//; // 1994
        
        webVC.tEnterUserId = model.tEnterUserId;
        webVC.tOrderId = model.tOrderId;
        
        // 分享用属性
        webVC.fxTitle = model.tGameName;
        webVC.content = model.gettIntroduction;
        webVC.fxImg = model.tImgPath;
        
        NSLog(@"htmlUrl-------%@--%@",webVC.htmlUrl,model.tEnterUrl);
        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 205;
}

#pragma mark - 定时器
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
    return _timer;
}

- (void)timeMethod{
    
    //    timeResult = timeCount % 7 + 1;
    //    timeCount++;
    
    [_mytableView reloadData];
}


///**
// *  上下拉刷新
// */
- (void)tableViewRefresh
{
    WS(weakSelf);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    MJRefreshGifHeader *header = [MyRefresh headerWithRefreshingBlock:^{
        _initPage = 1;
        _isUp = NO;
        [weakSelf getDataPage:[NSString stringWithFormat:@"%zd", _initPage]];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置header
    self.mytableView.mj_header = header;
    
    _mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUp = YES;
        [weakSelf getDataPage:[NSString stringWithFormat:@"%zd", _initPage]];
    }];
}

/** 分页查询赛事接口*/
- (void)getDataPage:(NSString *)page{
    
    NSDictionary * appIdDic  = @{@"dicKey":@"tAppUserId",    @"data":USERID};
    NSDictionary * selectDic = @{@"dicKey":@"isSelectEnter", @"data":@"0"};
    NSDictionary * pageDic   = @{@"dicKey":@"page",          @"data":page};
    
    NSArray *postArr = @[pageDic, appIdDic, selectDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/games/selectGamesByUser", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"News成功----> obj = %@", obj);
           
            if ([[obj objectForKey:@"isShowShare"] isEqualToString:@"0"])
            { //1隐藏
                _isShowShare = @"0";
            }
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"gamesPoList"] != nil) {
                // 成功remove
                [_dialogView removeFromSuperview];
                if (!self.isUp) {
                    [self.dataSource removeAllObjects];
                }
                
                // 获取系统当前时间
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a = [dat timeIntervalSince1970]*1000;
                NSInteger systime = (NSInteger)a;
                NSLog(@"请求成功获取当前系统时间 = %zd", systime);
                
                NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
                // 赛事集合
                if (![[obj objectForKey:@"gamesPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"gamesPoList"]) {
                        EventsModel *eventModel = [EventsModel mj_objectWithKeyValues:dic];
                        eventModel.endMilli = a + eventModel.countDownMilli;
                        [self.dataSource addObject:eventModel];
                        [sizeArray addObject:eventModel];
                    }
                }
                
                if (sizeArray.count == 0 && !_isUp) {
                    [self dialog];
                    [_dialogView bringSubviewToFront:_dialogView.nothingImageView];
                    _dialogView.nothingRefreshButton.hidden = YES;
                    
                }else if (sizeArray.count < [[obj objectForKey:@"size"] integerValue]) {
                    _mytableView.mj_footer.hidden = YES;
                }else{
                    _mytableView.mj_footer.hidden = NO;
                    _initPage = _initPage + 1;
                }
            }else{
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            if (_dataSource.count > 0) {
                [self.mytableView reloadData];
            }
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_mytableView.mj_header endRefreshing];
            [_mytableView.mj_footer endRefreshing];
        }
        else
        {
            NSLog(@"%@",error);
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_mytableView.mj_header endRefreshing];
            [_mytableView.mj_footer endRefreshing];
            
            if (error.code == 100) {
                //                [self.view addSubview:_dialogView];
                [_dialogView bringSubviewToFront:_dialogView.noNetworkView];
                [_dialogView.noNetworkRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
}

- (void)dialog
{
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_dialogView];
}


// 无网络刷新
- (void)btn {
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    
    _isUp = NO;
    // 请求数据
    [self getDataPage:[NSString stringWithFormat:@"%zd", _initPage]];
}

- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"我的赛事" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
}

//MARK: 赛事开始的时候请求的数据 1994
-(void)SelectUserEvents:(NSString *)userId tGamesId:(NSString *)tGamesId{
    
    NSDictionary * tIdDic    = @{@"dicKey":@"tGamesId", @"data":tGamesId};
    NSDictionary * userIdDic =@{@"dicKey":@"tAppUserId", @"data":userId};
    
    NSArray *postArr = @[tIdDic, userIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/enter/selectUserMatchResult", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSLog(@"赛事已开始数据 11obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                MyEventStart *model = [MyEventStart mj_objectWithKeyValues:obj];
                [array addObject:model];
                NSLog(@"model---%@",model);
                
                MineEventsWebVC *webVC = [MineEventsWebVC new];
                webVC.fxTitle = model.tTitle;
                webVC.content = model.tGameName;
                webVC.fxImg = model.tImgPath;
                webVC.htmlUrl = model.tGamesResultUrl;
                webVC.tInfo = model.tInfo;
                webVC.tGameId = model.tGameId;
                
                [self.navigationController pushViewController:webVC animated:YES];
            }else{
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"message:[obj objectForKey:@"resultMessage"] delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                
                [alert show];
            }
        }else{

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
