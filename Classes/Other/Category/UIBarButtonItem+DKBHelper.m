//
//  UIBarButtonItem+DKBHelper.m
//  CarNetworking
//
//  Created by dkb on 16/9/12.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "UIBarButtonItem+DKBHelper.h"

@implementation UIBarButtonItem (DKBHelper)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 为tagButton设置尺寸
    button.size = button.currentBackgroundImage.size;
    // target 调用target对象的action方法
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // self 就是这个类 相当于UIBarbuttonItem
    return [[self alloc] initWithCustomView:button];// CustomView:自定义View
}

+ (instancetype)itemBackWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        // 别忘记设置尺寸
        button.size = CGSizeMake(80, 18);
        button.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:13];
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.userInteractionEnabled = NO;// 不可点击
        // contentEdgeInsets内边距
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 14, 0.5, 0);
    }else{
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        // 别忘记设置尺寸
        button.size = CGSizeMake(19, 34);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit]; 尺寸跟随里面的内容
        // contentEdgeInsets内边距
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[self alloc] initWithCustomView:button];
}
// 搜索页面取消按钮
+ (instancetype)SearchRightWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        // 别忘记设置尺寸
        CGFloat buttonwidth = [AppTools labelRectWithLabelSize:CGSizeMake(0, 15) LabelText:title Font:[UIFont systemFontOfSize:12]].width;
        button.size = CGSizeMake(buttonwidth, 18);
        button.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:12];
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.userInteractionEnabled = YES;// 可点击
        // contentEdgeInsets内边距
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        // 别忘记设置尺寸
        button.size = CGSizeMake(19, 34);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit]; 尺寸跟随里面的内容
        // contentEdgeInsets内边距
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)LoginLeftbarWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    // 别忘记设置尺寸
    button.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // contentEdgeInsets内边距
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, -4, 0);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // self 就是这个类 相当于UIBarbuttonItem
    return [[self alloc] initWithCustomView:button];// CustomView:自定义View
}

+ (instancetype)LoginRightbarWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    // 别忘记设置尺寸
    button.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    // contentEdgeInsets内边距
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, -4, 0);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // self 就是这个类 相当于UIBarbuttonItem
    return [[self alloc] initWithCustomView:button];// CustomView:自定义View
}

+ (instancetype)itemDoubleWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 为tagButton设置尺寸
    button.size = button.currentBackgroundImage.size;
    // target 调用target对象的action方法
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // self 就是这个类 相当于UIBarbuttonItem
    return [[self alloc] initWithCustomView:button];// CustomView:自定义View
}

@end
