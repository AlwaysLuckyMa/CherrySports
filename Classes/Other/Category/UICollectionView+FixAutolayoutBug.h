//
//  UICollectionView+FixAutolayoutBug.h
//  RenWoXing
//
//  Created by dkb on 16/8/2.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (FixAutolayoutBug)

+ (void)fixLayoutSubviewsBug;

- (void)_layoutSubviews;

@end
