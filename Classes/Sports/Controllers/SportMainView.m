//
//  SportMainView.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/6.
//  Copyright © 2017年 dkb. All rights reserved.
//
#define SportNumBackView_Height    (SCREEN_HEIGHT-64-44)
#define currentViewHeight          SportNumBackView_Height / 9  //SportNumBackView_Height的 1 / 9
#define SCREEN_WIDTH               [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT              [UIScreen mainScreen].bounds.size.height
#define H(b)                       SCREEN_HEIGHT * b / 667
#define W(a)                       SCREEN_WIDTH  * a / 375

#import "SportMainView.h"

#import <CoreMotion/CoreMotion.h> //气压值类

@interface SportMainView ()
<
    CLLocationManagerDelegate
>
{
    CLLocationManager * _locationManager;    // 大气压
    
    UIView            * _compassView;        // 指南针view
    UIImageView       * _compassBgImageView; // 指南针罗盘view
    UIImageView       * _compassImageView;   // 指南针指针view
    
    UIView            * _firstView;          //
    UILabel           * _mileageLabel;       // 里程
    UILabel           * _timeLabel;          // 时间
    UILabel           * _speedLabel;         // 速度
    
    UIView            * _secondView;         //
    UILabel           * _heatLabel;          //热量
    UILabel           * _altitudeLabel;      //海拔
    UILabel           * _ClimbLabel;         //爬升
    
    UIButton          * _starBtn;            //开始button
}

@property (nonatomic, strong) CMAltimeter * altimeter;   // 气压计
@property (nonatomic ,strong) CLLocationManager * mgr;
@end


@implementation SportMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self positionMan];
        [self startControl]; //初始化手机传感器
        [self createUI];     //创建UI
    }
    return self;
}

#pragma mark - 监听
- (void)positionMan
{
    _mgr = [[CLLocationManager alloc] init];
    //成为CoreLocation管理者的代理监听获取到的位置
    self.mgr.delegate = self;
    
    // 开始获取用户位置 获取用户的方向信息是不需要用户授权的
    [self.mgr startUpdatingHeading];
}

#pragma mark - 搭建UI
- (void)createUI
{
     /*               布 局 高 度 值
     currentViewHeight / 3
     currentViewHeight * 4
     currentViewHeight * 2
     currentViewHeight * 2
     currentViewHeight
     */

    //指南针
    _compassView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, currentViewHeight * 4 )];
//    _compassView.backgroundColor = [UIColor redColor];
    [self addSubview:_compassView];

    //指针
    _compassImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - (currentViewHeight * 4))/2, currentViewHeight / 3, currentViewHeight * 4, currentViewHeight * 4)];
    _compassImageView.image = [UIImage imageNamed:@"compass"];
//    _compassImageView.backgroundColor = [UIColor redColor];
    _compassImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_compassImageView];
    
    //罗盘
    _compassBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - (currentViewHeight * 4))/2, currentViewHeight / 3, currentViewHeight * 4, currentViewHeight * 4)];
    _compassBgImageView.image = [UIImage imageNamed:@"1background"];
    [self addSubview:_compassBgImageView];
    UILabel * compassSpeed = [self labelRect:CGRectMake(0,
                                                        (currentViewHeight * 4-(currentViewHeight * 4 / 5) + currentViewHeight * 1.5 / 3) / 2,
                                                        SCREEN_WIDTH,
                                                        currentViewHeight * 4 / 5)
                                     labelText:@"0.00"
                            labelTextAlignment:NSTextAlignmentCenter
                                     labelFont:H(50)
                                    labelColor:[UIColor blackColor]];
//    compassSpeedLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:compassSpeed];
    UILabel * compassSpeedName = [self labelRect:CGRectMake(0,
                                                             CGRectGetMaxY(compassSpeed.frame)+5,
                                                             SCREEN_WIDTH,
                                                             currentViewHeight * 2 / 5)
                                        labelText:@"时速(km/h)"
                               labelTextAlignment:NSTextAlignmentCenter
                                        labelFont:H(15)
                                       labelColor:[UIColor grayColor]];
    //    compassSpeedLabel.backgroundColor = [UIColor grayColor];
    
    [self addSubview:compassSpeedName];
    
    //中间布局
    [self createCenterViews];
    
    _starBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SportNumBackView_Height - currentViewHeight, SCREEN_WIDTH, currentViewHeight)];
    _starBtn.backgroundColor = [UIColor redColor];
//    [_starBtn.layer setMasksToBounds:YES];
//    [_starBtn.layer setCornerRadius:15];
    _starBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_starBtn setTitle:@"开始骑行" forState:UIControlStateNormal];
    [_starBtn addTarget:self action:@selector(clickBootonBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_starBtn];

    //GPS
    UIView * GPSView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, currentViewHeight / 3)];
//    GPSView.backgroundColor = [UIColor yellowColor];
    [self addSubview:GPSView];
    
    //获取字体的Size做适配
    CGSize size   = [self sizeWithText:@"GPS" font:[UIFont systemFontOfSize:H(15)] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UILabel * GPS = [self labelRect:CGRectMake(17,
                                               0,
                                               size.width,
                                               currentViewHeight / 3)
                                       labelText:@"GPS"
                              labelTextAlignment:NSTextAlignmentLeft
                                       labelFont:H(15)
                                      labelColor:[UIColor grayColor]];
    [GPSView addSubview:GPS];
    
//    GPS.backgroundColor = [UIColor blackColor];
    UIImageView * gpsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(GPS.frame),
                                                                              0,
                                                                              50,
                                                                              currentViewHeight / 3)];
    gpsImageView.backgroundColor = [UIColor redColor];
    [GPSView addSubview:gpsImageView];
}

#pragma mark - 获取字体的Size
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary * attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)clickBootonBtn
{
    
}

#pragma mark - CLLocationManagerDelegate 当获取到用户方向时就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //  将获取到的角度转为弧度 = (角度 * π) / 180;
    CGFloat angle = newHeading.magneticHeading * M_PI / 180;
    // 旋转图片 顺时针 正 逆时针 负数
    [UIView animateWithDuration:0.2 animations:^{
       _compassImageView.transform = CGAffineTransformMakeRotation(- angle);
    }];
}

#pragma mark - 初始化大气压
- (void)startControl
{
    [self getAltitude];    //获取海拔高度
    [self getCMAltimeter]; //获取大气压
}

#pragma mark - 获取海拔高度
- (void)getAltitude
{
    //然后实例化对象  别忘了遵循代理CLLocationManagerDelegate
    _locationManager                 = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate        = self;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
    //    _startLocation = nil;
}

#pragma mark - 获取大气压
- (void)getCMAltimeter
{
    _altimeter = [[CMAltimeter alloc]init];
    
    if (![CMAltimeter isRelativeAltitudeAvailable]) {//检测设备是否支持气压计
        NSLog(@"这个设备上没有气压表!");
        return;
    }
    //开始监测
    [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error)
     {
         // 实时刷新数据
         [self updateLabels:altitudeData];
     }];
    //停止
    //        [self.altimeter stopRelativeAltitudeUpdates];
}

#pragma mark - 海拔具体实现 CLLocation中 horizontalAccuracy、verticalAccuracy体现精度（反应信号可信度或者强度）
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    float altitude = newLocation.altitude;
    _altitudeLabel.text = [NSString stringWithFormat:@"%.2f", altitude];
//    _altitudeLabel.text = [NSString stringWithFormat:@"海拔高度为：%.2fm \n垂直精度为：%.2fm \n速度为：%.2fm/s", altitude,newLocation.verticalAccuracy,newLocation.speed];
}

- (void)updateLabels:(CMAltitudeData *)altitudeData
{
    //相对高度，并非海拔
//    _lable.text = [NSString stringWithFormat:@"相对高度，并非海拔:%.2f m \n实时气压: %.2fkPa \n", [altitudeData.relativeAltitude floatValue],[altitudeData.pressure floatValue]];
}


#pragma mark - 创建UI
- (void)createCenterViews
{
    //里程
    _firstView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_compassView.frame), SCREEN_WIDTH, currentViewHeight * 2)];
    //    _firstView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_firstView];
    
    CGFloat   labelW         = (SCREEN_WIDTH / 3);  //通用 宽度
    CGFloat   labelH         = 40;                  //通用 数字高度
    CGFloat   nameLabelH     = 30;                  //通用 热量name的高度
    NSInteger fontNum        = H(40);               //通用 字体大小
    NSInteger fontNameNum    = H(15);               //通用 字体大小
    
    CGFloat  secondNameGetMaxY = (currentViewHeight * 2 - (labelH + nameLabelH)) / 2;    //里程值Y值
    
    UILabel * mileageNameLabel = [self labelRect:CGRectMake(0,
                                                            secondNameGetMaxY,
                                                            labelW,
                                                            nameLabelH)
                                       labelText:@"里程(m)"
                              labelTextAlignment:NSTextAlignmentCenter
                                       labelFont:fontNameNum
                                      labelColor:[UIColor grayColor]];
    [_firstView addSubview:mileageNameLabel];
    
    UILabel * timeNameLabel = [self labelRect:CGRectMake(CGRectGetMaxX(mileageNameLabel.frame),
                                                         secondNameGetMaxY,
                                                         labelW,
                                                         nameLabelH)
                                    labelText:@"时间"
                           labelTextAlignment:NSTextAlignmentCenter
                                    labelFont:fontNameNum
                                   labelColor:[UIColor grayColor]];
    [_firstView addSubview:timeNameLabel];
    
    UILabel * speedNameLabel = [self labelRect:CGRectMake(CGRectGetMaxX(timeNameLabel.frame),
                                                          secondNameGetMaxY,
                                                          labelW,
                                                          nameLabelH)
                                     labelText:@"匀速(km/h)"
                            labelTextAlignment:NSTextAlignmentCenter
                                     labelFont:fontNameNum
                                    labelColor:[UIColor grayColor]];
    [_firstView addSubview:speedNameLabel];
    
    //里程Y值
    CGFloat   firstGetMaxY   = CGRectGetMaxY(speedNameLabel.frame) - 5;
    //里程
    _mileageLabel = [self labelRect:CGRectMake(0,
                                               firstGetMaxY,
                                               labelW,
                                               labelH)
                          labelText:@"0.00"
                 labelTextAlignment:NSTextAlignmentCenter
                          labelFont:fontNum
                         labelColor:[UIColor blackColor]];
    [_firstView addSubview:_mileageLabel];
    
    _timeLabel = [self labelRect:CGRectMake(CGRectGetMaxX(_mileageLabel.frame),
                                            firstGetMaxY,
                                            labelW,
                                            labelH)
                       labelText:@"00:00"
              labelTextAlignment:NSTextAlignmentCenter
                       labelFont:fontNum
                      labelColor:[UIColor blackColor]];
    [_firstView addSubview:_timeLabel];
    
    _speedLabel = [self labelRect:CGRectMake(CGRectGetMaxX(_timeLabel.frame),
                                             firstGetMaxY,
                                             labelW,
                                             labelH)
                        labelText:@"0.00"
               labelTextAlignment:NSTextAlignmentCenter
                        labelFont:fontNum
                       labelColor:[UIColor blackColor]];
    [_firstView addSubview:_speedLabel];
    
    //横线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, currentViewHeight * 6, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self addSubview:lineView];
    
////////////////////////////////////////////////////    第二段label    /////////////////////////////////////////////////
    
    //热量
    _secondView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_firstView.frame), SCREEN_WIDTH, currentViewHeight * 2)];
    //    _secondView.backgroundColor = [UIColor blueColor];
    [self addSubview:_secondView];
    
    UILabel * heatNameLabel = [self labelRect:CGRectMake(0,
                                                         secondNameGetMaxY,
                                                         labelW,
                                                         nameLabelH)
                                    labelText:@"热量(kcal)"
                           labelTextAlignment:NSTextAlignmentCenter
                                    labelFont:fontNameNum
                                   labelColor:[UIColor grayColor]];
    [_secondView addSubview:heatNameLabel];
    UILabel * altitudenameLabel = [self labelRect:CGRectMake(CGRectGetMaxX(heatNameLabel.frame),
                                                             secondNameGetMaxY,
                                                             labelW,
                                                             nameLabelH)
                                        labelText:@"海拔(m)"
                               labelTextAlignment:NSTextAlignmentCenter
                                        labelFont:fontNameNum
                                       labelColor:[UIColor grayColor]];
    [_secondView addSubview:altitudenameLabel];
    UILabel * ClimbNameLabel = [self labelRect:CGRectMake(CGRectGetMaxX(altitudenameLabel.frame),
                                                          secondNameGetMaxY,
                                                          labelW,
                                                          nameLabelH)
                                     labelText:@"爬升(m)"
                            labelTextAlignment:NSTextAlignmentCenter
                                     labelFont:fontNameNum
                                    labelColor:[UIColor grayColor]];
    [_secondView addSubview:ClimbNameLabel];
    
    //热量值Y值
    CGFloat  getMaxlabelY   = CGRectGetMaxY(ClimbNameLabel.frame) - 5;
    
    _heatLabel = [self labelRect:CGRectMake(0,
                                            getMaxlabelY,
                                            labelW,
                                            labelH)
                       labelText:@"0"
              labelTextAlignment:NSTextAlignmentCenter
                       labelFont:fontNum
                      labelColor:[UIColor blackColor]];
    [_secondView addSubview:_heatLabel];
    
    _altitudeLabel = [self labelRect:CGRectMake(CGRectGetMaxX(_heatLabel.frame),
                                                getMaxlabelY,
                                                labelW,
                                                labelH)
                           labelText:@"0.0"
                  labelTextAlignment:NSTextAlignmentCenter
                           labelFont:fontNum
                          labelColor:[UIColor blackColor]];
    [_secondView addSubview:_altitudeLabel];
    
    _ClimbLabel = [self labelRect:CGRectMake(CGRectGetMaxX(_altitudeLabel.frame),
                                             getMaxlabelY,
                                             labelW,
                                             labelH)
                        labelText:@"0.0"
               labelTextAlignment:NSTextAlignmentCenter
                        labelFont:fontNum
                       labelColor:[UIColor blackColor]];
    [_secondView addSubview:_ClimbLabel];
    
}

- (UILabel*)labelRect:(CGRect)rect labelText:(NSString *)text labelTextAlignment:(NSTextAlignment)textAlignment labelFont:(NSInteger)num labelColor:(UIColor*)Lcolor
{
    UILabel * label  = [[UILabel alloc]initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:num];;
//    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:num];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = textAlignment;
    label.textColor = Lcolor;
    label.text = text;
    return label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
