//
//  MineMessageViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/16.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineMessageViewController.h"
#import "MineMessageHeaderView.h"
#import "MineMessageCell.h"
#import "MineMessageModel.h"
#import "MyMessageModel.h"
@interface MineMessageViewController ()<UITableViewDelegate, UITableViewDataSource, MineMessageDelegate>
/** 按钮视图*/
@property (nonatomic, strong) MineMessageHeaderView *btnView;
/** 列表*/
@property (nonatomic, strong) UITableView *mytableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 高度数组*/
@property (nonatomic, strong) NSMutableArray *heightArr;

/** 是否上啦加载*/
@property (nonatomic, assign) BOOL isUp;
/** 页面加载图 */
@property (nonatomic, strong)DialogView *dialogView;

/** 赛事阅读状态 0-已阅 1-未阅*/
@property (nonatomic, copy) NSString *gamesReadState;
/** 系统阅读状态 0-已阅 1-未阅*/
@property (nonatomic, copy) NSString *systemReadState;
/** 评论阅读状态 0-已阅 1-未阅*/
@property (nonatomic, copy) NSString *commentReadState;

/** type*/
@property (nonatomic, copy) NSString *type;

@end

@implementation MineMessageViewController

-(void)dealloc
{
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
    _btnView.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _type = @"0";
    _isUp = NO;
    [self addViews];
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    [self.view addSubview:_dialogView];
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    [self getDataType:_type];
    [self tableViewRefresh];
}

- (void)addViews
{
    if (!_btnView) {
        _btnView = [MineMessageHeaderView new];
        _btnView.delegate = self;
//        _btnView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_btnView];
        [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    if (!_mytableView) {
        _mytableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.equalTo(_btnView.mas_bottom);
        }];
        [_mytableView registerClass:[MineMessageCell class] forCellReuseIdentifier:@"cell"];
    }
}

#pragma mark -- btnViewDelegate
- (void)ClickButtonNum:(NSString *)num
{
    // 根据按钮的下标值请求数据
    if ([num isEqualToString:@"0"]) {
        NSLog(@"点击了第0个按钮");
    }else if ([num isEqualToString:@"1"]){
        NSLog(@"点击了第1个按钮");
    }else{
        NSLog(@"点击了第2个按钮");
    }
    _type = num;
    _isUp = NO;
    [self getDataType:_type];
}

#pragma mark -- tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MineMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.myModel = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 松手取消选中色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"sssss --- %f", [_heightArr[indexPath.row] floatValue] + 21);
//    return [_heightArr[indexPath.row] floatValue] + 30;
    return 43 + [_dataSource[indexPath.row] labelHeight];
}
// 每个区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
        [weakSelf getDataType:_type];
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

/** 分页查询消息接口*/
- (void)getDataType:(NSString *)type{
    
    NSDictionary *userIdDic = @{@"dicKey":@"tAppUserId", @"data":USERID};
    NSDictionary *typeDic = @{@"dicKey":@"tType", @"data":type};
    NSDictionary *installTimeDic = @{@"dicKey":@"installTime", @"data":SYSTIME};
    
    NSArray *postArr = @[userIdDic, typeDic, installTimeDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/message/selectMessage", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            NSlog(@"message成功----> obj = %@", obj);
            NSLog(@"code = %@", [obj objectForKey:@"resultCode"]);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"messagePoList"] != nil) {
                [_dialogView removeFromSuperview];
                //判断如果不是上拉加载，就先清空数据集dataArray
                if (!self.isUp) {
                    self.dataSource = [[NSMutableArray alloc] init];
                }
                
                // 阅读状态
                _gamesReadState = [obj objectForKey:@"gamesReadState"];
                _systemReadState = [obj objectForKey:@"systemReadState"];
                _commentReadState = [obj objectForKey:@"commentReadState"];
                if ([_gamesReadState isEqualToString:@"0"]) {
                    _btnView.eventsImageV.hidden = YES;
                }else{
                    _btnView.eventsImageV.hidden = NO;
                }
                if ([_systemReadState isEqualToString:@"0"]) {
                    _btnView.systemImageV.hidden = YES;
                }else{
                    _btnView.systemImageV.hidden = NO;
                }
                if ([_commentReadState isEqualToString:@"0"]) {
                    _btnView.commentImageV.hidden = YES;
                }else{
                    _btnView.commentImageV.hidden = NO;
                }
//                if ([_commentReadState isEqualToString:@"0"] && [_systemReadState isEqualToString:@"0"] && [_gamesReadState isEqualToString:@"0"]) {
//                    NSLog(@"发送通知取消小红点");
//                }
                
                NSMutableArray *sizeArray = [NSMutableArray array];
                // 消息数据
                if (![[obj objectForKey:@"messagePoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"messagePoList"]) {
                        MyMessageModel *model = [MyMessageModel mj_objectWithKeyValues:dic];
                        model.labelHeight = [AppTools labelRectWithLabelSize:CGSizeMake(SCREEN_WIDTH-40, 10000) LabelText:model.tContent Font:[UIFont systemFontOfSize:15]].height;
                        [self.dataSource addObject:model];
                        [sizeArray addObject:model];
                    }
                }
                
                if (sizeArray.count == 0 && !_isUp) {
                    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
                    [self.view addSubview:_dialogView];
                    [_dialogView bringSubviewToFront:_dialogView.nothingImageView];
                    _dialogView.nothingRefreshButton.hidden = YES;
                }else if (sizeArray.count < [[obj objectForKey:@"size"] integerValue]) {
                    _mytableView.mj_header.hidden = YES;
                    // 成功remove
                    [_dialogView removeFromSuperview];
                }else{
                    _mytableView.mj_header.hidden = NO;
                    // 成功remove
                    [_dialogView removeFromSuperview];
                }
            }else{
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            
            // 更新当前后台系统时间
            NSString *timeStr = [obj objectForKey:@"systemTime"];
            if (timeStr.length > 0){
                [[NSUserDefaults standardUserDefaults] setValue:[obj objectForKey:@"systemTime"] forKey:@"isMessageTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                
            }
        
            // 刷新列表
            [self.mytableView reloadData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_mytableView.mj_header endRefreshing];
            [_mytableView.mj_footer endRefreshing];
        }else {
            NSLog(@"%@",error);
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_mytableView.mj_header endRefreshing];
            [_mytableView.mj_footer endRefreshing];
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
    [self getDataType:_type];
}

- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"我的消息" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(back)];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    // 发通知让我的页面重新请求数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyRefiersh" object:nil];
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




//- (NSMutableArray *)dataSource
//{
//    if (!_dataSource) {
//        _dataSource = [[NSMutableArray alloc] init];
//        _heightArr = [[NSMutableArray alloc] init];
//        NSMutableArray *arrM = [NSMutableArray arrayWithObjects:@{@"time": @"2018-12-12", @"contents":@"您已经报名了100年内世界足球先生联赛，详情请看请仔细信息！"}, @{@"time": @"2018-12-12", @"contents":@"您已经报名了100年内世界足球先生联赛，详情请看请仔细阅读报名信息！"}, @{@"time": @"2018-12-12", @"contents":@"您已经报名了100年内世界足球先生联赛，详情请看请仔细阅噶克里斯就放假了卡萨经历过卡死机路公交了撒个娇雷克萨了几个撒娇了开关机了康佳快拉上两节课萨克拉嘎临时工读报名信息！"}, nil];
//        for (NSInteger i = 0; i < arrM.count; i++) {
//            // 模拟从服务器取得数据
//            MineMessageModel *model = [[MineMessageModel alloc]init];
//            [model mj_setKeyValues:arrM[i]];
//            model.labelHeight = [AppTools labelRectWithLabelSize:CGSizeMake(SCREEN_WIDTH-40, 10000) LabelText:model.contents Font:[UIFont fontWithName:@"Microsoft YaHei" size:11]].height;
//            [_heightArr addObject:[NSString stringWithFormat:@"%f", model.labelHeight]];
//            NSLog(@"--- %@", model.time);
//            [_dataSource addObject:model];
//        }
//    }
//    return _dataSource;
//}

@end
