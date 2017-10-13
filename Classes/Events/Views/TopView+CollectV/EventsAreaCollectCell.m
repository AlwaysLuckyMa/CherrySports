//
//  EventsAreaCollectCell.m
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "EventsAreaCollectCell.h"

@interface EventsAreaCollectCell ()
/** image*/
@property (nonatomic, strong) UIView *backV;
@end

@implementation EventsAreaCollectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    [self.contentView addSubview:self.backV];
    [self.contentView addSubview:self.title];
}

- (UIView *)backV
{
    if (!_backV) {
//
        _backV = [AppTools createViewBackground:[UIColor whiteColor]];
        _backV.layer.borderColor = UIColorFromRGB(0xe7e7e9).CGColor;
        _backV.layer.borderWidth = 0.5;
//        _imageV.image = [_imageV.image stretchableImageWithLeftCapWidth:floorf(_imageV.image.size.width/2) topCapHeight:floorf(_imageV.image.size.height/2)];

    }
    return _backV;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [AppTools createLabelText:@"" Color:TEXT_COLOR_DARK Font:11 TextAlignment:NSTextAlignmentCenter];
        _title.font = [UIFont systemFontOfSize:11];
    }
    return _title;
}

-(void)labelValSelect:(NSString *)isSelect{
    
    if ([isSelect isEqualToString:@"1"]) {
        _backV.backgroundColor = UIColorFromRGB(0xfae1e4);
        _backV.layer.borderColor = UIColorFromRGB(0xe18a9a).CGColor;
        _title.textColor = TEXT_COLOR_RED;
    }else{
        _backV.layer.borderColor = UIColorFromRGB(0xe7e7e9).CGColor;
        _backV.backgroundColor = [UIColor whiteColor];
        _title.textColor = TEXT_COLOR_DARK;
    }
}

- (void)setEventCityModel:(EventsCityModel *)eventCityModel
{
    _title.text = eventCityModel.tName;
    
    NSInteger cityWidth = [AppTools labelRectWithLabelSize:CGSizeMake(1000, 14) LabelText:eventCityModel.tName Font:[UIFont systemFontOfSize:11]].width;
//    NSLog(@"cityTid = %@", eventCityModel.tId);
//    [_backV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(cityWidth+16);
//        make.left.bottom.mas_equalTo(0);
//    }];
}

- (void)setSelectModel:(EventsSelectModel *)selectModel
{
    _title.text = selectModel.tName;
    
    NSInteger cityWidth = [AppTools labelRectWithLabelSize:CGSizeMake(1000, 14) LabelText:selectModel.tName Font:[UIFont systemFontOfSize:11]].width;
//    NSLog(@"searchId = %@", selectModel.tId);
//    [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(cityWidth+16);
//        make.left.bottom.mas_equalTo(0);
//    }];
}

- (void)setTypeModel:(EventsTypeModel *)typeModel
{
    _title.text = typeModel.tName;
    
    NSInteger cityWidth = [AppTools labelRectWithLabelSize:CGSizeMake(1000, 14) LabelText:typeModel.tName Font:[UIFont systemFontOfSize:11]].width;
//    NSLog(@"width = %zd", cityWidth);
//    NSLog(@"typeId = %@", typeModel.tId);
//    [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(cityWidth+16);
//        make.left.bottom.mas_equalTo(0);
//    }];
}


- (void)layoutSubviews
{
    WS(weakSelf);
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.left.right.mas_equalTo(0);
    }];
    
    [super layoutSubviews];
}

@end
