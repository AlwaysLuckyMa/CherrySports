//
//  HomeNewSectionAllCell.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/8/15.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewCenterModel.h"

@interface HomeNewSectionAllCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView             * AllBgView;
@property (weak, nonatomic) IBOutlet UILabel            * AllName;
@property (weak, nonatomic) IBOutlet UIImageView        * AllImageView;
@property (weak, nonatomic) IBOutlet UILabel            * AllTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel            * AllContentLabel;

@property (nonatomic,strong)         HomeNewCenterModel * homeNewCenterModel;

- (void)AssignmentCell:(HomeNewCenterModel*)model;
@end
