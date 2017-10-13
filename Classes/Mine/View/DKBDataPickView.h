//
//  DKBDataPickView.h
//  CherrySports
//
//  Created by dkb on 16/11/21.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DKBDataDelegate <NSObject>

- (void)dataWithString:(NSString *)str;

@end

@interface DKBDataPickView : UIView

/** backView*/
@property (nonatomic, strong) UIView *backViews;
/** datapicer*/
@property (nonatomic, strong) UIPickerView *customPicker;
/** leftBtn*/
@property (nonatomic, strong) UIButton *backBtn;
/** rightBtn*/
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, assign) id <DKBDataDelegate> dkbDelegate;

@end
