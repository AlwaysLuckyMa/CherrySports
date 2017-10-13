//
//  EventsSearchView.m
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "EventsSearchView.h"
#import "EventsAreaCollectCell.h"
#import "EventsSelectModel.h"
@interface EventsSearchView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>{
    NSString *cellRow;
    NSMutableArray *array;
}
/** 注释*/
@property (nonatomic, strong) UICollectionView *myCollectV;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *bottomView;

/** 重置*/
@property (nonatomic, strong) UIButton *resetBtn;
/** 查询*/
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, copy) NSString *selectStr;

@property (nonatomic, assign) BOOL isSelect;

@end
@implementation EventsSearchView

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColorFromRGB(0xF4F5F9);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0f];
        self.dataSource = [NSMutableArray array];
        
        array = [[NSMutableArray alloc] init];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"] == nil) {
            cellRow = @"";
            for (int i = 0; i < _dataSource.count; i++) {
                EventsSelectModel *model = _dataSource[i];
                model.isSelect = NO;
            }
        }else{
            cellRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"];
            for (int i = 0; i < _dataSource.count; i++) {
                EventsSelectModel *model = _dataSource[i];
                if ([cellRow rangeOfString:model.tId].location != NSNotFound) {
                    model.isSelect = YES;
                    [array addObject:model.tId];
                }else{
                    model.isSelect = NO;
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isReduction) name:@"isReduction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchReload) name:@"searchReload" object:nil];
        [self  addSubViews];
    }
    return self;
}

// 接受通知刷新
- (void)searchReload
{
    [self isReduction];
}


- (void)isReduction
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"] == nil) {
        cellRow = @"";
        for (int i = 0; i < _dataSource.count; i++) {
            EventsSelectModel *model = _dataSource[i];
            model.isSelect = NO;
        }
    }
    
    array = [[NSMutableArray alloc] init];
    
    if (cellRow.length > 0) {
        for (int i = 0; i < _dataSource.count; i++) {
            EventsSelectModel *model = _dataSource[i];
            if ([cellRow rangeOfString:model.tId].location != NSNotFound) {
                model.isSelect = YES;
                [array addObject:model.tId];
            }else{
                model.isSelect = NO;
            }
        }
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"] == nil) {
        _isSelect = NO;
        for (int i = 0; i < _dataSource.count; i++) {
            EventsSelectModel *model = _dataSource[i];
            model.isSelect = NO;
        }
    }

    
    [_myCollectV reloadData];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"];
    NSDictionary *dic;
    if (str.length > 0) {
        dic = @{@"searchRow":str};
    }else{
        dic = @{@"searchRow":@""};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchColor" object:dic];
    
    [self.searchDelegate SearchCollectBackStatus:@"0"];
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"] == nil) {
        cellRow = @"";
        
        for (int i = 0; i < _dataSource.count; i++) {
            EventsSelectModel *model = _dataSource[i];
            model.isSelect = NO;
        }
    }else{
        cellRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"];
        for (int i = 0; i < _dataSource.count; i++) {
            EventsSelectModel *model = _dataSource[i];
            if ([cellRow rangeOfString:model.tId].location != NSNotFound) {
                model.isSelect = YES;
                [array addObject:model.tId];
            }else{
                model.isSelect = NO;
            }
        }
    }
}

- (void)addSubViews
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.myCollectV];
    [self.backView addSubview:self.resetBtn];
    [self.backView addSubview:self.searchBtn];
    
    [self addSubview:self.bottomView];
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [AppTools createViewBackground:UIColorFromRGB(0xF4F5F9)];
        _backView.userInteractionEnabled = YES;
    }
    return _backView;
}

- (UIButton *)resetBtn
{
    if (!_resetBtn) {
        _resetBtn = [AppTools createButtonTitle:@"重 置" TitleColor:[UIColor whiteColor] Font:14 Background:UIColorFromRGB(0x3a3839)];
        _resetBtn.layer.masksToBounds = YES;
        _resetBtn.layer.cornerRadius = 5;
        [_resetBtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [AppTools createButtonTitle:@"查 询" TitleColor:[UIColor whiteColor] Font:14 Background:TEXT_COLOR_RED];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.cornerRadius = 5;
        [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [AppTools createViewBackground:[[UIColor blackColor]colorWithAlphaComponent:0.0f]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_bottomView addGestureRecognizer:tap];
    }
    return _bottomView;
}

- (UICollectionView *)myCollectV
{
    if (!_myCollectV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 滚动方向(纵向)
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 16;
//        if (IS_IPHONE_6) {
//            layout.minimumInteritemSpacing = 20;
//        }else if (IS_IPHONE_6Plus){
//            layout.minimumInteritemSpacing = 26;
//        }else{
//            layout.minimumInteritemSpacing = 20;
//        }
        
        _myCollectV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _myCollectV.delegate = self;
        _myCollectV.dataSource = self;
        [_myCollectV registerClass:[EventsAreaCollectCell class] forCellWithReuseIdentifier:@"item"];
        _myCollectV.backgroundColor = UIColorFromRGB(0xF4F5F9);
//        _myCollectV.backgroundColor = [UIColor yellowColor];
    }
    return _myCollectV;
}

#pragma mark - 每个item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(62, 24);
}

#pragma mark - 上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark - cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
#pragma mark - 布局Item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"item";
    EventsAreaCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    EventsSelectModel *model = [self.dataSource objectAtIndex:indexPath.item];
    cell.selectModel = model;
    
//    NSlog(@"userdefaults = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"] == nil && _isSelect == NO) {
        [cell labelValSelect:@"0"];
        
    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"] != nil && _isSelect == NO)
    {
        if (model.isSelect == YES  && [cellRow rangeOfString:model.tId].location != NSNotFound) {
            [cell labelValSelect:@"1"];
            NSlog(@"这个字符串中有 = %@", model.tId);
        }else{
            [cell labelValSelect:@"0"];
        }
    }else{
        if (model.isSelect == YES) {
            [cell labelValSelect:@"1"];
            NSlog(@"这个字符串中有 = %@", model.tId);
        }else{
            [cell labelValSelect:@"0"];
        }
    }
    
    return cell;
}

#pragma mark - Collection点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %zd, row = %zd", indexPath.section, indexPath.item);
    _isSelect = YES;
    if (cellRow.length == 0) {
        cellRow = @"";
    }
    EventsSelectModel *model = [_dataSource objectAtIndex:indexPath.row];
    
    if (model.isSelect == NO) {
        [array addObject:model.tId];
    }else{
        [array removeObject:model.tId];
    }
    
    model.isSelect = !model.isSelect;
    
    NSlog(@"array = %@", array);
    [collectionView reloadData];
}

// 重置按钮点击方法
- (void)resetAction:(UIButton *)sender
{
    array = [NSMutableArray array];
    _selectStr = @"";
    cellRow = @"";
    _isSelect = NO;
    
    for (int i = 0; i < _dataSource.count; i++) {
        EventsSelectModel *model = _dataSource[i];
        model.isSelect = NO;
    }
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isSearchRow"];
    [_myCollectV reloadData];
    NSDictionary *dic = @{@"searchRow":cellRow};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchColor" object:dic];
    
    //    // 重置代理
    [self.searchDelegate SearchCollectBackStatus:@"1"];
}
// 查询方法
- (void)searchAction:(UIButton *)sender
{
    _selectStr = @"";
    for (int i = 0; i < array.count; i++) {
        NSString * str = array[i];
        if (_selectStr.length == 0) {
            _selectStr = str;
        }else{
            _selectStr = [_selectStr stringByAppendingString:[NSString stringWithFormat:@",%@", str]];
        }
    }
    
    NSlog(@"str = %@", _selectStr);
    if (_selectStr.length > 0) {
        cellRow = _selectStr;
        [[NSUserDefaults standardUserDefaults] setValue:cellRow forKey:@"isSearchRow"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isSearchRow"];
        cellRow = @"";
    }
    _isSelect = NO;
    if (cellRow.length > 0) {
        [self.searchDelegate SearchdidSelectTId:_selectStr];
    }else{
        [self.searchDelegate SearchdidSelectTId:@""];
    }
    NSDictionary *dic = @{@"searchRow":cellRow};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchColor" object:dic];
    
    [_myCollectV reloadData];
}
// 轻拍方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    array = [[NSMutableArray alloc] init];
    
    if (cellRow.length > 0) {
        for (int i = 0; i < _dataSource.count; i++) {
            EventsSelectModel *model = _dataSource[i];
            if ([cellRow rangeOfString:model.tId].location != NSNotFound) {
                model.isSelect = YES;
                [array addObject:model.tId];
            }else{
                model.isSelect = NO;
            }
        }
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"] == nil) {
        _isSelect = NO;
        for (int i = 0; i < _dataSource.count; i++) {
            EventsSelectModel *model = _dataSource[i];
            model.isSelect = NO;
        }
    }
    
    [_myCollectV reloadData];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"];
    NSDictionary *dic;
    if (str.length > 0) {
        dic = @{@"searchRow":str};
    }else{
        dic = @{@"searchRow":@""};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchColor" object:dic];
    [self.searchDelegate SearchCollectBackStatus:@"0"];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(_searchHeight+46);
    }];
    
    if (IS_IPHONE_6Plus) {
        [_myCollectV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-40);
            make.left.mas_equalTo(40);
            make.height.mas_equalTo(_searchHeight-14);
        }];
    }else{
        [_myCollectV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-30);
            make.left.mas_equalTo(30);
            make.height.mas_equalTo(_searchHeight-14);
        }];
    }
    
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo((SCREEN_WIDTH-200)/3);
        if (IS_IPHONE_6Plus) {
            make.left.mas_equalTo(40);
        }else{
            make.left.mas_equalTo(30);
        }
        make.bottom.mas_equalTo(-13);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-(SCREEN_WIDTH-200)/3);
        if (IS_IPHONE_6Plus) {
            make.right.mas_equalTo(-40);
        }else{
            make.right.mas_equalTo(-30);
        }
        make.bottom.mas_equalTo(-13);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    
    [super layoutSubviews];
}

@end
