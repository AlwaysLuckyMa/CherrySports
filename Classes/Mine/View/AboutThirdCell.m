//
//  AboutThirdCell.m
//  CherrySports
//
//  Created by 吴庭宇 on 2016/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "AboutThirdCell.h"

@interface AboutThirdCell ()
//cell顶部分割线
@property (nonatomic,strong)UIView *topView;
//底部分割线
@property (nonatomic,strong)UIView *bottomView;

@end
@implementation AboutThirdCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }return self;
}
-(void)makeUI
{
    [self.contentView addSubview:self.cellLabel];
    [self.contentView addSubview:self.self.rightLabel];
    //cell顶部分割线
    [self.contentView addSubview:self.topView];
    [self addSubview:self.bottomView];
    
}
#pragma mark--懒加载
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView =[UIView new];
        _bottomView.backgroundColor = LINE_COLOR;
        
    }return _bottomView;
}
-(UIView *)topView
{
    if (!_topView) {
        _topView =[UIView new];
        _topView.backgroundColor = LINE_COLOR;
    }return _topView;
}
-(UILabel *)cellLabel{
    if (!_cellLabel) {
        _cellLabel = [AppTools createLabelText:@"" Color:TEXT_COLOR_DARK Font:16 TextAlignment:NSTextAlignmentLeft];
    }return _cellLabel;
}
-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [AppTools createLabelText:@"" Color:TEXT_COLOR_LIGHT Font:14 TextAlignment:NSTextAlignmentRight];
    }return _rightLabel;
}

#pragma mark --布局
-(void)layoutSubviews
{
    if (_isshowBottom==YES) {
        //bottomView
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-0.5);
            make.left.and.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    WS(weakSelf)
    [_cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    //topview
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(0.5);
    }];
   
   [super layoutSubviews];
}




@end
