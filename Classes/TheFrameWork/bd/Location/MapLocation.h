//
//  MapLocation.h
//  RenWoXing
//
//  Created by 李昞辰 on 16/5/10.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol MapLocationDelegate <NSObject>

- (void)userLocationCoooor:(CLLocationCoordinate2D)coooor;

@end

@interface MapLocation : NSObject

+ (instancetype)shareMapLocation;

//初始化百度地图用户位置管理类
- (void)initBMKUserLocation;

//开始定位
-(void)startLocation;

//停止定位
-(void)stopLocation;

@property (nonatomic, assign) id<MapLocationDelegate>locationDelegate;


@end
