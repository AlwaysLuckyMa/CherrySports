//
//  SearchCollectionViewCell.m
//  CherrySports
//
//  Created by dkb on 16/11/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@interface SearchCollectionViewCell ()
/** image*/
@property (nonatomic, strong) UIView *imageV;
@end

@implementation SearchCollectionViewCell

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
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.title];
}

- (UIView *)imageV
{
    if (!_imageV) {
        _imageV = [AppTools createViewBackground:UIColorFromRGB(0xfdd6db)];
        _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = 5;
        _imageV.layer.borderWidth = 0.75;
        _imageV.layer.borderColor = UIColorFromRGB(0xc83648).CGColor;
//        _imageV.contentMode = UIViewContentModeScaleAspectFit;
//        _imageV.image = [_imageV.image stretchableImageWithLeftCapWidth:floorf(_imageV.image.size.width/2) topCapHeight:floorf(_imageV.image.size.height/2)];
        _imageV.hidden = YES;
    }
    return _imageV;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [AppTools createLabelText:@"" Color:[UIColor whiteColor] Font:12 TextAlignment:NSTextAlignmentLeft];
        _title.font = [UIFont systemFontOfSize:12];
    }
    return _title;
}

-(void)labelVal:(NSString *)cityName cityNameWidth:(NSInteger)cityNameWidth isSelect:(NSString *)isSelect{
    
    if ([isSelect isEqualToString:@"1"]) {
        _title.textColor = TEXT_COLOR_RED;
        _title.text = cityName;
        _imageV.hidden = NO;
    }else{
        _title.textColor = TEXT_COLOR_DARK;
        _title.text = cityName;
        _imageV.hidden = YES;
    }
    //    NSLog(@"width = %zd", cityNameWidth);
    _titleWidth = cityNameWidth;
    [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_titleWidth+16);
        make.left.bottom.mas_equalTo(0);
    }];
}

- (void)layoutSubviews
{
    WS(weakSelf);
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageV);
        make.centerY.equalTo(_imageV);
    }];
    
    [super layoutSubviews];
}


@end
