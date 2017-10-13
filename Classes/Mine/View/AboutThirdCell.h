//
//  AboutThirdCell.h
//  CherrySports
//
//  Created by 吴庭宇 on 2016/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutThirdCell : UITableViewCell
@property(nonatomic,strong)UILabel *cellLabel;
@property(nonatomic,strong)UILabel *rightLabel;
//判断底部分割线是否显示
@property (nonatomic,assign)BOOL isshowBottom;
@end
