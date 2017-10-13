//
//  EnshrineView.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/19.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "EnshrineView.h"
@interface EnshrineView ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    UITableView    * _tableView;
}
@end
@implementation EnshrineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor    = [UIColor blueColor];
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
