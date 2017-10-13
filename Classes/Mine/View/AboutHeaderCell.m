//
//  AboutHeaderCell.m
//  CherrySports
//
//  Created by 吴庭宇 on 2016/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "AboutHeaderCell.h"

@interface AboutHeaderCell ()
@property (nonatomic,strong)UIImageView *logoImage;
@property (nonatomic,strong)UILabel *cherryLabel;


@end
@implementation AboutHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }return self;
}
-(void)makeUI
{
    [self.contentView addSubview:self.versionLabel];
    [self.contentView addSubview:self.logoImage];
    [self.contentView addSubview:self.cherryLabel];
    }
#pragma mark --懒加载

-(UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel =[UILabel new];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _versionLabel.text = [NSString stringWithFormat:@"V %@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
        _versionLabel.font = [UIFont systemFontOfSize:13];
        _versionLabel.textColor = TEXT_COLOR_LIGHT;
    }return _versionLabel;
}
-(UIImageView *)logoImage{
    if (!_logoImage) {
        _logoImage = [UIImageView new];
        _logoImage.image = [UIImage imageNamed:@"cherry_logo"];
        //图片自适应
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
    }return _logoImage;
}
-(UILabel *)cherryLabel{
    if (!_cherryLabel) {
        _cherryLabel =[UILabel new];
        _cherryLabel.text = @"樱桃体育";
        _cherryLabel.font = [UIFont systemFontOfSize:16];
        _cherryLabel.textColor = TEXT_COLOR_DARK;
    }return _cherryLabel;
}
#pragma mark --布局
-(void)layoutSubviews
{
    WS(weakSelf)
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(46);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [_cherryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logoImage.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cherryLabel.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
   [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
