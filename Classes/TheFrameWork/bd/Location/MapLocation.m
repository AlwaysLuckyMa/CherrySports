//
//  MapLocation.m
//  RenWoXing
//
//  Created by 李昞辰 on 16/5/10.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "MapLocation.h"

@interface MapLocation ()<BMKLocationServiceDelegate, BMKMapViewDelegate, BMKGeoCodeSearchDelegate>{
    CLLocationCoordinate2D coor;
//    BMKReverseGeoCodeOption *reverseGeoCodeOption;//逆地理编码
}
@property (nonatomic, strong)BMKLocationService *location; // 定位
@property (nonatomic, strong)BMKGeoCodeSearch *geoCodeSearch;

@end

@implementation MapLocation


+ (instancetype)shareMapLocation{
    static MapLocation *location = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[MapLocation alloc] init];
    });
    return location;
}


#pragma 初始化百度地图用户位置管理类
/**
 *  初始化百度地图用户位置管理类
 */
- (void)initBMKUserLocation
{
    _location = [[BMKLocationService alloc]init];
    _location.delegate = self;
    [self startLocation];
    // 默认地址为哈尔滨（如果用户未开启定位服务，就将位置自动定位到哈尔滨）
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"UserLocation"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"locationWD"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"locationJD"];
}
#pragma 打开定位服务
/**
 *  打开定位服务
 */
-(void)startLocation
{
    [_location startUserLocationService];
}
#pragma 关闭定位服务

/**
 *  关闭定位服务
 */
-(void)stopLocation
{
    [_location stopUserLocationService];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    [_mapView updateLocationData:userLocation];
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
//    NSString *locationStr = [NSString stringWithFormat:@"%f, %f", coor.latitude, coor.longitude];
//    [[NSUserDefaults standardUserDefaults] setValue:locationStr forKey:@"UserLocation"];
//    NSLog(@"用户坐标 = %@", USERLOCATION);
    
    [_locationDelegate userLocationCoooor:CLLocationCoordinate2DMake(coor.latitude, coor.longitude)];

    NSString *latitudeWD = [NSString stringWithFormat:@"%f", coor.latitude];
    NSString *longitudeJD = [NSString stringWithFormat:@"%f", coor.longitude];
    [[NSUserDefaults standardUserDefaults] setValue:latitudeWD forKey:@"locationWD"];
    [[NSUserDefaults standardUserDefaults] setValue:longitudeJD forKey:@"locationJD"];
    
    // 初始化地理编码类
    // 注意：必须初始化地理编码类
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    
    // 初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    // 需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    //下面这行代码就是你之前给注释了的代码
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    NSLog(@"%d",[_geoCodeSearch reverseGeoCode:reverseGeoCodeOption]);
    
    [self stopLocation];
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"businessCircle = %@\n address = %@\n poiList = %@\n streetNumber = %@\n streetName = %@\n district = %@\n city = %@\n province = %@\n", result.businessCircle, result.address, result.poiList, result.addressDetail.streetNumber, result.addressDetail.streetName, result.addressDetail.district, result.addressDetail.city, result.addressDetail.province);
    [[NSUserDefaults standardUserDefaults] setValue:result.address forKey:@"locationAddress"];
    for (int i = 0; i < result.poiList.count; i++) {
        NSLog(@"poiList = %@\n ====%@\n", [result.poiList[i] name], [result.poiList[i] address]);
    }
    //BMKReverseGeoCodeResult是编码的结果，包括地理位置，道路名称，uid，城市名等信息
}



@end
