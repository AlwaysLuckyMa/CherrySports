//
//  MineMessageCell.m
//  CherrySports
//
//  Created by dkb on 16/11/16.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineMessageCell.h"

@interface MineMessageCell ()
/** time*/
@property (nonatomic, strong) UILabel *time;
/** 内容*/
@property (nonatomic, strong) UILabel *contents;
/** 线*/
@property (nonatomic, strong) UIView *line;
@end

@implementation MineMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    // 时间
    if (!_time) {
        _time = [AppTools createLabelText:@"" Color:TEXT_COLOR_LIGHT Font:10 TextAlignment:NSTextAlignmentLeft];
//        _time.backgroundColor = [UIColor greenColor];
        _time.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(200);
            if (IS_IPHONE_6Plus || IS_IPHONE_6) {
                make.top.mas_equalTo(12);
            }else{
                make.top.mas_equalTo(14);
            }
        }];
    }
    // 内容
    if (!_contents) {
        _contents = [AppTools createLabelText:@"" Color:UIColorFromRGB(0x191919) Font:14 TextAlignment:NSTextAlignmentLeft];
        _contents.font = [UIFont systemFontOfSize:12];
//        _contents.backgroundColor = [UIColor redColor];
        _contents.numberOfLines = 0;
        [self.contentView addSubview:_contents];
    }
    // 底部线
    if (!_line) {
        _line = [AppTools createViewBackground:LINE_COLOR];
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
}

- (void)setMyModel:(MyMessageModel *)myModel
{
    _time.text = myModel.tCreateTime;
    _contents.text = myModel.tContent;
    
    
    [_contents mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_time);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(myModel.labelHeight);
        if (IS_IPHONE_6Plus || IS_IPHONE_6) {
            make.bottom.mas_equalTo(-12);
        }else{
            make.bottom.mas_equalTo(-14);
        }
    }];
}










@end
