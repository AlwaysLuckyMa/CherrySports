//
//  HomeNewSectionCenter2Cell.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/15.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewCenterModel.h"

@interface HomeNewSectionCenter2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView                * HomeNewCenter2BgView;
@property (weak, nonatomic) IBOutlet UILabel               * HomeNewCenter2Name;
@property (weak, nonatomic) IBOutlet UIImageView           * HomeNewCenter2Imageview;
@property (weak, nonatomic) IBOutlet UILabel               * HomeNewCenter2titleLabel;
@property (weak, nonatomic) IBOutlet UILabel               * HomeNewCenter2contentLabel;

@property (nonatomic,strong)         HomeNewCenterModel    * homeNewCenterModel;

- (void)AssignmentCell:(HomeNewCenterModel*)model;

@end
