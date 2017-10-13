//
//  weChatPay.m
//  RenWoXing
//
//  Created by 一休休休休 on 16/5/4.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "weChatPay.h"
#import "ServerUtility.h"

@implementation weChatPay
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static weChatPay *instance;
    dispatch_once(&onceToken, ^{
        instance = [[weChatPay alloc] init];
    });
    return instance;
}

- (void) wechatPayPartnerId:(NSString *)partnerId PrepayId:(NSString *)prepayId NonceStr:(NSString *)nonceStr TumeStamp:(NSString *)tumeStamp Package:(NSString *)package Sign:(NSString *)sign
{
    PayReq *req   = [[PayReq alloc] init];
    req.partnerId           = partnerId;
    req.prepayId            = prepayId;
    req.nonceStr            = nonceStr;
    req.timeStamp           = tumeStamp.intValue;
    req.package             = package;
    req.sign                = sign;
    [WXApi sendReq:req];
}

- (void) weChatPayAction :(id)target UrlPath:(NSString *)urlPath PostArr:(NSArray *)postArr{
//    NSString *urlPath = @"http://192.168.1.3:8081/useritf/pay/wechat_ao?pId=027&totalPrice=327&buyCount=3";
    [ServerUtility POSTAction:urlPath param:postArr target:target finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            NSLog(@"%@",obj);
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]){
                [[NSUserDefaults standardUserDefaults] setValue:[obj objectForKey:@"oId"] forKey:@"oId"];
                PayReq *req   = [[PayReq alloc] init];
                req.partnerId           = [obj objectForKey:@"partnerId"];
                req.prepayId            = [obj objectForKey:@"prepayId"];
                req.nonceStr            = [obj objectForKey:@"nonceStr"];
                req.timeStamp           = [[obj objectForKey:@"timeStamp"] intValue];
                req.package             = [obj objectForKey:@"packageValue"];
                req.sign                = [obj objectForKey:@"sign"];
                [WXApi sendReq:req];
            }
            
        }else{
            NSLog(@"%@",error);
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:target animated:YES];
            mbp.detailsLabelText = @"亲，网络开小差了。";
            mbp.detailsLabelFont = TEXT_FONT_BIG;
            mbp.mode = MBProgressHUDModeText;
            [mbp hide:YES afterDelay:2.00];
            
        }
    }];
    
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        [_delegate wxPayResult:resp.errCode];
    }
    
}

@end
