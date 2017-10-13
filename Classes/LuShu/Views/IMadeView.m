//
//  IMadeView.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/19.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "IMadeView.h"
@interface IMadeView ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    UITableView    * _tableView;
}
@end
@implementation IMadeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor    = [UIColor whiteColor];

//        [self createTableView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
