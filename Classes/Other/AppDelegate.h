//
//  AppDelegate.h
//  CherrySports
//
//  Created by dkb on 16/10/25.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
//static NSString *appKey = @"08c3c54b25c11a40d45b3ca9"; // 神州成的key
static NSString *appKey = @"95d7300332032f599feb9617"; // 樱桃Key
static NSString *channel = @"App Store";
static BOOL isProduction = 0;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) BMKMapManager *mapManager;
/***  是否允许横屏的标记 */
@property (nonatomic,assign)BOOL allowRotation;

@end

