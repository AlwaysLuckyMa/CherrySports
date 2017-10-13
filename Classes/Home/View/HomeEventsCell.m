//
//  HomeEventsCell.m
//  CherrySports
//
//  Created by dkb on 16/10/31.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "HomeEventsCell.h"

@implementation HomeEventsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    [self.contentView addSubview:self.backImage];
    [self.backImage addSubview:self.timeImage];
    [self.timeImage addSubview:self.time];
    [self.backImage addSubview:self.titleImage];
    [self.backImage addSubview:self.title];
}

- (UIImageView *)backImage
{
    if (!_backImage)
    {
        _backImage = [AppTools CreateImageViewImageName:@"Eventaaaaa.jpg"];
    }
    return _backImage;
}

- (UIImageView *)timeImage
{
    if (!_timeImage)
    {
        _timeImage = [AppTools CreateImageViewImageName:@"home_event_title1"];
        _timeImage.image = [_timeImage.image stretchableImageWithLeftCapWidth:floorf(_timeImage.image.size.width/2) topCapHeight:floorf(_timeImage.image.size.height/2)];
    }
    return _timeImage;
}

- (UIImageView *)titleImage
{
    if (!_titleImage)
    {
        _titleImage = [AppTools CreateImageViewImageName:@"home_event_title2"];
        _titleImage.image = [_titleImage.image stretchableImageWithLeftCapWidth:floorf(_titleImage.image.size.width/2) topCapHeight:floorf(_titleImage.image.size.height/2)];
    }
    return _titleImage;
}

- (UILabel *)time
{
    if (!_time)
    {
        _time = [AppTools createLabelText:@"时间：10月15日" Color:[UIColor whiteColor] Font:12 TextAlignment:NSTextAlignmentLeft];
    }
    return _time;
}

- (UILabel *)title
{
    if (!_title)
    {
        _title = [AppTools createLabelText:@"德国杯第一场比赛即将开战" Color:[UIColor whiteColor] Font:12 TextAlignment:NSTextAlignmentLeft];
    }
    return _title;
}

- (void)setHomeEventModel:(HomeEventsModel *)homeEventModel
{
    NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:homeEventModel.tImgPath]];
    [_backImage sd_setImageWithURL:url placeholderImage:PLACEHOLDW options:SDWebImageAllowInvalidSSLCertificates];
    
    _title.text = homeEventModel.tTitle;
    NSString *string;
    if (homeEventModel.tGameBegin.length > 0) {
        string = [homeEventModel.tGameBegin substringToIndex:16];
    }
//    NSLog(@"str = %@",string);
    _time.text = [NSString stringWithFormat:@"时间：%@", string];
    
    CGFloat imageWidth;
    if (IS_IPHONE_5 || IS_IPHONE_4) {
        imageWidth = [AppTools labelRectWithLabelSize:CGSizeMake(10000, 15) LabelText:_time.text Font:[UIFont systemFontOfSize:14*SCREEN_WIDTH/375]].width;
    }else{
        imageWidth = [AppTools labelRectWithLabelSize:CGSizeMake(10000, 15) LabelText:_time.text Font:[UIFont systemFontOfSize:14]].width;
    }

    NSLog(@"=== imageWidth = %f", imageWidth);
    if (imageWidth > 66.5) {
        [_timeImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(imageWidth);
        }];
    }else{
        [_timeImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(66.5);
        }];
    }
}


- (void)layoutSubviews
{
    [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    
    [_timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(3);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.centerY.equalTo(_timeImage);
    }];
    
    [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.centerY.equalTo(_titleImage);
    }];
    [super layoutSubviews];
}


@end
