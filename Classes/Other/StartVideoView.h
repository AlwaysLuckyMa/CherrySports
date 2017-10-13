//
//  StartVideoView.h
//  CherrySports
//
//  Created by dkb on 17/2/16.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol StartVideoDelegate <NSObject>

- (void)StartVideoDelegate;

@end

@interface StartVideoView : UIView

@property(nonatomic,strong)NSURL *movieURL;
//@property (nonatomic,assign)BOOL isFirst;
//
@property (nonatomic, assign)id<StartVideoDelegate>delegate;

@end
