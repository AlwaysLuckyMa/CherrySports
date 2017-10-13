//
//  DKBNavigationController.m
//  CarNetworking
//
//  Created by dkb on 16/9/13.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "DKBNavigationController.h"


#import "HomeViewController.h"
#import "CommunityViewController.h"
#import "NewsViewController.h"
#import "EventsViewController.h"
#import "MineViewController.h"

#import "DKBTabBar.h"
@interface DKBNavigationController (){
    BOOL _poping;
    UIViewController *_popVC;
}

@end

@implementation DKBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航控制器背景图片(这里图片颜色跟系统默认一样 看不出效果)
    WS(weakSelf);
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}
/**
 * 可以在这个方法中拦截所有push进来的控制器
 */

// 改变push过后的返回按钮，需要重写pushViewController方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 如果push进来的不是第一个控制器
    if (self.childViewControllers.count > 0)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        // 别忘记设置尺寸
        button.size = CGSizeMake(70, 30);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit]; 尺寸跟随里面的内容
        // contentEdgeInsets内边距
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if (animated) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // 这句super的push要放在后面,让ViewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (animated) {
        _poping = YES;
        _popVC = [self visibleViewController];
    }
    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = YES;
    _poping = NO;
    _popVC = nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count == 1 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
        if (_poping && ![_popVC isEqual:(self.visibleViewController)]) {
            return NO;
        }
    }
    
    return YES;
}

// 点击按钮pop回上一页
- (void)back
{
    self.hidesBottomBarWhenPushed = NO;
    [self popViewControllerAnimated:YES];
}


@end
