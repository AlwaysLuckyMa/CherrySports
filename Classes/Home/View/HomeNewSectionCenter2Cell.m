//
//  HomeNewSectionCenter2Cell.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/15.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "HomeNewSectionCenter2Cell.h"

@implementation HomeNewSectionCenter2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)AssignmentCell:(HomeNewCenterModel*)model
{
    self.HomeNewCenter2Name.text          = model.tGameTypeName;
    self.HomeNewCenter2titleLabel.text    = model.tGameName;
    self.HomeNewCenter2contentLabel.text  = model.tIntroduction;
    
    [self.HomeNewCenter2Imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URLL,model.tImgPath]]
                                    placeholderImage:[UIImage imageNamed:@"201"]];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.HomeNewCenter2BgView.layer.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.HomeNewCenter2BgView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.HomeNewCenter2BgView.layer.mask = maskLayer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
