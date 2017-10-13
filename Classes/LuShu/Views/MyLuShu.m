//
//  MyLuShu.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/19.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "MyLuShu.h"

#import "DownloadedView.h" //已经下载
#import "IMadeView.h"      //我制作的
#import "EnshrineView.h"   //收藏
@interface MyLuShu ()
{
    UIButton       * _btn;
    DownloadedView * _downLoad;
    IMadeView      * _iMade;
    EnshrineView   * _enshrine;
    NSArray        * _controllArr;
}
@end

@implementation MyLuShu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor    = [UIColor whiteColor];
        [self initView];
        [self createSelectView];
    }
    return self;
}

- (void)initView
{
    CGFloat  view_X = 0;
    CGFloat  view_Y = 44;
    CGFloat  view_W = SCREEN_WIDTH;
    CGFloat  view_H = SCREEN_HEIGHT - 44 - 64-44;
    
    _iMade            = [[IMadeView alloc]initWithFrame:CGRectMake(view_X, view_Y,view_W,view_H)];
    [self addSubview:_iMade];
    
    _enshrine         = [[EnshrineView alloc]initWithFrame:CGRectMake(view_X, view_Y, view_W, view_H)];
    [self addSubview:_enshrine];
    
    _downLoad         = [[DownloadedView alloc]initWithFrame:CGRectMake(view_X, view_Y, view_W, view_H)];
    [self addSubview:_downLoad];

    _controllArr = @[_downLoad,_iMade,_enshrine];
}

- (void)createSelectView
{
    NSArray * titleArr = @[@"已下载",@"我的制作",@"收藏"];
    for (NSInteger i = 0; i < 3; i++)
    {
        CGFloat btn_X       = 10 + ( 10 + (SCREEN_WIDTH - 40) / 3 ) * i;
        _btn                = [[UIButton alloc]initWithFrame:CGRectMake( btn_X, 7, (SCREEN_WIDTH - 40) / 3, 30)];
        _btn.tag            = 100 + i;
        [_btn setTitle:titleArr[i]                                forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor grayColor]                   forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor]                  forState:UIControlStateSelected];
        if (_btn.tag == 100)
        {
            _btn.selected            = YES;
            _btn.backgroundColor     = [UIColor redColor];
            _btn.layer.masksToBounds = YES;
            _btn.layer.cornerRadius  = 8;
        }
        [_btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
    }
}

- (void)selectBtn:(UIButton *)sender
{
    UIButton * button = nil;
    for (UIButton * btnView in [self subviews])
    {
        if ( [btnView isKindOfClass:[UIButton class]] )
        {
            UIButton * btn = (UIButton *)btnView;
            btn.selected        = NO;
            btn.backgroundColor = [UIColor clearColor];
            if (btn.tag - 100 == sender.tag - 100)
            {
                button = btn;
            }
        }
    }
    
    if (button != nil)
    {
        button.selected            = YES;
        button.backgroundColor     = [UIColor redColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  = 8;
        [self bringSubviewToFront:_controllArr[button.tag- 100]];
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
