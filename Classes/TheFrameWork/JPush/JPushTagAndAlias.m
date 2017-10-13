//
//  JPushTagAndAlias.m
//  RenWoXing
//
//  Created by 一休休休休 on 16/5/5.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "JPushTagAndAlias.h"
#import "JPUSHService.h"

@implementation JPushTagAndAlias
+(instancetype)shareJPush {
    static dispatch_once_t onceToken;
    static JPushTagAndAlias *instance;
    dispatch_once(&onceToken, ^{
        instance = [[JPushTagAndAlias alloc] init];
    });
    return instance;
}


-(void) setTagsAlias:(NSString *)alias {
    //设置tag值，暂时放在这里
    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
    [self setTags:&tags addTag:@"tag1"];
    [self analyseInput:&alias tags:&tags];
    
    [JPUSHService setTags:tags
                    alias:alias
         callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                   target:self];
}

- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
    //  if ([tag isEqualToString:@""]) {
    // }
    [*tags addObject:tag];
}
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)analyseInput:(NSString **)alias tags:(NSSet **)tags {
    // alias analyse
    if (![*alias length]) {
        // ignore alias
        *alias = nil;
    }
    // tags analyse
    if (![*tags count]) {
        *tags = nil;
    } else {
        __block int emptyStringCount = 0;
        [*tags enumerateObjectsUsingBlock:^(NSString *tag, BOOL *stop) {
            if ([tag isEqualToString:@""]) {
                emptyStringCount++;
            } else {
                emptyStringCount = 0;
                *stop = YES;
            }
        }];
        if (emptyStringCount == [*tags count]) {
            *tags = nil;
        }
    }
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}


@end
