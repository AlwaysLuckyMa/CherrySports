//
//  HomeNewSectionCenter1Cell.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/14.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewCenterModel.h"

@interface HomeNewSectionCenter1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView               * TopCellBgView;
@property (weak, nonatomic) IBOutlet UILabel              * topCellNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView          * topCellImageView;
@property (weak, nonatomic) IBOutlet UILabel              * topCellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel              * topCellContentLabel;

@property (strong,nonatomic)         HomeNewCenterModel   * homeNewCenterModel;

- (void)AssignmentCell:(HomeNewCenterModel*)model;

@end
