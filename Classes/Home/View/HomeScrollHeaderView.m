//
//  HomeScrollHeaderView.m
//  CherrySports
//
//  Created by dkb on 16/12/19.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeScrollHeaderView.h"
#import <SDCycleScrollView.h>

@interface HomeScrollHeaderView () <SDCycleScrollViewDelegate>

/** 轮播图*/
@property (nonatomic, strong) SDCycleScrollView *myScrollView;

@property (nonatomic, strong) NSMutableArray *roolImageArr;

/** 白弧Image*/
@property (nonatomic, strong) UIImageView *whiteImage;

@end

@implementation HomeScrollHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray    = [NSMutableArray array];
    _roolImageArr = [NSMutableArray array];
    
    if (dataArray.count != 0) {
        for (int i = 1; i < dataArray.count - 1; i++) {
            HomeImageModel *model = dataArray[i];
            [_roolImageArr addObject:[AppTools httpsWithStr:model.tImgPath]];
            [_dataArray addObject:model];
        }
    }
//    _myScrollView.imageURLStringsGroup = nil;
    _myScrollView.imageURLStringsGroup = _roolImageArr;
    //    NSLog(@"imagearr = %@, btnArr = %@", _dataArray, _btnArr);
    [self createViews];
}

- (void)createViews
{
    if (!_myScrollView) {
        // 轮播图
        _myScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16) imageURLStringsGroup:_roolImageArr];
        
        _myScrollView.pageControlAliment = SDCycleScrollViewPageContolStyleAnimated;
        _myScrollView.autoScrollTimeInterval = 5; //时间间隔
        _myScrollView.delegate = self;
        _myScrollView.pageDotColor = [UIColor blackColor];
        _myScrollView.currentPageDotColor = NAVIGATIONBAR_COLOR;
        _myScrollView.placeholderImage = PLACEHOLDW;
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
    NSLog(@"---点击了第%ld张图片", index);
    [self.delegate ClickSliderWebModel:_dataArray[index]];
}





@end
