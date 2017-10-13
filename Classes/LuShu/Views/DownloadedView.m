//
//  DownloadedView.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/19.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "DownloadedView.h"

#import "DownloadCell.h"

@interface DownloadedView ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    UITableView    * _tableView;
}
@end

@implementation DownloadedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor    = [UIColor yellowColor];

        [self createTableView];
    }
    return self;
}

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 44 - 64 - 44) ];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:nil] forCellReuseIdentifier:@"DownloadCellID"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_HEIGHT - 44) / 3;
}

#pragma mark - Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DownloadCellID";
    
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    return cell;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
