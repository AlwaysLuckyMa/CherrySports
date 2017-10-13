//
//  StartImageView.m
//  CherrySports
//
//  Created by dkb on 17/2/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "StartImageView.h"
#import <SDCycleScrollView.h>

@interface StartImageView () <SDCycleScrollViewDelegate>
/** 轮播图*/
@property (nonatomic, strong) SDCycleScrollView *myScrollView;

@property (nonatomic, strong) NSMutableArray *roolImageArr;

// 按钮倒计时
@property (nonatomic, assign) NSInteger numCount;
/** 按钮*/
@property (nonatomic, strong) UIImageView *buttonImage;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation StartImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addViews];
        _numCount = 3;
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = [NSMutableArray array];
    _roolImageArr = [NSMutableArray array];
    
    if (dataArray.count != 0) {
        for (int i = 0; i < dataArray.count; i++) {
            StartModel *model = dataArray[i];
            NSlog(@"本地图片地址url= %@", model.localImageUrl);
//            [_roolImageArr addObject:[AppTools httpsWithStr:model.localImageUrl]];
            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:model.localImageUrl];
            [_roolImageArr addObject:fullPath];
            [_dataArray addObject:model];
        }
    }
    //    _myScrollView.imageURLStringsGroup = nil;
    _myScrollView.localizationImageNamesGroup = _roolImageArr;
    //    NSLog(@"imagearr = %@, btnArr = %@", _dataArray, _btnArr);
    [self createViews];
    [self timer];
}



- (void)createViews
{
    if (!_myScrollView) {
        // 轮播图
        _myScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) imageNamesGroup:_roolImageArr];
        _myScrollView.pageControlAliment = SDCycleScrollViewPageContolStyleAnimated;
        _myScrollView.autoScrollTimeInterval = 5;
        _myScrollView.delegate = self;
        _myScrollView.showPageControl = NO;
//        _myScrollView.pageDotImage = [UIImage imageNamed:@"small01"];
//        _myScrollView.currentPageDotImage = [UIImage imageNamed:@"small02"];
//        _myScrollView.pageDotColor = [UIColor blackColor];
//        _myScrollView.currentPageDotColor = NAVIGATIONBAR_COLOR;
//        _myScrollView.placeholderImage = PLACEHOLDW;
        
        _myScrollView.infiniteLoop = NO;
        _myScrollView.autoScroll = NO;
        [self addSubview:_myScrollView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            _myScrollView.imageURLStringsGroup = _roolImageArr;
        });
        // 清除缓存
        [_myScrollView clearCache];
    }
    
    //    if (!_whiteImage) {
    //        _whiteImage = [AppTools CreateImageViewImageName:@"home_banner_white"];
    //        [self addSubview:_whiteImage];
    //        [_whiteImage mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.bottom.mas_equalTo(0);
    //            make.left.right.mas_equalTo(0);
    //        }];
    //    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    StartModel *model = _dataArray[index];
    NSlog(@"---点击了第%ld张图片, tlink = %@", index, model.tLink);
    if (![model.tLink isEqualToString:@""]) {
        [self.delegate ClickStartModel:_dataArray[index]];
    }
}

- (void)tapAction
{
    if (_numCount == 0) {
        [self.delegate ClickTapImage];
    }
}

- (UIImageView *)buttonImage
{
    WS(weakSelf);
    if (!_buttonImage) {
        _buttonImage = [AppTools CreateImageViewImageName:@"tiaoguo_1"];
        _buttonImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.myScrollView addSubview:_buttonImage];
        _buttonImage.userInteractionEnabled = YES;
        [_buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
                make.right.mas_equalTo(-40);
                make.top.mas_equalTo(60);
            }else{
                make.top.mas_equalTo(50);
                make.right.mas_equalTo(-30);
            }
        }];
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_buttonImage addGestureRecognizer:tapImage];
    }
    return _buttonImage;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [AppTools createLabelText:[NSString stringWithFormat:@"%zd",_numCount] Color:[UIColor whiteColor] Font:14 TextAlignment:NSTextAlignmentCenter];
        _numLabel.font = [UIFont systemFontOfSize:16];
        [self.buttonImage addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.centerY.equalTo(_buttonImage);
            make.width.height.mas_equalTo(20);
        }];
    }
    return _numLabel;
}

- (NSTimer *)timer
{
    if (!_timer) {
        [self buttonImage];
        [self numLabel];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeVideo) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)timeVideo
{
    _numCount --;
    
    if (_numCount > 0) {
        _numLabel.text = [NSString stringWithFormat:@"%zd",_numCount];
    }else{
        _buttonImage.image = [UIImage imageNamed:@"tiaoguo_2"];
        _numLabel.hidden = YES;
        [_timer invalidate];
    }
}

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
