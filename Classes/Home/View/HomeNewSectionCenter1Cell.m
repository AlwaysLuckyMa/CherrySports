//
//  HomeNewSectionCenter1Cell.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/14.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "HomeNewSectionCenter1Cell.h"

@implementation HomeNewSectionCenter1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)AssignmentCell:(HomeNewCenterModel*)model
{
    self.topCellNameLabel.text = model.tGameTypeName;
    [self.topCellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URLL,model.tImgPath]]
                             placeholderImage:[UIImage imageNamed:@"201"]];
    self.topCellTitleLabel.text = model.tGameName;
    self.topCellContentLabel.text =model.tIntroduction;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.TopCellBgView.layer.bounds
                                                    byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                          cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.TopCellBgView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.TopCellBgView.layer.mask = maskLayer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
