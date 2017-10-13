//
//  SearchCollectionViewCell.h
//  CherrySports
//
//  Created by dkb on 16/11/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat titleWidth;

/** title*/
@property (nonatomic, strong) UILabel *title;

- (void)labelVal:(NSString *)cityName cityNameWidth:(NSInteger)cityNameWidth isSelect:(NSString *)isSelect;

@end
