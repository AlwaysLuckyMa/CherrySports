//
//  AppTools.h
//
//  Created by dkb on 16/3/14.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AppTools : NSObject
/** 返回高度*/
+ (CGSize)labelRectWithLabelSize:(CGSize)size
                      LabelText:(NSString *)labelText
                           Font:(UIFont *)font;

/** 日期*/
+ (NSString *)timestampExchange:(NSInteger)time;

/** 时间*/
+(NSString*)getDateWithUpdatedAt:(NSInteger)time;

// 文字转图片
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color;

/**
 *  循环TableViewCell取值
 *
 *  @param tableView tableView description
 *
 *  @return return value description
 */
+(NSArray *)cellsForTableView:(UITableView *)tableView;

/**
 *  获取字符串格式的当前时间
 *
 *  @return return value description
 */
+(NSString*)getCurrentTimeString:(NSDate *)date format:(NSString *)format;

/**
 *  字符串转date再转字符串 **年*月*日
 */
+ (NSString *)strWithDateWithStr:(NSString *)strDate dateFormat:(NSString *)dateFormat;

/**
 *  二维码
 */
+ (UIImage *)barCode2DStr:(NSString *)str;

/*
 * 导航栏右侧按钮
 */
+ (UIButton *)rightbuttonTitle:(NSString *)title;
/**
 *  字符集转码
 */
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
/**
 *  全角转半角
 */
+ (NSString *)myTransformHiraganaKatakana:(NSString *)str;

/**
 *  验证输入 (textFeild做限制)
 */
+ (BOOL)validateNumber:(NSString*)str validateStr:(NSString *)validateStr;
/**
 *   给 UIView 某几个角添加圆角
 *
 *  @param aView    输入view
 *  @param aCorners 要添加圆角的角（方向）
 *  @param aSize    圆角size
 */
+ (void)addCornerWithView:(UIView *)aView type:(UIRectCorner)aCorners size:(CGSize)aSize;


+ (UIImageView *)createWireImageX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Color:(UIColor *)color;

#pragma mark - 基本控件封装
/** UILabel */
+ (UILabel *)createLabelText:(NSString *)text Color:(UIColor *)color Font:(CGFloat)font TextAlignment:(NSTextAlignment)textAlignment;
/** 带间距的label*/
+ (UILabel *)createLabelText:(NSString *)text Color:(UIColor *)color Font:(CGFloat)font TextAlignment:(NSTextAlignment)textAlignment Number:(CGFloat)number;
/** 设置字间距*/
+ (NSAttributedString *)labelNumber:(int)number String:(NSString *)str;
/** UIView */
+ (UIView *)createViewBackground:(UIColor *)background;
/** UIButton */
+ (UIButton *)createButtonTitle:(NSString *)title TitleColor:(UIColor *)titleColor Font:(CGFloat)font Background:(UIColor *)background;
/** UIImageView */
+ (UIImageView *)CreateImageViewImageName:(NSString *)imageName;
/** UITextField */
+ (UITextField *)createTextFieldText:(NSString *)title Placeholder:(NSString *)placeholder TextColor:(UIColor *)textColor TextFont:(CGFloat)textFont TextAlignment:(NSTextAlignment)textAlignment;

/**
 *  返回一张纯色的图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  返回拼接好的图片地址
 *
 *  @param imagePath 网络返回的图片路径
 *  @param imagePathType 需要拼接的图片类型
 */
+ (NSURL *) getImageURL :(NSString *) imagePath imagePathType:(NSString *)imagePathType;

/**
 *  16进制颜色(html颜色值)字符串转为UIColor
 */
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
/**
 *  图像压缩
 */
+ (NSData *)imageData:(UIImage *)myimage;
/** 用来隐藏导航控制器的线*/
+ (UIImage *)imageWithView:(UIView *)view;

+(NSString *)udid;

+ (void) getCurrentVC;

/** navigationTitle*/
+ (UIButton *)titleButtonImage:(NSString *)str;

+ (NSString *)notRounding:(float)price afterPoint:(NSInteger)position;

/** url拼接https*/
+ (NSString *)httpsWithStr:(NSString *)Str;

+ (NSString *)httpsWithStrUser:(NSString *)str;

+ (NSString *)httpsWithMyEventStrUser:(NSString *)str;

@end

