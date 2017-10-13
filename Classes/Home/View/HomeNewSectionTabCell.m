//
//  HomeNewSectionTabCell.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/14.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "HomeNewSectionTabCell.h"

#import "OYCountDownManager.h"

@implementation HomeNewSectionTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(countDownNotification)
                                                 name:kCountDownNotification
                                               object:nil];
}

- (void)AssignmentCell:(HomeNewCenterModel*)model
{
    self.HomeNewSectionLabel.text = [NSString stringWithFormat:@"比赛时间:%@", model.tGameBegin];
    [self.HomeNewSectionImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URLL,model.tImgPath]]
                             placeholderImage:[UIImage imageNamed:@"201"]];
}

#pragma mark - 倒计时通知回调
- (void)countDownNotification { //传过来的时间戳是毫秒
    
    // 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {return;}
    
    NSInteger countDown = [self.model.countDownMilli integerValue] / 1000 - kCountDownManager.timeInterval;
    
    if (countDown < 0)
    {
        self.HomeNewSectionButtonLabel.text = @"赛事已结束";
        return;
    }
    _day         = (int)countDown/3600/24;
    _hour        = (int)((countDown % ( 60 * 60 * 24)) / ( 60 * 60));
    _minute      = (int)((countDown/60)%60);

    if (_day == 0 && _hour==0 && _minute==0)
    {
        self.HomeNewSectionButtonLabel.text = @"赛事已结束";
    }
    else
    {
        self.HomeNewSectionButtonLabel.text = [NSString stringWithFormat:@"倒计时:%02zd天%02zd时%02zd分", _day, _hour, _minute];
    }
    
    //  当倒计时到了进行回调
//    if (countDown == 0) {
//        self.HomeNewSectionButtonLabel.text = @"赛事已结束";
//        if (self.countDownZero) {
//            self.countDownZero();
//        }
//    }

}

- (void)setModel:(HomeNewCenterModel *)model
{
    _model = model;
    
    // 手动调用通知的回调
    [self countDownNotification];
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.HomeNewSectionImage.layer.bounds
                                                    byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                          cornerRadii:CGSizeMake(12.0f, 12.0f)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.HomeNewSectionImage.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.HomeNewSectionImage.layer.mask = maskLayer;
    
    //
    UIBezierPath * maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.HomeNewSectionView.layer.bounds
                                                     byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight
                                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer * maskLayer1 = [CAShapeLayer new];
    maskLayer1.frame = self.HomeNewSectionView.layer.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.HomeNewSectionView.layer.mask = maskLayer1;
    
    self.HomeNewSectionButton.layer.borderWidth = 2;
    self.HomeNewSectionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.HomeNewSectionButton.layer setMasksToBounds:YES];
    [self.HomeNewSectionButton.layer setCornerRadius:16];
    self.HomeNewSectionButton.userInteractionEnabled = NO;
    
    [self.HomenewsSectionButtonLabelView.layer setMasksToBounds:YES];
    [self.HomenewsSectionButtonLabelView.layer setCornerRadius:16];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
