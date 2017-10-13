//
//  DialogView.m
//  CherrySports
//
//  Created by dkb on 16/11/30.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "DialogView.h"

@implementation DialogView

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void) createView  {
    WS(weakSelf);
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
//        make.size.mas_equalTo(CGSizeMake(150, 171));
    }];
    [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loadingImageView.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 20));
    }];
    //无网络
    [self.noNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.noNetworkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        //        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self.noNetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.noNetworkImageView.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 20));
    }];
    [self.noNetworkRefreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.noNetworkLabel.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    //程序异常
    [self.excptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.excptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        //        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self.excptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.excptionImageView.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 20));
    }];
    [self.excptionRefreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.excptionLabel.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    //无数据
    [self.nothingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.nothingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        //        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self.nothingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nothingImageView.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 20));
    }];
    [self.nothingRefreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nothingLabel.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

#pragma mark 页面加载中
-(UIView *) loadingView {
    if (!_loadingView) {
        _loadingView = [[UIView alloc] init];
        _loadingView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_loadingView];
    }
    return _loadingView;
}
-(UIImageView *) loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
        //        _loadingImageView.image = [UIImage imageNamed:@"loading.gif"];
        _loadingImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.loadingView addSubview:_loadingImageView];
    }
    return _loadingImageView;
}
-(UILabel *) loadingLabel {
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.textColor = TEXT_COLOR_LIGHT;
        _loadingLabel.text = @"页面努力加载中...";
        _loadingLabel.font = [UIFont systemFontOfSize:14];
        _loadingLabel.hidden = YES;
        [self.loadingView addSubview:_loadingLabel];
    }
    return _loadingLabel;
}

#pragma mark 无网络
-(UIView *) noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[UIView alloc] init];
        _noNetworkView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_noNetworkView];
    }
    return _noNetworkView;
}
-(UIImageView *) noNetworkImageView {
    if (!_noNetworkImageView) {
        _noNetworkImageView = [[UIImageView alloc] init];
        _noNetworkImageView.image = [UIImage imageNamed:@"noNetwork"];
        _noNetworkImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.noNetworkView addSubview:_noNetworkImageView];
    }
    return _noNetworkImageView;
}
-(UILabel *) noNetworkLabel {
    if (!_noNetworkLabel) {
        _noNetworkLabel = [[UILabel alloc] init];
        _noNetworkLabel.textAlignment = NSTextAlignmentCenter;
        _noNetworkLabel.textColor = TEXT_COLOR_LIGHT;
        _noNetworkLabel.text = @"您的网络好像不太给力，请稍后重试";
        _noNetworkLabel.font = [UIFont systemFontOfSize:14];
        [self.noNetworkView addSubview:_noNetworkLabel];
    }
    return _noNetworkLabel;
}
-(UIButton *) noNetworkRefreshButton{
    if (!_noNetworkRefreshButton) {
        _noNetworkRefreshButton = [[UIButton alloc] init];
        [_noNetworkRefreshButton setTitle:@"点击刷新" forState:UIControlStateNormal];
        [_noNetworkRefreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _noNetworkRefreshButton.backgroundColor = NAVIGATIONBAR_COLOR;
        _noNetworkRefreshButton.layer.cornerRadius = 15;
        _noNetworkRefreshButton.layer.masksToBounds = YES;
        _noNetworkRefreshButton.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:14];
        [self.noNetworkView addSubview:_noNetworkRefreshButton];
    }
    return _noNetworkRefreshButton;
}

#pragma mark 程序异常
-(UIView *) excptionView {
    if (!_excptionView) {
        _excptionView = [[UIView alloc] init];
        _excptionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_excptionView];
    }
    return _excptionView;
}
-(UIImageView *) excptionImageView {
    if (!_excptionImageView) {
        _excptionImageView = [[UIImageView alloc] init];
        _excptionImageView.image = [UIImage imageNamed:@"excption"];
        _excptionImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.excptionView addSubview:_excptionImageView];
    }
    return _excptionImageView;
}
-(UILabel *) excptionLabel {
    if (!_excptionLabel) {
        _excptionLabel = [[UILabel alloc] init];
        _excptionLabel.textAlignment = NSTextAlignmentCenter;
        _excptionLabel.textColor = TEXT_COLOR_LIGHT;
        _excptionLabel.font = [UIFont systemFontOfSize:14];
        _excptionLabel.text = @"服务器好像开小差了，请稍后重试";
        [self.excptionView addSubview:_excptionLabel];
    }
    return _excptionLabel;
}
-(UIButton *) excptionRefreshButton{
    if (!_excptionRefreshButton) {
        _excptionRefreshButton = [[UIButton alloc] init];
        [_excptionRefreshButton setTitle:@"点击刷新" forState:UIControlStateNormal];
        [_excptionRefreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _excptionRefreshButton.layer.cornerRadius = 15;
        _excptionRefreshButton.layer.masksToBounds = YES;
        _excptionRefreshButton.backgroundColor = NAVIGATIONBAR_COLOR;
        _excptionRefreshButton.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:14];
        [self.excptionView addSubview:_excptionRefreshButton];
    }
    return _excptionRefreshButton;
}

#pragma mark 无数据
-(UIView *) nothingView {
    if (!_nothingView) {
        _nothingView = [[UIView alloc] init];
        _nothingView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_nothingView];
    }
    return _nothingView;
}
-(UIImageView *) nothingImageView {
    if (!_nothingImageView) {
        _nothingImageView = [[UIImageView alloc] init];
        _nothingImageView.image = [UIImage imageNamed:@"nothing"];
        _nothingImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.nothingView addSubview:_nothingImageView];
    }
    return _nothingImageView;
}
-(UILabel *) nothingLabel {
    if (!_nothingLabel) {
        _nothingLabel = [[UILabel alloc] init];
        _nothingLabel = [[UILabel alloc] init];
        _nothingLabel.textAlignment = NSTextAlignmentCenter;
        _nothingLabel.textColor = TEXT_COLOR_LIGHT;
        _nothingLabel.font = [UIFont systemFontOfSize:14];
        _nothingLabel.text = @"什么都没有哦";
        [self.nothingView addSubview:_nothingLabel];
    }
    return _nothingLabel;
}
-(UIButton *) nothingRefreshButton{
    if (!_nothingRefreshButton) {
        _nothingRefreshButton = [[UIButton alloc] init];
        [_nothingRefreshButton setTitle:@"点击刷新" forState:UIControlStateNormal];
        [_nothingRefreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nothingRefreshButton.layer.cornerRadius = 15;
        _nothingRefreshButton.layer.masksToBounds = YES;
        _nothingRefreshButton.backgroundColor = NAVIGATIONBAR_COLOR;
        _nothingRefreshButton.hidden = YES;
        _nothingRefreshButton.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:14];
        [self.nothingView addSubview:_nothingRefreshButton];
    }
    return _nothingRefreshButton;
}


//播放动画
- (void)runAnimationWithCount:(int)count name:(NSString *)name
{
    // 1.加载所有的动画图片
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 1; i <= count; i++) {
        // 计算文件名
        NSString *filename = [NSString stringWithFormat:@"%@_%d", name, i];
        // 加载图片
        //缓存就是
        // imageNamed: 有缓存机制(传入文件名)；好处是快，坏处就是占内存
        UIImage *image = [UIImage imageNamed:filename];
        
        // imageWithContentsOfFile: 没有缓存(传入文件的全路径)
        //         NSBundle *bundle = [NSBundle mainBundle];
        //         NSString *path = [bundle pathForResource:filename ofType:nil];
        //         UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        // 添加图片到数组中
        [images addObject:image];
    }
    self.loadingImageView.animationImages = images;
    
    // 2.设置播放次数(0次为无限播放)
    self.loadingImageView.animationRepeatCount = 0;
    
    // 3.设置播放时间
    self.loadingImageView.animationDuration = images.count * 0.3;
    
    [self.loadingImageView startAnimating];
    
    // 4.动画放完1秒后清除内存
    //     CGFloat delay = self.loadingImageView.animationDuration + 1.0;
    [self.loadingImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:60];
    //    [self performSelector:@selector(clearCache) withObject:nil afterDelay:delay];
}


@end
