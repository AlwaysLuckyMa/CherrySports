//
//  HomeScrollHeaderView.h
//  CherrySports
//
//  Created by dkb on 16/12/19.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeImageModel.h"

@protocol ClickScroImageIdDelegate <NSObject>

- (void)ClickSliderWebModel:(HomeImageModel *)webModel;

@end

@interface HomeScrollHeaderView : UICollectionReusableView

@property (nonatomic, strong) NSMutableArray *dataArray;

/** 点击slider代理*/
@property (nonatomic, assign) id<ClickScroImageIdDelegate> delegate;

@end
