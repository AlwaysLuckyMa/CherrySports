//
//  DKBTabBar.m
//  CarNetworking
//
//  Created by dkb on 16/9/12.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "DKBTabBar.h"

@interface DKBTabBar ()

@end

@implementation DKBTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundImage:[UIImage imageNamed:@"background"]];
    }
    return self;
}

// 布局子页面
- (void)layoutSubviews
{
    // 等之前的布局完之后，再布局一次
    [super layoutSubviews];
    
    // 拿到扩展类中的宽度高度
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5; // 5个按钮每个占五分之一 //2017070710.54 1994
    CGFloat buttonH = height;
    NSInteger index = 0; // 索引 0 ~ 4
    
//    NSlog(@"%@",self.subviews); //查看除了按钮,其他控件
    for (UIView *button in self.subviews)
    {
        // 遍历当前控件 获取到_UIBarBackground 这个UIView
//        if (button.height == 49.5)// 62 其实应该是个固定数据 定值
//        {
//            NSLog(@"_UIBarBackground子视图图片的数目%ld",button.subviews.count);
//            NSLog(@"_UIBarBackground子视图类型%@====%@",[button.subviews.firstObject class], [button.subviews.lastObject class]);
//            // 按照顺序,应该是最后一个添加的显示最前面,所以移除最后一个啊
//            [button.subviews.lastObject removeFromSuperview];
//        }
    
        // isKindOfClass 类型
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue; // 判断如果不是UITabBarButton类型 就continue
        // 第一种判断方法
        CGFloat buttonX = buttonW *index;
        // 另一种判断方法 如果不是继承自UIControl 或者button == self.publishButton 就continue
        // if (![button isKindOfClass:[UIControl class]] || button == self.publishButton)continue;
        
        // 宽度高度Y值都一样 所以放到外面去算
        button.frame = CGRectMake(buttonX, buttonY-1, buttonW, buttonH);
        
        // 增加索引
        index++;
    }
}

@end
