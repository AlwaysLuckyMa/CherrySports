//
//  PhotoAlbumImageScrollView.h
//  RenWoXing
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoScrollDelegate <NSObject>

- (void)photoSctolldelegate;

@end

@interface PhotoAlbumImageScrollView : UIScrollView <UIActionSheetDelegate>

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

@property (nonatomic, assign)id<PhotoScrollDelegate>scrolldelegate;

@property (nonatomic, strong)UIImageView *sentImg;

@end
