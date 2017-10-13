//
//  AppDelegate.m
//  CherrySports
//
//  Created by dkb on 16/10/25.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "AppDelegate.h"
#import "EBForeNotification.h"

#define UMAPPKEY @"58116387734be45d4e0025a1"
#define WeiXInAPPKey @"wx4c522c8994d0241b"
#define WeiXinAPPSecret @"4eddc8ef43d8800734d7915ebed0886e"
#define SinaAPPkey @"4223238394"
#define SinaAPPSecret @"5de061271b396919ad1dfbaea23b5c1f"
#define QQAPPID @"1105783746"
#define QQAPPKey @"7t8pR3CBighsP2eg"


@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    sleep(0.3);
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];

    // 打开数据库
    [[KBDataBaseSingle sharDataBase] openDB]; //星期五
    
    DKBTabBarController *tabbar = [[DKBTabBarController alloc] init];;
    
    
    // 进入程序 默认显示第0个tabbar
    tabbar.selectedIndex = 0;
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [tabbar.tabBar setBackgroundImage:img];
    [tabbar.tabBar setShadowImage:img];
    
    [tabbar.tabBar setBackgroundImage:[UIImage imageNamed:@"background"]];
    
    self.window.rootViewController = tabbar;
    
    // 改变输入光标颜色
    [[UITextField appearance] setTintColor:UIColorFromRGB(0x07bd29)];
    [[UITextView appearance] setTintColor:UIColorFromRGB(0x07bd29)];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"svlWowAMXO46oml9UWTHBV6jaLCi43RP"  generalDelegate:nil];
    if (!ret) {
        NSlog(@"manager start failed!");
    }
    // 初始化百度地图单利类
    [[MapLocation shareMapLocation] initBMKUserLocation];
    [[MapLocation shareMapLocation] startLocation];
    
    //     友盟登录
    [self useUMengSocialData];
    //     注册微信AppId
    [WXApi registerApp:WeiXInAPPKey withDescription:@"weixin"];
    
    
//    UITextView *textview = [UITextView new];

    
    // 极光
    //JPush
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dddd:) name:EBBannerViewDidClick object:nil];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"registration = %@", registrationID);
    }];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - 友盟登录
- (void)useUMengSocialData
{
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAPPKEY];
    // 获取友盟social版本号
    NSlog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    //第一个参数为新浪appkey,第二个参数为新浪secret，第三个参数是新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAPPkey  appSecret:SinaAPPSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //设置微信AppKey和secret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeiXInAPPKey appSecret:WeiXinAPPSecret redirectURL:@""];
    // 如果不想显示平台下的某些类型，可用以下接口设置
    //    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    //设置qq平台
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPID appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

// 支持所有iOS系统
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        if ([url.host isEqualToString:@"safepay"]) {
//            //跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSlog(@"result = %@",resultDic);
//                
//            }];
//        }else{
//            return [WXApi handleOpenURL:url delegate:[weChatPay sharedManager]];
//        }
//        return YES;
//    }
//    return result;
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [WXApi handleOpenURL:url delegate:[weChatPay sharedManager]];
//}

#pragma mark - IOS9.0以后废弃了这两个方法的调用  改用上边这个方法了，请注意、
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // 其他如支付等SDK的回调
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay", @"wx4c522c8994d0241b"]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:[weChatPay sharedManager]];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 其他如支付等SDK的回调
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay", @"wx4c522c8994d0241b"]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:[weChatPay sharedManager]];
            //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic){
            NSlog(@"result = %@",resultDic);
                
        }];
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    // 其他如支付等SDK的回调
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay", @"wx4c522c8994d0241b"]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:[weChatPay sharedManager]];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic){
            NSlog(@"result = %@",resultDic);
            
        }];
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    [UMSocialSnsService  applicationDidBecomeActive];
//}

// 禁止应用横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (self.allowRotation) {
//        return  UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    if (application.applicationState == UIApplicationStateActive) {
        
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:NO];
        completionHandler(UIBackgroundFetchResultNewData);
        
    }else{
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSlog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:YES];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:YES];
    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //应用程序进入后台时，将当前VC传给接口用于统计。
//    [AppTools getCurrentVC];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//-(void)dddd:(NSNotification*)noti{
//    NSLog(@"ddd,%@",noti);
//}

@end
@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host

{
    
    return YES;
    
}
@end
