//
//  AddCell.h
//  气泡Demo
//
//  Created by 嘟嘟 on 2017/8/22.
//  Copyright © 2017年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCell : UITableViewCell

@property (nonatomic,copy)void(^addCellblock)();

@end
