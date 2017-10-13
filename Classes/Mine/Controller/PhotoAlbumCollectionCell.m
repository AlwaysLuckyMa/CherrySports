//
//  PhotoAlbumCollectionCell.m
//  RenWoXing
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "PhotoAlbumCollectionCell.h"

@interface PhotoAlbumCollectionCell ()<PhotoScrollDelegate>

@property (nonatomic, strong)UIImageView *myImage;

@end

@implementation PhotoAlbumCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _myImage = [UIImageView new];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

-(void)setPhotoListModel:(PhotoAlbumList *)photoListModel{
    _photoListModel = photoListModel;
    
//    NSURL *url = [AppTools getImageURL:photoListModel.imgUrl imagePathType:@"/scrollviewlist"];
//    [_myImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    
    NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:photoListModel.tPhotoImg]];
//    [_myImage sd_setImageWithURL:url placeholderImage:PLACEHOLDW options:SDWebImageAllowInvalidSSLCertificates];
    [self.myImage sd_setImageWithURL:url placeholderImage:PLACEHOLDH options:SDWebImageRetryFailed];
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:url];
    
    if (imageView.image == nil) {
        [self.cellDelegate reloadIndex:photoListModel.number];
    }
    
    [_photoView removeFromSuperview];
    
    _photoView = [[PhotoAlbumImageScrollView alloc] initWithFrame:self.contentView.bounds andImage:_myImage.image];
    _photoView.scrolldelegate = self;
    _photoView.autoresizingMask = (1 << 6) -1;
    [self.contentView addSubview:self.photoView];
    
}


//- (void)tapAction{
//    [self.cellDelegate CollectAction];
//}

// 实现代理方法
- (void)photoSctolldelegate
{
    [self.cellDelegate CollectAction];
}

@end
