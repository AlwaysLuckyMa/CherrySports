//
//  MyAnimatedAnnotationView.h
//  RenWoXing
//
//  Created by 李昞辰 on 16/5/4.
//  Copyright © 2016年 一休休休休. All rights reserved.
//
/**
 *  自定义标注
 */

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MyAnimatedAnnotationView : BMKAnnotationView

@property (nonatomic, strong) NSMutableArray *annotationImages;
@property (nonatomic, strong) UIImageView *annotationImageView;

@end
