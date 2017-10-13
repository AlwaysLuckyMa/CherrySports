//
//  ServerUtility.m
//  Manager
//
//  Created by 一休休休休 on 16/3/19.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "ServerUtility.h"
#import "MD5.h"
#import <AFNetworking.h>

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL YES
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certificate @"lxtyssl"

static BOOL isFirst = NO;
static BOOL canCHeckNetwork = NO;

@implementation ServerUtility

#pragma 传入多个或单个字段都可用
+(NSDictionary *) get_postArray:(NSArray*) postArray {
    
    NSMutableDictionary *afPostDic = [NSMutableDictionary new];
    NSString *ValidateStr = @"";
    NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:@"data" ascending:YES];
    
    postArray = [postArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByA]];
    
    //post数据
    for (NSDictionary *postDic in postArray) {
        if (![[postDic objectForKey:@"data"] isEqualToString:@""]) {
            
            NSString *str = [AppTools myTransformHiraganaKatakana:[postDic objectForKey:@"data"]];
            ValidateStr = [ValidateStr stringByAppendingString:str];
            [afPostDic setValue:str forKey:[postDic objectForKey:@"dicKey"]];
        }        
    }
    
    ValidateStr = [ValidateStr stringByAppendingString:@"77D20B37F67CF43423A19FC3D21AFCB0"];
    ValidateStr = [AppTools encodeToPercentEscapeString:ValidateStr];
    ValidateStr = [ValidateStr stringByReplacingOccurrencesOfString:@"%20" withString:@""];
    [afPostDic setValue:[MD5 md5:[ValidateStr lowercaseString]] forKey:@"validatekey"];
    [afPostDic setValue:@"iOS" forKey:@"appcode"];
    
    return afPostDic;
}

/**
 *  登录接口专用
 *
 *  @param urlpath   接口地址
 *  @param postArray 接口参数
 *  @param cb        回调
 */
+(void) indexPOSTAction:(NSString *)urlpath param:(NSArray *)postArray target:(id)aTarget finish:(void (^)(NSData *, NSDictionary *, NSError *))cb{    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCHeckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错位" code:100 userInfo:nil];
        cb(nil, nil,error);
        return;
    }
    
    //2..实现解析
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager]; // 获得请求管理者
    /* https 1
     * 加上这个函数， https ssl 验证
     */
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    //告诉afn返回格式不是json
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.f;
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];//添加类型
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    MBProgressHUD * hud = [[MBProgressHUD alloc]init];
    if (aTarget != nil) {
        [aTarget addSubview: hud];
        [hud show:YES];    // 开始显示数据加载的显示图片
    }
    
    [manager POST:urlpath parameters:[ServerUtility get_postArray:postArray] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        [hud removeFromSuperview];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //成功 cb是对方传递过来的对象 这里是直接调用
        if(responseObject == nil){
            cb(nil,nil,nil);
        }else{
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            cb(responseObject, obj ,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud removeFromSuperview];
        //失败
        NSLog(@"%@",error);
        cb(nil, nil ,error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

}

+ (void)POSTAction:(NSString *)urlpath
             param:(NSArray *)postArray
            target:(id)aTarget
            finish:(void (^)(NSData *, NSDictionary *, NSError *))cb{
//    UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未知");
                    // 后加：如果有网络就置为NO
                    canCHeckNetwork = NO;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"没有网络");
                    canCHeckNetwork = YES;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3G|4G");
                    // 后加：如果有网络就置为NO
                    canCHeckNetwork = NO;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    // 后加：如果有网络就置为NO
                    canCHeckNetwork = NO;
                    NSLog(@"WiFi");
                    break;
                default:
                    break;
            }
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        // 后加：如果这次没网让它下次还判断网络
        isFirst = NO;
        NSError *error = [NSError errorWithDomain:@"网络错位" code:100 userInfo:nil];
//        errorView.backgroundColor = [UIColor redColor];
//        [aTarget addSubview:errorView];
        cb(nil, nil,error);
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //2..实现解析
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = 15.f;
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];//添加类型
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    MBProgressHUD * hud = [[MBProgressHUD alloc]init];
    [aTarget addSubview: hud];
    [hud show:YES];    // 开始显示数据加载的显示图片
    
    [manager POST:urlpath parameters:[ServerUtility get_postArray:postArray] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [hud removeFromSuperview];
        //成功 cb是对方传递过来的对象 这里是直接调用
        if(responseObject == nil){
            cb(nil,nil,nil);
        }else{
//            [errorView removeFromSuperview];
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            cb(responseObject, obj ,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud removeFromSuperview];
        //失败
        NSLog(@"%@",error);
//        errorView.backgroundColor = [UIColor redColor];
//        [aTarget addSubview:errorView];
        cb(nil, nil ,error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *setCer = [[NSSet alloc] initWithObjects:certData, nil];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
//    securityPolicy.pinnedCertificates = @[certData];
    securityPolicy.pinnedCertificates = setCer;
    
    return securityPolicy;
}

// 下载视频
+ (NSURLSessionDownloadTask * )downloadFileWithUrl:(NSString *)url
                                            status:(NSString *)status
                                           Version:(NSString *)version
                                  DownloadProgress:(DownloadProgress)progress
                                DownloadCompletion:(CompletionState)completion
{
    // 1、 设置请求
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    // 2、初始化
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    // 3、开始下载
    
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request
                                                              progress:^(NSProgress * _Nonnull downloadProgress)
    {
        progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount,
                 1.0 * downloadProgress.totalUnitCount,1.0 * downloadProgress.completedUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //这里要返回一个NSURL，其实就是文件的位置路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        if ([status isEqualToString:@"0"])
        {
            NSlog(@"视频路径：%@",fullPath);
        }else{
            
//            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
            
            NSlog(@"图片路径：%@",fullPath);
        }
        return [NSURL fileURLWithPath:fullPath];//转化为文件路径
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error){
        
        //如果下载的是压缩包的话，可以在这里进行解压
        NSLog(@"----%@---%ld---%@",error.domain,error.code,error);
        //下载成功
        if (error == nil)
        {
            completion(YES,@"下载完成",[filePath path], response.suggestedFilename);
            NSlog(@"%@",filePath);
            
        }else{
            //下载失败的时候，只列举判断了两种错误状态码
            NSString * message = nil;
            if (error.code == - 1005) {
                message = @"网络异常";
            }else if (error.code == -1001){
                message = @"请求超时";
            }else{
                message = @"未知错误";
            }
            completion(NO,message,nil,nil);
        }
    }];
    [task resume];
    return task;
}

//+ (void)pause:(NSURLSessionDownloadTask *)task{
//    [task suspend];
//}

+ (void)start:(NSURLSessionDownloadTask *)task{
    [task resume];
}


+ (void)downloadUrl:(NSString *)urlStr GPXFileblock:(void(^)(NSURL * gpxFileUrl))gpxFileUrl loadDownFileProgress:(void(^)(CGFloat progress,CGFloat total,CGFloat current))progress;
{
    MBProgressHUD * hud = [[MBProgressHUD alloc]init];
    hud.labelText = @"gpx文件加载中";
    [hud show:YES];    // 开始显示数据加载的显示图片
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /*
     参数1.请求对象
     参数2.progress进度回调 downloadProgress处理进度
     参数3.destination 回调（目标位置）
     有返回值
     targetPath :临时文件路径
     response：响应头信息
     参数4.completionHandler 下载完成后的回调
     filePath:最终的存放文件路径
     */
    // 下载文件
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress)
    {
        NSlog(@"GPX文件加载中");
        progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount,
                 1.0 * downloadProgress.totalUnitCount,
                 1.0 * downloadProgress.completedUnitCount);
    }
    destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response)
    {
        //Cache
//        NSArray  * paths           = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
//        NSString * cachesDirectory = [paths objectAtIndex:0];
//        NSString * str             = [cachesDirectory stringByAppendingPathComponent:@"GPX/News.archive"];
        
        //Documents
        NSString * fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSlog(@"document   = %@",fullPath);
        NSlog(@"targetPath = %@",targetPath);
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error)
    {
        NSlog(@"下载gpx文件完成回调--%@",filePath);
        gpxFileUrl(filePath);
        [hud removeFromSuperview];
    }];
    
    [download resume];
    
    
    
  
}

/** https ssl 验证函数*/
//- (AFSecurityPolicy *)customSecurityPolicy{
//    // 先导入证书 证书由服务端生成，具体由服务端人员操作
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"]; // 证书的路径
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    // validatesDomainName 是否需要验证域名， 默认为YES；
//    // 假如证书的域名与你请求的域名不一致，需把该项设置为NO，如设成NO的话，即服务器使用其他科新人机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    // 置为NO，主要用于这种请求：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com
//    // 如置为NO，建议自己添加对应域名的校验逻辑
////    securityPolicy.validatesDomainName = NO;
//    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
//    
//    return securityPolicy;
//}

/*
三.关于证书 参考文章:http://www.2cto.com/Article/201510/444706.html
服务端给的是crt后缀的证书，其中iOS客户端用到的cer证书，是需要开发人员转换：
1.证书转换
在服务器人员，给你发送的crt证书后，进到证书路径，执行下面语句

openssl x509 -in 你的证书.crt -out 你的证书.cer -outform der

这样你就可以得到cer类型的证书了。双击，导入电脑。
2.证书放入工程
1、可以直接把转换好的cer文件拖动到工程中。
2、可以在钥匙串内，找到你导入的证书，单击右键，导出项目，就可以导出.cer文件的证书了

参考链接:http://www.jianshu.com/p/97745be81d64。

四.在info.plist去掉之前允许http加载的代码 就是删除下面的代码(么有的就省了这一步)
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
*/
@end
