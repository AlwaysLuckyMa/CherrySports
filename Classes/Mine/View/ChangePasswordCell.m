//
//  ChangePasswordCell.m
//  CherrySports
//
//  Created by dkb on 16/11/18.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "ChangePasswordCell.h"

@implementation ChangePasswordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    if (!_passView) {
        _passView = [ChangePasswordView new];
        [self.contentView addSubview:_passView];
        [_passView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(42.5);
            make.height.mas_equalTo(178);
            make.left.right.mas_equalTo(0);
        }];
    }
}

@end
