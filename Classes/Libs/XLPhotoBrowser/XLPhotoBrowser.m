//
//  XLPhotoBrowser.m
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/16.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "XLPhotoBrowser.h"
#import "XLZoomingScrollView.h"
#import "TAPageControl.h"
#import "FSActionSheetConfig.h"
#import "FSActionSheet.h"

#import "XLPhotoBrowserConfig.h"
#import "UIImageView+WebCache.h"

#import "shareArr.h"
#import <sys/utsname.h> //判断手机型号

@interface XLPhotoBrowser () <XLZoomingScrollViewDelegate , UIScrollViewDelegate>

/**
 *  存放所有图片的容器
 */
@property (nonatomic , strong) UIScrollView  *scrollView;
/**
 *   保存图片的过程指示菊花
 */
@property (nonatomic , strong) UIActivityIndicatorView  *indicatorView;
/**
 *   保存图片的结果指示label
 */
@property (nonatomic , strong) UILabel *savaImageTipLabel;
/**
 *  正在使用的XLZoomingScrollView对象集
 */
@property (nonatomic , strong) NSMutableSet  *visibleZoomingScrollViews;
/**
 *  循环利用池中的XLZoomingScrollView对象集,用于循环利用
 */
@property (nonatomic , strong) NSMutableSet  *reusableZoomingScrollViews;
/**
 *  pageControl
 */
@property (nonatomic , strong) UIControl  *pageControl;
/**
 *  index label
 */
@property (nonatomic , strong) UILabel  *indexLabel;
/**
 *  保存按钮
 */
@property (nonatomic , strong) UIButton *saveButton;
/**
 *  ActionSheet的otherbuttontitles
 */
@property (nonatomic , strong) NSArray  *actionOtherButtonTitles;
/**
 *  ActionSheet的title
 */
@property (nonatomic , strong) NSString  *actionSheetTitle;
/**
 *  actionSheet的取消按钮title
 */
@property (nonatomic , strong) NSString  *actionSheetCancelTitle;
/**
 *  actionSheet的高亮按钮title
 */
@property (nonatomic , strong) NSString  *actionSheetDeleteButtonTitle;
@property (nonatomic, assign) CGSize pageControlDotSize;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, strong) UIButton * btn;

@property(nonatomic, retain)UIImageView *bgimg;
@property(nonatomic, retain)UIImageView *leftimg;
@property(nonatomic, retain)UILabel *presentlab; //大小label

@property(nonatomic, strong) NSArray *arr;

@end

@implementation XLPhotoBrowser

#pragma mark    -   set / get

- (UILabel *)savaImageTipLabel
{
    if (_savaImageTipLabel == nil) {
        _savaImageTipLabel = [[UILabel alloc] init];
        _savaImageTipLabel.textColor = [UIColor whiteColor];
        _savaImageTipLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        _savaImageTipLabel.textAlignment = NSTextAlignmentCenter;
        _savaImageTipLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _savaImageTipLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return _indicatorView;
}

- (void)setBrowserStyle:(XLPhotoBrowserStyle)browserStyle
{
    _browserStyle = browserStyle;
    [self setUpBrowserStyle];
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.dotColor = currentPageDotColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    if ([self.pageDotColor isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage
{
    _currentPageDotImage = currentPageDotImage;
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage
{
    _pageDotImage = pageDotImage;
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot
{
    if (!image || !self.pageControl) return;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage = image;
        }
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        if (isCurrentPageDot) {
            [pageControl setValue:image forKey:@"_currentPageImage"];
        } else {
            [pageControl setValue:image forKey:@"_pageImage"];
        }
    }
}

- (void)setPageControlStyle:(XLPhotoBrowserPageControlStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    [self setUpPageControl];
}

- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        _placeholderImage = [UIImage xl_imageWithColor:[UIColor grayColor] size:CGSizeMake(100, 100)];
    }
    return _placeholderImage;
}

#pragma mark    -   initial

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initial];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initial];
        
    }
    return self;
}

- (void)initial
{
    self.backgroundColor = XLPhotoBrowserBackgrounColor;
    self.visibleZoomingScrollViews = [[NSMutableSet alloc] init];
    self.reusableZoomingScrollViews = [[NSMutableSet alloc] init];
    [self placeholderImage];
    
    _pageControlAliment = XLPhotoBrowserPageControlAlimentCenter;
    _showPageControl = YES;
    _pageControlDotSize = CGSizeMake(10, 10);
    _pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;
    _hidesForSinglePage = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _browserStyle = XLPhotoBrowserStylePageControl;
    
    self.currentImageIndex = 0;
    self.imageCount = 0;
    
    _arr = @[@"3",@"2",@"1",@"10",@"8",@"4",@"22",@"5",@"5"]; //假数据
    
}

- (void)iniaialUI
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self setUpScrollView];
    [self setUpPageControl];
    [self setUpToolBars];
    [self setUpBrowserStyle];
    [self showFirstImage];
    [self updatePageControlIndex];
}

- (void)setUpScrollView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(load_over_center) name:@"load_over" object:nil];
    CGRect rect = self.bounds;
    rect.size.width += XLPhotoBrowserImageViewMargin;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = rect;
    self.scrollView.xl_x = 0;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake((self.scrollView.frame.size.width) * self.imageCount, 0);
    [self addSubview:self.scrollView];
    self.scrollView.contentOffset = CGPointMake(self.currentImageIndex * (self.scrollView.frame.size.width), 0);
    CGFloat btnW = 110;
    CGFloat btnH = 25;
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(
                                                               (XLScreenW - 110)/2,
                                                               XLScreenH - 20 - 20,
                                                               btnW,
                                                               btnH
                                                               )];
    _btn = btn;
    btn.backgroundColor = [UIColor clearColor];
//    btn.backgroundColor = [UIColor whiteColor];
    _btn.layer.borderWidth = 0.5;
    _btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_btn.layer setMasksToBounds:YES];
    [_btn.layer setCornerRadius:5];
    [btn addTarget:self action:@selector(downloadImgClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];

    _bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                           0,
                                                           0,
                                                           btnW,
                                                           btnH)];
    _bgimg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    _bgimg.layer.borderColor = [UIColor clearColor].CGColor;
    _bgimg.layer.borderWidth =  1;
    _bgimg.layer.cornerRadius = 5;
    [_bgimg.layer setMasksToBounds:YES];
    [_btn addSubview:_bgimg];
    
    _presentlab = [[UILabel alloc] initWithFrame:_bgimg.bounds];
    _presentlab.textAlignment = NSTextAlignmentCenter;
    _presentlab.textColor = [UIColor whiteColor];
    _presentlab.font = [UIFont systemFontOfSize:11];
    [_btn addSubview:_presentlab];
    //    _presentlab.text = [NSString stringWithFormat:@"%@",_arr[0]]; 1999
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSArray *HD_pic_Array = [user objectForKey:@"高清图片"];
//    NSString * st = HD_pic_Array[self.num];
    
    NSString * st = [shareArr getURLArrShare].urlArr[self.num];
    NSLog(@"265高清图片--%@",st);
    NSURL * url = [NSURL URLWithString:st];
    
    UIImage * showImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[url absoluteString]];
   
    if (showImage)
    {
        _btn.hidden = YES;
    }else{
        _btn.hidden = NO;
    }
    
    if (self.currentImageIndex == 0) { // 修复bug , 如果刚进入的时候是0,不会调用scrollViewDidScroll:方法,不会展示第一张图片
        [self showPhotos];
    }
    
}

//接收到sd的通知 图片加载完成
- (void)load_over_center
{
   _btn.hidden = YES;
    
}

//代理
- (void)SettingDelegateNum:(XLZoomingScrollView *)XLZoom loadNum:(NSInteger)dow_num loadAlNum:(NSInteger)al_num allNum:(CGFloat)allFNum
{
//    NSLog(@"走代理了-----");
    if (al_num <= dow_num) {
        _presentlab.text = [NSString stringWithFormat:@"%0.0lf%%",allFNum*100];
    }
    
}

/**
 *  设置pageControl
 */
- (void)setUpPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    
    if ((self.imageCount <= 1) && self.hidesForSinglePage) {
        return;
    }
    
    switch (self.pageControlStyle) {
        case XLPhotoBrowserPageControlStyleAnimated:
        {
            TAPageControl *pageControl = [[TAPageControl alloc] init];
            pageControl.numberOfPages = self.imageCount;
            pageControl.dotColor = self.currentPageDotColor;
            pageControl.currentPage = self.currentImageIndex;
            pageControl.userInteractionEnabled = NO;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case XLPhotoBrowserPageControlStyleClassic:
        {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            _pageControl = pageControl;
            pageControl.numberOfPages = self.imageCount;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            [self addSubview:pageControl];
            pageControl.currentPage = self.currentImageIndex;
        }
            break;
        default:
            break;
    }
    
    // 重设pagecontroldot图片
    self.currentPageDotImage = self.currentPageDotImage;
    self.pageDotImage = self.pageDotImage;

    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        size = [pageControl sizeForNumberOfPages:self.imageCount];
    } else {
        size = CGSizeMake(self.imageCount * self.pageControlDotSize.width * 1.2, self.pageControlDotSize.height);
    }
    CGFloat x = (self.xl_width - size.width) * 0.5;
    if (self.pageControlAliment == XLPhotoBrowserPageControlAlimentRight) {
        x = self.xl_width - size.width - 10;
    }
    CGFloat y = self.xl_height - size.height - 10;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
    self.pageControl.hidden = !self.showPageControl;
}

- (void)setUpToolBars
{
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.xl_centerX = self.xl_width * 0.5;
    indexLabel.xl_centerY = 35;
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont systemFontOfSize:18];
    indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
    indexLabel.clipsToBounds = YES;
    self.indexLabel = indexLabel;
    [self addSubview:indexLabel];
    
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
    self.saveButton = saveButton;
    [self addSubview:saveButton];
}

- (void)setUpBrowserStyle
{
    switch (self.browserStyle) {
        case XLPhotoBrowserStylePageControl:
        {
            self.pageControl.hidden = NO;
            self.indexLabel.hidden = YES;
            self.saveButton.hidden = YES;
        }
            break;
        case XLPhotoBrowserStyleIndexLabel:
        {
            self.indexLabel.hidden = NO;
            self.pageControl.hidden = YES;
            self.saveButton.hidden = YES;
        }
            break;
        case XLPhotoBrowserStyleSimple:
        {
            self.indexLabel.hidden = NO;
            self.saveButton.hidden = NO;
            self.pageControl.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)dealloc
{
    [self.reusableZoomingScrollViews removeAllObjects];
    [self.visibleZoomingScrollViews removeAllObjects];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _savaImageTipLabel.layer.cornerRadius = 5;
    _savaImageTipLabel.clipsToBounds = YES;
    [_savaImageTipLabel sizeToFit];
    _savaImageTipLabel.xl_height = 30;
    _savaImageTipLabel.xl_width += 20;
    _savaImageTipLabel.center = self.center;

    _indicatorView.center = self.center;
}

#pragma mark    -   private method

- (UIWindow *)findTheMainWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal);
        BOOL windowSizeIsEqualToScreen = (window.xl_width == XLScreenW && window.xl_height == XLScreenH);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowSizeIsEqualToScreen) {
            return window;
        }
    }
    
    XLPBLog(@"XLPhotoBrowser在当前工程未匹配到合适的window,请根据工程架构酌情调整此方法,匹配最优窗口");
    if (XLPhotoBrowserDebug) {
        NSAssert(false, @"XLPhotoBrowser在当前工程未匹配到window,请根据工程架构酌情调整findTheMainWindow方法,匹配最优窗口");
    }
    
    UIWindow * delegateWindow = [[[UIApplication sharedApplication] delegate] window];
    return delegateWindow;
}

#pragma mark    -   private -- 长按图片相关

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    XLZoomingScrollView *currentZoomingScrollView = [self zoomingScrollViewAtIndex:self.currentImageIndex];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        XLPBLog(@"UIGestureRecognizerStateBegan , currentZoomingScrollView.progress %f",currentZoomingScrollView.progress);
//        if (currentZoomingScrollView.progress < 1.0) { 保存图片1994
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self longPress:longPress];
//            });
//            return;
//        }

        if (self.actionOtherButtonTitles.count <= 0 && self.actionSheetDeleteButtonTitle.length <= 0 && self.actionSheetTitle.length <= 0) {
            return;
        }
        FSActionSheet *actionSheet = [[FSActionSheet alloc] initWithTitle:self.actionSheetTitle delegate:nil cancelButtonTitle:self.actionSheetCancelTitle highlightedButtonTitle:self.actionSheetDeleteButtonTitle otherButtonTitles:self.actionOtherButtonTitles];
        __weak typeof(self) weakSelf = self;
        // 展示并绑定选择回调
        [actionSheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(photoBrowser:clickActionSheetIndex:currentImageIndex:)]) {
                [weakSelf.delegate photoBrowser:weakSelf clickActionSheetIndex:selectedIndex currentImageIndex:weakSelf.currentImageIndex];
            }
        }];
    }
}

/**
 具体的删除逻辑,请根据自己项目的实际情况,自行处理
 */
//- (void)delete
//{
//    if (self.currentImageIndex == 0) {
//        XLZoomingScrollView *currentZoomingScrollView = [self zoomingScrollViewAtIndex:self.currentImageIndex];
//        [self.reusableZoomingScrollViews addObject:currentZoomingScrollView];
//        [currentZoomingScrollView prepareForReuse];
//        [currentZoomingScrollView removeFromSuperview];
//        [self.visibleZoomingScrollViews minusSet:self.reusableZoomingScrollViews];
//    }
//    self.currentImageIndex --;
//    self.imageCount --;
//    if (self.currentImageIndex == -1 && self.imageCount == 0) {
//        [self dismiss];
//    } else {
//        self.currentImageIndex = (self.currentImageIndex == (-1) ? 0 : self.currentImageIndex);
//        if (self.currentImageIndex == 0) {
//            [self setUpImageForZoomingScrollViewAtIndex:0];
//            [self updatePageControlIndex];
//            [self showPhotos];
//        }
//        
//        self.scrollView.contentSize = CGSizeMake((self.scrollView.frame.size.width) * self.imageCount, 0);
//        self.scrollView.contentOffset = CGPointMake(self.currentImageIndex * (self.scrollView.frame.size.width), 0);
//    }
//    UIPageControl *pageControl = (UIPageControl *)self.pageControl;
//    pageControl.numberOfPages = self.imageCount;
//    [self updatePageControlIndex];
//}

#pragma mark    -   private -- save image
- (void)saveImage
{
    XLZoomingScrollView *zoomingScrollView = [self zoomingScrollViewAtIndex:self.currentImageIndex];

    
    UIImageWriteToSavedPhotosAlbum(zoomingScrollView.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    [self addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

//- (NSData *)getfileUrl:(NSString *)imageURL
//{
//    NSData * imageData = nil;
//    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imageURL]];
//    if (isExit)
//    {
//        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURL]];
//        if (cacheImageKey.length)
//        {
//            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
//            if (cacheImagePath.length)
//            {
//                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
//            }
//        }
//    }
//    if (!imageData) {
//        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
//    }
//    return imageData;
//}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [self.indicatorView removeFromSuperview];
    [self addSubview:self.savaImageTipLabel];
    if (error) {
        self.savaImageTipLabel.text = XLPhotoBrowserSaveImageFailText;
    } else {
        self.savaImageTipLabel.text = XLPhotoBrowserSaveImageSuccessText;
    }
    [self.savaImageTipLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

#pragma mark    -   private ---loadimage

- (void)showPhotos
{
    // 只有一张图片
    if (self.imageCount == 1) {
        [self setUpImageForZoomingScrollViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = self.scrollView.bounds;
    NSInteger firstIndex = floor((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floor((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    if (firstIndex >= self.imageCount) {
        firstIndex = self.imageCount - 1;
    }
    if (lastIndex < 0){
        lastIndex = 0;
    }
    if (lastIndex >= self.imageCount) {
        lastIndex = self.imageCount - 1;
    }
    
    // 回收不再显示的zoomingScrollView
    NSInteger zoomingScrollViewIndex = 0;
    for (XLZoomingScrollView *zoomingScrollView in self.visibleZoomingScrollViews) {
        zoomingScrollViewIndex = zoomingScrollView.tag - 100;
        if (zoomingScrollViewIndex < firstIndex || zoomingScrollViewIndex > lastIndex) {
            [self.reusableZoomingScrollViews addObject:zoomingScrollView];
            [zoomingScrollView prepareForReuse];
            [zoomingScrollView removeFromSuperview];
        }
    }
    
    // _visiblePhotoViews 减去 _reusablePhotoViews中的元素
    [self.visibleZoomingScrollViews minusSet:self.reusableZoomingScrollViews];
    while (self.reusableZoomingScrollViews.count > 2) { // 循环利用池中最多保存两个可以用对象
        [self.reusableZoomingScrollViews removeObject:[self.reusableZoomingScrollViews anyObject]];
    }
    
    // 展示图片
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingZoomingScrollViewAtIndex:index]) {
            [self setUpImageForZoomingScrollViewAtIndex:index];
        }
    }
}

/**
 *  判断指定的某个位置图片是否在显示
 */
- (BOOL)isShowingZoomingScrollViewAtIndex:(NSInteger)index
{
    for (XLZoomingScrollView* view in self.visibleZoomingScrollViews) {
        if ((view.tag - 100) == index) {
            return YES;
        }
    }
    return NO;
}

/**
 *  获取指定位置的XLZoomingScrollView , 三级查找,正在显示的池,回收池,创建新的并赋值
 *
 *  @param index 指定位置索引
 */
- (XLZoomingScrollView *)zoomingScrollViewAtIndex:(NSInteger)index
{
    for (XLZoomingScrollView* zoomingScrollView in self.visibleZoomingScrollViews) {
        if ((zoomingScrollView.tag - 100) == index) {
            return zoomingScrollView;
        }
    }
    XLZoomingScrollView* zoomingScrollView = [self dequeueReusableZoomingScrollView];
    [self setUpImageForZoomingScrollViewAtIndex:index];
    return zoomingScrollView;
}

/**
 *   加载指定位置的图片
 */
- (void)setUpImageForZoomingScrollViewAtIndex:(NSInteger)index //1996
{
    XLZoomingScrollView *zoomingScrollView = [self dequeueReusableZoomingScrollView];
    zoomingScrollView.zoomingScrollViewdelegate = self;
    [zoomingScrollView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    zoomingScrollView.tag = 100 + index;
    zoomingScrollView.frame = CGRectMake((self.scrollView.xl_width) * index, 0, self.xl_width, self.xl_height);
    
    
    self.currentImageIndex = index;
    if (zoomingScrollView.hasLoadedImage == NO) {
        
        if ([self highQualityImageURLForIndex:index])
        { // 如果提供了高清大图数据源,就去加载
            
            [zoomingScrollView setShowHighQualityImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
                            
        } else if ([self assetForIndex:index])
        {
            ALAsset *asset = [self assetForIndex:index];
            //加载的是高清图片      aspectRatioThumbnail加载的是较高清图片   thumbnail 加载的是缩略图片
            CGImageRef imageRef = asset.defaultRepresentation.fullScreenImage;
            [zoomingScrollView setShowImage:[UIImage imageWithCGImage:imageRef]];
            CGImageRelease(imageRef);
        } else {
            [zoomingScrollView setShowImage:[self placeholderImageForIndex:index]];
        }
        zoomingScrollView.hasLoadedImage = YES;
    }
    
    [self.visibleZoomingScrollViews addObject:zoomingScrollView];
    [self.scrollView addSubview:zoomingScrollView];
    
}

- (void)downloadImgClick
{
//    NSLog(@"点击下载原图");
    
    NSString * str = [NSString stringWithFormat:@"%ld",(long)_num];
    NSNotification * noti = [NSNotification notificationWithName:@"NOTI" object:nil userInfo:@{@"num":str}];
    [[NSNotificationCenter defaultCenter]postNotification:noti];

    [self setUpImageForZoomingScrollViewAtIndex:_num];
    
//    NSLog(@"点击下载原图--%ld",_num);
}


/**
 *  从缓存池中获取一个XLZoomingScrollView对象
 */
- (XLZoomingScrollView *)dequeueReusableZoomingScrollView
{
    XLZoomingScrollView *photoView = [self.reusableZoomingScrollViews anyObject];
    if (photoView) {
        [self.reusableZoomingScrollViews removeObject:photoView];
    } else {
        photoView = [[XLZoomingScrollView alloc] init];
    }
    return photoView;
}

/**
 *  获取指定位置的占位图片,和外界的数据源交互
 */
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.datasource photoBrowser:self placeholderImageForIndex:index];
        
    } else if(self.images.count>index) {
        
        if ([self.images[index] isKindOfClass:[UIImage class]]) {
            return self.images[index];
        } else {
            return self.placeholderImage;
        }
    }
    return self.placeholderImage;
}

/**
 *  获取指定位置的高清大图URL,和外界的数据源交互
 */
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index  //66
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        NSURL *url = [self.datasource photoBrowser:self highQualityImageURLForIndex:index];
        if (!url) {
            XLPBLog(@"高清大图URL数据 为空,请检查代码 , 图片索引:%zd",index);
            return nil;
        }
        if ([url isKindOfClass:[NSString class]]) {
            url = [NSURL URLWithString:(NSString *)url];
        }
        if (![url isKindOfClass:[NSURL class]]) {
            XLPBLog(@"高清大图URL数据有问题,不是NSString也不是NSURL , 错误数据:%@ , 图片索引:%zd",url,index);
        }
//        NSAssert([url isKindOfClass:[NSURL class]], @"高清大图URL数据有问题,不是NSString也不是NSURL");
        return url;
    } else if(self.images.count>index) {
        if ([self.images[index] isKindOfClass:[NSURL class]]) {
            return self.images[index];
        } else if ([self.images[index] isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:self.images[index]];
            return url;
        } else {
            return nil;
        }
    }
    return nil;
}

/**
 *  获取指定位置的 ALAsset,获取图片
 */
- (ALAsset *)assetForIndex:(NSInteger)index
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:assetForIndex:)]) {
        return [self.datasource photoBrowser:self assetForIndex:index];
    } else if (self.images.count > index) {
        if ([self.images[index] isKindOfClass:[ALAsset class]]) {
            return self.images[index];
        } else {
            return nil;
        }
    }
    return nil;
}

/**
 *  获取多图浏览,指定位置图片的UIImageView视图,用于做弹出放大动画和回缩动画
 */
- (UIView *)sourceImageViewForIndex:(NSInteger)index
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:sourceImageViewForIndex:)]) {
        return [self.datasource photoBrowser:self sourceImageViewForIndex:index];
    }
    return nil;
}

/**
 *  第一个展示的图片 , 点击图片,放大的动画就是从这里来的
 */
- (void)showFirstImage
{
    // 获取到用户点击的那个UIImageView对象,进行坐标转化
    CGRect startRect;
    if (self.sourceImageView) {
        
    } else if(self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:sourceImageViewForIndex:)]) {
        self.sourceImageView = [self.datasource photoBrowser:self sourceImageViewForIndex:self.currentImageIndex];
             _presentlab.text = [NSString stringWithFormat:@"查看原图"]; //201707116.25 _arr[self.currentImageIndex]
        //1999
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
        }];
        XLPBLog(@"需要提供源视图才能做弹出/退出图片浏览器的缩放动画");
        return;
    }
    startRect = [self.sourceImageView.superview convertRect:self.sourceImageView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    tempView.frame = startRect;
    [self addSubview:tempView];
    
    CGRect targetRect; // 目标frame
    UIImage *image = self.sourceImageView.image;
    
#warning 完善image为空的闪退
    if (image == nil) {        XLPBLog(@"需要提供源视图才能做弹出/退出图片浏览器的缩放动画");
        return;
    }
    CGFloat imageWidthHeightRatio = image.size.width / image.size.height;
    CGFloat width = XLScreenW;
    CGFloat height = XLScreenW / imageWidthHeightRatio;
    CGFloat x = 0;
    CGFloat y;
    if (height > XLScreenH) {
        y = 0;
    } else {
        y = (XLScreenH - height ) * 0.5;
    }
    targetRect = CGRectMake(x, y, width, height);
    self.scrollView.hidden = YES;
    self.alpha = 1.0;

    // 动画修改图片视图的frame , 居中同时放大
    [UIView animateWithDuration:XLPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.frame = targetRect;
    } completion:^(BOOL finished) {
        [tempView removeFromSuperview];
        self.scrollView.hidden = NO;
    }];
}

#pragma mark    -   XLZoomingScrollViewDelegate

/**
 *  单击图片,退出浏览
 */
- (void)zoomingScrollView:(XLZoomingScrollView *)zoomingScrollView singleTapDetected:(UITapGestureRecognizer *)singleTap
{
    _btn.hidden = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.savaImageTipLabel.alpha = 0.0;
        self.indicatorView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.savaImageTipLabel removeFromSuperview];
        [self.indicatorView removeFromSuperview];
    }];
    NSInteger currentIndex = zoomingScrollView.tag - 100;
    UIView *sourceView = [self sourceImageViewForIndex:currentIndex];
    
    if (sourceView == nil) {
        [self dismiss];
        return;
    }
    self.scrollView .hidden = YES;
    self.pageControl.hidden = YES;
    self.indexLabel .hidden = YES;
    self.saveButton .hidden = YES;

    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:self];
    
//    if ([[self deviceVersion] isEqualToString:@"iPhone 5s"]
//        ||
//        [[self deviceVersion] isEqualToString:@"iPhone 5"]
//        ||
//        [[self deviceVersion] isEqualToString:@"iPhone 5c"])
//    {
//        
    targetTemp.origin.y += 20; //1998

//    }
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = zoomingScrollView.currentImage;
    tempView.frame = CGRectMake(
                                - zoomingScrollView.contentOffset.x + zoomingScrollView.imageView.xl_x,
                                - zoomingScrollView.contentOffset.y + zoomingScrollView.imageView.xl_y,
                                zoomingScrollView.imageView.xl_width,
                                zoomingScrollView.imageView.xl_height);

    [self addSubview:tempView];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:XLPhotoBrowserHideImageAnimationDuration animations:^{
        
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView //19944
{
    [self showPhotos];
    NSInteger pageNum = floor((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width);
    self.currentImageIndex = pageNum == self.imageCount ? pageNum - 1 : pageNum;
    [self updatePageControlIndex];
    
    NSInteger pageNum1 = scrollView.contentOffset.x /scrollView.bounds.size.width;
    
    _btn.hidden = YES;
    
    _presentlab.text = [NSString stringWithFormat:@"查看原图"]; //201707116.25/,_arr[pageNum1]
    
    self.num = pageNum1;  //有用
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSArray *HD_pic_Array = [user objectForKey:@"高清图片"];
//    NSString * str = HD_pic_Array[pageNum1];
    NSString * str = [shareArr getURLArrShare].urlArr[pageNum1]; //去缓存里取 判断加没加载过
    NSLog(@"//去缓存里取 判断加没加载过--%zi",[shareArr getURLArrShare].urlArr.count);
    NSURL *url = [NSURL URLWithString:str];
    UIImage *showImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[url absoluteString]];
    if (showImage)
    {
        _btn.hidden = YES;
    }
   
    
}

#pragma mark 结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView //19944
{
    NSInteger pageNum = floor((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width);
    self.currentImageIndex = pageNum == self.imageCount ? pageNum - 1 : pageNum;
    [self updatePageControlIndex];
//    NSLog(@"滑动结束---------%lf",scrollView.contentOffset.x);
//    NSLog(@"滑动结束---------%ld",pageNum);
    self.num = pageNum;
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSArray *HD_pic_Array = [user objectForKey:@"高清图片"];
//    NSString * str = HD_pic_Array[pageNum];
    NSString * str = [shareArr getURLArrShare].urlArr[pageNum]; //去缓存里取 判断加没加载过

    NSURL *url = [NSURL URLWithString:str];
    UIImage *showImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[url absoluteString]];
    if (showImage) {
        _btn.hidden = YES;
    }else{
        _btn.hidden = NO;
    }
}

/**
 *  修改图片指示索引label
 */
- (void)updatePageControlIndex
{
    if (self.imageCount == 1 && self.hidesForSinglePage == YES) {
        self.indexLabel.hidden = YES;
        self.pageControl.hidden = YES;
        return;
    }
    UIPageControl *pageControl = (UIPageControl *)self.pageControl;
    pageControl.currentPage = self.currentImageIndex;
    NSString *title = [NSString stringWithFormat:@"%zd / %zd",self.currentImageIndex+1,self.imageCount];
    self.indexLabel.text = title;
    
    [self setUpBrowserStyle];
}

#pragma mark    -   public method

/**
 *  快速创建并进入图片浏览器
 *
 *  @param currentImageIndex 开始展示的图片索引
 *  @param imageCount        图片数量
 *  @param datasource        数据源
 *
 */
+ (instancetype)showPhotoBrowserWithCurrentImageIndex:(NSInteger)currentImageIndex imageCount:(NSUInteger)imageCount datasource:(id<XLPhotoBrowserDatasource>)datasource
{
    XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
    browser.imageCount = imageCount;
    browser.currentImageIndex = currentImageIndex;
    browser.datasource = datasource;
    [browser show];
    return browser;
}

///**
// *  进入图片浏览器
// *
// *  @param index      从哪一张开始浏览,默认第一章
// *  @param imageCount 要浏览图片的总个数
// */
//- (void)showWithImageIndex:(NSInteger)index imageCount:(NSInteger)imageCount datasource:(id<XLPhotoBrowserDatasource>)datasource
//{
//    self.currentImageIndex = index;
//    self.imageCount = imageCount;
//    self.datasource = datasource;
//    [self show];
//}

- (void)show
{
    if (self.imageCount <= 0) {
        return;
    }
    if (self.currentImageIndex >= self.imageCount) {
        self.currentImageIndex = self.imageCount - 1;
    }
    if (self.currentImageIndex < 0) {
        self.currentImageIndex = 0;
    }
    UIWindow *window = [self findTheMainWindow];
    
    self.frame = window.bounds;
    self.alpha = 0.0;
    [window addSubview:self];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self iniaialUI];
}

/**
 *  退出
 */
- (void)dismiss
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:XLPhotoBrowserHideImageAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 *  初始化底部ActionSheet弹框数据
 *
 *  @param title                  ActionSheet的title
 *  @param delegate               XLPhotoBrowserDelegate
 *  @param cancelButtonTitle      取消按钮文字
 *  @param deleteButtonTitle      删除按钮文字
 *  @param otherButtonTitles      其他按钮数组
 */
- (void)setActionSheetWithTitle:(nullable NSString *)title delegate:(nullable id<XLPhotoBrowserDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle deleteButtonTitle:(nullable NSString *)deleteButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitle, ...
{
    NSMutableArray *otherButtonTitlesArray = [NSMutableArray array];
    NSString *buttonTitle;
    va_list argumentList;
    if (otherButtonTitle) {
        [otherButtonTitlesArray addObject:otherButtonTitle];
        va_start(argumentList, otherButtonTitle);
        while ((buttonTitle = va_arg(argumentList, id))) {
            [otherButtonTitlesArray addObject:buttonTitle];
        }
        va_end(argumentList);
    }
    self.actionOtherButtonTitles = otherButtonTitlesArray;
    self.actionSheetTitle = title;
    self.actionSheetCancelTitle = cancelButtonTitle;
    self.actionSheetDeleteButtonTitle = deleteButtonTitle;
    if (delegate) {
        self.delegate = delegate;
    }
}

/**
 *  保存当前展示的图片
 */
- (void)saveCurrentShowImage
{
    XLZoomingScrollView * zoomingScrollView = [self zoomingScrollViewAtIndex:self.currentImageIndex];
    NSString * st = [shareArr getURLArrShare].urlArr[self.num];
    NSURL * url = [NSURL URLWithString:st];
    UIImage * showImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[url absoluteString]];
    if (showImage)
    {
        UIImage * image = [UIImage imageWithData:[self getfileUrl:[shareArr getURLArrShare].urlArr[self.num]]]; //9-28
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    else
    {
        UIImageWriteToSavedPhotosAlbum(zoomingScrollView.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    [self addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

- (NSData *)getfileUrl:(NSString *)imageURL
{
    NSData * imageData = nil;
    
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imageURL]];
    
    if (isExit)
    {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURL]];
        
        if (cacheImageKey.length)
        {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            
            if (cacheImagePath.length)
            {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData)
    {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    }
    return imageData;
}

#pragma mark    -   public method  -->  XLPhotoBrowser简易使用方式:一行代码展示

/**
 一行代码展示(在某些使用场景,不需要做很复杂的操作,例如不需要长按弹出actionSheet,从而不需要实现数据源方法和代理方法,那么可以选择这个方法,直接传数据源数组进来,框架内部做处理)
 
 @param images            图片数据源数组(,内部可以是UIImage/NSURL网络图片地址/ALAsset)
 @param currentImageIndex 展示第几张
 
 @return XLPhotoBrowser实例对象
 */
+ (instancetype)showPhotoBrowserWithImages:(NSArray *)images currentImageIndex:(NSInteger)currentImageIndex
{
    if (images.count <=0 || images ==nil) {
        XLPBLog(@"一行代码展示图片浏览的方法,传入的数据源为空,不进入图片浏览,请检查传入数据源");
        return nil;
    }
    
    
    XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
    browser.imageCount = images.count;
    browser.currentImageIndex = currentImageIndex;
    browser.images = images;
    [browser show];
    return browser;
}

- (NSString*)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";

    
    return platform;
}


@end
