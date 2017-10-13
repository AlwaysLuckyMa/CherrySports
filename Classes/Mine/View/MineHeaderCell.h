//
//  HeaderCell.h
//  CherrySports
//
//  Created by 吴庭宇 on 2016/10/28.
//  Copyright © 2016年 dkb. All rights reserved.
//
#pragma mark - Mine 头部Cell 目前不用这个版本

#import <UIKit/UIKit.h>

@interface HeaderCell : UITableViewCell
/**头像*/
@property (nonatomic,strong)UIImageView *headView;
//主标题
@property (nonatomic,strong)UILabel *titleLabel;
//子标题
@property (nonatomic,strong)UILabel *subtitleLabel;
//title数组
@property (nonatomic,strong)NSArray *titleArr;
//数字数组
@property (nonatomic,strong)NSArray *numberStr;

@end
