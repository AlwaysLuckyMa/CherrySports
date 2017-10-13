//
//  HomeNewSectionCenterCell.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/14.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "HomeNewSectionCenterCell.h"

@implementation HomeNewSectionCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)AssignmentCell:(HomeNewCenterModel*)model
{
    self.CenterName.text = model.tGameTypeName;
    [self.CenterImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URLL,model.tImgPath]]
                             placeholderImage:[UIImage imageNamed:@"201"]];
    self.CentertitleLabel.text = model.tGameName;
    self.CenterContentLabel.text =model.tIntroduction;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
