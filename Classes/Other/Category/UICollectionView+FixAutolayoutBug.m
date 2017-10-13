//
//  UICollectionView+FixAutolayoutBug.m
//  RenWoXing
//
//  Created by dkb on 16/8/2.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "UICollectionView+FixAutolayoutBug.h"

@implementation UICollectionView (FixAutolayoutBug)

+ (void)fixLayoutSubviewsBug
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


