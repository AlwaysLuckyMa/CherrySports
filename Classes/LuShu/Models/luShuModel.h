//
//  luShuModel.h
//  气泡Demo
//
//  Created by 嘟嘟 on 2017/9/4.
//  Copyright © 2017年 MC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface luShuModel : NSObject

@property (nonatomic,strong) NSString  * city;
@property (nonatomic,strong) NSString  * title;
@property (nonatomic,assign) CGFloat     latitude;
@property (nonatomic,assign) CGFloat     longitude;
@property (nonatomic,assign) NSInteger * tag;
@property (nonatomic,assign) CLLocationCoordinate2D coor;
//@property (nonatomic,assign) CLLocationCoordinate2D lastCoor;
@property (nonatomic,strong) UIColor  * bgcolor;

@end
