//
//  MineMessageModel.h
//  CherrySports
//
//  Created by dkb on 16/11/16.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineMessageModel : NSObject

/** time*/
@property (nonatomic, copy) NSString *time;
/** content*/
@property (nonatomic, copy) NSString *contents;
/** label高度*/
@property (nonatomic, assign) CGFloat labelHeight;

@end
