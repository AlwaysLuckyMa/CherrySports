//
//  UIView+tapClick.m
//  CarNetworking
//
//  Created by dkb on 16/9/13.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "UIView+tapClick.h"
#import <objc/runtime.h>

static char tapChar_DKB;

@implementation UIView (tapClick)

- (void)tapClick:(void (^)())clickBlock{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandleMethod:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    //   设置关联
    /*!
     *  @author dKB
     * id object 调用者  self
     * const void *key C 语言字符 （*key 取地址）
     *   id value   任意类型, 这里填写block即可
     * objc_AssociationPolicy policy  属性策略
     */
    objc_setAssociatedObject(self, &tapChar_DKB, clickBlock, 3);
}

- (void)tapHandleMethod:(UITapGestureRecognizer *)tap{
    void(^tapBlock)() = objc_getAssociatedObject(self, &tapChar_DKB);
    if (tapBlock) {
        tapBlock();
    }
}


@end
