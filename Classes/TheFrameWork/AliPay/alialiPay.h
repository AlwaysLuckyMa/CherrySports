//
//  alialiPay.h
//  RenWoXing
//
//  Created by 一休休休休 on 16/5/4.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol aliPayDelegate <NSObject>

@optional
- (void)aliPayResult:(int)result;
@end

@interface alialiPay : NSObject

@property (nonatomic, assign) id<aliPayDelegate> delegate;
+ (instancetype)sharedManager;
- (void) aliPayAction :(id)target UrlPath:(NSString *)urlPath PostArr:(NSArray *)postArr;


- (void)aliPayPayInfo:(NSString *)orderSpec Sign:(NSString *)signedString;
@end
