//
//  presentLushuSelect.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/10/12.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "presentLushuSelect.h"
#import "presentLuShuCell.h"
@interface presentLushuSelect ()
<
    UITableViewDelegate
   ,UITableViewDataSource
>
{
    UITableView * _tableView;
    UIView      * _view;
}
@end

@implementation presentLushuSelect

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor    = [UIColor whiteColor];
        [self createUI];
        [self createTableView];
    }
    return self;
}

- (void)createTableView
{                                                                                                                                                                                      //加style有段头
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view.frame), SCREEN_WIDTH,SCREEN_HEIGHT - 64) ];
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"presentLuShuCell" bundle:nil] forCellReuseIdentifier:@"presentLuShuCellID"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_HEIGHT - 64) / 4;
}

#pragma mark - Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"presentLuShuCellID";
    
    presentLuShuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    cell.textLabel.text = @"哈哈";
    return cell;
    
}

- (void)createUI
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    view.backgroundColor = [UIColor colorWithPatternImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR]];
    _view = view;
    [self addSubview:view];
    
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(17, 22, 50, 44)];
//    leftBtn.backgroundColor = [UIColor blackColor];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 17 - 50, 22, 50, 44)];
//    rightBtn.backgroundColor = [UIColor blackColor];
    [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    //导航title
    UIView * titleView   = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, 22, 100, 64)];
        UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLable.text = @"路书导航";
        titleLable.textColor = [UIColor whiteColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont boldSystemFontOfSize:18];
//        titleLable.font = [UIFont systemFontOfSize:16];
        [titleView addSubview:titleLable];
    [view addSubview:titleView];
}

- (void)leftBtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    
}

- (void)rightBtnClick
{
    NSlog(@"确认");
}









@end
