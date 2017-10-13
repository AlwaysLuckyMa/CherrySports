//
//  UIImage+Extension.h
//  CherrySports
//
//  Created by dkb on 16/11/7.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 * 传入图片的名称,返回一张可拉伸不变形的图片
 *
 * @param imageName 图片名称
 *
 * @return 可拉伸图片
 */
+ (UIImage *)resizableImageWithName:(NSString *)imageName;

@end
