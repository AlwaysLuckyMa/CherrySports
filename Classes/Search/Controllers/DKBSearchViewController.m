//
//  DKBSearchViewController.m
//  CherrySports
//
//  Created by dkb on 16/11/28.
//  Copyright © 2016年 dkb. All rights reserved.
//
/** 搜索页*/
#import "DKBSearchViewController.h"
#import "SearchCollectionViewCell.h"
#import "SearchEventViewController.h"
#import "SearchNewsViewController.h"
#import "CustomTextField.h"

@interface DKBSearchViewController ()<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>{
    NSInteger cellRow;
}
/**textField**/
@property (nonatomic,strong)UIImageView *textImage;
@property (nonatomic,strong)CustomTextField *textField;
/** collectView*/
@property (nonatomic, strong) UICollectionView *myCollectV;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *searchArray;

/** <#注释#>*/
@property (nonatomic, copy) NSString *searchText;

@end

@implementation DKBSearchViewController

- (void)dealloc
{
    _myCollectV.delegate = nil;
    _myCollectV.dataSource = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationController];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;    // 手势的代理设置为self
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
//{
//    NSLog(@"111111");
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    cellRow = 0;
    [self addSubViews];
}

- (void)addSubViews
{
//    [self.view addSubview:self.textImage];
    [self.view addSubview:self.myCollectV];
}

- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        self.searchArray = [NSMutableArray arrayWithObjects:@"赛事查询", @"资讯查询", nil];
    }
    return _searchArray;
}


- (UIImageView *)textImage
{
    if (!_textImage) {
        _textImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_input_final"]];
        // 自适应图片大小
        _textImage.contentMode = UIViewContentModeScaleAspectFit;
        
        //textfield
        self.textField = [[CustomTextField alloc]initWithFrame:CGRectMake(_textImage.frame.origin.x + 5, _textImage.frame.origin.y, _textImage.frame.size.width-5, _textImage.frame.size.height)];
//        self.textField.adjustsFontSizeToFitWidth = YES;
//        self.textField.backgroundColor = [UIColor yellowColor];
        self.textField.placeholder = @"请输入关键字查询......";
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.textColor = UIColorFromRGB(0xa2a1a1);
//        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textField.autocorrectionType = UITextAutocorrectionTypeYes;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //设置代理
        self.textField.delegate = self;
        //弹出键盘
        self.textField.returnKeyType = UIReturnKeySearch;
        [_textImage addSubview:self.textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-5);
        }];
        
        [self.textField addTarget:self action:@selector(textFieldchange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textImage;
}

- (UICollectionView *)myCollectV
{
    if (!_myCollectV)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 滚动方向(纵向)
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        
        _myCollectV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _myCollectV.delegate = self;
        _myCollectV.dataSource = self;
        [_myCollectV registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
        _myCollectV.backgroundColor = [UIColor whiteColor];
    }
    return _myCollectV;
}

#pragma mark - 每个item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 30);
}
#pragma mark - 上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    if (IS_IPHONE_6) {
//        return UIEdgeInsetsMake(10, (SCREEN_WIDTH - 240 - 72)/2, 0, (SCREEN_WIDTH - 240 - 72)/2);
//    }else if (IS_IPHONE_6Plus){
//        return UIEdgeInsetsMake(10, (SCREEN_WIDTH - 240 - 72)/2, 0, (SCREEN_WIDTH - 240 - 72)/2);
//    }
    return UIEdgeInsetsMake(10, 20, 0, 20);
}

#pragma mark - 区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark - cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.searchArray.count;
}
#pragma mark - 布局Item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"item";
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    NSInteger cityWidth = [AppTools labelRectWithLabelSize:CGSizeMake(1000, 14) LabelText:self.searchArray[indexPath.row] Font:[UIFont systemFontOfSize:11]].width;
    
    if (indexPath.row == cellRow) {
        [cell labelVal:[_searchArray objectAtIndex:indexPath.row] cityNameWidth:cityWidth isSelect:@"1"];
    } else {
        [cell labelVal:[_searchArray objectAtIndex:indexPath.row] cityNameWidth:cityWidth isSelect:@"0"];
    }
    
    return cell;
}

#pragma mark - Collection点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = (SearchCollectionViewCell *)[_myCollectV cellForItemAtIndexPath:indexPath];
    cellRow = indexPath.row;
    [collectionView reloadData];
    
    NSlog(@"section = %zd, row = %zd", indexPath.section, indexPath.item);
}

- (void)viewWillLayoutSubviews
{
    [_myCollectV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-SCREEN_WIDTH/6.25);
        make.left.mas_equalTo(SCREEN_WIDTH/6.25);
        make.bottom.mas_equalTo(0);
    }];
    
    [super viewWillLayoutSubviews];
}







#pragma mark --设置导航栏
-(void)setNavigationController
{
    STATUS_WIHTE
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.titleView = self.textImage;
    self.navigationItem.titleView.userInteractionEnabled = YES;
    
    self.navigationItem.leftBarButtonItem =[UIBarButtonItem itemWithImage:@"news_navigation_left" highImage:@"news_navigation_left" target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem SearchRightWithTitle:@"取消" target:self action:@selector(backClick)];
}


- (void)textFieldchange:(UITextField *)textfield
{
    NSLog(@"text = %@", textfield.text);
    _searchText = textfield.text;
}

//搜索
#pragma mark --导航栏左右按钮点击事件
-(void)searchClick{
    NSlog(@"点击了搜索");
    [_textField resignFirstResponder]; // 关键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_searchText.length == 0) {
            [self showHint:@"请先输入搜索内容"];
        }else{
            if (cellRow == 0) {
                SearchEventViewController *sEventVC = [SearchEventViewController new];
                sEventVC.searchStr = _searchText;
                [self.navigationController pushViewController:sEventVC animated:YES];
            }else{
                SearchNewsViewController *sNewsVC = [SearchNewsViewController new];
                sNewsVC.searchStr = _searchText;
                [self.navigationController pushViewController:sNewsVC animated:YES];
            }
        }
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
     [aTextfield resignFirstResponder];//关闭键盘
    [self searchClick];
    return YES;
}

//取消返回
- (void)backClick{
    [_textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
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
