//
//  StartVideoView.m
//  CherrySports
//
//  Created by dkb on 17/2/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "StartVideoView.h"

//#import <MediaPlayer/MediaPlayer.h>
//#import <AVKit/AVKit.h>

#define VIDEOTIME [[NSUserDefaults standardUserDefaults] objectForKey:@"tPlayTime"]

@interface StartVideoView ()
//@property (strong, nonatomic) MPMoviePlayerController *player;
///** 定时器*/
//@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, strong) NSTimer *timerOne;
//@property (nonatomic, assign) NSInteger timeF;
///** 3 - 0*/
//@property (nonatomic, assign) NSInteger num;
//
///** 进入按钮*/
//@property (nonatomic, strong) UIImageView *enterImageV;
///** <#注释#>*/
//@property (nonatomic, strong) UILabel *timeLabel;

/** <#注释#>*/
@property (nonatomic, strong) UIView *aView;
/** <#注释#>*/
@property (nonatomic, strong) AVPlayer *player;
/** <#注释#>*/
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
/** <#注释#>*/
@property (nonatomic, strong) AVPlayerItem *playItem;

/** <#注释#>*/
@property (nonatomic, assign) NSInteger countDown;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger number;
// 按钮倒计时
@property (nonatomic, assign) NSInteger numCount;
/** 按钮*/
@property (nonatomic, strong) UIImageView *buttonImage;
@property (nonatomic, strong) UILabel *numLabel;
@end

@implementation StartVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addViews];
        NSString *videoTime = VIDEOTIME;
        _numCount = 3;
        if (![videoTime isEqualToString:@"0"]) {
            _countDown = videoTime.integerValue;
        }else{
            _countDown = 0;
        }
        
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setMovieURL:(NSURL *)movieURL
{
    _movieURL = movieURL;
    if (!_player) {
        [self addAVPlayer];
        [self timer];
    }
}

- (void)tapAction
{
    [self.player pause];
    [self.player setRate:0];
    [_timer invalidate];
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0;
        [self.delegate StartVideoDelegate];
    }];
}

- (UIImageView *)buttonImage
{
    WS(weakSelf);
    if (!_buttonImage) {
        _buttonImage = [AppTools CreateImageViewImageName:@"tiaoguo_1"];
        _buttonImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_buttonImage];
        [_buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-40);
            make.top.mas_equalTo(40);
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
            make.left.mas_equalTo(10);
            make.centerY.equalTo(_buttonImage);
            make.width.height.mas_equalTo(20);
        }];
    }
    return _numLabel;
}

- (void)addAVPlayer{
    
//    NSString *urlStr=[NSString stringWithFormat:@"http://video.szzhangchu.com/1446716559431_3808609356.mp4"];
//    urlStr =[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:urlStr];
    
    //得到playItem对象,播放项目对象
    self.playItem = [AVPlayerItem playerItemWithURL:_movieURL];
    
    //得到player对象,播放器对象
    self.player=[AVPlayer playerWithPlayerItem:self.playItem];
    
    //得到AVPlayerLayer对象,AVPlayerLayer是子类的CALayer AVPlayer对象可以在AVPlayerLayer对象上直接视觉输出。
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;//视频填充模式
    [self.layer addSublayer:self.playerLayer];
    [self.player play];
    
    
    [self addProgressObserver];
    
    [self addNotificationCenters];
}

#pragma mark -  添加进度观察 - addProgressObserver
- (void)addProgressObserver {
    WS(weakSelf);
    //  设置每秒执行一次  Periodic 定期的意思
    // CMTime curFrame = CMTimeMake(第几帧， 帧率）
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue: dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //  获取当前时间
        //        CMTime currentTime = _player.currentItem.currentTime;
        CMTime currentTime = weakSelf.playItem.currentTime;
        NSUInteger dTotalSeconds = CMTimeGetSeconds(currentTime);
        NSUInteger dHours = floor(dTotalSeconds / 3600);
        NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
        NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
        NSString *videoDurationText = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
        NSlog(@"当前播放时间为：%@", videoDurationText);
        
        //  转化成秒数
        //        CGFloat currentPlayTime = (CGFloat)currentTime.value / currentTime.timescale;
        //  总时间
        CMTime totalTime = weakSelf.playItem.duration;
        // 时间CMTime对象的.value值除以timescale才得到秒数: value/timescale = seconds.
        //        _totalMovieDuration = (CGFloat)totalTime.value / totalTime.timescale;
        //也可以通过CMTimeGetSeconds来获得总时长
//        _totalMovieDuration = CMTimeGetSeconds(totalTime);
        
        //将CMTime 对象转化为秒数
//        _topProgressSlider.value = CMTimeGetSeconds(currentTime) / _totalMovieDuration;
//        progressSlider = CMTimeGetSeconds(currentTime) / _totalMovieDuration;
        //        NSLog(@"每秒进度 = %f", _topProgressSlider.value);
        
    }];
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
    _number ++;
    _numCount --;
    
    if (_numCount > 0) {
        _numLabel.text = [NSString stringWithFormat:@"%zd",_numCount];
    }else{
        _buttonImage.image = [UIImage imageNamed:@"tiaoguo_2"];
        _buttonImage.userInteractionEnabled = YES;
        _numLabel.hidden = YES;
    }
    
    if (_countDown != 0) {
        if (_number == _countDown+1) {
            [self.player pause];
            [self.player setRate:0];
            [_timer invalidate];
            [UIView animateWithDuration:1 animations:^{
                self.alpha = 0;
                [self.delegate StartVideoDelegate];
            }];
        }
    }
}

#pragma mark - 观察者 观察播放完毕 观察屏幕旋转
- (void)addNotificationCenters {
    //  注册观察者用来观察，是否播放完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //  注册观察者来观察屏幕的旋转
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark 播放结束后的代理回调
- (void)moviePlayDidEnd:(NSNotification *)notify
{
    NSLog(@"播放结束触发");
    [self.player pause];
    [self.player setRate:0];
    [self.delegate StartVideoDelegate];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_player) {
        _player = nil;
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [_timer invalidate];
    _timer = nil;
    if (_player) {
        _player = nil;
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
}




@end
