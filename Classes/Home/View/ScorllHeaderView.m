//
//  ScorllHeaderView.m
//  CherrySports
//
//  Created by dkb on 16/10/27.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "ScorllHeaderView.h"

#define TIMERTIME 5
@interface ScorllHeaderView ()
/** 记录btn的Tag*/
@property (nonatomic, assign) NSInteger btnIndex;
/** 记录是左滑还是右滑*/
@property (nonatomic, assign) NSInteger offset;
/** 记录点击的btn是否<3*/
@property (nonatomic, assign) BOOL isBtn;

@end

@implementation ScorllHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = [NSMutableArray array];
    _btnArr = [NSMutableArray array];
    [_myScrollView removeFromSuperview];
    [_btnScrollView removeFromSuperview];

    if (dataArray.count != 0) {
        for (int i = 0; i < dataArray.count; i++) {
            HomeImageModel *model = dataArray[i];
            [_dataArray addObject:model];
        }
        for (int i = 1; i < dataArray.count - 1; i++) {
            HomeImageModel *model = dataArray[i];
            [_btnArr addObject:model];
        }
    }
    [self addSubViews];
//    NSLog(@"imagearr = %@, btnArr = %@", _dataArray, _btnArr);
}

-(void)dealloc
{
    [_myScrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}

- (void)addSubViews
{
    [self addSubview:self.myScrollView];
    [self addSubview:self.btnScrollView];
    
    if (!_timer) {
        [self timer];
        [self pageControl];
    }
}

- (UIScrollView *)myScrollView
{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175)];
        _myScrollView.pagingEnabled = YES; // 按页滚动
        _myScrollView.bounces = NO; // 取消边框反弹
        _myScrollView.showsHorizontalScrollIndicator = NO; // 不显示水平滚动条
        _myScrollView.delegate = self;
        _myScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _dataArray.count, 175);
//        _myScrollView.backgroundColor = [UIColor purpleColor];
        
        for (int i = 0; i < _dataArray.count; i++) {
            UIImageView *scrolImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, 175)];
            scrolImage.userInteractionEnabled = YES; // 页面交互
            scrolImage.tag = 1000+i;
            // 图片过大从中间开始显示
            //            scrolImage.contentMode = UIViewContentModeScaleAspectFill;
            HomeImageModel *model = _dataArray[i];
            NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:model.tImgPath]];
            [scrolImage sd_setImageWithURL:url placeholderImage:PLACEHOLDW options:SDWebImageAllowInvalidSSLCertificates];
            //            [scrolImage sd_setImageWithURL:url placeholderImage:PLACEHOLDW];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [scrolImage addGestureRecognizer:tap];
            [_myScrollView addSubview:scrolImage];
            
            //设置observer
            [_myScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
        }
    }
    
    return _myScrollView;
}

- (UIScrollView *)btnScrollView
{
    if (!_btnScrollView)
    {
        _btnScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45.5, 44, 27.5, 103)];
        _btnScrollView.bounces = NO; // 取消边框反弹
        _btnScrollView.pagingEnabled = YES; // 按页滚动
        _btnScrollView.showsVerticalScrollIndicator = NO;
        _btnScrollView.delegate = self;
        _btnScrollView.contentOffset = CGPointMake(0, 0);
        _btnScrollView.contentSize = CGSizeMake(27.5, 26 * _btnArr.count);
        _btnScrollView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0];
        
        for (int i = 0; i < _btnArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"banner-s"]  forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@""]  forState:UIControlStateNormal];
            button.tag = 2999+i;
            if (i > 0) {
                button.frame = CGRectMake(0, 26 * i, 27.5, 25);
                button.selected = NO;
            }else{
                button.selected = YES;
                _btnIndex = 2999;
                button.frame = CGRectMake(0, 0, 27.5, 25);
            }
            //            [button addTarget:self action:@selector(btnCender:) forControlEvents:UIControlEventTouchUpInside];
#warning _btnScrollView 会自动屏蔽子视图的 touch事件,但是可以用手势实现
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnCender:)];
            [button addGestureRecognizer:tap];
            [_btnScrollView addSubview:button];
            HomeImageModel *model = _btnArr[i];
            UIImageView *btnImage = [UIImageView new];
            NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:model.tNavigationImg]];
            [btnImage sd_setImageWithURL:url placeholderImage:PLACEHOLDH options:SDWebImageAllowInvalidSSLCertificates];
            btnImage.frame = CGRectMake(2.5, 0, 25, 25);
            btnImage.userInteractionEnabled = YES;
            [button addSubview:btnImage];
            //设置observer
//            [_btnScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
        }
    }
    
    return _btnScrollView;
}

- (void)btnCender:(UITapGestureRecognizer *)cender
{
    UIButton *button = (UIButton *)cender.view;
    if (button.tag < 3002) {
        _isBtn = YES;
    }else if (button.tag > 3002 && _btnArr.count == 5){
        [_btnScrollView setContentOffset:CGPointMake(0, (self.btnArr.count-4) * 26) animated:YES];
    }
    
    NSLog(@"cender.tag = %zd", button.tag);
    NSLog(@"index.tag = %zd", _btnIndex);
    [self.timer invalidate];
    self.timer = nil;
    
    UIButton *btn = (UIButton *)[self viewWithTag:_btnIndex];
    btn.selected = NO;
    UIButton *myButton = (UIButton *)[self viewWithTag:button.tag];
    _btnIndex = myButton.tag;
    myButton.selected = YES;
    //myScrollView联动
    _myScrollView.contentOffset = CGPointMake(SCREEN_WIDTH* (button.tag % 2999+1), 0);
    
    [self timer];
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMERTIME target:self selector:@selector(timerAction:) userInfo:_myScrollView repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
    return _timer;
}

#pragma mark - 轮播图点击
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    int i = _myScrollView.contentOffset.x / SCREEN_WIDTH;
    HomeImageModel *model = _dataArray[i];
    [self.delegate ClickSliderWebModel:model];
    NSLog(@"点击了第%f张图", _myScrollView.contentOffset.x / SCREEN_WIDTH);
}

#pragma mark --定时器切换轮播图
-(void)timerAction:(NSTimer *)timer
{
    [UIView animateWithDuration:1 animations:^{
        [_myScrollView setContentOffset:CGPointMake(_myScrollView.contentOffset.x + SCREEN_WIDTH, 0) animated:YES];
        // 改变btnScrollView的偏移量
        NSInteger offset = _myScrollView.contentOffset.x - SCREEN_WIDTH;
        int num = (int) offset/(int)SCREEN_WIDTH%self.btnArr.count;
        
        NSInteger offseter = (_myScrollView.contentOffset.x - SCREEN_WIDTH) / SCREEN_WIDTH;
        int number = (int) offseter % self.btnArr.count;
        
        if (number == self.btnArr.count-1 || _isBtn == YES) {
            [_btnScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            _isBtn = NO;
        }else if (number >= 3 && num < self.btnArr.count - 1) {
            [_btnScrollView setContentOffset:CGPointMake(0, (self.btnArr.count-4) * 26) animated:YES];
        }
    }];
    
    if (_myScrollView.contentOffset.x == SCREEN_WIDTH * (self.dataArray.count - 2)) {
        _myScrollView.contentOffset = CGPointMake(0, 0);
        
        CGPoint newContentsize = _myScrollView.contentOffset;
        newContentsize.x += SCREEN_WIDTH;
    }
    
    self.pageControl.currentPage = _myScrollView.contentOffset.x / SCREEN_WIDTH;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _myScrollView) {
        self.pageControl.currentPage = (_myScrollView.contentOffset.x - SCREEN_WIDTH) / SCREEN_WIDTH;
        if (_myScrollView.contentOffset.x == (_dataArray.count - 1) * SCREEN_WIDTH) {
            self.pageControl.currentPage = 0;
        }else if (_myScrollView.contentOffset.x == 0)
        {
            self.pageControl.currentPage = self.dataArray.count;
        }
        if (_myScrollView.contentOffset.x == 0 * SCREEN_WIDTH) {
            _myScrollView.contentOffset = CGPointMake((self.dataArray.count - 2) * SCREEN_WIDTH, 0);
        }else if (_myScrollView.contentOffset.x == (self.dataArray.count - 1) *SCREEN_WIDTH){
            _myScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }

        // 改变btnScrollView的偏移量
        NSInteger offset = (_myScrollView.contentOffset.x - SCREEN_WIDTH) / SCREEN_WIDTH;
        int num = (int) offset % self.btnArr.count;
        
        if (num <= 3){
            [_btnScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (num > 3) {
            _isBtn = NO;
            [_btnScrollView setContentOffset:CGPointMake(0, (self.btnArr.count-4) * 26) animated:YES];
        }
    }
}

//当手指接触的时候让定时器停止
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

//当手指离开的时候开始滑动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMERTIME target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self timer];
}

// KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //改变pageControl
    NSInteger offset = _myScrollView.contentOffset.x - SCREEN_WIDTH;
    int num = (int) offset/(int)SCREEN_WIDTH%self.btnArr.count;
    _pageControl.currentPage = num;
    
    UIButton *button = (UIButton *)[self viewWithTag:_btnIndex];
    button.selected = NO;
    UIButton *btn = (UIButton *)[self viewWithTag:num + 2999];
    btn.selected = YES;
    _btnIndex = btn.tag;
}

-(UIPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 175-50, 100, 30)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = self.dataArray.count-2;
    }
    return _pageControl;
}




@end
