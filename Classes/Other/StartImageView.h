//
//  StartImageView.h
//  CherrySports
//
//  Created by dkb on 17/2/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartModel.h"

@protocol ClickStartImageDelegate <NSObject>

- (void)ClickStartModel:(StartModel *)webModel;
- (void)ClickTapImage;

@end

@interface StartImageView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) id<ClickStartImageDelegate>delegate;

@end
