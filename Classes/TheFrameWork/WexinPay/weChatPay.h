//
//  weChatPay.h
//  RenWoXing
//
//  Created by 一休休休休 on 16/5/4.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)wxPayResult:(int)result;

@end

@interface weChatPay : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;
- (void) wechatPayPartnerId:(NSString *)partnerId PrepayId:(NSString *)prepayId NonceStr:(NSString *)nonceStr TumeStamp:(NSString *)tumeStamp Package:(NSString *)package Sign:(NSString *)sign;

- (void) weChatPayAction :(id)target UrlPath:(NSString *)urlPath PostArr:(NSArray *)postArr;
@end
