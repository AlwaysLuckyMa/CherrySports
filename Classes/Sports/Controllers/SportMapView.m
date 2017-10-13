//
//  SportMapView.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/6.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "SportMapView.h"
#import "presentLushuSelect.h"
@interface SportMapView ()
<
    BMKMapViewDelegate,
    BMKLocationServiceDelegate
>
{
    BMKMapView                   * _mapView;             // 地图对象
    BMKLocationService           * _locService;          // 定位
    UILabel                      * _V_label;             // 速度
    UILabel                      * _T_label;             // 时间
    UILabel                      * _S_label;             // 距离
    UIView                       * _bottomView;          // 底部导航View
    UILabel                      * _bottomLabel;         // 底部导航label
    CLLocationCoordinate2D         _CenterCoordinate2D;  // 中心点坐标
    UIButton                     * _starNavBtn;
    presentLushuSelect           * _presentLushuView;
}


@end

@implementation SportMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor    = [UIColor whiteColor];
        [self createMap];
        [self createTopView];
//        _bottomView.hidden = YES;
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT + 50, SCREEN_WIDTH, 50);
        
    }
    return self;
}

- (void)createTopView
{
    CGFloat topView_W                        = SCREEN_WIDTH - 40;
    CGFloat ChildrenView_X                   = topView_W / 3;
    CGFloat ChildrenView_H                   = 30;
    CGFloat ChildrenView_Name_H              = 45 - 30;
    CGFloat ChildrenView_Name_Y              = ChildrenView_H;
    CGFloat ChildrenView_label_font          = 18;
    CGFloat ChildrenView_labelName_font      = 10;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH- topView_W)/2, 30, topView_W, 45)];
    view.backgroundColor = [UIColor whiteColor];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:8];
    [view.layer setBorderColor:[UIColor blackColor].CGColor];
    [view.layer setBorderWidth:0.2];
//    [view.layer setShadowColor:[UIColor blackColor].CGColor];
//    [view.layer setShadowOpacity:1.0f];
//    [view.layer setShadowOffset:CGSizeMake(10, 10)];
    [self addSubview:view];
    
    _V_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ChildrenView_X, ChildrenView_H)];
    _V_label.textAlignment = NSTextAlignmentCenter;
    _V_label.text = @"0.00";
    _V_label.textColor = [UIColor blackColor];
    _V_label.font = [UIFont systemFontOfSize:ChildrenView_label_font];
    [view addSubview:_V_label];
    UILabel * V_label_name = [[UILabel alloc]initWithFrame:CGRectMake(0, ChildrenView_Name_Y, ChildrenView_X, ChildrenView_Name_H)];
    V_label_name.textAlignment = NSTextAlignmentCenter;
    V_label_name.text = @"当前速度";
    V_label_name.textColor = [UIColor grayColor];
    V_label_name.font = [UIFont systemFontOfSize:ChildrenView_labelName_font];
    [view addSubview:V_label_name];
    
    
    _T_label = [[UILabel alloc]initWithFrame:CGRectMake(ChildrenView_X, 0, ChildrenView_X, ChildrenView_H)];
    _T_label.textAlignment = NSTextAlignmentCenter;
    _T_label.text = @"00:00:00";
    _T_label.textColor = [UIColor blackColor];
    _T_label.font = [UIFont systemFontOfSize:ChildrenView_label_font];
    [view addSubview:_T_label];
    UILabel * T_label_name = [[UILabel alloc]initWithFrame:CGRectMake(ChildrenView_X, ChildrenView_Name_Y, ChildrenView_X, ChildrenView_Name_H)];
    T_label_name.textAlignment = NSTextAlignmentCenter;
    T_label_name.text = @"运动时间";
    T_label_name.textColor = [UIColor grayColor];
    T_label_name.font = [UIFont systemFontOfSize:ChildrenView_labelName_font];
    [view addSubview:T_label_name];
    
    
    _S_label = [[UILabel alloc]initWithFrame:CGRectMake(ChildrenView_X * 2, 0, ChildrenView_X, ChildrenView_H)];
    _S_label.textAlignment = NSTextAlignmentCenter;
    _S_label.text = @"0.00";
    _S_label.textColor = [UIColor blackColor];
    _S_label.font = [UIFont systemFontOfSize:ChildrenView_label_font];
    [view addSubview:_S_label];
    UILabel * S_label_name = [[UILabel alloc]initWithFrame:CGRectMake(ChildrenView_X * 2, ChildrenView_Name_Y, ChildrenView_X, ChildrenView_Name_H)];
    S_label_name.textAlignment = NSTextAlignmentCenter;
    S_label_name.text = @"总距离";
    S_label_name.textColor = [UIColor grayColor];
    S_label_name.font = [UIFont systemFontOfSize:ChildrenView_labelName_font];
    [view addSubview:S_label_name];
    
    //右侧三个btn
    CGFloat btn_X                        = SCREEN_WIDTH - 40 - 20;
    CGFloat btn_Y                        = CGRectGetMaxY(view.frame);
    for (int i = 0; i< 3; i++)
    {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btn_X ,btn_Y + 10 + 50 * i, 40, 40)];
        btn.backgroundColor = [UIColor blackColor];
        [view.layer setMasksToBounds:YES];
        [view.layer setCornerRadius:8];
        [btn.layer setBorderColor:[UIColor blackColor].CGColor];
        [btn.layer setBorderWidth:0.2];
        [btn setImage:[UIImage imageNamed:@"climbangle_dashboard@2x"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"roadbook_map_start_cilck@2x"] forState:UIControlStateSelected];
        btn.tag = 3000+i;
        [btn addTarget:self action:@selector(clockBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    //底部导航语音提示label
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];

    _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, 50)];
    _bottomLabel.backgroundColor = [UIColor whiteColor];
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel.text = @"导航语音提示Label";
    _bottomLabel.textColor = [UIColor blackColor];
    _bottomLabel.font = [UIFont systemFontOfSize:20];
    [_bottomView addSubview:_bottomLabel];
    
    UIButton * bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50)];
    bottomBtn.backgroundColor = [UIColor blackColor];
    [bottomBtn setTitle:@"x" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomclockBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:bottomBtn];
    
    
    //开始导航
    _starNavBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - ((SCREEN_WIDTH ) / 3)) / 2, SCREEN_HEIGHT - 50, (SCREEN_WIDTH) / 3, 40)];
    _starNavBtn.backgroundColor = [UIColor blueColor];
    [_starNavBtn setTitle:@"开始导航" forState:UIControlStateNormal];
    [_starNavBtn addTarget:self action:@selector(starNavBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_starNavBtn];
    
    //下面三个btn
    CGFloat bottom_X                        = SCREEN_WIDTH - 40 - 20;
    CGFloat bottom_Y                        = CGRectGetMinY(_bottomView.frame);
    NSArray * arr = @[@"-",@"+",@"0"];
    for (int i = 0; i< 3; i++)
    {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(bottom_X ,bottom_Y - 50 - 50 * i, 40, 40)];
        if (i == 1) {
            btn.frame = CGRectMake(bottom_X ,bottom_Y - 40 - 50 * i, 40, 40);
        }
        btn.backgroundColor = [UIColor redColor];
        [view.layer setMasksToBounds:YES];
        [view.layer setCornerRadius:8];
        [btn.layer setBorderColor:[UIColor blackColor].CGColor];
        [btn.layer setBorderWidth:0.2];
//        [btn setImage:[UIImage imageNamed:@"climbangle_dashboard@2x"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"roadbook_map_start_cilck@2x"] forState:UIControlStateSelected];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 3003+i;
        [btn addTarget:self action:@selector(clockBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }

   
}

#pragma mark -
- (void)starNavBtn
{
    NSlog(@"开始导航");
    [BDVoice BDVoiceStar:self BDSpeakStr:@"开始导航"];
    
    [UIView animateWithDuration:0.3 animations:^{
        _starNavBtn.hidden = YES;
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
- (void)bottomclockBtn
{
    NSlog(@"退出导航");
    [BDVoice BDVoiceStar:self BDSpeakStr:@"导航结束"];
    
    [UIView animateWithDuration:0.3 animations:^{
        _starNavBtn.hidden = NO;
        _bottomView.frame  = CGRectMake(0, SCREEN_HEIGHT + 50, SCREEN_WIDTH, 50);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)clockBtn:(UIButton *)sender
{
    CGFloat tag = sender.tag - 3000;
    if (tag == 0) {
        NSlog(@"0");
        
        [self createTopTableview]; //不要换位置  优先级
        
        [UIView animateWithDuration:0.3 animations:^{
            _presentLushuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished){ }];
    }
    if (tag == 1) { NSlog(@"1"); }
    if (tag == 2) { NSlog(@"2"); }
    if (tag == 3) {_mapView.zoomLevel--;}
    if (tag == 4) {_mapView.zoomLevel++;}
    if (tag == 5) {_mapView.centerCoordinate = _CenterCoordinate2D;}
}

- (void)createTopTableview
{
    _presentLushuView = [[presentLushuSelect alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _presentLushuView.backgroundColor = [UIColor blueColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_presentLushuView];
}

#pragma mark - 初始化地图
- (void)createMap
{
    _mapView                   = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mapView.mapType           = BMKMapTypeStandard; //标准地图  BMKMapTypeSatellite
    _mapView.userTrackingMode  = BMKUserTrackingModeFollow;
    _mapView.zoomLevel         = 17; //最佳缩放度
    _mapView.zoomEnabled       = YES;
    _mapView.delegate          = self;
    _mapView.showsUserLocation = YES;//显示定位图层  设置为no不定位到当前位置
    [self addSubview:_mapView];
    
    _locService                = [[BMKLocationService alloc]init];//初始化BMKLocationService
    _locService.delegate       = self;
    [_locService startUserLocationService]; //启动LocationService
}

#pragma mark  实时更新用户位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _CenterCoordinate2D = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
