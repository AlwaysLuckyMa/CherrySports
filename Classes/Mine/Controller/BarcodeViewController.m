//
//  BarcodeViewController.m
//  CherrySports
//
//  Created by dkb on 17/1/7.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "BarcodeViewController.h"

@interface BarcodeViewController ()

/** <#注释#>*/
@property (nonatomic, strong) UIImageView *codeImageView;

@end

@implementation BarcodeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 布局导航控制器
    [self setNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self codeView];
}

-(void)codeView
{
    WS(weakSelf);
    
    UILabel *title = [AppTools createLabelText:@"参赛者签到二维码" Color:TEXT_COLOR_DARK Font:16 TextAlignment:NSTextAlignmentCenter];
//    title.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.width.mas_equalTo(150);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc]init];
        _codeImageView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_codeImageView];
        [_codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(280);
            make.top.equalTo(title.mas_bottom).offset(20);
            make.centerX.equalTo(weakSelf.view);
        }];
        //传过来的id 转成二维码
        NSString *str = USERID; /** 1是领红包类型,用于客户端扫码区分 */
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
        CGSize size = CGSizeMake(280, 280);
        CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
        UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(cgImage);
        //self.imageView.image = codeImage;
        self.codeImageView.image = codeImage;
    }
    
    UILabel *content = [AppTools createLabelText:@"向工作人员出示二维码获取信息成功视为通过" Color:TEXT_COLOR_DARK Font:15 TextAlignment:NSTextAlignmentCenter];
//    content.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    UILabel *instructions = [AppTools createLabelText:@"请妥善保管二维码以防他人恶意使用" Color:TEXT_COLOR_RED Font:15 TextAlignment:NSTextAlignmentCenter];
//    instructions.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:instructions];
    [instructions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerX.equalTo(weakSelf.view);
    }];
    
}


- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"我的二维码" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
