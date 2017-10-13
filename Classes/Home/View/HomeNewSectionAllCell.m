//
//  HomeNewSectionAllCell.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/15.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "HomeNewSectionAllCell.h"

@implementation HomeNewSectionAllCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)AssignmentCell:(HomeNewCenterModel*)model
{
    self.AllName.text         = model.tGameTypeName;
    self.AllTitleLabel.text   = model.tGameName;
    self.AllContentLabel.text = model.tIntroduction;
    
    [self.AllImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URLL,model.tImgPath]]
                         placeholderImage:[UIImage imageNamed:@"201"]];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self.AllBgView.layer setMasksToBounds:YES];
    [self.AllBgView.layer setCornerRadius:14];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
