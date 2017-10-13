//
//  UITextView+FixAutolayoutBug.m
//  RenWoXing
//
//  Created by dkb on 16/8/3.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "UITextView+FixAutolayoutBug.h"

@implementation UITextView (FixAutolayoutBug)

+ (void)fixLayoutSubbiewsBug
{
    Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method new = class_getInstanceMethod(self, @selector(_layoutSubviews));
    
    method_exchangeImplementations(existing, new);
}

- (void)_layoutSubviews
{
    [super layoutSubviews];
    [self _layoutSubviews];
    [super layoutSubviews];
}


@end
