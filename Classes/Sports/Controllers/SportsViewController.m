//
//  SportsViewController.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/30.
//  Copyright © 2017年 dkb. All rights reserved.
//

#define SportNumBackView_Height    (SCREEN_HEIGHT-64-44)
#define  ReturnView_Y              104
#define  ReturnView_W              50
#define  ReturnView_H              44

#import "SportsViewController.h"

#import "SportMainView.h"   //运动数据view
#import "PopCollectionVC.h"
#import "SportMapView.h"    //地图数据view
//#import "BDVoice.h"  //全局
#import "daTouZenVC.h"      //路书
#import "luShuNavViewController.h"
@interface SportsViewController ()
<
    UIGestureRecognizerDelegate,
    UIPopoverPresentationControllerDelegate, //pop代理
    CallBackWithActionIdSelected,            //pop点击回调代理
    BDSSpeechSynthesizerDelegate
>
{
    UIView                       * _SportNumLeftView;    // 运动数据页 右边的view
    UIView                       * _SportMapReturnView;  // 地图页面   左边的view
    UIButton                     * _leftBtn;             // leftBtnitem
    NSArray                      * _leftBtnImagearr;     // 首页leftBtnitem的背景图片数组
    NSArray                      * _MapReturnImagearr;   // 地图页返回view背景图片数组
 
    SportMainView                * _sportMainView;
    SportMapView                 * _sportMapView;
    UIView                       * _rightView;
}

@end

@implementation SportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createArr];  //初始化数组
    [self setNavigationController];
    [self createMain]; //创建运动首页视图
    
}

- (void)createMain
{
    __weak typeof(self)weak_self = self;
    //运动首页
    _sportMainView                                  = [[SportMainView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SportNumBackView_Height)];
    [self.view addSubview:_sportMainView];
   
    _rightView                  = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 40, 50, 44)];
    _rightView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"drag_btn_left@2x"]];
    [_sportMainView addSubview:_rightView];
        UIPanGestureRecognizer * pan                = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognize:)];
        pan.delegate                                = self;
        [_sportMainView addGestureRecognizer:pan];
    
        UITapGestureRecognizer * tap                = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognize_one)];
        tap.numberOfTapsRequired                    = 1;
        tap.numberOfTouchesRequired                 = 1;
        [_sportMainView addGestureRecognizer:tap];
   
    //地图页面
    _sportMapView                               = [[SportMapView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];\
    _sportMapView.MapViewSelect                 = ^(NSInteger num) {
        if (num == 0) {
//            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:luShuNav];
//            [weak_self presentViewController:nav animated:YES completion:^{
//                NSlog(@"UIWindow * _window");
//            }];

        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_sportMapView];
    
    //地图返回view
    _SportMapReturnView                         = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, ReturnView_Y, ReturnView_W, ReturnView_H)];
    _SportMapReturnView.backgroundColor         = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sidebar_cycling@2x"]];
    
    UIPanGestureRecognizer * SportReturnpan     = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureReturn:)];
    SportReturnpan.delegate                     = self;
    [_SportMapReturnView addGestureRecognizer:SportReturnpan];
    [[UIApplication sharedApplication].keyWindow addSubview:_SportMapReturnView];
    
        UITapGestureRecognizer *SportReturntap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureReturn_one)];
        SportReturntap.numberOfTapsRequired = 1;
        SportReturntap.numberOfTouchesRequired = 1;
        [_SportMapReturnView addGestureRecognizer:SportReturntap];
    
    
}

- (void)panGestureRecognize_one
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;  //黑色
    [UIView animateWithDuration:0.2 animations:^{
        _sportMainView.frame        = CGRectMake(-SCREEN_WIDTH,
                                                 0,
                                                 SCREEN_WIDTH,
                                                 SportNumBackView_Height);
        
        _sportMapView.frame         = CGRectMake(0,
                                                 0,
                                                 SCREEN_WIDTH,
                                                 SCREEN_HEIGHT);
        
        _SportMapReturnView.frame   = CGRectMake(0,
                                                 ReturnView_Y,
                                                 ReturnView_W,
                                                 ReturnView_H);
        
    }];


}
- (void)panGestureReturn_one
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//白色
    [UIView animateWithDuration:0.2 animations:^{
        _sportMainView.frame        = CGRectMake(0,
                                                 0,
                                                 SCREEN_WIDTH,
                                                 SportNumBackView_Height);
        
        _sportMapView.frame         = CGRectMake(SCREEN_WIDTH,
                                                 0,
                                                 SCREEN_WIDTH,
                                                 SCREEN_HEIGHT);
        
        _SportMapReturnView.frame   = CGRectMake(SCREEN_WIDTH+_sportMainView.frame.origin.x,
                                                 ReturnView_Y,
                                                 ReturnView_W,
                                                 ReturnView_H);
    }];

}

#pragma mark - 运动首页拖动手势
- (void)panGestureReturn:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation                         = [recognizer translationInView:self.view];
    CGPoint newCenter                           = CGPointMake(recognizer.view.center.x + translation.x,
                                                              recognizer.view.center.y);
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateChanged:
            newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
            recognizer.view.center              = newCenter;
            [recognizer setTranslation:CGPointZero inView:self.view];
            _sportMainView.frame                = CGRectMake(-SCREEN_WIDTH+_SportMapReturnView.frame.origin.x,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SportNumBackView_Height);
            _sportMapView.frame                 = CGRectMake(_SportMapReturnView.frame.origin.x,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT);
            break;
            
        case UIGestureRecognizerStateEnded:
            if (_SportMapReturnView.frame.origin.x < 100)
            {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;  //黑色
                [UIView animateWithDuration:0.2 animations:^{
                    _sportMainView.frame        = CGRectMake(-SCREEN_WIDTH,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SportNumBackView_Height);
                    _sportMapView.frame         = CGRectMake(0,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT);
                    _SportMapReturnView.frame   = CGRectMake(0,
                                                             ReturnView_Y,
                                                             ReturnView_W,
                                                             ReturnView_H);
                }];
            }
            else
            {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//白色
                [UIView animateWithDuration:0.2 animations:^{
                    _sportMainView.frame        = CGRectMake(0,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SportNumBackView_Height);
                    _sportMapView.frame         = CGRectMake(SCREEN_WIDTH,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT);
                    _SportMapReturnView.frame   = CGRectMake(SCREEN_WIDTH+_sportMainView.frame.origin.x,
                                                             ReturnView_Y,
                                                             ReturnView_W,
                                                             ReturnView_H);
                }];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 地图页面拖动手势
- (void)panGestureRecognize:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation                         = [recognizer translationInView:self.view];
    CGPoint newCenter                           = CGPointMake(recognizer.view.center.x + translation.x,
                                                              recognizer.view.center.y );
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateChanged:
            newCenter.x                         = MIN(self.view.frame.size.width - recognizer.view.frame.size.width/2,
                                                      newCenter.x);
            recognizer.view.center              = newCenter;
            [recognizer setTranslation:CGPointZero inView:self.view];
            _sportMapView.frame                 = CGRectMake(SCREEN_WIDTH+_sportMainView.frame.origin.x,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT);
            _SportMapReturnView.frame           = CGRectMake(SCREEN_WIDTH+_sportMainView.frame.origin.x,
                                                             ReturnView_Y,
                                                             ReturnView_W,
                                                             ReturnView_H);
            break;
            
        case UIGestureRecognizerStateEnded:
            if (_sportMainView.frame.origin.x < -70)
            {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;  //黑色
                [UIView animateWithDuration:0.2 animations:^{
                    _sportMainView.frame        = CGRectMake(-SCREEN_WIDTH,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SportNumBackView_Height);
                    _sportMapView.frame         = CGRectMake(0,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT);
                    _SportMapReturnView.frame   = CGRectMake(0,
                                                             ReturnView_Y,
                                                             ReturnView_W,
                                                             ReturnView_H);
                    
                }];
            }
            else
            {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//白色
                [UIView animateWithDuration:0.2 animations:^{
                    _sportMainView.frame        = CGRectMake(0,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SportNumBackView_Height);
                    _sportMapView.frame         = CGRectMake(SCREEN_WIDTH,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT);
                    _SportMapReturnView.frame   = CGRectMake(SCREEN_WIDTH,
                                                             ReturnView_Y,
                                                             ReturnView_W,
                                                             ReturnView_H);
                }];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置导航控制器
- (void)setNavigationController
{
    self.view.backgroundColor                     = [UIColor whiteColor];
    // 导航栏颜色
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR]
                                                  forBarMetrics:UIBarMetricsDefault];
    // 标题
    UILabel *titleLabel                           = [AppTools createLabelText:@"运动" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font                               = [UIFont systemFontOfSize:16];
    titleLabel.frame                              = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled             = YES;
    self.navigationItem.titleView                 = titleLabel;
    
    // 设置导航栏左侧按钮
    UIBarButtonItem *multiItem                    = [UIBarButtonItem itemWithImage:@"icon_droplistsetting@2x"
                                                                         highImage:@"icon_droplistsetting@2x"
                                                                            target:self
                                                                            action:@selector(SportClick)];
    
    UIBarButtonItem *deleteItem                   = [UIBarButtonItem itemWithImage:@"icon_droplistsetting@2x"
                                                                         highImage:@"icon_droplistsetting@2x"
                                                                            target:self
                                                                            action:@selector(SportClick)];
    
    self.navigationItem.rightBarButtonItems       = @[multiItem,deleteItem];
    
    // 设置导航栏右侧按钮
    _leftBtn                                      = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 28)];
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_biking@2x"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(popColltrollerclick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem         = [[UIBarButtonItem alloc]initWithCustomView:_leftBtn];
}

- (void)SportClick
{
    [BDVoice BDVoiceStar:self BDSpeakStr:@"iphone7在中国制造"];
}

#pragma mark - POP
- (void)popColltrollerclick
{
    PopCollectionVC * popInTableVC                                      = [[PopCollectionVC alloc]init];
    //    popInTableVC.actionIdList = nil; //传过去的数组
    popInTableVC.callBackDelegate                                       = self;
    popInTableVC.preferredContentSize                                   = CGSizeMake(300, 100);        // 设置大小
    popInTableVC.modalPresentationStyle                                 = UIModalPresentationPopover;// 设置 Sytle
    popInTableVC.popoverPresentationController.sourceView = _leftBtn;     // 需要通过 sourceView 来判断位置的
    // 指定箭头所指区域的矩形框范围（位置和尺寸）,以sourceView的左上角为坐标原点
    popInTableVC.popoverPresentationController.sourceRect               = CGRectMake(10, 0, 50, 28); // 可以 通过 Point 或  Size 调试位置
    popInTableVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;// 箭头方向
    popInTableVC.popoverPresentationController.delegate                 = self;// 设置代理
    popInTableVC.popoverPresentationController.backgroundColor          = [UIColor whiteColor];
    [self presentViewController:popInTableVC animated:YES completion:nil];

}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone; //不适配
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    return YES;   //点击蒙版popover消失， 默认YES
}

//弹框消失时调用的方法
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    NSlog(@"弹框已经消失");
}

- (void)callbackWithActionId:(NSInteger)newActionId
{
    NSlog(@"popSelect----%zi",newActionId);
    [_leftBtn setBackgroundImage:[UIImage imageNamed:_leftBtnImagearr[newActionId]] forState:UIControlStateNormal];
    _SportMapReturnView.backgroundColor                                 = [UIColor colorWithPatternImage:[UIImage imageNamed:_MapReturnImagearr[newActionId]]];
}

- (void)createArr
{
    _leftBtnImagearr                                                    = @[@"icon_biking@2x",
                                                                            @"icon_running@2x",
                                                                            @"icon_traveling@2x",
                                                                            @"icon_walking@2x",
                                                                            @"",@"",@"",@""];
    _MapReturnImagearr                                                  = @[@"sidebar_cycling@2x",
                                                                            @"sidebar_running@2x",
                                                                            @"sidebar_other@2x",
                                                                            @"sidebar_hiking@2x",
                                                                            @"",@"",@"",@""];
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
