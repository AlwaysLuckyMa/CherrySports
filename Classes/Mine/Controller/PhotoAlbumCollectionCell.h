//
//  PhotoAlbumCollectionCell.h
//  RenWoXing
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumImageScrollView.h"
#import "PhotoAlbumList.h"

@protocol photoCollectDelegate  <NSObject>

- (void)CollectAction;

- (void)reloadIndex:(NSInteger)index;

@end

@interface PhotoAlbumCollectionCell : UICollectionViewCell

@property (nonatomic, strong)PhotoAlbumList *photoListModel;
@property (nonatomic, strong)PhotoAlbumImageScrollView *photoView;

@property (nonatomic, assign)id<photoCollectDelegate>cellDelegate;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)UIImage *image1;

@end
