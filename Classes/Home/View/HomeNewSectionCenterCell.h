//
//  HomeNewSectionCenterCell.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/14.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewCenterModel.h"

@interface HomeNewSectionCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel            * CenterName;
@property (weak, nonatomic) IBOutlet UIImageView        * CenterImageview;
@property (weak, nonatomic) IBOutlet UILabel            * CentertitleLabel;
@property (weak, nonatomic) IBOutlet UILabel            * CenterContentLabel;

@property (nonatomic,strong)         HomeNewCenterModel * homeNewCenterModel;

- (void)AssignmentCell:(HomeNewCenterModel*)model;
@end
