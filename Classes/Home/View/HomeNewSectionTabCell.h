//
//  HomeNewSectionTabCell.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/14.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewCenterModel.h"

@class HomeNewCenterModel;

@interface HomeNewSectionTabCell : UITableViewCell

@property (weak,   nonatomic) IBOutlet UIImageView * HomeNewSectionImage;
@property (weak,   nonatomic) IBOutlet UIView      * HomeNewSectionView;
@property (weak,   nonatomic) IBOutlet UIButton    * HomeNewSectionButton;
@property (weak,   nonatomic) IBOutlet UILabel     * HomeNewSectionLabel;
@property (weak,   nonatomic) IBOutlet UILabel     * HomeNewSectionButtonLabel;
@property (weak,   nonatomic) IBOutlet UIView      * HomenewsSectionButtonLabelView;

@property (assign, nonatomic)int                     day;
@property (assign, nonatomic)int                     hour;
@property (assign, nonatomic)int                     minute;
@property (assign, nonatomic)int                     second;
@property (assign, nonatomic)int                     millisecond;

- (void)AssignmentCell:(HomeNewCenterModel*)model;

@property (strong, nonatomic) HomeNewCenterModel * model;

// 倒计时到0时回调
//@property (nonatomic, copy) void(^countDownZero)();




@end
