//
//  UIView+tapClick.h
//  CarNetworking
//
//  Created by dkb on 16/9/13.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (tapClick)
- (void)tapClick:(void (^)())clickBlock;
@end
