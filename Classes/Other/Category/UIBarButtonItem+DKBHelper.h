//
//  UIBarButtonItem+DKBHelper.h
//  CarNetworking
//
//  Created by dkb on 16/9/12.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DKBHelper)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemBackWithTitle:(NSString *)title target:(id)target action:(SEL)action;

// 搜索页面取消按钮
+ (instancetype)SearchRightWithTitle:(NSString *)title target:(id)target action:(SEL)action;

#pragma mark - 因为登录页面左右两侧按钮和标题的高度不一所以单独写
// 登录页面左边按钮
+ (instancetype)LoginLeftbarWithTitle:(NSString *)title target:(id)target action:(SEL)action;
// 登录页面右边按钮
+ (instancetype)LoginRightbarWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)itemDoubleWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
