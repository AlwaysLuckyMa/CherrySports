//
//  PopCollectionVC.h
//  pop圆角
//
//  Created by 嘟嘟 on 2017/9/6.
//  Copyright © 2017年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CallBackWithActionIdSelected <NSObject>

- (void)callbackWithActionId:(NSInteger)actionId;

@end

@interface PopCollectionVC : UIViewController

@property NSArray *actionIdList;
@property (weak) id<CallBackWithActionIdSelected> callBackDelegate;


@end
