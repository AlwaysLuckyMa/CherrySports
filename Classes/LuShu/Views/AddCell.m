//
//  AddCell.m
//  气泡Demo
//
//  Created by 嘟嘟 on 2017/8/22.
//  Copyright © 2017年 MC. All rights reserved.
//

#import "AddCell.h"

@implementation AddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)addCellBtn:(UIButton *)sender
{
    self.addCellblock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // self.addCellblock();
}

@end
