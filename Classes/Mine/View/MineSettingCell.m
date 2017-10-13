//
//  SettingCell.m
//  CherrySports
//
//  Created by 吴庭宇 on 2016/10/30.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineSettingCell.h"

@interface SettingCell ()
@property(nonatomic,strong)UIView *lineView;

@end
@implementation SettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
    [self.contentView addSubview:self.Label];
    [self.contentView addSubview:self.rightLabel];
    if (_isShow == NO) {
        [self addSubview:self.lineView];
    }
}
#pragma mark --懒加载
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView =[AppTools createViewBackground:LINE_COLOR];
    }return _lineView;
}
-(UILabel *)Label
{
    if (!_Label) {
        _Label = [AppTools createLabelText:@"" Color:TEXT_COLOR_DARK Font:16 TextAlignment:NSTextAlignmentLeft];
//        _Label.font = [UIFont fontWithName:@"Microsoft YaHei" size:12];
    }return _Label;
}
-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [AppTools createLabelText:@"" Color:TEXT_COLOR_LIGHT Font:0 TextAlignment:NSTextAlignmentRight];
//        _rightLabel.backgroundColor = [UIColor yellowColor];
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            _rightLabel.font = [UIFont fontWithName:@"Arial" size:14*SCREEN_WIDTH/375];
        }else{
            _rightLabel.font = [UIFont fontWithName:@"Arial" size:14];
        }
    }return _rightLabel;
}

#pragma ma rk --布局子视图
-(void)layoutSubviews
{
    WS(weakSelf);
    [_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(100);
        
    }];
    if (_isShow == NO) {
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
   [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(-25);
       make.centerY.equalTo(weakSelf.contentView);
       make.width.mas_equalTo(150);
   }];

    [super layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
