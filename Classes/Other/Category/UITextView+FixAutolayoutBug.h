//
//  UITextView+FixAutolayoutBug.h
//  RenWoXing
//
//  Created by dkb on 16/8/3.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (FixAutolayoutBug)

+ (void)fixLayoutSubbiewsBug;
- (void)_layoutSubviews;

@end
