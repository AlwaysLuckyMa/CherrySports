//
//  SportMapView.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/6.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportMapView : UIView

@property (nonatomic,copy) void(^MapViewSelect)(NSInteger);

@end
