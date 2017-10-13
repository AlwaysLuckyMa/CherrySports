//
//  shareArr.m
//  图片放大
//
//  Created by 嘟嘟 on 2017/6/30.
//  Copyright © 2017年 MC. All rights reserved.
//

#import "shareArr.h"

@implementation shareArr

+ (instancetype)getURLArrShare{
    static dispatch_once_t pred;
    static shareArr *share_arr;
    dispatch_once(&pred, ^{
        share_arr = [[shareArr alloc] init];
    });
    return share_arr;
}



- (NSMutableArray *)shareAllArr
{
    if (_shareAllArr ==nil) {
        _shareAllArr = [NSMutableArray array];
    }
    return _shareAllArr;
}

- (NSMutableArray *)lastNumArr
{
    if (_lastNumArr ==nil) {
        _lastNumArr = [NSMutableArray array];
    }
    return _lastNumArr;
}

- (NSMutableArray *)urlArr
{
    if (_urlArr ==nil) {
        _urlArr = [NSMutableArray array];
    }
    return _urlArr;
}



@end
