//
//  ServerUtility.h
//  Manager
//
//  Created by 一休休休休 on 16/3/19.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^DownloadProgress)     (CGFloat progress,CGFloat total,CGFloat current);
typedef void(^CompletionState)      (BOOL state,NSString * message,NSString * filePath,NSString * response);

typedef void(^GPXFileBlock)         (NSURL * gpxFileUrl);
typedef void(^GPXFileBlockProgress) (CGFloat progress,CGFloat total,CGFloat current);

@interface ServerUtility : NSObject


+(NSString *) get_postArray:(NSArray*)postArray;

+(void) POSTAction:(NSString *)urlpath param:(NSArray *)postArray target:(id)aTarget finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;

+(void) indexPOSTAction:(NSString *)urlpath param:(NSArray *)postArray target:(id)aTarget finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;


// 下载
+ (NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString *)url status:(NSString *)status Version:(NSString *)version DownloadProgress:(DownloadProgress)progress DownloadCompletion:(CompletionState)completion;
+ (void)pause:(NSURLSessionDownloadTask *)task;
+ (void)start:(NSURLSessionDownloadTask *)task;

+ (void)downloadUrl:(NSString *)urlStr GPXFileblock:(void(^)(NSURL * gpxFileUrl))gpxFileUrl loadDownFileProgress:(void(^)(CGFloat progress,CGFloat total,CGFloat current))progress;

@end
