//
//  MineAboutAsViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/10.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineAboutAsViewController.h"
#import "AboutHeaderCell.h"
#import "AboutSecondCell.h"
#import "AboutThirdCell.h"
@interface MineAboutAsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mytableView;
@end

@implementation MineAboutAsViewController

-(void)dealloc
{
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationController];
    [self addViews];
}

- (void)addViews
{
    [self.view addSubview:self.mytableView];
}

#pragma mark --tableview懒加载
-(UITableView *)mytableView
{
    if (!_mytableView) {
        _mytableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //隐藏cell默认线
        _mytableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _mytableView.delegate =self;
        _mytableView.dataSource =self;
    }
    //注册cell
    [_mytableView registerClass:[AboutHeaderCell class] forCellReuseIdentifier:@"headerCell"];
    [_mytableView registerClass:[AboutSecondCell class] forCellReuseIdentifier:@"secondCell"];
    [_mytableView registerClass:[AboutThirdCell class] forCellReuseIdentifier:@"thirdCell"];
    
    return _mytableView;
}

#pragma mark --UitableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 1;
    }else
    {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *iden = @"headerCell";
        AboutHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *iden = @"secondCell";
        AboutSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        cell.rightLabel.text = _synopsis;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellLabel.text = @"简介";
        return cell;
    }else{
        static NSString *iden = @"thirdCell";
        AboutThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
//        NSArray *array = [NSArray arrayWithObjects:@"官网",@"新浪微博",@"微信公众号", nil];
//        NSArray *array2 = [NSArray arrayWithObjects:_officialWebsite, _microBlogSina, _wechatPublicNumber, nil];
        NSArray *array = [NSArray arrayWithObjects:@"官网", nil];
        NSArray *array2 = [NSArray arrayWithObjects:_officialWebsite, nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellLabel.text = array[indexPath.row];
        cell.rightLabel.text = array2[indexPath.row];
//        if (indexPath.row == 2) {
//            //显示最后一个cell底部分割线
//            cell.isshowBottom = YES;
//        }
                if (indexPath.row == 0) {
                    //显示最后一个cell底部分割线
                    cell.isshowBottom = YES;
                }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 212;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 松手取消选中色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)setNavigationController
{
    // 导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:[UIColor colorWithRed:189/255.0 green:7/255.0 blue:29/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    STATUS_WIHTE
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"关于我们" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
