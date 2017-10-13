  
//

//
//  AppTools.m
//
//  Created by dkb on 16/3/14.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "AppTools.h"
#import "SSKeychain.h"
#import "LoginVC.h"

//#import "LoginViewController.h"

@implementation AppTools

+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color {
    CGSize imageSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = [UIFont fontWithName:fontName size:size];
    label.text = iconCode;
    if(color){
        label.textColor = color;
    }
    
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    return retImage;
}

+(CGSize)labelRectWithLabelSize:(CGSize)size
                      LabelText:(NSString *)labelText
                           Font:(UIFont *)font{
    NSDictionary  *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize actualsize = [labelText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return actualsize;
}

+ (NSString *)timestampExchange:(NSInteger)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString*)getDateWithUpdatedAt:(NSInteger)time{
    NSString *date = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *formatterDay = [[NSDateFormatter alloc] init];
    [formatterDay setDateFormat:@"hh"];
    //    获取系统当前的时间
    //    NSTimeZone**时区是一个地理名字,是为了克服各个地区或国家之间在使用时间上的混乱
    NSDate *liuxin = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:liuxin];
    NSDate *localDate = [liuxin dateByAddingTimeInterval:interval];
    //时间搓转化为NSDate
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time/1000];
    //    截取“年-月-日”
    NSString *dataTime = [formatter stringFromDate:localDate];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //    只要“时”
    NSString *dataTimeDay = [formatterDay stringFromDate:localDate];
    NSString *conformDay = [formatterDay stringFromDate:confromTimesp];
    
    NSArray *timeArr = [confromTimespStr componentsSeparatedByString:@"-"];
    NSArray *currentArr = [dataTime componentsSeparatedByString:@"-"];
    if ([currentArr[0]integerValue]-[timeArr[0] integerValue] == 0) {
        if ([currentArr[1]integerValue]-[timeArr[1] integerValue] ==0) {
            if ([currentArr[2]integerValue]-[timeArr[2] integerValue] ==0) {
                date = [NSString stringWithFormat:@"%ld小时前",(long)[dataTimeDay integerValue]-[conformDay integerValue]];
            }else{
                date = [NSString stringWithFormat:@"%ld天前",(long)[currentArr[2]integerValue] - [timeArr[2] integerValue]];
            }
        }else{
            date = [NSString stringWithFormat:@"%ld月前", (long)[currentArr[1]integerValue]-[timeArr[1] integerValue]];
        }
    }else{
        date = [NSString stringWithFormat:@"%ld年前",(long)[currentArr[0]integerValue] -[timeArr[0] integerValue]];
    }
    return date;
    
}


/**
 *  循环TableViewCell取值
 *
 *  @param tableView tableView description
 *
 *  @return return value description
 */
+(NSArray *)cellsForTableView:(UITableView *)tableView
{
    NSInteger sections = tableView.numberOfSections;
    NSMutableArray *cells = [[NSMutableArray alloc]  init];
    for (int section = 0; section < sections; section++) {
        NSInteger rows =  [tableView numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [cells addObject:[tableView cellForRowAtIndexPath:indexPath]];
        }
    }
    return cells;
}


+ (NSString*)getCurrentTimeString:(NSDate *)date format:(NSString *)format
{
    NSDate*curTime = date;// 获取本地时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];  // 格式化时间NSDate
    NSString*stringFromDate = [formatter stringFromDate:curTime];
    return stringFromDate;
}

+ (NSString *)strWithDateWithStr:(NSString *)strDate dateFormat:(NSString *)dateFormat
{
    // 将时间转成NSDate 这里为格林时间
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate = [format dateFromString:strDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:fromdate];
    NSDate *fromDate = [fromdate dateByAddingTimeInterval:frominterval];
    
    // 将Date转成字符串
    NSDateFormatter *dateFromat = [[NSDateFormatter alloc] init];
    [dateFromat setDateFormat:dateFormat];
    // GMT8为中国时区
    [dateFromat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *str = [dateFromat stringFromDate:fromDate];
    
    return str;
}


+ (UIImage *)barCode2DStr:(NSString *)str
{
    NSData *stringData = [str dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage",qrFilter.outputImage,@"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],@"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGSize size = CGSizeMake(SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.44);
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return codeImage;
}

+ (UIButton *)rightbuttonTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    // 别忘记设置尺寸
    button.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //        [button sizeToFit]; 尺寸跟随里面的内容
    // contentEdgeInsets内边距
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, -5, 0);
    
    return button;
}

/**
 *  字符串EncodingUTF8
 *
 *  @param input 要转换的字符串
 *
 *  @return 转换完的字符串
 */
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                              kCFAllocatorDefault,
                                                                              (CFStringRef)input,NULL,
                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return outputStr;
}
/**
 *  全角转半角
 */
+ (NSString *)myTransformHiraganaKatakana:(NSString *)str{
    NSMutableString *convertedString = [str mutableCopy];
    
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformFullwidthHalfwidth, false);
    return convertedString;
}

/**
 *  验证输入 (用来限制密码长度)
 */
+ (BOOL)validateNumber:(NSString*)str validateStr:(NSString *)validateStr {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:validateStr];
    int i = 0;
    while (i < str.length) {
        NSString * string = [str substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - 基本控件封装
+ (UIView *)createViewBackground:(UIColor *)background
{
    UIView *view = [[UIView alloc] init];
    if (background == nil) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = background;
    }
    
    
    return view;
}

+ (UILabel *)createLabelText:(NSString *)text Color:(UIColor *)color Font:(CGFloat)font TextAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = color;
    label.textAlignment = textAlignment;
    
//    if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
////        label.font = [UIFont fontWithName:@"Microsoft YaHei" size:font+2.0f];
//        label.font = [UIFont systemFontOfSize:font+2.0f];
//    }else{
//        label.font = [UIFont fontWithName:@"Microsoft YaHei" size:font];
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        label.font = [UIFont systemFontOfSize:font*SCREEN_WIDTH/375];
    }else{
        label.font = [UIFont systemFontOfSize:font];
    }
    
//    }
    
    return label;
}

+ (UILabel *)createLabelText:(NSString *)text Color:(UIColor *)color Font:(CGFloat)font TextAlignment:(NSTextAlignment)textAlignment Number:(CGFloat)number
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.textAlignment = textAlignment;
    
//    label.font = [UIFont fontWithName:@"Microsoft YaHei" size:font];
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        label.font = [UIFont systemFontOfSize:font*SCREEN_WIDTH/375];
    }else{
        label.font = [UIFont systemFontOfSize:font];
    }
    
    NSDictionary *attrsDictionary =@{
                                     NSFontAttributeName: label.font,
                                     NSKernAttributeName:[NSNumber numberWithFloat:number]//这里修改字符间距
                                     };
    label.attributedText = [[NSAttributedString alloc]initWithString:text attributes:attrsDictionary];
    
    return label;
}

+ (NSAttributedString *)labelNumber:(int)number String:(NSString *)str
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
    
    return attributedString;
}


+ (UIButton *)createButtonTitle:(NSString *)title TitleColor:(UIColor *)titleColor Font:(CGFloat)font Background:(UIColor *)background
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
//    button.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:font];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    button.backgroundColor = background;
    
    return button;
}

+ (UIImageView *)CreateImageViewImageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];

    return imageView;
}

+ (UITextField *)createTextFieldText:(NSString *)title Placeholder:(NSString *)placeholder TextColor:(UIColor *)textColor TextFont:(CGFloat)textFont TextAlignment:(NSTextAlignment)textAlignment
{
    UITextField *textField = [UITextField new];
    textField.text = title;
    textField.placeholder = placeholder;
    textField.textAlignment = textAlignment;
    textField.textColor = textColor;
//    textField.font = [UIFont fontWithName:@"Microsoft YaHei" size:textFont];
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        textField.font = [UIFont systemFontOfSize:textFont*SCREEN_WIDTH/375];
    }else{
        textField.font = [UIFont systemFontOfSize:textFont];
    }
    
    
    return textField;
}

+ (UIImageView *)createWireImageX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Color:(UIColor *)color
{
        height = 100;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {10,3};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, color.CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 80);    //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH, 80.0);
    CGContextStrokePath(line);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageView;
}

+ (UIButton *)titleButtonImage:(NSString *)str
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:str] forState:UIControlStateHighlighted];
    // 别忘记设置尺寸
    button.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        [button sizeToFit]; 尺寸跟随里面的内容
    // contentEdgeInsets内边距
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    
    return button;
}



#pragma mark - 设置View单个圆角
+ (void)addCornerWithView:(UIView *)aView type:(UIRectCorner)aCorners size:(CGSize)aSize
{
    // 根据矩形画带圆角的曲线
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:aCorners cornerRadii:aSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = aView.bounds;
    maskLayer.path = maskPath.CGPath;
    aView.layer.mask = maskLayer;
}


#pragma mark - 返回一张纯色图片作为navigationController
/** 返回一张纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString *)httpsWithStr:(NSString *)Str
{
    return [NSString stringWithFormat:@"%@%@",SERVER_URLL, Str];
}

+ (NSString *)httpsWithStrUser:(NSString *)str
{
    int value = arc4random() % 1000;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locationJD"] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"locationWD"] != nil)
    {
        NSLog(@"1+httpsWithStrUser+++%@",[NSString stringWithFormat:@"%@%@&tAppUserId=%@&appcode=iOS&longitude=%@&latitude=%@&sJis=%zd",
                                      SERVER_URLL,
                                      str,
                                      USERID,
                                      LOCATIONJD,
                                      LOCATIONWD,
                                      value]);
       return [NSString stringWithFormat:@"%@%@&tAppUserId=%@&appcode=iOS&longitude=%@&latitude=%@&sJis=%zd",
               SERVER_URLL,
               str,
               USERID,
               LOCATIONJD,
               LOCATIONWD,
               value];
    }
    NSLog(@"2+httpsWithStrUser+++%@",[NSString stringWithFormat:@"%@%@&tAppUserId=%@&appcode=iOS&sJis=%zd",
                                      SERVER_URLL,
                                      str,
                                      USERID,
                                      value]);
    return [NSString stringWithFormat:@"%@%@&tAppUserId=%@&appcode=iOS&sJis=%zd",
            SERVER_URLL,
            str,
            USERID,
            value];
//    return [NSString stringWithFormat:@"http://%@&tAppUserId=%@&appcode=iOS&sJis=%zd", str, USERID, value];
}

+ (NSString *)httpsWithMyEventStrUser:(NSString *)str
{
    int value = arc4random() % 1000;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locationJD"] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"locationWD"] != nil) {
        return [NSString stringWithFormat:@"%@%@&tAppUserId=%@&appcode=iOS&jumpPosition=2&longitude=%@&latitude=%@&sJis=%zd",
                SERVER_URLL, str, USERID, LOCATIONJD, LOCATIONWD, value];
    }
    return [NSString stringWithFormat:@"%@%@&tAppUserId=%@&appcode=iOS&jumpPosition=2&sJis=%zd",
            SERVER_URLL, str, USERID, value];
    //    return [NSString stringWithFormat:@"http://%@&tAppUserId=%@&appcode=iOS&sJis=%zd", str, USERID, value];
}

+ (NSURL *) getImageURL :(NSString *) imagePath imagePathType:(NSString *)imagePathType {
    NSString *imageURL = @"";
//    NSRange iStart = [tmpFilename rangeOfString : @"/"];
//    tmpFilename
    
//    NSString *runtimeDirectory = [imagePath substringToIndex:iStart.location-1];
    
    if (imagePath && ![imagePath isKindOfClass:[NSNull class]] && imagePath.length > 0) {
        NSArray *strings = [imagePath componentsSeparatedByString: @"/"];
        if (strings.count >= 2) {
            for (NSString *str in strings) {
                if ([str isEqualToString:[strings objectAtIndex:[strings count]-1]]) {                    NSString *tmpFilename  = [strings objectAtIndex:[strings count]-1];
                    imageURL = [imageURL stringByAppendingString:tmpFilename];
                }else if([str isEqualToString:[strings objectAtIndex:[strings count]-2]]){
                    imageURL = [imageURL stringByAppendingString:str];
                    imageURL = [imageURL stringByAppendingString:imagePathType];
                    imageURL = [imageURL stringByAppendingString:@"/"];
                }else{
                    imageURL = [imageURL stringByAppendingString:str];
                    imageURL = [imageURL stringByAppendingString:@"/"];
                }
                
            }
        }
    }
    return [NSURL URLWithString:[FILE_URL stringByAppendingString:imageURL]];
}


//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

// 压缩图像
+ (NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data = UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data = UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data = UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}

/** 用来隐藏导航控制器的线*/
+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tImage;
}

+(NSString *)udid{
    NSString *udid = @"";
    NSArray *kcArray = [SSKeychain accountsForService:@"ytty_udid"];
    if(kcArray){
        NSDictionary *dic = [kcArray lastObject];
        udid = [SSKeychain passwordForService:@"ytty_udid" account:dic[kSSKeychainAccountKey]];
    }
    if(udid.length<=0){
        udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:udid forService:@"ytty_udid" account:@"ytty_udid"];
    }
    return udid;
}

//+ (void) getCurrentVC {
//    UIViewController *topVC;
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    
//    if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
//        DKBTabBarController *tabBar = (DKBTabBarController *)window.rootViewController;
//        DKBNavigationController *navVC = (DKBNavigationController *)tabBar.selectedViewController;
//        topVC = [navVC visibleViewController];
//        
//    }
//    //访问接口将vc名传给接口
//    NSDictionary *vcNameDict = @{@"dicKey":@"className",@"data":NSStringFromClass([topVC class])};
//    NSDictionary *appUserIdDict;
//    NSDictionary *uuIdDict;
//    if (USERID) {
//        appUserIdDict = @{@"dicKey":@"appUserId",@"data":USERID};
//        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
//        uuIdDict = @{@"dicKey":@"uuid",@"data":identifierForVendor};
//    } else {
//        appUserIdDict = @{@"dicKey":@"appUserId",@"data":@""};
//        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
//        uuIdDict = @{@"dicKey":@"uuid",@"data":identifierForVendor};
//    }
//    NSArray *postArray = @[vcNameDict,appUserIdDict,uuIdDict];
//    NSString *urlPath = [NSString stringWithFormat:@"%@/system/memoryClassInfo",SERVER_URL];
//    [ServerUtility POSTAction:urlPath param:postArray target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
//        if (error == nil) {
//            NSlog(@"保存类名称%@",obj);
//        } else {
//            NSlog(@"%@", error);
//        }
//    }];
//}

/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     目标数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 NSRoundPlain,   // Round up on a tie ／／貌似取整
 
 NSRoundDown,    // Always down == truncate  ／／只舍不入
 
 NSRoundUp,      // Always up    ／／ 只入不舍
 
 NSRoundBankers  // on a tie round so last digit is even  貌似四舍五入
 */
+ (NSString *)notRounding:(float)price afterPoint:(NSInteger)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}



@end

