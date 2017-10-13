//
//  NewsTextScro.m
//  CherrySports
//
//  Created by dkb on 16/12/18.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "NewsTextScro.h"
#import "NewsTypeModel.h"

#import "MineSettingViewController.h"
#import "DKBSearchViewController.h"
#import "NewsTextList.h"

#import "ZJScrollPageView.h"

@interface NewsTextScro ()<ZJScrollPageViewDelegate>
/**页面加载图**/
@property (nonatomic, strong) DialogView *dialogView;

@property (nonatomic, strong) NSMutableArray *tagArr;

@property (nonatomic, assign) CGFloat corWidth;
/** 右侧按钮*/
@property (nonatomic, strong) UIImageView *moreImage;

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;
/** <#注释#>*/
@property (nonatomic, strong) ZJSegmentStyle *style;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation NewsTextScro

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    STATUS_WIHTE
    // 布局导航控制器
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACK_GROUND_COLOR;
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    _style = [[ZJSegmentStyle alloc] init];
    
    _style.contentViewBounces = NO;
    // 设置滚动条高度
    _style.segmentHeight = 43;
    //显示遮盖
    _style.showCover = YES;
    // 遮盖的高度
    _style.coverHeight = 30;
    // 遮盖圆角
    _style.coverCornerRadius = 5;
    // 字体大小
    _style.titleFont = [UIFont systemFontOfSize:14];
    // 遮盖颜色
    _style.coverBackgroundColor = NAVIGATIONBAR_COLOR;
    // 标题一般状态时的颜色
    _style.normalTitleColor = TEXT_COLOR_DARK;
    // 标题选中状态颜色
    _style.selectedTitleColor = [UIColor whiteColor];
    // 标题间隔
    _style.titleMargin = 15;

    
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_dialogView];
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    // 标签请求数据
    [self getTagData];
}


#pragma mark -请求标签数据
- (void)getTagData{
    NSString *url = [NSString stringWithFormat:@"%@/news/selectNewsType",SERVER_URL];
    [ServerUtility POSTAction:url param:nil target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error ==nil) {
            //            NSLog(@"请求成功news-----obj====%@",obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"] && [obj objectForKey:@"newsPoList"] != nil && [obj objectForKey:@"newsPoList"] != nil) {
                NSLog(@"请求条件符合");
                // 初始化标签数组
                self.tagArr = [NSMutableArray array];
                // 赛事集合
                NSMutableArray *array = [[NSMutableArray alloc] init];
                NSMutableArray *titleArr = [[NSMutableArray alloc] init];
                if (![array isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"newsPoList"]) {
                        NewsTypeModel *typeModel = [NewsTypeModel mj_objectWithKeyValues:dic];
                        [self.tagArr addObject:typeModel];
                        [titleArr addObject:typeModel.tName];
                    }
                }
                self.titles = titleArr;
                // 初始化
                if (!_scrollPageView) {
                    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) segmentStyle:_style titles:self.titles parentViewController:self delegate:self];
                    scrollPageView.backgroundColor = BACK_GROUND_COLOR;
                    [self.view addSubview:scrollPageView];
                }
            }else{
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            // 请求数据成功创建标签按钮和列表scrollView
            [self createSmallScro];
//            [self makeTagButton];
//            [self makeContentList];
        }else{
            NSLog(@"error ==%@",error);
            if (error.code == 100) {
                [_dialogView bringSubviewToFront:_dialogView.noNetworkView];
                [_dialogView.noNetworkRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
    }];
}
- (void)createSmallScro
{
    // 右侧按钮
    if (!_moreImage) {
        _moreImage = [AppTools CreateImageViewImageName:@"news_smalScro_RightBtn-1"];
        [self.view addSubview:_moreImage];
        [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.width.mas_equalTo(45.5);
            make.height.mas_offset(43);
        }];
    }
}

- (NSInteger)numberOfChildViewControllers
{
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        NewsTextList *list = [[NewsTextList alloc] init];
        list.btnArr = _tagArr;
        childVc = list;
    }
    
    
    return childVc;
}


- (void)btn {
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    // 请求数据
    [self getTagData];
}


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
    NSLog(@"资讯设置");
    MineSettingViewController *settingVC = [MineSettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - 搜索按钮
- (void)SearchClick
{
    DKBSearchViewController *searchVC =[[DKBSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    NSLog(@"资讯搜索");
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
