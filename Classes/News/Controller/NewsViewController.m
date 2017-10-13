//
//  NewsViewController.m
//  CherrySports
//
//  Created by dkb on 16/10/26.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - 导航条VC
#import "NewsViewController.h"
#import "NewsScrollListViewController.h"
#import "NewsTypeModel.h"
#import "BackView.h"

#import "MineSettingViewController.h"
#import "DKBSearchViewController.h"

@interface NewsViewController ()<UIScrollViewDelegate>
/**页面加载图**/
@property (nonatomic, strong) DialogView *dialogView;
@property (nonatomic, strong) UIScrollView *smallScrollV;
@property (nonatomic, strong) UIScrollView *bigScrollV;
@property (nonatomic, strong) NSMutableArray *tagArr;
@property (nonatomic, strong) UIView *corV;
@property (nonatomic, assign) NSInteger currTag;
@property (nonatomic, strong) UIView *smallSubV;
@property (nonatomic, strong) UIView *kongV;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) BackView *backView;
@property (nonatomic, strong) UIView *corView;
@property (nonatomic, strong) UIImageView *jianView;
@property (nonatomic, assign) CGFloat corWidth;
/** 右侧按钮*/
@property (nonatomic, strong) UIImageView *moreImage;
@end

@implementation NewsViewController

-(void)dealloc
{
    _bigScrollV.delegate = nil;
}

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
    self.view.backgroundColor = [UIColor whiteColor];
//    self.tagArr = [NSMutableArray arrayWithObjects:@"足球咨询", @"马拉松咨询", @"网球咨询", @"篮球咨询", @"乒乓球咨询", @"羽毛球咨询",@"马拉松咨询", @"网球咨询", @"篮球咨询", @"乒乓球咨询", @"羽毛球咨询", nil];
    
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
                if (![array isEqual:[NSNull null]]) {
                    for (NSDictionary *dic in [obj objectForKey:@"newsPoList"]) {
                        NewsTypeModel *typeModel = [NewsTypeModel mj_objectWithKeyValues:dic];
                        [self.tagArr addObject:typeModel];
                    }
                }
                
            }else{
                [_dialogView bringSubviewToFront:_dialogView.excptionView];
                [_dialogView.excptionRefreshButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            // 请求数据成功创建标签按钮和列表scrollView
            [self createSmallScro];
            [self makeTagButton];
            [self makeContentList];
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

- (void)btn {
    [_dialogView bringSubviewToFront:_dialogView.loadingView];
    [_dialogView runAnimationWithCount:3 name:@"loading"];
    // 请求数据
    [self getTagData];
}

- (void)createSmallScro
{
    // 右侧按钮
    if (!_moreImage) {
        _moreImage = [AppTools CreateImageViewImageName:@"collection"];
        [self.view addSubview:_moreImage];
        [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.width.mas_equalTo(36.5);
            make.height.mas_offset(33);
        }];
    }
    
    // 上方滑动的小的scrollview
    if (!_smallScrollV) {
        self.smallScrollV = [UIScrollView new];
        _smallScrollV.showsHorizontalScrollIndicator = NO;
        _smallScrollV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_smallScrollV];
        [_smallScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(@0);
            make.height.mas_equalTo(@39);
            make.right.equalTo(_moreImage.mas_left);
        }];
    }
    
    // 红线
    if (!_kongV) {
        _kongV = [UIView new];
        _kongV.backgroundColor = [UIColor colorWithRed:0.73 green:0.05 blue:0.14 alpha:1.00];
        [self.view addSubview:_kongV];
        [_kongV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.equalTo(_smallScrollV).offset(-4.5);
            make.height.mas_offset(1.5);
        }];
    }
    
    // 下面大的列表scrollview
    if (!_bigScrollV) {
        self.bigScrollV = [UIScrollView new];
        _bigScrollV.delegate = self;
        _bigScrollV.pagingEnabled = YES;
        _bigScrollV.showsHorizontalScrollIndicator = NO;
        _bigScrollV.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        [self.view addSubview:_bigScrollV];
        [_bigScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.equalTo(_smallScrollV.mas_bottom);
            
        }];
    }
}

// 创建标签按钮
- (void)makeTagButton{
    // 通过在scrollview上放个view，用view来约束scrollview的contentSize
    if (!_smallSubV)
    {
        _smallSubV = [UIView new];
        _smallSubV.backgroundColor = [UIColor whiteColor];
        [_smallScrollV addSubview:_smallSubV];
        [_smallSubV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_smallScrollV);
            make.height.equalTo(_smallScrollV);
            
        }];
        
        // 作为一个中间变量来接收上一个控件
        UIButton *lastBtn = nil;
        for (int i = 0; i < _tagArr.count; i++) {
            
            // 循环创建标签按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1000 + i;
            // 计算文字大小
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
            CGFloat length = [[_tagArr[i] tName] boundingRectWithSize:CGSizeMake(138, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            NSLog(@"length = %f", length);
            if ([_tagArr[i] tName].length < 4) {
                length = length + 5;
            }
            [btn setTitle:[_tagArr[i] tName] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            if (btn.tag == 1000) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [btn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                _backView = [BackView new];
                [_smallSubV addSubview:_backView];
                [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(_smallSubV);
                    make.top.mas_equalTo(_smallSubV).mas_offset(9);
                    make.left.mas_equalTo(_smallSubV).mas_offset(8);
                }];
                [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(length+10);
                }];
                
                //        _jianView = [AppTools CreateImageViewImageName:@"news_back_jian"];
            }
            [_smallSubV addSubview:btn];
            // 标题向下偏移
            CGFloat interval = 12.0;
            btn.titleEdgeInsets = UIEdgeInsetsMake(interval, 0, 0, 0);
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_smallScrollV);
                make.bottom.equalTo(_smallScrollV).offset(-8);
                make.width.mas_equalTo(length + 5);
                if (lastBtn) {
                    make.left.mas_equalTo(lastBtn.mas_right).offset(5);
                } else {
                    make.left.mas_equalTo(10);
                }
                
            }];
            // 将控件给中间变量，然后根据中间变量来控制下一个控件的位置
            lastBtn = btn;
            
            //            [corView mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.left.equalTo(btn.mas_left);
            //                make.width.equalTo(btn.mas_width);
            //
            //            }];
        } // 循环结束
        // 最后一个控件结束时，确定view的大小，也就确定了scrollview的contentSize
        [_smallSubV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(lastBtn.mas_right).offset(10);
            
        }];
    }
}

// 创建列表scrollview
- (void)makeContentList{
    UIView *bigSubV = [UIView new];
    bigSubV.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
    [_bigScrollV addSubview:bigSubV];
    [bigSubV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bigScrollV);
        make.height.equalTo(_bigScrollV);
    }];
    
    // 创建中间变量
    UIView *lastV = nil;
    for (int i = 0; i < _tagArr.count; i++) {
        NewsScrollListViewController *newsListVC = [NewsScrollListViewController new];
        newsListVC.model = _tagArr[i];
        newsListVC.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        //                newsListVC.cateTag = _tagArr[i];
        [bigSubV addSubview:newsListVC.view];
        // 当tableView点击就消失的时候,加这行代码
        [self addChildViewController:newsListVC];
        [newsListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bigScrollV);
            make.width.equalTo(_bigScrollV);
            if (lastV) {
                make.left.equalTo(lastV.mas_right);
            } else {
                make.left.mas_offset(0);
            }
            
        }];
        
        
        lastV = newsListVC.view;
    }
    // 同理上一个scrollview
    [bigSubV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastV.mas_right);
        
    }];
}

// 标签按钮点击方法，下面列表scrollview联动
- (void)btnAction:(UIButton *)btn{
    NSLog(@"111");
    CGFloat offset = self.smallScrollV.contentSize.width - self.smallScrollV.bounds.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        if (!IS_IPHONE_6Plus) {
            if (_smallScrollV.contentSize.width > SCREEN_WIDTH) {
                if (btn.tag%1000 < _tagArr.count - 3){
                    if (IS_IPHONE_5 || IS_IPHONE_4) {
                        _smallScrollV.contentOffset = CGPointMake(btn.frame.origin.x-5.5, 0);
                    }else{
                        // iphone 6
                        _smallScrollV.contentOffset = CGPointMake(btn.frame.origin.x-5, 0);
                    }
            }
            }else{
                if (offset > 0)
                {
                    if (_smallScrollV.contentSize.width > SCREEN_WIDTH) {
                    }
                    if (IS_IPHONE_4 || IS_IPHONE_5) {
                        [self.smallScrollV setContentOffset:CGPointMake(offset-5, 0) animated:YES];
                    }else{
                        // iphone 6
                        [self.smallScrollV setContentOffset:CGPointMake(offset-17, 0) animated:YES];
                    }
                }
            }
        }else{
            if (_smallScrollV.contentSize.width > SCREEN_WIDTH) {
                // plus 逻辑
                if (btn.tag%1000 < _tagArr.count - 4) {
                    _smallScrollV.contentOffset = CGPointMake(btn.frame.origin.x-13, 0);
                }else{
                    [self.smallScrollV setContentOffset:CGPointMake(offset, 0) animated:YES];
                }
            }
        }
        
        // 告诉self.view约束需要更新
        [self.view setNeedsUpdateConstraints];
        // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        [self.view updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(btn.frame.size.width);
                make.left.mas_equalTo(btn.frame.origin.x);
            }];
            [self.view layoutIfNeeded];
        }];
        
        _bigScrollV.contentOffset = CGPointMake(SCREEN_WIDTH * (btn.tag % 1000), 0);
    }];
    
    // 延迟0.3秒在变色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < _tagArr.count; i++) {
            UIButton *button = [self.view  viewWithTag:i + 1000];
            if (button.tag == btn.tag) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
            }
        }
    });
}

//// 滑动列表scrollview的时候，上面标签scrollview联动
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    CGFloat tmp = _bigScrollV.contentOffset.x / SCREEN_WIDTH;
//    NSLog(@"tem = %f", tmp);
//    for (int i = 0; i < _tagArr.count; i++) {
//        UIButton *button = [self.view  viewWithTag:i + 1000];
//        if (button.tag == tmp + 1000) {
//            if (tmp > 1 && tmp != _tagArr.count) {
//                [UIView animateWithDuration:0.5 animations:^{
//                    UIButton *btn = [self.view  viewWithTag:i + 1000 - 1];
//                    if (IS_IPHONE_5 || IS_IPHONE_6) {
//                        if (tmp <= _tagArr.count - 3) {
//                            _smallScrollV.contentOffset = CGPointMake(btn.frame.origin.x - 5, 0);
//                        }
//                    }else{
//                        if (tmp < _tagArr.count - 2) {
//                            _smallScrollV.contentOffset = CGPointMake(btn.frame.origin.x - 5, 0);
//                        }
//                    }
//                }];
//            }else if(tmp != _tagArr.count){
//                [UIView animateWithDuration:0.5 animations:^{
//                    _smallScrollV.contentOffset = CGPointMake(0, 0);
//
//                }];
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            });
//            [UIView animateWithDuration:0.5 animations:^{
//
//                _corView.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y+9, button.frame.size.width, button.frame.size.height-1);
//                //                _corView.center = button.center;
//            }];
//        } else {
//            [button setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
//        }
//    }
//}

// 滑动列表scrollview的时候，上面标签scrollview联动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat tmp = _bigScrollV.contentOffset.x / SCREEN_WIDTH;
    NSLog(@"_ssss = %f", _smallScrollV.contentSize.width);
    NSLog(@"tem = %f", tmp);
    for (int i = 0; i < _tagArr.count; i++) {
        UIButton *button = [self.view  viewWithTag:i + 1000];
        if (button.tag == tmp + 1000) {
            if (tmp > 1 && tmp != _tagArr.count) {
                [UIView animateWithDuration:0.5 animations:^{
                    UIButton *btn = [self.view  viewWithTag:i + 1000 - 1];
                    if (IS_IPHONE_4 ||IS_IPHONE_5) {
                        if (_smallScrollV.contentSize.width > SCREEN_WIDTH) {
                            if (tmp >= _tagArr.count - 3) {
                                CGFloat offset = self.smallScrollV.contentSize.width - self.smallScrollV.bounds.size.width;
                                _smallScrollV.contentOffset = CGPointMake(offset-5, 0);
                            }else if (tmp < _tagArr.count - 3) {
                                _smallScrollV.contentOffset = CGPointMake(btn.frame.origin.x - 5, 0);
                            }
                        }
                    }else if (IS_IPHONE_6Plus){
                        if (_smallScrollV.contentSize.width > SCREEN_WIDTH) {
                            if (tmp >= _tagArr.count - 3) {
                                CGFloat offset = self.smallScrollV.contentSize.width - self.smallScrollV.bounds.size.width;
                                _smallScrollV.contentOffset = CGPointMake(offset, 0);
                            }else if (tmp < _tagArr.count - 3){
                                _smallScrollV.contentOffset = CGPointMake(btn.frame.origin.x - 13, 0);
                            }
                        }
                    }else{
                        // iphone 6
                        if (_smallScrollV.contentSize.width > SCREEN_WIDTH) {
                            if (tmp >= _tagArr.count - 4) {
                                CGFloat offset = self.smallScrollV.contentSize.width - self.smallScrollV.bounds.size.width;
                                _smallScrollV.contentOffset = CGPointMake(offset-5, 0);
                            }else if (tmp < _tagArr.count - 4) {
                                _smallScrollV.contentOffset = CGPointMake(btn.frame.origin.x - 5, 0);
                            }
                        }
                    }
                }];
            }else if(tmp != _tagArr.count){
                [UIView animateWithDuration:0.5 animations:^{
                    _smallScrollV.contentOffset = CGPointMake(0, 0);
                    
                }];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
            [UIView animateWithDuration:0.5 animations:^{
                
                // 告诉self.view约束需要更新
                [self.view setNeedsUpdateConstraints];
                // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
                [self.view updateConstraintsIfNeeded];
                
                [UIView animateWithDuration:0.3 animations:^{
                    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(button.frame.size.width);
                        make.left.mas_equalTo(button.frame.origin.x);
                    }];
                    [self.view layoutIfNeeded];
                }];
                
                //                _corView.center = button.center;
            }];
        } else {
            [button setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        }
    }
}

//只要滚动了就会触发
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"===  %.1f",scrollView.contentOffset.x);
}


- (void)setNavigationController
{
    // 导航栏颜色
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    // 导航栏标题（用图片）
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"news_navigation_title"]];
    // 设置导航栏左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_navigation_left" highImage:@"news_navigation_left" target:self action:@selector(SearchClick)];
    // 设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"news_navgation_right" highImage:@"news_navgation_right" target:self action:@selector(SettingClick)];
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
