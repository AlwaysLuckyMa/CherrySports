//
//  DKBDataPickView.m
//  CherrySports
//
//  Created by dkb on 16/11/21.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "DKBDataPickView.h"

@interface DKBDataPickView ()<UIPickerViewDelegate, UIPickerViewDataSource>
/** <#注释#>*/
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end


@implementation DKBDataPickView
{
    NSMutableArray *yearArray; // 年数组
    NSArray *monthArray; // 月数组
    NSMutableArray *monthMutableArray; // 月可变数组
    NSMutableArray *DaysMutableArray; // 天可变数组
    NSMutableArray *DaysArray;
    NSString *currentMonthString; // 本月的字符串
    
    NSInteger selectedYearRow; // 记录选择的年的行数
    NSInteger selectedMonthRow; // 记录选择的月的行数
    NSInteger selectedDayRow; // 记录选择的日的行数
    
    BOOL firstTimeLoad; //是否第一次加载
    
    NSInteger m ; // 记录当前是第几行
    int year; // 记录当前年
    int month; // 记录当前月
    int day; // 记录当前日
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
//    self.customPicker.hidden = YES; // 隐藏自定义选择器
//    self.toolbarCancelDone.hidden = YES; // 隐藏工具栏
    
    NSDate *date = [NSDate date];
    
    // 获得本年度 yyyy
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    
    // 获取本月度 MM
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    month=[currentMonthString intValue];
    
    
    
    
    // 获取当前日 dd
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    day =[currentDateString intValue];
    
    // 初始化 年月日可变数组
    yearArray = [[NSMutableArray alloc]init];
    monthMutableArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    // 年数组保存从1970年至今的所有年份
    for (int i = 1970; i <= year ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    // PickerView -  Months data
    
    // 月数组保存从1月至12月
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    for (int i=1; i<month+1; i++) {
        [monthMutableArray addObject:[NSString stringWithFormat:@"%d  年",i]];
    }
    DaysArray = [[NSMutableArray alloc]init];
    
    // 除了当前月份以外所有日子数组
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    // 记录当前日的数组
    for (int i = 1; i <day+1; i++)
    {
        [DaysMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    // PickerView - Default Selection as per current Date
    // 设置初始默认值  第一列默认从第十行开始 inComponent：第几列
    [self.customPicker selectRow:10 inComponent:0 animated:YES];
    
    // [pickerView selectRow:30 inComponent:0 animated:NO];
    // 第二列默认显示月份为本月
    [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:2 animated:YES];
    // 第三列默认显示第0行
    [self.customPicker selectRow:0 inComponent:4 animated:YES];
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 当用户选择某个row时,picker view调用此函数
    m=row; // 记录当前选择的第几行
    
    if (component == 0)
    {
        // 记录年的行数
        selectedYearRow = row;
        // 重载所有新数据
        [self.customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        // 记录月的行数
        selectedMonthRow = row;
        // 重载所有新数据
        [self.customPicker reloadAllComponents];
    }
    else if (component == 4)
    {
        // 记录日的行数
        selectedDayRow = row;
        // 重载所有新数据
        [self.customPicker reloadAllComponents];
    }
}


#pragma mark - UIPickerViewDatasource
// 相当于布局
// 当picker view需要给指定的component.row指定view时,调用此函数.返回值为用作row内容的view
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    if (component != 1 && component != 3 && component != 5) {
        UILabel *pickerLabel = (UILabel *)view;
        
        if (pickerLabel == nil) {
            CGRect frame = CGRectMake(0.0, 0.0, 50, 20);
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setFont:[UIFont systemFontOfSize:12.0f]];
        }
        
        if (component == 0)
        {
            pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
        }
        else if (component == 2)
        {
            pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
        }
        else if (component == 4)
        {
            pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
            
        }
        
        return pickerLabel;
    }else{
        UILabel *dw = (UILabel *)view;
        if (dw == nil) {
            CGRect frame = CGRectMake(0, 0, 15, 15);
            dw = [[UILabel alloc] initWithFrame:frame];
            [dw setTextAlignment:NSTextAlignmentLeft];
            [dw setBackgroundColor:[UIColor clearColor]];
            [dw setFont:[UIFont systemFontOfSize:12]];
        }
        if (component == 1) {
            dw.text = @"年";
        }else if (component == 3){
            dw.text = @"月";
        }else if (component == 5){
            dw.text = @"日";
        }
        
        return dw;
    }
}

- (CGFloat)pickerView: (UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20;
}

- (CGFloat)pickerView: (UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 70;
    }else if (component == 1){
        return 15;
    }else if (component == 2){
        return 70;
    }else if (component == 3){
        return 15;
    }else if (component == 4){
        return 70;
    }
    return 15;
}

// 一共三列 年 月 日
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}

// 返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count]; // 年的行数
        
    }
    else if (component == 2)
    {
        NSInteger selectRow =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        // 如果是当前年 则返回到当前月份
        if (selectRow==n) {
            return [monthMutableArray count];
        }else
        {
            // 否则显示全月
            return [monthArray count];
        }
    }
    else if (component == 4)
    {
        NSInteger selectRow1 =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        NSInteger selectRow =  [pickerView selectedRowInComponent:1];
        // 符合条件则是当前月， 日 最大为当前日
        if (selectRow==month-1 &selectRow1==n) {
            
            return day;
            
        }else{
            // 算每个月有多少天
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
                
                
            }
            else
            {
                return 30;
            }
            
            
        }
        
    }else{
        return 1;
    }
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
        _backViews.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 205);
        [UIView animateWithDuration:0.5f animations:^{
            _backViews.frame = CGRectMake(0, SCREEN_HEIGHT-269, SCREEN_WIDTH, 205);
        }];
        [self addSubview:_backViews];
    }
    
    if (!_customPicker)
    {
        _customPicker = [[UIPickerView alloc] init];
        _customPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _customPicker.dataSource = self;   //这个不用说了瑟
        _customPicker.delegate = self;       //这个不用说了瑟
        _customPicker.frame = CGRectMake(0, 35, SCREEN_WIDTH, 170);
//        _customPicker.backgroundColor = [UIColor yellowColor];
        _customPicker.showsSelectionIndicator = YES;    //这个最好写 你不写来试下哇
        [self.backViews addSubview:_customPicker];
    }
    
    // 为了避免点击确定和取消按钮中间的位置触发到轻拍手势~ 所以用个白色button盖住
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor whiteColor];
    [self.backViews addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
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
        _backViews.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 205);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.0s后自动执行这个block里面的代码
        self.hidden = YES;
    });
}


// 点击确认按钮返回日期
- (void)ok
{
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:2]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:4]]];
    NSlog(@"选中的日期---->%@", str);
    // 协议传日期
    [self.dkbDelegate dataWithString:str];
    // 动画返回
    [UIView animateWithDuration:0.5f animations:^{
        _backViews.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 205);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.0s后自动执行这个block里面的代码
        self.hidden = YES;
    });
}







@end
