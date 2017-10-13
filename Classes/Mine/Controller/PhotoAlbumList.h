//
//  PhotoAlbumList.h
//  RenWoXing
//
//  Created by 李昞辰 on 16/5/14.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoAlbumList : NSObject

/**
 *  相册名
 */
@property (nonatomic, copy)NSString *name;

/** 
 *  相册地址
 */
@property (nonatomic, copy)NSString *tPhotoImg;

/**
 *  相册id
 */
@property (nonatomic, copy)NSString *tId;

@property (nonatomic, assign)NSInteger number;


@end
