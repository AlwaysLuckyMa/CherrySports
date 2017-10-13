//
//  CustomTextField.m
//  CherrySports
//
//  Created by dkb on 16/11/18.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpUI];
}

- (void)setUpUI
{
//    self.font = [UIFont fontWithName:@"Microsoft YaHei" size:12];
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        self.font = [UIFont systemFontOfSize:14*SCREEN_WIDTH/375];
    }else{
        self.font = [UIFont systemFontOfSize:14];
    }
    
    //字体颜色
    self.textColor = TEXT_COLOR_DARK;
    
    //占位符的颜色和大小
    [self setValue:TEXT_COLOR_DARK forKeyPath:@"_placeholderLabel.textColor"];
//    [self setValue:[UIFont fontWithName:@"Microsoft YaHei" size:12] forKeyPath:@"_placeholderLabel.font"];
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        [self setValue:[UIFont systemFontOfSize:15*SCREEN_WIDTH/375] forKeyPath:@"_placeholderLabel.font"];
    }else{
        [self setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
}


//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+3, bounds.origin.y+3, bounds.size.width, bounds.size.height);//更好理解些
    return inset;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+1, bounds.origin.y+3, bounds.size.width, bounds.size.height);
    return inset;
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+1, bounds.origin.y+3, bounds.size.width, bounds.size.height);
    return inset;
}

@end
