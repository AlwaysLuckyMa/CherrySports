//
//  DKBGenderPickView.m
//  CherrySports
//
//  Created by dkb on 16/11/23.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "DKBGenderPickView.h"

@implementation DKBGenderPickView
{
    BOOL firstTimeLoad; //是否第一次加载
    
    NSInteger m ; // 记录当前是第几行
    
    NSMutableArray *genderArray;
    NSInteger selectedGenderRow;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    //    self.backgroundColor = [UIColor yellowColor];
    // 加载pikerView
    [self createpikerViews];
    
    
    m=0;
    firstTimeLoad = YES; // 是第一次加载
    
    genderArray = [NSMutableArray arrayWithObjects:@"男", @"女", nil];
    
    // PickerView - Default Selection as per current Date
    // 设置初始默认值  第一列默认从第一行开始 inComponent：第几列
    [self.customPicker selectRow:0 inComponent:0 animated:YES];
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 当用户选择某个row时,picker view调用此函数
    m=row; // 记录当前选择的第几行
    
    // 记录gender的行数
    selectedGenderRow = row;
    // 重载所有新数据
    [self.customPicker reloadAllComponents];
}


#pragma mark - UIPickerViewDatasource
// 相当于布局
// 当picker view需要给指定的component.row指定view时,调用此函数.返回值为用作row内容的view
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 20);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    
    pickerLabel.text = [genderArray objectAtIndex:row];
    return pickerLabel;
}

- (CGFloat)pickerView: (UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20;
}

- (CGFloat)pickerView: (UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}

// 一共三列 年 月 日
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// 返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return genderArray.count;
}

- (void)createpikerViews
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenView)];
        [self addGestureRecognizer:_tap];
    }
    
    if (!_backViews) {
        _backViews = [AppTools createViewBackground:[UIColor whiteColor]];
        _backViews.clipsToBounds = YES;
        _backViews.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 114);
        [UIView animateWithDuration:0.5f animations:^{
            _backViews.frame = CGRectMake(0, SCREEN_HEIGHT-178, SCREEN_WIDTH, 114);
        }];
        [self addSubview:_backViews];
    }
    
    if (!_customPicker)
    {
        _customPicker = [[UIPickerView alloc] init];
        _customPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _customPicker.dataSource = self;   //这个不用说了瑟
        _customPicker.delegate = self;       //这个不用说了瑟
        if (IS_IPHONE_4) {
            _customPicker.frame = CGRectMake(71, -20, SCREEN_WIDTH - 140, 74);
        }else{
            _customPicker.frame = CGRectMake(71, 25, SCREEN_WIDTH - 140, 74);
        }
        _customPicker.backgroundColor = [UIColor clearColor];
        _customPicker.showsSelectionIndicator = YES;    //这个最好写 你不写来试下哇
        [self.backViews addSubview:_customPicker];
    }
    
    // 为了避免点击确定和取消按钮中间的位置触发到轻拍手势~ 所以用个白色button盖住
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor whiteColor];
    [self.backViews addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"datapicker_backBtn"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"datapicker_backBtn"] forState:UIControlStateHighlighted];
        [_backBtn imageForState:UIControlStateNormal];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -15, 0);
        [self.backViews addSubview:_backBtn];
        [_backBtn addTarget:self action:@selector(hidenView) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(50);
        }];
    }
    
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setImage:[UIImage imageNamed:@"datapicker_okBtn"] forState:UIControlStateNormal];
        [_okBtn setImage:[UIImage imageNamed:@"datapicker_okBtn"] forState:UIControlStateHighlighted];
        [_okBtn imageForState:UIControlStateNormal];
        _okBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -15, 0);
        [self.backViews addSubview:_okBtn];
        [_okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(50);
        }];
    }
}

// 轻拍 或取消 动画返回并隐藏
- (void)hidenView
{
    [UIView animateWithDuration:0.5f animations:^{
        _backViews.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 114);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.0s后自动执行这个block里面的代码
        self.hidden = YES;
    });
}


// 点击确认按钮返回日期
- (void)ok
{
    NSString *str = [NSString stringWithFormat:@"%@",[genderArray objectAtIndex:[self.customPicker selectedRowInComponent:0]]];
    NSLog(@"选中的性别---->%@", str);
    // 协议传性别
    [self.dkbGenderDelegate GenderWithString:str];
    // 动画返回
    [UIView animateWithDuration:0.5f animations:^{
        _backViews.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 114);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.0s后自动执行这个block里面的代码
        self.hidden = YES;
    });
}


@end
