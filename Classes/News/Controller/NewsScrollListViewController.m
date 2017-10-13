//
//  NewsScrollListViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/7.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - 资讯HOME VC
#import "NewsScrollListViewController.h"
#import "NewsListTableViewCell.h"
#import "NewsListModel.h"

#import "ENWebViewController.h"

@interface NewsScrollListViewController ()<UITableViewDelegate, UITableViewDataSource>
/** tableView*/
@property (nonatomic, strong) UITableView *mytableView;
@property (nonatomic, strong)DialogView *dialogView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 页码*/
@property (nonatomic, assign) NSInteger initPage;
/** 是否上啦加载*/
@property (nonatomic, assign) BOOL isUp;
@end

@implementation NewsScrollListViewController

-(void)dealloc
{
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 网络请求相关
    _initPage = 1;
    _isUp = NO;
    [self tableViewRefresh];
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_dialogView];
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    // 请求数据
    [self getDataPage:[NSString stringWithFormat:@"%zd", _initPage] tNewsType:_model.tId tId:@""];
}

- (UITableView *)mytableView
{
    if (!_mytableView)
    {
        _mytableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _mytableView.backgroundColor = BACK_GROUND_COLOR;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        [self.view addSubview:_mytableView];
        [_mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(-2);
            make.bottom.mas_equalTo(-45);
        }];
        _mytableView.rowHeight = 82;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mytableView registerClass:[NewsListTableViewCell class] forCellReuseIdentifier:@"listCell"];
    }
    return _mytableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"listCell";
    NewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.model = [_dataSource objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.top.hidden = NO;
    }else{
        cell.top.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index = %@", indexPath);
    // 松手取消选中色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsListModel *model = [_dataSource objectAtIndex:indexPath.row];
    ENWebViewController *webVC = [ENWebViewController new];
    webVC.htmlUrl = model.tNewsInfoUrl;
    webVC.tId = model.tId;
    webVC.tType = @"1";
    // 分享用属性
    webVC.fxTitle = model.tNewsName;
    webVC.content = model.tIndexInfo;
    webVC.fxImg = model.tImgPath;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        return 74;
//    }
    return 82;
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
        [weakSelf getDataPage:[NSString stringWithFormat:@"%zd", _initPage] tNewsType:_model.tId tId:@""];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置header
    self.mytableView.mj_header = header;
    
    _mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUp = YES;
        [weakSelf getDataPage:[NSString stringWithFormat:@"%zd", _initPage] tNewsType:_model.tId tId:@""];
    }];
}


/** 分页查询资讯接口*/
- (void)getDataPage:(NSString *)page tNewsType:(NSString *)tNewsType tId:(NSString *)tId{
    
    NSDictionary *pageDic = @{@"dicKey":@"page", @"data":page};
    NSDictionary *tNewsTypeDic = @{@"dicKey":@"tNewsType", @"data":tNewsType};
    NSDictionary *tIdDic = @{@"dicKey":@"tId", @"data":tId};
    
    NSArray *postArr = @[pageDic, tNewsTypeDic, tIdDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/news/selectNews", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
//            NSLog(@"NewsList成功----> obj = %@", obj);
            //            NSLog(@"code = %@", [obj objectForKey:@"resultCode"]);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"newsPoList"] != nil) {
                // 成功remove
                [_dialogView removeFromSuperview];
                if (!self.isUp) {
                    self.dataSource = [[NSMutableArray alloc] init];
                }
                NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
                // 赛事集合
                if (![[obj objectForKey:@"newsPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"newsPoList"]) {
                        NewsListModel *model = [NewsListModel mj_objectWithKeyValues:dic];
                        [self.dataSource addObject:model];
                        [sizeArray addObject:model];
                    }
                }
                
                if (sizeArray.count == 0 && !_isUp) {
                    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
                    [self.view addSubview:_dialogView];
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



// 无网络刷新
- (void)btn {
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    
    _initPage = 1;
    // 请求数据
    [self getDataPage:[NSString stringWithFormat:@"%zd", _initPage] tNewsType:_model.tId tId:@""];
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