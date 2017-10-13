//
//  shareArr.h
//  图片放大
//
//  Created by 嘟嘟 on 2017/6/30.
//  Copyright © 2017年 MC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface shareArr : NSObject

@property (nonatomic, copy)NSMutableArray *urlArr;
@property (nonatomic, copy)NSMutableArray *shareAllArr;

@property (nonatomic, assign)int Record_num;

@property(nonatomic)NSInteger maxValue;
@property(nonatomic)NSInteger alValue;

@property(nonatomic)NSInteger lastNum;
@property (nonatomic, copy)NSMutableArray *lastNumArr;

@property(nonatomic,copy)NSString * contStr;

+ (instancetype)getURLArrShare;



@end
