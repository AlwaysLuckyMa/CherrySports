//
//  MineCollectViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/16.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineCollectViewController.h"
#import "MineCollectHeaderView.h"
#import "MineCollectEventsCell.h"
#import "MineCollectNewsCell.h"
#import "EventsCountDown.h"
#import "MyCollectModel.h"
#import "MyCollectNews.h"

#import "ENWebViewController.h"

@interface MineCollectViewController ()<UITableViewDelegate, UITableViewDataSource, CollectHeaderDelegate,cancelCollectionDelegate>{
    NSInteger timeCount; // 定时器计数
    NSInteger timeResult; // 计算显示几个字符
}

/** 标签View*/
@property (nonatomic, strong) MineCollectHeaderView *topView;
/** BOOL判断点击的是哪个按钮走不同布局*/
@property (nonatomic, assign) BOOL isNews;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *dataArray;
/** tableView*/
@property (nonatomic, strong) UITableView *mytableView;

/** 定时器*/
@property (nonatomic, strong) NSTimer *timer;

/** 是否上啦加载*/
@property (nonatomic, assign) BOOL isUp;
/** 页面加载图 */
@property (nonatomic, strong)DialogView *dialogView;
/**判断是否点击了删除按钮**/
@property (nonatomic,assign) BOOL isDelete;
/**确定删除，取消view**/
@property (nonatomic,strong)UIView *showEditView;
/**选中的删除cell的Id数组**/
@property (nonatomic,strong)NSMutableArray *deleteArr;

/** <#注释#>*/
@property (nonatomic, strong) MyCollectModel *model;
/** <#注释#>*/
@property (nonatomic, strong) MyCollectNews *newsModel;

@end

@implementation MineCollectViewController

-(void)dealloc
{
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
    _topView.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    _isDelete = NO;
    [self setNavigationController];
    [self timer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    _deleteArr = [NSMutableArray array];
    
    timeCount = 1;
    timeResult = 1;
    
    _isDelete = NO;
    _isUp = NO;
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    [self.view addSubview:_dialogView];
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    
    [self tableViewRefresh];
    
    [self getData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)createUI
{
    [self topView];
    [self mytableView];
}

- (MineCollectHeaderView *)topView
{
    if (!_topView) {
        _topView = [MineCollectHeaderView new];
        _topView.delegate = self;
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    return _topView;
}

#pragma mark - topView && delegate
- (void)ClickButtonNumber:(NSString *)num
{
    NSLog(@"number = %@", num);
    if ([num isEqualToString:@"1"]) {
        _isNews = YES;
        NSArray *cells = [self.mytableView visibleCells];
        for (MineCollectNewsCell *cell in cells) {
            cell.selectButton.hidden = YES;
        }
        //隐藏_showEditView
        [UIView animateWithDuration:0.5 animations:^{
            _showEditView.hidden = YES;
        }];
        [self getData];
    }else{
        _isNews = NO;
        NSArray *cells = [self.mytableView visibleCells];
        for (MineCollectNewsCell *cell in cells) {
            cell.selectButton.hidden = YES;
//            cell.isGreen = NO;
        }
        //隐藏_showEditView
        [UIView animateWithDuration:0.5 animations:^{
            _showEditView.hidden = YES;
        }];
        [self getData];
    }
//        [self.mytableView reloadData];
}
- (UITableView *)mytableView
{
    if (!_mytableView)
    {
        _mytableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(_topView.mas_bottom);
            make.bottom.mas_equalTo(36);
        }];
        [_mytableView registerClass:[MineCollectEventsCell class] forCellReuseIdentifier:@"collectEventsCell"];
        [_mytableView registerClass:[MineCollectNewsCell class] forCellReuseIdentifier:@"collectNewsCell"];
    }
    return _mytableView;
}

#pragma mark - tableView && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isNews) {
        return self.dataArray.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isNews) {
        static NSString *identifier = @"collectNewsCell";
        MineCollectNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        MyCollectNews *newsModel = [_dataArray objectAtIndex:indexPath.row];
        
        if (_isDelete) {
            newsCell.selectButton.hidden = NO;
            // 取消选中效果
            newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            newsCell.selectButton.hidden = YES;
            newsCell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        newsCell.newsModel = newsModel;
        return newsCell;
    }else{
        static NSString *identifier = @"collectEventsCell";
        MineCollectEventsCell *eventsCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        MyCollectModel *model = [_dataSource objectAtIndex:indexPath.row];
        
        if (_isDelete) {
            eventsCell.selectButton.hidden = NO;
            // 取消选中效果
            eventsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            eventsCell.selectButton.hidden = YES;
            eventsCell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        eventsCell.eventsModel = model;
        
        if ([model.tGameState isEqualToString:@"4"] || [model.tGameState isEqualToString:@"3"]) {
            eventsCell.status.text = @"";
            eventsCell.status.hidden = YES;
            eventsCell.theEnd.hidden = NO;
            if (model.tGameStateInfo.length != 0) {
                eventsCell.theEnd.text = model.tGameStateInfo;
            }
        }else{
            if (model.tGameStateInfo.length != 0) {
//                NSString *tempStr = [[NSString stringWithFormat:@"%@... ...", model.tGameStateInfo] substringWithRange:NSMakeRange(0, timeResult + 5)];
//                eventsCell.status.text = tempStr;
                eventsCell.status.text = model.tGameStateInfo;
            }
            eventsCell.status.hidden = NO;
            eventsCell.theEnd.hidden = YES;
        }
        
        return eventsCell;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isNews) {
        return 88;
    }else{
        return 195;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isNews) {
        if (_isDelete == YES) {
            //删除模式
            MyCollectModel *newsModel =_dataArray[indexPath.row];
            MineCollectNewsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (newsModel.isGreen == NO) {
                [cell.selectButton setImage:[UIImage imageNamed:@"mine_collection_gouGreen"] forState:UIControlStateNormal];
            }else{
                [cell.selectButton setImage:[UIImage imageNamed:@"mine_collection_gouGray"] forState:UIControlStateNormal];
            }
            newsModel.isGreen = ! newsModel.isGreen;
            
            if (![_deleteArr containsObject:newsModel.tId]) {
                //不存在，把选中的cellId加入删除数组
                [_deleteArr addObject:newsModel.tId];
            }else{
                //存在,从删除数组中删除选中的cell的Id
                [_deleteArr removeObject:newsModel.tId];
            }
        }else{
            // 松手取消选中色
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            //正常跳转模式

            MyCollectNews *model = [_dataArray objectAtIndex:indexPath.row];
            ENWebViewController *webVC = [ENWebViewController new];
            webVC.delegate = self;
            webVC.htmlUrl = model.tNewsInfoUrl;
            webVC.tEnterUrl = model.tEnterUrl;
            webVC.tType = @"1";
            webVC.tId = model.tId;
            // 分享用属性
            webVC.fxTitle = model.tNewsName;
            webVC.content = model.tIndexInfo;
            webVC.fxImg = model.tImgPath;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }else{
        if (_isDelete == YES) {
            //删除模式
            MyCollectModel *collectModel =_dataSource[indexPath.row];
            MineCollectEventsCell *cell =[tableView cellForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (collectModel.isGreen == NO) {
                [cell.selectButton setImage:[UIImage imageNamed:@"mine_collection_gouGreen"] forState:UIControlStateNormal];
            }else{
                [cell.selectButton setImage:[UIImage imageNamed:@"mine_collection_gouGray"] forState:UIControlStateNormal];
            }
            collectModel.isGreen = !collectModel.isGreen;
            
            if (![_deleteArr containsObject:collectModel.tId]) {
                //不存在，把选中的cellId加入删除数组
                [_deleteArr addObject:collectModel.tId];
            }else{
                //存在,从删除数组中删除选中的cell的Id
                [_deleteArr removeObject:collectModel.tId];
            }
        }else{
            // 松手取消选中色
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            //正常跳转模式
            MyCollectModel *model = [_dataSource objectAtIndex:indexPath.row];
            
            ENWebViewController *webVC = [ENWebViewController new];
            webVC.delegate = self;
            webVC.htmlUrl = model.tInfoUrl;
            webVC.tId = model.tId;
            webVC.tType = @"0";
            webVC.tIsLink = model.tIsLink;
            webVC.tLink = model.tLink;
            // 报名url
            webVC.tEnterUrl = model.tEnterUrl;
            
            // 分享用属性
            webVC.fxTitle = model.tGameName;
            webVC.content = model.gettIntroduction;
            webVC.fxImg = model.tImgPath;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}
#pragma mark -cancelCollectionRefreshDelegate
-(void)cancelCollectionAndRefresh{
    [self getData];
    [self.mytableView reloadData];
}

- (void)CancelNewsCollectionAndRefresh{
    [self getData];
    [self.mytableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}


- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"我的收藏" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem itemWithImage:@"mine_collection_lajixiang" highImage:nil target:self action:@selector(editingStatus:)];
    
    
}
#pragma mark --tableViewCell编辑状态
-(void)editingStatus:(UIBarButtonItem *)sender
{
    // 开关编辑模式
    if (_isDelete == NO) {
        _isDelete = YES;
        // 关掉用户交互
        self.topView.userInteractionEnabled = NO;
        // 添加确定取消按钮
        [self createShowEditView];
        _showEditView.hidden = NO;
        // 刷新tableView
        [self.mytableView reloadData];
    }
    //没有收藏的数据的时候
    if (_isNews) {
        if (_dataArray.count == 0) {
            self.topView.userInteractionEnabled = YES;
            _showEditView.hidden =YES;
            _isDelete = NO;
        }
    }else{
        if (_dataSource.count == 0) {
            self.topView.userInteractionEnabled = YES;
            _showEditView.hidden =YES;
            _isDelete = NO;
        }
    }
}
-(void)createShowEditView
{
    if (!_showEditView) {
        _showEditView = [[UIView alloc]init];
        [self.view addSubview:_showEditView];
        
        _showEditView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        WS(weakSelf);
        [_showEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(230);
            make.centerX.equalTo(weakSelf.view);
            make.bottom.mas_equalTo(-60);
        }];
        
        //添加确定，取消按钮
        UIButton *sureButton = [UIButton new];
        [_showEditView addSubview: sureButton];
        [sureButton setBackgroundImage:[UIImage imageNamed:@"mine_collection_delete"] forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.height.equalTo(_showEditView);
        }];
        UIButton *cancelButton = [UIButton new];
        [_showEditView addSubview: cancelButton];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"mine_collection_quxiao"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.height.equalTo(_showEditView);
        }];
    }
}

- (void)deleteButton
{
    NSLog(@"删除");
    if (_deleteArr.count > 0) {
        _isDelete = NO;
        // 打开用户交互
        self.topView.userInteractionEnabled = YES;
        // 隐藏确定取消按钮
        _showEditView.hidden = YES;
        [self cancelCollectionInterface];
    }else{
        _isDelete = NO;
        _showEditView.hidden =YES;
        // 打开用户交互
        self.topView.userInteractionEnabled = YES;
        [self.mytableView reloadData];
    }
}

- (void)cancelButton
{
    NSLog(@"取消");
    if (_dataArray.count != 0) {
        MyCollectModel *model = [MyCollectModel new];
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < _dataArray.count; i++) {
            model = _dataArray[i];
            model.isGreen = NO;
            [array addObject:model];
        }
        _dataArray = [NSMutableArray array];
        _dataArray = array;
    }
    if (_dataSource.count != 0) {
        MyCollectNews *model = [MyCollectNews new];
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < _dataSource.count; i++) {
            model = _dataSource[i];
            model.isGreen = NO;
            [array addObject:model];
        }
        _dataSource = [NSMutableArray array];
        _dataSource = array;
    }
    
    _isDelete = NO;
    
    // 初始化记录删除ID 的数组
    _deleteArr = [[NSMutableArray alloc] init];
    // 打开用户交互
    self.topView.userInteractionEnabled = YES;
    // 隐藏确定取消按钮
    _showEditView.hidden = YES;
    // 刷新tableView
    [self.mytableView reloadData];
}


#pragma mark --请求删除收藏接口
-(void)cancelCollectionInterface{
    NSString *str;
    for (int i=0; i<_deleteArr.count; i++) {
        if (str.length > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@",%@", _deleteArr[i]]];
        }else{
            str = [NSString stringWithFormat:@"%@",_deleteArr[i]];
        }
        NSLog(@"str = %@", str);
    }
    NSDictionary *tIdDic = @{@"dicKey":@"tCollectionId", @"data":str};
    NSDictionary *userIdDic =@{@"dicKey":@"tAppUserId", @"data":USERID};
    
    
    NSArray *postArr = @[userIdDic,tIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/collection/deleteUserCollection", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error) {
            NSLog(@"fail");
            [self showHint:@"亲，网络开小差了"];
            _isDelete = YES;
            _showEditView.hidden = NO;
            // 打开用户交互
            self.topView.userInteractionEnabled = NO;
        }else{
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]) {
                [self showHint:[obj objectForKey:@"resultMessage"]];
                [self getData];
            }else{
                [self showHint:[obj objectForKey:@"resultMessage"]];
            }
            
        }
    }];
}



///**
// *  上下拉刷新
// */
- (void)tableViewRefresh
{
    WS(weakSelf);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    MJRefreshGifHeader *header = [MyRefresh headerWithRefreshingBlock:^{
        _isUp = NO;
        _isDelete = NO;
        // 打开用户交互
        self.topView.userInteractionEnabled = YES;
        // 隐藏确定取消按钮
        _showEditView.hidden = YES;
        [weakSelf getData];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置header
    self.mytableView.mj_header = header;
    //
    //    _mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        _isUp = YES;
    //        [weakSelf getDataPage:[NSString stringWithFormat:@"%zd", _initPage] type:_type];
    //    }];
    //    //    self.myCollectionView.mj_footer.hidden = YES;
}

/** 收藏接口*/
- (void)getData{
    
    NSDictionary *userIdDic = @{@"dicKey":@"tAppUserId", @"data":USERID};
    
    NSArray *postArr = @[userIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/collection/selectUserCollection", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"message成功----> obj = %@", obj);
            NSLog(@"code = %@", [obj objectForKey:@"resultCode"]);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"gameCollectionPoList"] != nil && [obj objectForKey:@"newsCollectionPoList"] != nil) {
                [_dialogView removeFromSuperview];
                if (_isNews == NO) {
                    //判断如果不是上拉加载，就先清空数据集dataArray
                    if (!self.isUp) {
                        self.dataSource = [[NSMutableArray alloc] init];
                        self.deleteArr = [[NSMutableArray alloc] init];
                        self.model = [MyCollectModel new];
                    }
                    
                    // 获取系统当前时间
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
//                    NSInteger systime = (NSInteger)a;
                    NSLog(@"请求成功获取当前系统时间 = %zd", a);
                    
                    NSMutableArray *sizeArray = [NSMutableArray array];
                    // Events数据
                    if (![[obj objectForKey:@"gameCollectionPoList"] isEqual:[NSNull null]]) {
                        for (NSDictionary *dic in [obj objectForKey:@"gameCollectionPoList"]) {
                            _model = [MyCollectModel mj_objectWithKeyValues:dic];
                            _model.endMilli = a + _model.countDownMilli;
                            _model.isGreen = NO;
                            [self.dataSource addObject:_model];
                            [sizeArray addObject:_model];
                        }
                    }
                    
                    if (_dataSource.count == 0 && !_isUp) {
                        _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
                        [self.view addSubview:_dialogView];
                        [_dialogView bringSubviewToFront:_dialogView.nothingImageView];
                        _dialogView.nothingRefreshButton.hidden = YES;
                        
                    }else if (sizeArray.count < [[obj objectForKey:@"size"] integerValue]) {
                        _mytableView.mj_footer.hidden = YES;
                        // 成功remove
                        [_dialogView removeFromSuperview];
                    }else{
                        _mytableView.mj_footer.hidden = NO;
                        //                    _initPage += 1;
                        // 成功remove
                        [_dialogView removeFromSuperview];
                    }
                }else{
                    //判断如果不是上拉加载，就先清空数据集dataArray
                    if (!self.isUp) {
                        self.dataArray = [[NSMutableArray alloc] init];
                        self.deleteArr = [[NSMutableArray alloc] init];
                        self.newsModel = [MyCollectNews new];
                    }
                    
                    NSMutableArray *sizeArray = [NSMutableArray array];
                    // news数据
                    if (![[obj objectForKey:@"newsCollectionPoList"] isEqual:[NSNull null]]) {
                        for (NSDictionary *dic in [obj objectForKey:@"newsCollectionPoList"]) {
                            _newsModel = [MyCollectNews mj_objectWithKeyValues:dic];
                            _newsModel.isGreen = NO;
                            [self.dataArray addObject:_newsModel];
                        }
                    }
                    
                    if (_dataArray.count == 0 && !_isUp) {
                        _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
                        [self.view addSubview:_dialogView];
                        [_dialogView bringSubviewToFront:_dialogView.nothingImageView];
                        [_dialogView.nothingRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
                        
                    }else if (sizeArray.count < [[obj objectForKey:@"size"] integerValue]) {
                        _mytableView.mj_footer.hidden = YES;
                        // 成功remove
                        [_dialogView removeFromSuperview];
                    }else{
                        _mytableView.mj_footer.hidden = NO;
                        //                    _initPage += 1;
                        // 成功remove
                        [_dialogView removeFromSuperview];
                    }
                }
            }else{
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            // 刷新
            [self.mytableView reloadData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_mytableView.mj_header endRefreshing];
            //            [_mytableView.mj_footer endRefreshing];
        }else {
            NSLog(@"%@",error);
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_mytableView.mj_header endRefreshing];
            //            [_mytableView.mj_footer endRefreshing];
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
    // 请求数据
    [self getData];
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
