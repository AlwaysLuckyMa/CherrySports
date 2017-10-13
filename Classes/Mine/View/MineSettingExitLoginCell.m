//
//  MineSettingExitLoginCell.m
//  CherrySports
//
//  Created by dkb on 16/11/23.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineSettingExitLoginCell.h"

@implementation MineSettingExitLoginCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    UIView *line = [AppTools createViewBackground:LINE_COLOR];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *botLine = [AppTools createViewBackground:LINE_COLOR];
    [self.contentView addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *exitLabel = [AppTools createLabelText:@"退出登录" Color:TEXT_COLOR_RED Font:16 TextAlignment:NSTextAlignmentCenter];
    exitLabel.attributedText = [AppTools labelNumber:0.5 String:@"退出登录"];
    [self.contentView addSubview:exitLabel];
    [exitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
}


@end
