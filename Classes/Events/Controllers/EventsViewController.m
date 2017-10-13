//
//  EventsViewController.m
//  CherrySports
//
//  Created by dkb on 16/10/26.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsTopView.h"
#import "EventsAreaChooseView.h"
#import "EventsTypeChooseView.h"
#import "EventsSearchView.h"
#import "EventsHomeCell.h"

#import "EventsCountDown.h"
#import "EventsModel.h"
#import "EventsCityModel.h"
#import "EventsTypeModel.h"
#import "EventsSelectModel.h"
#import "EventAddress.h"

#import "MineSettingViewController.h"
#import "DKBSearchViewController.h"

#import "ENWebViewController.h"

@interface EventsViewController ()<UITableViewDelegate, UITableViewDataSource, TopViewDelegate, EventsAreaDelegate, EventsTypeDelegate, EventsSearchDelegate>{
    NSInteger timeCount; // 定时器计数
    NSInteger timeResult; // 计算显示几个字符
    
    NSString *areaRow;
    NSString *areaWai;
}
/** topView*/
@property (nonatomic, strong) EventsTopView *topView;
/** 地区选择View*/
@property (nonatomic, strong) EventsAreaChooseView *areaView;
/** 城市信息数组*/
@property (nonatomic, strong) NSMutableArray *areaWArray;
@property (nonatomic, strong) NSMutableArray *areaNArray;
@property (nonatomic, strong) NSMutableArray *areaALLArray;
@property (nonatomic, assign) NSInteger areaHeight;
/** 赛事类型View*/
@property (nonatomic, strong) EventsTypeChooseView *typeView;
/** 赛事类型数组*/
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger typeHeight;
/** 快捷查询View*/
@property (nonatomic, strong) EventsSearchView *searchView;
/** 快捷查询数组*/
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, assign) NSInteger searchHeight;
/** 根据iphone算高度*/
@property (nonatomic, assign) NSInteger areaNum;
@property (nonatomic, assign) NSInteger typeNum;

/** tableView*/
@property (nonatomic, strong) UITableView *mytableView;

/** 定时器*/
@property (nonatomic, strong) NSTimer *timer;


/** 页码*/
@property (nonatomic, assign) NSInteger initPage;
/** 是否上啦加载*/
@property (nonatomic, assign) BOOL isUp;
/** 页面加载图 */
@property (nonatomic, strong) DialogView *dialogView;
/** 赛事集合数组*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 选择的赛事id*/
@property (nonatomic, copy) NSString *cityId;
/** 选择的类型id*/
@property (nonatomic, copy) NSString *typeId;
/** 选择的状态id*/
@property (nonatomic, copy) NSString *searchId;

@property (nonatomic, assign) BOOL isTime;

@property (nonatomic, assign) BOOL ispush;

/** <#注释#>*/
@property (nonatomic, assign) NSInteger areaCount;

@end

@implementation EventsViewController

-(void)dealloc
{
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
    _topView.delegate = nil;
    _areaView.areaDelegate = nil;
    _typeView.typeDelegate = nil;
    _searchView.searchDelegate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    STATUS_WIHTE
    if (_ispush == YES) {
        [_mytableView reloadData];
        
        _ispush = NO;
    }
    [self timer];
    // 布局导航控制器
    [self setNavigationController];
}
// 点击空白处 View收回
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if (_typeView.hidden == NO || _searchView.hidden == NO || _areaView.hidden == NO) {
//        _typeView.hidden = YES;
//        _searchView.hidden = YES;
//        _areaView.hidden = YES;
//    }
//    _topView.areaImage.hidden = YES;
//    _topView.eventImage.hidden = YES;
//    _topView.searchImage.hidden = YES;
//}
// 页面即将消失时 View收回
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
    _ispush = YES;
    if (_typeView.hidden == NO || _searchView.hidden == NO || _areaView.hidden == NO) {
        _typeView.hidden = YES;
        _searchView.hidden = YES;
        _areaView.hidden = YES;
    }
    _topView.areaImage.hidden = YES;
    _topView.eventImage.hidden = YES;
    _topView.searchImage.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isReduction" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    timeCount = 1;
    timeResult = 1;
    
    // 网络请求相关
    _initPage = 2;
    _isUp = NO;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isAreaRow"] != nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"] != nil) {
        
        areaRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"];
        areaWai = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"];
        if (areaRow.length > 0 && areaWai > 0) {
            if (![areaRow isEqualToString:@"0"] && ![areaWai isEqualToString:@"0"]) {
                _cityId = [areaRow stringByAppendingString:[NSString stringWithFormat:@",%@", areaWai]];
            }
        }else if (areaRow.length > 0 && ![areaRow isEqualToString:@"0"]){
            _cityId = areaRow;
        }else if (areaWai.length > 0 && ![areaWai isEqualToString:@"0"]){
            _cityId = areaWai;
        }
    }else{
        _cityId = @"";
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isTypeRow"] != nil) {
        _typeId = [[NSUserDefaults standardUserDefaults] objectForKey:@"isTypeRow"];
    }else{
        _typeId = @"";
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isSearchRow"] != nil) {
        _searchId = [[NSUserDefaults standardUserDefaults]objectForKey:@"isSearchRow"];
    }else{
        _searchId = @"";
    }
    
    [self tableViewRefresh];
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_dialogView];
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    // 请求数据
    [self getData];
}

#pragma mark - 添加控件
- (void)addViews
{
    [self.view addSubview:self.topView];
//    [self.view addSubview:self.areaView];
//    [self.view addSubview:self.typeView];
//    [self.view addSubview:self.searchView];
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到窗口
    [window addSubview:self.areaView];
    [window addSubview:self.typeView];
    [window addSubview:self.searchView];
}
#pragma mark - 计算View高度
- (void)viewHeight
{
    // 地区选择高度
    if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        _areaNum = 4;
    }else{
        _areaNum = 3;
    }
    if (self.areaCount % _areaNum != 0) {
        _areaHeight = ((self.areaCount / _areaNum) + 1) * 35 + 10;
    }else{
        _areaHeight = (self.areaCount / _areaNum) * 35 + 10;
    }
    // 赛事类型高度
    if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        _typeNum = 4;
    }else{
        _typeNum = 3;
    }
    if (self.typeArray.count % _typeNum != 0) {
        _typeHeight = ((self.typeArray.count / _typeNum) + 1) * 35 + 10;
    }else{
        _typeHeight = (self.typeArray.count / _typeNum) * 35 + 10;
    }
    // 赛事查询高度
    if (self.searchArray.count % 3 != 0) {
        _searchHeight = ((self.searchArray.count / 3) + 1) * 35 + 10;
    }else{
        _searchHeight = (self.searchArray.count / 3) * 35 + 10;
    }
    
    [self addViews];
}
#pragma mark - 懒加载
- (EventsTopView *)topView
{
    if (!_topView) {
        _topView = [EventsTopView new];
        _topView.delegate = self;
    }
//    if (_areaArray.count != 0 && _typeArray.count != 0 && _searchArray.count != 0) {
//        EventsCityModel *city = _areaArray[0];
//        EventsTypeModel *type = _typeArray[0];
//        EventsSelectModel *search = _searchArray[0];
//        [_topView.areaButton setTitle:city.tName forState:UIControlStateNormal];
//        [_topView.eventTypeButton setTitle:type.tName forState:UIControlStateNormal];
//        [_topView.searchButton setTitle:search.tName forState:UIControlStateNormal];
//    }
    return _topView;
}

- (EventsAreaChooseView *)areaView
{
    if (!_areaView) {
        _areaView = [EventsAreaChooseView new];
        _areaView.areaDelegate = self;
        _areaView.hidden = YES;
    }
    if (_areaNArray.count != 0) {
        _areaView.dataSource = _areaNArray;
        _areaView.areaHeight = _areaHeight;
    }
    if (_areaWArray.count != 0) {
        _areaView.WArray = _areaWArray;
    }
    return _areaView;
}

- (EventsTypeChooseView *)typeView
{
    if (!_typeView) {
        _typeView = [EventsTypeChooseView new];
        _typeView.hidden = YES;
        _typeView.typeDelegate = self;
    }
    if (_typeArray.count != 0) {
        _typeView.dataSource = _typeArray;
        _typeView.typeHeight = _typeHeight;
    }
    return _typeView;
}

- (EventsSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [EventsSearchView new];
        _searchView.hidden = YES;
        _searchView.searchDelegate = self;
    }
    if (_searchArray.count != 0) {
        _searchView.dataSource = _searchArray;
        _searchView.searchHeight = _searchHeight;
    }
    return _searchView;
}

// 让3个View到前面
- (void)bringView
{
//    [self.view bringSubviewToFront:_searchView];
//    [self.view bringSubviewToFront:_areaView];
//    [self.view bringSubviewToFront:_typeView];
}

#pragma mark - topView 按钮点击代理事件
- (void)AreaClickDelegateSelected:(NSString *)str
{
    if ([str isEqualToString:@"1"]) {
        _typeView.hidden = YES;
        _searchView.hidden = YES;
        _areaView.hidden = NO;
        _areaView.alpha = 1.0;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isTypeRow"] != nil) {
            NSDictionary *dic;
            dic = @{@"TypeRow":str};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isTypeColor" object:dic];
        }else{
            NSDictionary *dic;
            dic = @{@"TypeRow":@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isTypeColor" object:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"typeReload" object:nil];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isSearchRow"] != nil) {
            NSDictionary *dic;
            dic = @{@"searchRow":str};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchColor" object:dic];
        }else{
            NSDictionary *dic;
            dic = @{@"searchRow":@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchColor" object:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchReload" object:nil];
        }
    }else{
        [UIView animateWithDuration:0.7f animations:^{
            _areaView.alpha = 0.0;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _areaView.hidden = YES;
        });
    }
}
- (void)TypeClickDelegateSelected:(NSString *)str
{
    if ([str isEqualToString:@"1"]) {
        _searchView.hidden = YES;
        _areaView.hidden = YES;
        _typeView.hidden = NO;
        _typeView.alpha = 1.0;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isAreaRow"] != nil) {
            NSDictionary *dic;
            dic = @{@"areaRow":str};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isAreaColor" object:dic];
        }else{
            NSDictionary *dic;
            dic = @{@"areaRow":@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isAreaColor" object:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"areaReload" object:nil];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isSearchRow"] != nil) {
            NSDictionary *dic;
            dic = @{@"searchRow":str};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchColor" object:dic];
        }else{
            NSDictionary *dic;
            dic = @{@"searchRow":@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchColor" object:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchReload" object:nil];
        }
    }else{
        [UIView animateWithDuration:0.7f animations:^{
            _typeView.alpha = 0.0;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _typeView.hidden = YES;
        });
    }
}

- (void)SearchClickDelegateSelected:(NSString *)str
{
    if ([str isEqualToString:@"1"]) {
        _searchView.hidden = NO;
        _searchView.alpha = 1.0;
        _typeView.hidden = YES;
        _areaView.hidden = YES;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isAreaRow"] != nil) {
            NSDictionary *dic;
            dic = @{@"areaRow":str};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isAreaColor" object:dic];
        }else{
            NSDictionary *dic;
            dic = @{@"areaRow":@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isAreaColor" object:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"areaReload" object:nil];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isTypeRow"] != nil) {
            NSDictionary *dic;
            dic = @{@"TypeRow":str};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isTypeColor" object:dic];
        }else{
            NSDictionary *dic;
            dic = @{@"TypeRow":@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isTypeColor" object:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"typeReload" object:nil];
        }
    }else{
        [UIView animateWithDuration:0.7f animations:^{
            _searchView.alpha = 0.0;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _searchView.hidden = YES;
        });
    }
}

#pragma mark - colletV 列表代理
/** 地区选择*/
- (void)AreadidSelectTId:(NSString *)tId
{
    NSLog(@"areaView代理 tid = %@", tId);
    _initPage = 1;
    _isUp = NO;
    _cityId = tId;
    [self getDataPage:[NSString stringWithFormat:@"%zd", _initPage] AreaCity:_cityId EventsType:_typeId Search:_searchId];
    [UIView animateWithDuration:0.7f animations:^{
        _areaView.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _areaView.hidden = YES;
        _topView.areaImage.hidden = YES;
        _topView.areaButton.selected = NO;
        [_topView Area:tId];
    });
}

/** 赛事类型*/
- (void)TypedidSelectTId:(NSString *)tId
{
    NSLog(@"areaView代理 tid = %@", tId);
    _initPage = 1;
    _typeId = tId;
    _isUp = NO;
    [self getDataPage:[NSString stringWithFormat:@"%zd", _initPage] AreaCity:_cityId EventsType:_typeId Search:_searchId];
    [UIView animateWithDuration:0.7f animations:^{
        _typeView.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _typeView.hidden = YES;
        _topView.eventImage.hidden = YES;
        _topView.eventTypeButton.selected = NO;
        [_topView Type:tId];
    });
}

/** 快捷查询*/
- (void)SearchdidSelectTId:(NSString *)tId
{
    NSLog(@"searchView代理 tid = %@", tId);
    _initPage = 1;
    _searchId = tId;
    _isUp = NO;
    [self getDataPage:[NSString stringWithFormat:@"%zd", _initPage] AreaCity:_cityId EventsType:_typeId Search:_searchId];
    [UIView animateWithDuration:0.7f animations:^{
        _searchView.alpha = 0.0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.0s后自动执行这个block里面的代码
        _searchView.hidden = YES;
        _topView.searchImage.hidden = YES;
        _topView.searchButton.selected = NO;
        [_topView Search:tId];
    });
}

#pragma mark - 点击空白处透明View 让Collection返回
- (void)AreaCollectBackStatus:(NSString *)status
{
    [UIView animateWithDuration:0.7f animations:^{
        _areaView.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _areaView.hidden = YES;
        _topView.areaImage.hidden = YES;
        _topView.areaButton.selected = NO;
    });
    // 是1则重置
    if ([status isEqualToString:@"1"]) {
        _initPage = 1;
        _cityId = @"";
        _isUp = NO;
        [self getDataPage:[NSString stringWithFormat:@"%zd", 1] AreaCity:@"" EventsType:_typeId Search:_searchId];
    }
}
- (void)TypeCollectBackStatus:(NSString *)status
{
    [UIView animateWithDuration:0.7f animations:^{
        _typeView.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _typeView.hidden = YES;
        _topView.eventImage.hidden = YES;
        _topView.eventTypeButton.selected = NO;
//        _topView.eventTypeButton.backgroundColor = [UIColor whiteColor];
    });
    // 是1则重置
    if ([status isEqualToString:@"1"]) {
        _initPage = 1;
        _typeId = @"";
        _isUp = NO;
        [self getDataPage:[NSString stringWithFormat:@"%zd", 1] AreaCity:_cityId EventsType:@"" Search:_searchId];
    }
}
- (void)SearchCollectBackStatus:(NSString *)status
{
    [UIView animateWithDuration:0.7f animations:^{
        _searchView.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _searchView.hidden = YES;
        _topView.searchImage.hidden = YES;
        _topView.searchButton.selected = NO;
//        _topView.searchButton.backgroundColor = [UIColor whiteColor];
    });
    // 是1则重置
    if ([status isEqualToString:@"1"]) {
        _initPage = 1;
        _searchId = @"";
        _isUp = NO;
        [self getDataPage:[NSString stringWithFormat:@"%zd", 1] AreaCity:_cityId EventsType:_typeId Search:@""];
    }
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
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(50);
        }];
        _mytableView.rowHeight = 205;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mytableView registerClass:[EventsHomeCell class] forCellReuseIdentifier:@"cell"];
    }
    return _mytableView;
}

// 开始拖拽tableView时触发
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (_typeView.hidden == NO || _searchView.hidden == NO || _areaView.hidden == NO) {
        _typeView.hidden = YES;
        _searchView.hidden = YES;
        _areaView.hidden = YES;
        _topView.areaImage.hidden = YES;
        _topView.eventImage.hidden = YES;
        _topView.searchImage.hidden = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    EventsHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.eventsModel = [_dataArray objectAtIndex:indexPath.row];
    
    if ([cell.eventsModel.tGameState isEqualToString:@"4"] || [cell.eventsModel.tGameState isEqualToString:@"3"]) {
        cell.status.text = @"";
        cell.status.hidden = YES;
        cell.theEnd.hidden = NO;
        cell.theEnd.text = cell.eventsModel.tGameStateInfo;
    }else{
//        NSString *tempStr = [[NSString stringWithFormat:@"%@... ...", cell.eventsModel.tGameStateInfo] substringWithRange:NSMakeRange(0, timeResult + 5)];
        cell.status.text = cell.eventsModel.tGameStateInfo;
        cell.status.hidden = NO;
        cell.theEnd.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 松手取消选中色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"index = %@", indexPath);
    EventsModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    ENWebViewController *webVC = [ENWebViewController new];
    webVC.htmlUrl = model.tInfoUrl;
    webVC.tEnterUrl = model.tEnterUrl;
    webVC.tId = model.tId;
    webVC.tType = @"0";
    webVC.tIsLink = model.tIsLink;
    webVC.tLink = model.tLink;
    webVC.tIsManyPeopleEnter = model.isManyPeopleEnter;
    // 分享用属性
    webVC.fxTitle = model.tGameName;
    webVC.content = model.gettIntroduction;
    webVC.fxImg = model.tImgPath;
    [self.navigationController pushViewController:webVC animated:YES];
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
    NSlog(@"%@", [NSThread currentThread]);
}

#pragma mark - masonry
- (void)viewWillLayoutSubviews
{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];

    [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(@114);
        make.bottom.mas_equalTo(0);
        //        make.height.mas_equalTo(_areaHeight);
    }];
    
    [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(@114);
        make.bottom.mas_equalTo(0);
        //        make.height.mas_equalTo(_typeHeight);
    }];
    
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(@114);
        make.bottom.mas_equalTo(0);
        //        make.height.mas_equalTo(_searchHeight);
    }];
    
//    [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.equalTo(@50);
//        make.bottom.mas_equalTo(0);
////        make.height.mas_equalTo(_areaHeight);
//    }];
//    
//    [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.equalTo(@50);
//        make.bottom.mas_equalTo(0);
////        make.height.mas_equalTo(_typeHeight);
//    }];
//    
//    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.equalTo(@50);
//        make.bottom.mas_equalTo(0);
////        make.height.mas_equalTo(_searchHeight);
//    }];
    [super viewWillLayoutSubviews];
}

#pragma mark - 设置导航控制器
- (void)setNavigationController
{
    // 导航栏颜色
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"樱桃体育" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    // 设置导航栏左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_navigation_left" highImage:@"news_navigation_left" target:self action:@selector(SearchClick)];
    // 设置导航栏右侧按钮
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"news_navgation_right" highImage:@"news_navgation_right" target:self action:@selector(SettingClick)];
}

#pragma mark - 设置按钮
- (void)SettingClick
{
    NSLog(@"赛事设置");
    MineSettingViewController *settingVC = [MineSettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - 搜索按钮
- (void)SearchClick
{
    if (_typeView.hidden == NO || _searchView.hidden == NO || _areaView.hidden == NO) {
        _typeView.hidden = YES;
        _searchView.hidden = YES;
        _areaView.hidden = YES;
    }
    _topView.areaImage.hidden = YES;
    _topView.eventImage.hidden = YES;
    _topView.searchImage.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isReduction" object:nil];
    DKBSearchViewController *searchVC =[[DKBSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    NSLog(@"赛事搜索");
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
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isAreaRow"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isWRow"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isTypeRow"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isSearchRow"];
        _cityId = @"";
        _typeId = @"";
        _searchId = @"";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isReduction" object:nil];
        [weakSelf getDataPage:[NSString stringWithFormat:@"%zd", 1] AreaCity:_cityId EventsType:_typeId Search:_searchId];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置header
    self.mytableView.mj_header = header;
    
    _mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUp = YES;
        
        [self getDataPage:[NSString stringWithFormat:@"%zd", _initPage] AreaCity:_cityId EventsType:_typeId Search:_searchId];
    }];
}

#pragma mark - 请求赛事页数据
- (void)getData{
    
    NSString *url = [NSString stringWithFormat:@"%@/games/selectGamesIndex", SERVER_URL];
    
    [ServerUtility POSTAction:url param:nil target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
//            NSlog(@"请求赛事大集合成功----> obj = %@", obj);
            NSLog(@"9.47请求赛事大集合成功----> obj = %@", obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"regionQryTypePoList"] != nil && [obj objectForKey:@"gameTypePoList"] != nil && [obj objectForKey:@"quickQueryList"] != nil && [obj objectForKey:@"gamesPoList"] != nil) {
                
                //判断如果不是上拉加载，就先清空数据集dataArray
                if (!self.isUp) {
                    _areaWArray = [[NSMutableArray alloc] init];
                    _areaNArray = [[NSMutableArray alloc] init];
                    _areaALLArray = [[NSMutableArray alloc] init];
                    _typeArray = [[NSMutableArray alloc] init];
                    _searchArray = [[NSMutableArray alloc] init];
                    _dataArray = [[NSMutableArray alloc] init];
                }
                
                // 城市信息
                NSMutableArray *addArray = [obj objectForKey:@"regionQryTypePoList"];
                if (![addArray isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in addArray) {
                        EventAddress *model = [EventAddress mj_objectWithKeyValues:dic];
                        [_areaALLArray addObject:model];
                        if (![model.regionPoList isEqual:[NSNull null]] && [model.tId isEqualToString:@"232"]) {
                            for (NSDictionary *dic in model.regionPoList) {
                                EventsCityModel *Nmodel = [EventsCityModel mj_objectWithKeyValues:dic];
                                [_areaNArray addObject:Nmodel];
                            }
                        }else if (![model.regionPoList isEqual:[NSNull null]] && ![model.tId isEqualToString:@"232"]){
                            for (NSDictionary *dic in model.regionPoList) {
                                EventsCityModel *Nmodel = [EventsCityModel mj_objectWithKeyValues:dic];
                                [_areaWArray addObject:Nmodel];
                            }
                        }
                    }
                }
                _areaCount = _areaNArray.count + _areaWArray.count;
                
                // 赛事类型
                if (![[obj objectForKey:@"gameTypePoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"gameTypePoList"]) {
                        EventsTypeModel *typeModel = [EventsTypeModel mj_objectWithKeyValues:dic];
                        [self.typeArray addObject:typeModel];
                    }
                }
                
                // 快捷查询
                if (![[obj objectForKey:@"quickQueryList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"quickQueryList"]) {
                        EventsSelectModel *searchModel = [EventsSelectModel mj_objectWithKeyValues:dic];
                        [self.searchArray addObject:searchModel];
                    }
                }
                // 获取系统当前时间
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a = [dat timeIntervalSince1970]*1000;
//                NSInteger systime = a;
                NSLog(@"请求成功获取当前系统时间 = %zd", a);
                // 赛事集合
                if (![[obj objectForKey:@"gamesPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"gamesPoList"]) {
                        EventsModel *eventModel = [EventsModel mj_objectWithKeyValues:dic];
                        eventModel.endMilli = a + eventModel.countDownMilli;
                        [self.dataArray addObject:eventModel];
                    }
                }
                
            }else{
                // 程序异常时
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            
            // 请求成功计算则每个View的高度
            [self viewHeight];
            // 调用[kCountDownManager reload]
//            [kCountDownManager reload];
            if (_cityId.length > 0 || _typeId.length > 0 || _searchId.length > 0) {
                [self getDataPage:[NSString stringWithFormat:@"%zd", 1] AreaCity:_cityId EventsType:_typeId Search:_searchId];
            }else{
                [_dialogView removeFromSuperview];
                // 刷新
                [self.mytableView reloadData];
                NSlog(@"%@", [NSThread currentThread]);
            }
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_mytableView.mj_header endRefreshing];
            [_mytableView.mj_footer endRefreshing];
        }else {
            NSLog(@"%@",error);
            [_mytableView.mj_header endRefreshing];
            [_mytableView.mj_footer endRefreshing];
            if (error.code == 100) {
                [_dialogView bringSubviewToFront:_dialogView.noNetworkView];
                NSLog(@"100");
                [_dialogView.noNetworkRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                NSLog(@"200");
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
}

/** 分页查询赛事接口*/
- (void)getDataPage:(NSString *)page AreaCity:(NSString *)city EventsType:(NSString *)eventsType Search:(NSString *)search{
    
    NSDictionary *pageDic = @{@"dicKey":@"page", @"data":page};
    NSDictionary *tCityDic = @{@"dicKey":@"tCity", @"data":city};
    NSDictionary *tGameDic = @{@"dicKey":@"tGameType", @"data":eventsType};
    NSDictionary *tGameStateDic = @{@"dicKey":@"tGameState", @"data":search};
    
    NSArray *postArr = @[pageDic, tCityDic, tGameDic, tGameStateDic];
    
    NSString *url = [NSString stringWithFormat:@"%@/games/selectGames", SERVER_URL];
    
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
            [_dialogView removeFromSuperview];
            NSlog(@"News成功----> obj = %@", obj);
//            NSLog(@"code = %@", [obj objectForKey:@"resultCode"]);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"gamesPoList"] != nil) {
                // 成功remove
                [_dialogView removeFromSuperview];
                if (!self.isUp) {
                    self.dataArray = [[NSMutableArray alloc] init];
                }
                
                // 获取系统当前时间
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a = [dat timeIntervalSince1970]*1000;
//                NSInteger systime = (NSInteger)a;
//                NSLog(@"请求成功获取当前系统时间 = %zd", systime);
                
                NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
                // 赛事集合   是否显示多人报名
                if (![[obj objectForKey:@"gamesPoList"] isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"gamesPoList"]) {
                        EventsModel *eventModel = [EventsModel mj_objectWithKeyValues:dic];
                        eventModel.endMilli = a + eventModel.countDownMilli;
                        [self.dataArray addObject:eventModel];
                        [sizeArray addObject:eventModel];
                    }
                }
                
                if (sizeArray.count == 0 && !_isUp) {
                    [self dialog];
                    [_dialogView bringSubviewToFront:_dialogView.nothingImageView];
                    _dialogView.nothingRefreshButton.hidden = YES;
                    [self bringView];
                    
                }else if (sizeArray.count < [[obj objectForKey:@"size"] integerValue]) {
                    _mytableView.mj_footer.hidden = YES;
                }else{
                    _mytableView.mj_footer.hidden = NO;
                    _initPage = _initPage + 1;
                }
            }else{
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
                [self bringView];
            }
            [self.mytableView reloadData];
            NSlog(@"%@", [NSThread currentThread]);
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
                [self bringView];
            } else {
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
                [self bringView];
            }
        }
    }];
}

- (void)dialog
{
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_dialogView];
}


// 无网络刷新
- (void)btn {
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    [self bringView];
    _initPage = 2;
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
