//
//  MapLocationViewController.h
//  RenWoXing
//
//  Created by 李昞辰 on 16/5/4.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapLocationViewController : UIViewController

@property (nonatomic, copy)NSString *storeName;
@property (nonatomic, copy)NSString *placeName;
@property (nonatomic, assign)CLLocationCoordinate2D locationCoor;

@end
