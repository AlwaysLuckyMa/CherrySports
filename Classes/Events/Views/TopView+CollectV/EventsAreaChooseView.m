//
//  EventsAreaChooseView.m
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "EventsAreaChooseView.h"
#import "EventsAreaCollectCell.h"
#import "EventsCityModel.h"
#import "EventStateView.h"

@interface EventsAreaChooseView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSString *cellRow;
    NSString *Wrow;
    NSMutableArray *array;
    NSMutableArray *arrayWai;
}
/** 注释*/
@property (nonatomic, strong) UICollectionView *myCollectV;
/** colletView后面的View*/
@property (nonatomic, strong) UIView *backView;
/** 重置*/
@property (nonatomic, strong) UIButton *resetBtn;
/** 查询*/
@property (nonatomic, strong) UIButton *searchBtn;

/** <#注释#>*/
@property (nonatomic, strong) EventsCityModel *model;

/** backView下面的透明View*/
@property (nonatomic, strong) UIView *bottomView;

/** <#注释#>*/
@property (nonatomic, copy) NSString *selectStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *wSelect;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) BOOL isReset;

@end

@implementation EventsAreaChooseView

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
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.f];
        self.dataSource = [NSMutableArray array];
        self.WArray = [NSMutableArray array];
        array = [[NSMutableArray alloc] init];
        arrayWai = [[NSMutableArray alloc] init];
        // 国内
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"] == nil) {
            cellRow = @"";
            for (int i = 0; i < _dataSource.count; i++) {
                EventsCityModel *model = _dataSource[i];
                model.isSelect = NO;
            }
        }else{
            cellRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"];
            for (int i = 0; i < _dataSource.count; i++) {
                EventsCityModel *model = _dataSource[i];
                if ([cellRow rangeOfString:model.tId].location != NSNotFound) {
                    model.isSelect = YES;
                    [array addObject:model.tId];
                }else{
                    model.isSelect = NO;
                }
            }
        }
        // 国外
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"] == nil) {
            Wrow = @"";
            for (int i = 0; i < _WArray.count; i++) {
                EventsCityModel *Wmodel = _WArray[i];
                Wmodel.isSelect = NO;
            }
        }else{
            Wrow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"];
            for (int i = 0; i < _WArray.count; i++) {
                EventsCityModel *Wmodel = _WArray[i];
                if ([Wrow rangeOfString:Wmodel.tId].location != NSNotFound) {
                    Wmodel.isSelect = YES;
                    [arrayWai addObject:Wmodel.tId];
                }else{
                    Wmodel.isSelect = NO;
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isReduction) name:@"isReduction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaReload) name:@"areaReload" object:nil];
        [self  addSubViews];
    }
    return self;
}

// 接受通知刷新
- (void)areaReload
{
    [self isReduction];
}

// 通知
- (void)isReduction
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"] == nil) {
        cellRow = @"";
        for (int i = 0; i < _dataSource.count; i++) {
            EventsCityModel *model = _dataSource[i];
            model.isSelect = NO;
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"] == nil) {
        Wrow = @"";
        for (int i = 0; i < _WArray.count; i++) {
            EventsCityModel *Wmodel = _WArray[i];
            Wmodel.isSelect = NO;
        }
    }
    
    array = [[NSMutableArray alloc] init];
    arrayWai = [[NSMutableArray alloc] init];
    if (cellRow.length > 0) {
        for (int i = 0; i < _dataSource.count; i++) {
            EventsCityModel *model = _dataSource[i];
            if ([cellRow rangeOfString:model.tId].location != NSNotFound) {
                model.isSelect = YES;
                [array addObject:model.tId];
            }else{
                model.isSelect = NO;
            }
        }
    }
    
    if (Wrow.length > 0) {
        for (int i = 0; i < _WArray.count; i++) {
            EventsCityModel *Wmodel = _WArray[i];
            if ([Wrow rangeOfString:Wmodel.tId].location != NSNotFound) {
                Wmodel.isSelect = YES;
                [arrayWai addObject:Wmodel.tId];
            }else{
                Wmodel.isSelect = NO;
            }
        }
    }
    
    [_myCollectV reloadData];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"];
    NSString *strW = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"];
    NSDictionary *dic;
    if (str.length > 0 || strW.length > 0) {
        dic = @{@"areaRow":@"1"};
    }else{
        dic = @{@"areaRow":@""};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isAreaColor" object:dic];
    
    [self.areaDelegate AreaCollectBackStatus:@"0"];
}

// 国内数据
- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"] == nil) {
        cellRow = @"";
        for (int i = 0; i < _dataSource.count; i++) {
            EventsCityModel *model = _dataSource[i];
            model.isSelect = NO;
        }
    }else{
        cellRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"];
        for (int i = 0; i < _dataSource.count; i++) {
            EventsCityModel *model = _dataSource[i];
            if ([cellRow rangeOfString:model.tId].location != NSNotFound) {
                model.isSelect = YES;
                [array addObject:model.tId];
            }else{
                model.isSelect = NO;
            }
        }
    }
}

// 国外数据
- (void)setWArray:(NSMutableArray *)WArray
{
    _WArray = WArray;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"] == nil) {
        Wrow = @"";
        for (int i = 0; i < _WArray.count; i++) {
            EventsCityModel *Wmodel = _WArray[i];
            Wmodel.isSelect = NO;
        }
    }else{
        Wrow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"];
        for (int i = 0; i < _WArray.count; i++) {
            EventsCityModel *Wmodel = _WArray[i];
            if ([Wrow rangeOfString:Wmodel.tId].location != NSNotFound) {
                Wmodel.isSelect = YES;
                [arrayWai addObject:Wmodel.tId];
            }else{
                Wmodel.isSelect = NO;
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
        
        _myCollectV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _myCollectV.delegate = self;
        _myCollectV.dataSource = self;
        
        [_myCollectV registerClass:[EventStateView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EventHeader"];
        [_myCollectV registerClass:[EventsAreaCollectCell class] forCellWithReuseIdentifier:@"item"];
        [_myCollectV registerClass:[EventsAreaCollectCell class] forCellWithReuseIdentifier:@"wItem"];
        _myCollectV.backgroundColor = UIColorFromRGB(0xF4F5F9);
//        _myCollectV.backgroundColor = [UIColor yellowColor];
    }
    return _myCollectV;
}

#pragma mark - 区头设置
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        static NSString *identifier = @"EventHeader";
        EventStateView *stateView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        stateView.backgroundColor = UIColorFromRGB(0xF4F5F9);
        if (_dataSource.count > 0 && _WArray.count > 0) {
            if (indexPath.section == 0) {
                stateView.title.text = @"国内";
            }else{
                stateView.title.text = @"国外";
            }
        }else if (_dataSource.count > 0 && _WArray.count == 0){
            if (indexPath.section == 0) {
                stateView.title.text = @"国内";
            }
        }else if (_dataSource.count == 0 && _WArray.count > 0){
            stateView.title.text = @"国外";
        }
        
        return stateView;
    }
    return nil;
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
    if (_WArray.count > 0 && _dataSource.count > 0) {
        return 2;
    }else if (_WArray.count > 0 || _dataSource.count > 0)
    {
        return 1;
    }
    return 0;
}

#pragma mark - 区头宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 50);
}
#pragma mark - cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_dataSource.count > 0) {
            return self.dataSource.count;
        }
        return self.WArray.count;
    }else{
        return self.WArray.count;
    }
}
#pragma mark - 布局Item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_dataSource.count > 0) {
            static NSString *identifier = @"item";
            EventsAreaCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            
            EventsCityModel *model = [self.dataSource objectAtIndex:indexPath.item];
            cell.eventCityModel = model;
            
            //    NSlog(@"userdefaults = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"]);
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"] == nil && _isSelect == NO) {
                [cell labelValSelect:@"0"];
                
            }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"] != nil && _isSelect == NO)
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
        }else{
            // 国外cell
            static NSString *identifier = @"wItem";
            EventsAreaCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            
            EventsCityModel *Wmodel = [self.WArray objectAtIndex:indexPath.item];
            cell.eventCityModel = Wmodel;
            
            //    NSlog(@"userdefaults = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"]);
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"] == nil && _isSelect == NO) {
                [cell labelValSelect:@"0"];
                
            }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"] != nil && _isSelect == NO)
            {
                if (Wmodel.isSelect == YES  && [Wrow rangeOfString:Wmodel.tId].location != NSNotFound) {
                    [cell labelValSelect:@"1"];
                    NSlog(@"这个字符串中有 = %@", Wmodel.tId);
                }else{
                    [cell labelValSelect:@"0"];
                }
            }else{
                if (Wmodel.isSelect == YES) {
                    [cell labelValSelect:@"1"];
                    NSlog(@"这个字符串中有 = %@", Wmodel.tId);
                }else{
                    [cell labelValSelect:@"0"];
                }
            }
            return cell;
        }
    }
        // 国外cell
        static NSString *identifier = @"wItem";
        EventsAreaCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        EventsCityModel *Wmodel = [self.WArray objectAtIndex:indexPath.item];
        cell.eventCityModel = Wmodel;
        
        //    NSlog(@"userdefaults = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"]);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"] == nil && _isSelect == NO) {
            [cell labelValSelect:@"0"];
            
        }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"] != nil && _isSelect == NO)
        {
            if (Wmodel.isSelect == YES  && [Wrow rangeOfString:Wmodel.tId].location != NSNotFound) {
                [cell labelValSelect:@"1"];
                NSlog(@"这个字符串中有 = %@", Wmodel.tId);
            }else{
                [cell labelValSelect:@"0"];
            }
        }else{
            if (Wmodel.isSelect == YES) {
                [cell labelValSelect:@"1"];
                NSlog(@"这个字符串中有 = %@", Wmodel.tId);
            }else{
                [cell labelValSelect:@"0"];
            }
        }
        return cell;
    
}



//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"item";
//    EventsAreaCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    
//    EventsCityModel *model = [self.dataSource objectAtIndex:indexPath.item];
//    cell.eventCityModel = model;
//
////    NSlog(@"userdefaults = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"]);
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"] == nil && _isSelect == NO) {
//        [cell labelValSelect:@"0"];
//        
//    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"] != nil && _isSelect == NO)
//    {
//        if (model.isSelect == YES  && [cellRow rangeOfString:model.tId].location != NSNotFound) {
//            [cell labelValSelect:@"1"];
//            NSlog(@"这个字符串中有 = %@", model.tId);
//        }else{
//            [cell labelValSelect:@"0"];
//        }
//    }else{
//        if (model.isSelect == YES) {
//            [cell labelValSelect:@"1"];
//            NSlog(@"这个字符串中有 = %@", model.tId);
//        }else{
//            [cell labelValSelect:@"0"];
//        }
//    }
//    
//    return cell;
//}

#pragma mark - Collection点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %zd, row = %zd", indexPath.section, indexPath.item);
    _isSelect = YES;
    if (indexPath.section == 0) {
        if (cellRow.length == 0) {
            cellRow = @"0";
        }
        EventsCityModel *model = [_dataSource objectAtIndex:indexPath.row];
        
        if (model.isSelect == NO) {
            [array addObject:model.tId];
        }else{
            [array removeObject:model.tId];
        }
        
        model.isSelect = !model.isSelect;
        
        NSlog(@"array = %@", array);
        [collectionView reloadData];
    }else{
        if (Wrow.length == 0) {
            Wrow = @"0";
        }
        EventsCityModel *model = [_WArray objectAtIndex:indexPath.row];
        
        if (model.isSelect == NO) {
            [arrayWai addObject:model.tId];
        }else{
            [arrayWai removeObject:model.tId];
        }
        
        model.isSelect = !model.isSelect;
        
        NSlog(@"array = %@", array);
        [collectionView reloadData];
    }
}

// 重置按钮点击方法
- (void)resetAction:(UIButton *)sender
{
    array = [NSMutableArray array];
    arrayWai = [NSMutableArray array];
    _selectStr = @"";
    _wSelect = @"";
    cellRow = @"";
    _isSelect = NO;
    Wrow = @"";
    for (int i = 0; i < _dataSource.count; i++) {
        EventsCityModel *model = _dataSource[i];
        model.isSelect = NO;
    }
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isAreaRow"];
    
    
    for (int i = 0; i < _WArray.count; i++) {
        EventsCityModel *Wmodel = _WArray[i];
        Wmodel.isSelect = NO;
    }
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isWRow"];
    
    [_myCollectV reloadData];
    
    NSDictionary *dic;
    if (cellRow.length > 0 || Wrow.length > 0) {
        dic = @{@"areaRow":@"1"};
    }else{
        dic = @{@"areaRow":@""};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isAreaColor" object:dic];
    //    // 重置代理
    [self.areaDelegate AreaCollectBackStatus:@"1"];
}
// 查询方法
- (void)searchAction:(UIButton *)sender
{
    _selectStr = @"";
    _wSelect = @"";
    for (int i = 0; i < array.count; i++) {
        NSString * str = array[i];
        if (_selectStr.length == 0) {
            _selectStr = str;
        }else{
            _selectStr = [_selectStr stringByAppendingString:[NSString stringWithFormat:@",%@", str]];
        }
    }
    
    for (int i = 0; i < arrayWai.count; i++) {
        NSString * str = arrayWai[i];
        if (_wSelect.length == 0) {
            _wSelect = str;
        }else{
            _wSelect = [_wSelect stringByAppendingString:[NSString stringWithFormat:@",%@", str]];
        }
    }
    
    NSlog(@"str = %@", _selectStr);
    if (_selectStr.length > 0) {
        cellRow = _selectStr;
        [[NSUserDefaults standardUserDefaults] setValue:cellRow forKey:@"isAreaRow"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isAreaRow"];
        cellRow = @"";
    }
    
    if (_wSelect.length > 0) {
        Wrow = _wSelect;
        [[NSUserDefaults standardUserDefaults] setValue:Wrow forKey:@"isWRow"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isWRow"];
        Wrow = @"";
    }
    NSString *str;
    
    if (cellRow.length == 0 && Wrow.length > 0) {
        str = Wrow;
    }else if (cellRow.length > 0 && Wrow.length == 0){
        str = cellRow;
    }else if (cellRow.length > 0 && Wrow.length > 0){
        str = [cellRow stringByAppendingString:[NSString stringWithFormat:@",%@", Wrow]];
    }else{
        str = @"";
    }
    
    
    if ([str isEqualToString:@"0,0"]) {
        str = @"";
    }
    _isSelect = NO;
    if (str.length > 0) {
        [self.areaDelegate AreadidSelectTId:str];
    }else{
        [self.areaDelegate AreadidSelectTId:@""];
    }
    NSDictionary *dic;
    if (cellRow.length > 0 || Wrow.length > 0) {
        if ([str isEqualToString:@"0,0"] || [str isEqualToString:@","]) {
            dic = @{@"areaRow":@""};
        }else{
            dic = @{@"areaRow":@"1"};
        }
    }else{
        dic = @{@"areaRow":@""};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isAreaColor" object:dic];
    
    [_myCollectV reloadData];
}
// 轻拍方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    array = [[NSMutableArray alloc] init];
    
    if (cellRow.length > 0) {
        for (int i = 0; i < _dataSource.count; i++) {
            EventsCityModel *model = _dataSource[i];
            if ([cellRow rangeOfString:model.tId].location != NSNotFound) {
                model.isSelect = YES;
                [array addObject:model.tId];
            }else{
                model.isSelect = NO;
            }
        }
    }
    
    arrayWai = [[NSMutableArray alloc] init];
    
    if (Wrow.length > 0) {
        for (int i = 0; i < _WArray.count; i++) {
            EventsCityModel *model = _WArray[i];
            if ([Wrow rangeOfString:model.tId].location != NSNotFound) {
                model.isSelect = YES;
                [arrayWai addObject:model.tId];
            }else{
                model.isSelect = NO;
            }
        }
    }
    
    [_myCollectV reloadData];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"];
    NSString *strW = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"];
    NSDictionary *dic;
    if (str.length > 0 || strW.length > 0) {
        dic = @{@"areaRow":@"1"};
    }else{
        dic = @{@"areaRow":@""};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isAreaColor" object:dic];
    [self.areaDelegate AreaCollectBackStatus:@"0"];
}

- (void)layoutSubviews
{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
    
    if (IS_IPHONE_6Plus) {
        [_myCollectV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-40);
            make.left.mas_equalTo(40);
            make.bottom.mas_equalTo(-44);
        }];
    }else{
        [_myCollectV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-30);
            make.left.mas_equalTo(30);
            make.bottom.mas_equalTo(-44);
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
