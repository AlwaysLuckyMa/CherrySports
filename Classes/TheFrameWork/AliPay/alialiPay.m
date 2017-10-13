//
//  alialiPay.m
//  RenWoXing
//
//  Created by 一休休休休 on 16/5/4.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "alialiPay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation alialiPay

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static alialiPay *instance;
    dispatch_once(&onceToken, ^{
        instance = [[alialiPay alloc] init];
    });
    return instance;
}

/** 调用这个方法*/
- (void)aliPayPayInfo:(NSString *)orderSpec Sign:(NSString *)signedString
{
    NSString *appScheme = @"CherrySportsScheme";
    
    if (orderSpec.length > 0 && signedString >0) {
        NSString *orderString = [NSString stringWithFormat:@"%@&biz_content=%@", orderSpec, signedString];
        NSlog(@"orderString = %@", orderString);
        [[[UIApplication sharedApplication] windows]objectAtIndex:0].hidden = NO;;
//        NSString *str = [self decodeString:orderString];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSlog(@"reslut = %@",resultDic);
            [_delegate aliPayResult:[[resultDic objectForKey:@"resultStatus"] intValue]];
        }];
    }
    
    
    //            [AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:<#(NSString *)#>
}

//-(NSString *)decodeString:(NSString*)encodedString
//
//{
//    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
//    
//    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
//                                                                                                                     (__bridge CFStringRef)encodedString,
//                                                                                                                     CFSTR(""),
//                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    return decodedString;
//}




-(void) aliPayAction:(id)target UrlPath:(NSString *)urlPath PostArr:(NSArray *)postArr{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"CherrySportsScheme";
//    NSString *urlPath = @"http://192.168.1.3:8081/useritf/pay/alipay_ao";
    [ServerUtility POSTAction:urlPath param:postArr target:target finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            NSlog(@"%@",obj);
            
            if ([[obj objectForKey:@"resultCode"] isEqualToString:@"0000"]){
                [[NSUserDefaults standardUserDefaults] setValue:[obj objectForKey:@"oId"] forKey:@"oId"];
                NSString *orderSpec = [obj objectForKey:@"payInfo"];
                NSString *signedString = [obj objectForKey:@"sign"];
                //将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = nil;
                if (signedString != nil) {
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, signedString, @"RSA"];
                    
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSlog(@"reslut = %@",resultDic);
                        [_delegate aliPayResult:[[resultDic objectForKey:@"resultStatus"] intValue]];
                    }];
                }
            } else {
                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:target animated:YES];
                mbp.detailsLabelText = [obj objectForKey:@"resultMessage"];
                mbp.detailsLabelFont = TEXT_FONT_BIG;
                mbp.mode = MBProgressHUDModeText;
                [mbp hide:YES afterDelay:2.00];
            }
            
        }else{
            NSlog(@"%@",error);
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:target animated:YES];
            mbp.detailsLabelText = @"亲，网络开小差了。";
            mbp.detailsLabelFont = TEXT_FONT_BIG;
            mbp.mode = MBProgressHUDModeText;
            [mbp hide:YES afterDelay:2.00];
        }
    }];
}



@end
