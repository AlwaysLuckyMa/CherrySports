//
//  MapLocationViewController.m
//  RenWoXing
//
//  Created by 李昞辰 on 16/5/4.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "MapLocationViewController.h"
#import "MyAnimatedAnnotationView.h"
#import <MapKit/MapKit.h> 
#import "CLLocation+YCLocation.h"

@interface MapLocationViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>
{
    BMKPointAnnotation* pointAnnotation;
    CLLocationCoordinate2D coor;
}

@property (nonatomic, strong)BMKMapView *mapView;
@property (nonatomic, strong)BMKLocationService *locationService; // 定位

@end

@implementation MapLocationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationService.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    // 定位中心店(请求数据)
    _mapView.centerCoordinate = _locationCoor;
    _mapView.delegate = self;
    
    self.view = _mapView;
    // 返回按钮
//    [self addBackBtn];
    
    // 地图类型
    //    _mapView.mapType = BMKMapTypeSatellite; // 卫星地图
    _mapView.mapType = BMKMapTypeStandard; // 标准地图
    
    // 比例尺
    _mapView.showMapScaleBar = YES;
    // 缩放级别(17是100米)
    _mapView.zoomLevel = 17;
    _mapView.maxZoomLevel = 20;
    _mapView.minZoomLevel = 5;
    
    _mapView.zoomEnabled = YES;
//    _mapView.zoomEnabledWithTap = YES;
    
    // 定位
    _locationService = [[BMKLocationService alloc] init];
    // 打开定位
    NSLog(@"进入普通定位态");
    [_locationService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    // 设置定位更新最小距离
    _locationService.distanceFilter = 10;
    // 添加标注
    [self addPointAnnotation];
    
//    // 设置下边显示栏
//    [self setMapPadding];
//    // 显示自己定位
//    [self userLocation];
    
}


/**
 *地图初始化完毕时会调用此接口
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
#pragma mark - 指南针位置
    CGPoint pt;
    pt = CGPointMake(SCREEN_WIDTH - 50,20);
    [_mapView setCompassPosition:pt];
}

#pragma mark - **************** 添加标注
- (void)addPointAnnotation
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        
        // 经度
//        coor.latitude = 45.868604;
        // 纬度
//        coor.longitude = 126.565286;
        pointAnnotation.coordinate = _locationCoor;
        pointAnnotation.title = _storeName;
    }
    [_mapView addAnnotation:pointAnnotation];
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (annotation == pointAnnotation) {
        //动画annotation
        // 生成重用标示identifier
        NSString *AnnotationViewID = @"AnimatedAnnotation";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        // 自定义图片
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:@"icon_openmap_mark"];
//      UIImage *image1 = [UIImage imageNamed:@"icon_nav_start"];
        images = [NSMutableArray arrayWithObjects:image, nil];
        annotationView.annotationImages = images;
        // 设置是否可以拖拽
        annotationView.draggable = NO;
        return annotationView;
    }
    return nil;
}


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
}

//// 添加自己定位按钮
//- (void)userLocation{
//    UIButton *userLocationBtn = [AppTools createButtonTitle:@"\U0000E641" TitleColor:[UIColor whiteColor] Font:0 IconFont:20.0f Background:[UIColor blackColor]];
//    userLocationBtn.alpha = 0.7;
//    userLocationBtn.layer.masksToBounds = YES;
//    userLocationBtn.layer.cornerRadius = 5;
//    [self.view addSubview:userLocationBtn];
//    [userLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(10);
//        make.bottom.mas_offset(-110);
//        make.width.height.mas_offset(30);
//        
//    }];
//    [userLocationBtn addTarget:self action:@selector(userLocationBtnAction) forControlEvents:UIControlEventTouchUpInside];
//}
//
//
//// 设置下边显示栏
//- (void)setMapPadding {
//    ///地图预留边界，默认：UIEdgeInsetsZero。设置后，会根据mapPadding调整logo、比例尺、指南针的位置，以及targetScreenPt(BMKMapStatus.targetScreenPt)
//    _mapView.mapPadding = UIEdgeInsetsMake(0, 0, 100, 0);
//    
//    UIView *bottomV = [AppTools createViewBackground:[UIColor whiteColor]];
//    [self.view addSubview:bottomV];
//    [self.view bringSubviewToFront:bottomV];
//    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_offset(0);
//        make.height.mas_offset(100);
//        
//    }];
//    
//    UIView *topV = [AppTools createViewBackground:BORDER_COLOR];
//    [bottomV addSubview:topV];
//    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.mas_offset(0);
//        make.height.mas_offset(0.5);
//        
//    }];
//    
//    UILabel *storelabel = [AppTools createLabelText:_storeName Color:[UIColor blackColor] Font:16.0f IconFont:0 TextAlignment:NSTextAlignmentLeft];
//    [bottomV addSubview:storelabel];
//    [storelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(10);
//        make.top.mas_offset(10);
//        make.right.mas_offset(-15);
//        make.height.mas_offset(20);
//        
//    }];
//    
//    UILabel *placeLabel = [AppTools createLabelText:_placeName Color:TEXT_COLOR_LIGHT Font:12.0f IconFont:0 TextAlignment:NSTextAlignmentLeft];
//    [bottomV addSubview:placeLabel];
//    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(storelabel);
//        make.top.equalTo(storelabel.mas_bottom).offset(5);
//        make.height.mas_offset(20);
//        
//    }];
//    
//    UIView *lineV = [AppTools createViewBackground:BORDER_COLOR];
//    [bottomV addSubview:lineV];
//    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_offset(0);
//        make.top.equalTo(placeLabel.mas_bottom).offset(10);
//        make.height.mas_offset(0.5);
//        
//    }];
//    
//    UIButton *routeBtn = [AppTools createButtonTitle:@"查看路线" TitleColor:TEXT_COLOR_LIGHT Font:12.0f IconFont:0 Background:[UIColor clearColor]];
//    routeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [bottomV addSubview:routeBtn];
//    [routeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_offset(0);
//        make.top.equalTo(lineV.mas_bottom);
//        
//    }];
//    [routeBtn addTarget:self action:@selector(routeBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    
//}
//
//// 返回按钮
//- (void)addBackBtn{
//    UIButton *backBtn = [AppTools createButtonTitle:@"\U0000E609" TitleColor:[UIColor whiteColor] Font:0 IconFont:24.0f Background:[UIColor blackColor]];
//    backBtn.alpha = 0.7;
//    [_mapView addSubview:backBtn];
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(-5);
//        make.top.mas_offset(20);
//        make.height.mas_offset(30);
//        make.width.mas_offset(55);
//        
//    }];
//    backBtn.layer.masksToBounds = YES;
//    backBtn.layer.cornerRadius = 5;
//    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
//}
//// 返回按钮
//- (void)backBtnAction{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        
//    }];
//}
//// 查看路线按钮
//- (void)routeBtnAction{
//    NSLog(@"查看路线");
//    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
//        [self goToBaidu:self.storeName];
//    }else{
//        [self onDaoHangForIOSMap:self.storeName];
//    }
//}
//// 定位用户位置
//- (void)userLocationBtnAction{
//    _mapView.centerCoordinate = CLLocationCoordinate2DMake(coor.latitude, coor.longitude);
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
////调起百度地图
//- (void)goToBaidu:(NSString *)zhongdian{
//    NSString *url2 = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%@|name:我的位置&destination=latlng:%@|name:%@&mode=driving",[NSString stringWithFormat:@"%f, %f", coor.latitude, coor.longitude],[NSString stringWithFormat:@"%f, %f", _locationCoor.latitude, _locationCoor.longitude],zhongdian] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url2]];
//}
////调起高德地图
//-(void) goToGaode:(NSString *)zhongdian{
//    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2",@"认我行", @"iosamap", zhongdian, _locationCoor.latitude, _locationCoor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
//}
//
//-(void) onDaoHangForIOSMap:(NSString *)zhongdian{
//    //起点
//    CLLocation * location = [[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude];
//    location = [location locationMarsFromBaidu];
//    
//    CLLocationCoordinate2D coor1 =location.coordinate;
//    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor1 addressDictionary:nil]];
//    currentLocation.name =@"我的位置";
//    
//    //目的地的位置
//    CLLocation * location2 = [[CLLocation alloc]initWithLatitude:self.locationCoor.latitude longitude:self.locationCoor.longitude];
//    location2 = [location2 locationMarsFromBaidu];
//    
//    CLLocationCoordinate2D coor2 =location2.coordinate;
//    //    CLLocationCoordinate2D coords = self.location;
//    
//    
//    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor2 addressDictionary:nil]];
//    
//    toLocation.name = zhongdian;
//    
//    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
//    NSString * mode = MKLaunchOptionsDirectionsModeDriving;
//
//    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:mode, MKLaunchOptionsMapTypeKey: [NSNumber                                 numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
//    //打开苹果自身地图应用，并呈现特定的item
//    [MKMapItem openMapsWithItems:items launchOptions:options];
//}

@end
