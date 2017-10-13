//
//  NickNameViewController.h
//  CherrySports
//
//  Created by dkb on 16/11/21.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseViewController.h"

@protocol NicknameDelegate <NSObject>

- (void)isPop;

@end

@interface NickNameViewController : BaseViewController

@property (nonatomic, assign) id<NicknameDelegate>delegate;

@end
