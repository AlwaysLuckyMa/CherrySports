//
//  DKBGenderPickView.h
//  CherrySports
//
//  Created by dkb on 16/11/23.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DKBgenderDelegate <NSObject>

- (void)GenderWithString:(NSString *)str;

@end

@interface DKBGenderPickView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

/** backView*/
@property (nonatomic, strong) UIView *backViews;
/** datapicer*/
@property (nonatomic, strong) UIPickerView *customPicker;
/** leftBtn*/
@property (nonatomic, strong) UIButton *backBtn;
/** rightBtn*/
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, assign) id <DKBgenderDelegate> dkbGenderDelegate;


@end
