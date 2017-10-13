//
//  EventsTopView.m
//  CherrySports
//
//  Created by dkb on 16/11/8.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "EventsTopView.h"

@interface EventsTopView ()

@property (nonatomic, assign)BOOL isAreaRed;

@property (nonatomic, assign)BOOL isTypeRed;

@property (nonatomic, assign)BOOL isSearchRed;

@end

@implementation EventsTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isAreaColor:) name:@"isAreaColor" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isTypeColor:) name:@"isTypeColor" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(issearchColor:) name:@"isSearchColor" object:nil];
        [self  createViews];
    }
    return self;
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)isAreaColor:(NSNotification *)cender
{
    NSDictionary *dic = cender.object;
    NSString *str = [dic objectForKey:@"areaRow"];
    [self Area:str];
}

- (void)isTypeColor:(NSNotification *)cender
{
    NSDictionary *dic = cender.object;
    NSString *str = [dic objectForKey:@"TypeRow"];
    [self Type:str];
}

- (void)issearchColor:(NSNotification *)cender
{
    NSDictionary *dic = cender.object;
    NSString *str = [dic objectForKey:@"searchRow"];
    [self Search:str];
}

- (void)createViews
{
    //button
    [self addSubview:self.areaButton];
    [self addSubview:self.eventTypeButton];
    [self addSubview:self.searchButton];
    
    //image
    [self addSubview:self.areaImage];
    [self addSubview:self.eventImage];
    [self addSubview:self.searchImage];
    // 阴影
    [self addSubview:self.lineColor];
    // 尖
    [self addSubview:self.jiansj];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAreaRow"];
    NSString *stra = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWRow"];
    if (str.length > 0 || stra.length >0) {
        [self Area:@"1"];
    }
    
    [self Type:[[NSUserDefaults standardUserDefaults] objectForKey:@"isTypeRow"]];
    [self Search:[[NSUserDefaults standardUserDefaults] objectForKey:@"isSearchRow"]];
}

- (UIView *)lineColor
{
    if (!_lineColor) {
        UIImage *backImage = [UIImage imageNamed:@"events_top_line"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        _lineColor = [UIView new];
        _lineColor.backgroundColor = bc;
    }
    return _lineColor;
}

- (UIImageView *)areaImage
{
    if (!_areaImage) {
        _areaImage = [AppTools CreateImageViewImageName:@"events_top_jian"];
        _areaImage.contentMode = UIViewContentModeScaleAspectFit;
        _areaImage.hidden = YES;
    }
    return _areaImage;
}
- (UIImageView *)eventImage
{
    if (!_eventImage) {
        _eventImage = [AppTools CreateImageViewImageName:@"events_top_jian"];
        _eventImage.contentMode = UIViewContentModeScaleAspectFit;
        _eventImage.hidden = YES;
    }
    return _eventImage;
}
- (UIImageView *)searchImage
{
    if (!_searchImage) {
        _searchImage = [AppTools CreateImageViewImageName:@"events_top_jian"];
        _searchImage.contentMode = UIViewContentModeScaleAspectFit;
        _searchImage.hidden = YES;
    }
    return _searchImage;
}
- (UIButton *)areaButton
{
    if (!_areaButton) {
        _areaButton = [[UIButton alloc]init];
        [_areaButton setTitle:@"地区选择" forState:UIControlStateNormal];
        [_areaButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        _areaButton.backgroundColor = [UIColor whiteColor];
        _areaButton.layer.masksToBounds = YES;
        _areaButton.layer.cornerRadius = 5;
        _areaButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _areaButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_areaButton addTarget:self action:@selector(areaClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _areaButton;
}
- (UIButton *)eventTypeButton
{
    if (!_eventTypeButton) {
        _eventTypeButton = [[UIButton alloc]init];
        _eventTypeButton.backgroundColor = [UIColor whiteColor];
        [_eventTypeButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        _eventTypeButton.layer.masksToBounds = YES;
        _eventTypeButton.layer.cornerRadius = 5;
        [_eventTypeButton setTitle:@"赛事类型" forState:UIControlStateNormal];
        _eventTypeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _eventTypeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_eventTypeButton addTarget:self action:@selector(eventTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _eventTypeButton;
}
- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc]init];
        _searchButton.backgroundColor = [UIColor whiteColor];
        [_searchButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        _searchButton.layer.masksToBounds = YES;
        _searchButton.layer.cornerRadius = 5;
        [_searchButton setTitle:@"赛事状态" forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _searchButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchButton;
}


- (void)areaClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        _areaImage.hidden = NO;
        // 其他隐藏
        _eventImage.hidden = YES;
        _searchImage.hidden = YES;
        _eventTypeButton.selected = NO;
        _searchButton.selected = NO;
        // 弹出地区选择view
        [self.delegate AreaClickDelegateSelected:@"1"];
    }else{
        _areaImage.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isReduction" object:nil];
        
        [self.delegate AreaClickDelegateSelected:@"0"];
    }
    
    if (_isAreaRed == YES) {
        if (sender.selected == NO) {
            [_areaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _areaButton.backgroundColor = NAVIGATIONBAR_COLOR;
        }else{
            [_areaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _areaButton.backgroundColor = NAVIGATIONBAR_COLOR;
        }
    }else{
        if (sender.selected == NO) {
            [_areaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _areaButton.backgroundColor = NAVIGATIONBAR_COLOR;
            if (_isSearchRed == NO) {
                _searchButton.selected = NO;
                [_searchButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
                _searchButton.backgroundColor = [UIColor whiteColor];
            }
            if (_isTypeRed == NO) {
                _eventTypeButton.selected = NO;
                [_eventTypeButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
                _eventTypeButton.backgroundColor = [UIColor whiteColor];
            }
        }else{
            [_areaButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
            _areaButton.backgroundColor = [UIColor whiteColor];
        }
    }
    sender.selected = !sender.selected;
}

- (void)eventTypeClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        _eventImage.hidden = NO;
        // 其他隐藏
        _areaImage.hidden = YES;
        _searchImage.hidden = YES;
        _areaButton.selected = NO;
        _searchButton.selected = NO;
        // 弹出赛事选择view
        [self.delegate TypeClickDelegateSelected:@"1"];
    }else{
        _eventImage.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isReduction" object:nil];
        
        [self.delegate TypeClickDelegateSelected:@"0"];
    }
    
    if (_isTypeRed == YES) {
        if (sender.selected == NO) {
            [_eventTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _eventTypeButton.backgroundColor = NAVIGATIONBAR_COLOR;
        }else{
            [_eventTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _eventTypeButton.backgroundColor = NAVIGATIONBAR_COLOR;
        }
    }else{
        if (sender.selected == NO) {
            [_eventTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _eventTypeButton.backgroundColor = NAVIGATIONBAR_COLOR;
            if (_isAreaRed == NO) {
                _areaButton.selected = NO;
                [_areaButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
                _areaButton.backgroundColor = [UIColor whiteColor];
            }
            if (_isSearchRed == NO) {
                _searchButton.selected = NO;
                [_searchButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
                _searchButton.backgroundColor = [UIColor whiteColor];
            }
        }else{
            [_eventTypeButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
            _eventTypeButton.backgroundColor = [UIColor whiteColor];
        }
    }
    sender.selected = !sender.selected;
}
- (void)searchClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        _searchImage.hidden = NO;
        // 其他隐藏
        _areaImage.hidden = YES;
        _eventImage.hidden = YES;
        _areaButton.selected = NO;
        _eventTypeButton.selected = NO;
        // 弹出快捷选择view
        [self.delegate SearchClickDelegateSelected:@"1"];
    }else{
        _searchImage.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isReduction" object:nil];
        
        [self.delegate SearchClickDelegateSelected:@"0"];
    }
    
    if (_isSearchRed == YES) {
        if (sender.selected == NO) {
            [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _searchButton.backgroundColor = NAVIGATIONBAR_COLOR;
        }else{
            [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _searchButton.backgroundColor = NAVIGATIONBAR_COLOR;
        }
    }else{
        if (sender.selected == NO) {
            [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _searchButton.backgroundColor = NAVIGATIONBAR_COLOR;
            if (_isAreaRed == NO) {
                _areaButton.selected = NO;
                [_areaButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
                _areaButton.backgroundColor = [UIColor whiteColor];
            }
            if (_isTypeRed == NO) {
                _eventTypeButton.selected = NO;
                [_eventTypeButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
                _eventTypeButton.backgroundColor = [UIColor whiteColor];
            }
        }else{
            [_searchButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
            _searchButton.backgroundColor = [UIColor whiteColor];
        }
    }
    
    sender.selected = !sender.selected;
}


- (void)layoutSubviews
{
    WS(weakSelf);
    
    // 地区btn
    [_areaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.mas_equalTo(20);
//        make.width.mas_equalTo((SCREEN_WIDTH-130)/3);
        make.width.mas_equalTo(81.5);
        make.height.mas_equalTo(28);
    }];
    

    [_eventTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.width.mas_equalTo(81.5);
        make.height.mas_equalTo(28);
    }];
    
    
    // 查询btn
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(81.5);
        make.height.mas_equalTo(28);
    }];

    // 底部阴影
    [_lineColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    // 地区图
    [_areaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_areaButton);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];

    // 赛事图
    [_eventImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_eventTypeButton.mas_centerX);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];

    // 查询图
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_searchButton.mas_centerX);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [super layoutSubviews];
}

- (void)Area:(NSString *)area
{
    if (area.length > 0 && ![area isEqualToString:@","] && ![area isEqualToString:@"0,0"]) {
        _isAreaRed = YES;
        [_areaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _areaButton.backgroundColor = NAVIGATIONBAR_COLOR;
    }else{
        _isAreaRed = NO;
        [_areaButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        _areaButton.backgroundColor = [UIColor whiteColor];
    }
}

- (void)Type:(NSString *)type
{
    if (type.length > 0) {
        _isTypeRed = YES;
        [_eventTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _eventTypeButton.backgroundColor = NAVIGATIONBAR_COLOR;
    }else{
        _isTypeRed = NO;
        [_eventTypeButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        _eventTypeButton.backgroundColor = [UIColor whiteColor];
    }
}

- (void)Search:(NSString *)search
{
    if (search.length > 0) {
        _isSearchRed = YES;
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _searchButton.backgroundColor = NAVIGATIONBAR_COLOR;
    }else{
        _isSearchRed = NO;
        [_searchButton setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        _searchButton.backgroundColor = [UIColor whiteColor];
    }
}

@end
