//
//  PopCollectionVC.m
//  pop圆角
//
//  Created by 嘟嘟 on 2017/9/6.
//  Copyright © 2017年 MC. All rights reserved.
//

#import "PopCollectionVC.h"

#import "PopCollectionViewCell.h"

@interface PopCollectionVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray * imageArr;
}
@property (nonatomic,strong) UICollectionViewFlowLayout * FlowLayout;
@property (nonatomic,strong) UICollectionView * CollectionView;

@end

@implementation PopCollectionVC

@synthesize actionIdList;
@synthesize callBackDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    imageArr = @[@"xingzhe_sporttype_cycling@2x"
                 ,@"xingzhe_sporttype_run@2x"
                 ,@"xingzhe_sporttype_travel@2x"
                 ,@"xingzhe_sporttype_walk@2x"
                 ,@"",@"",@"",@""];

    [self createCollectionView];
}


- (void)createCollectionView
{
    self.FlowLayout                     = [[UICollectionViewFlowLayout alloc] init];
    self.FlowLayout.scrollDirection     = UICollectionViewScrollDirectionVertical;
    self.CollectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 300, 100) collectionViewLayout:self.FlowLayout];
    self.CollectionView.backgroundColor = [UIColor whiteColor];
    self.CollectionView.delegate        = self;
    self.CollectionView.dataSource      = self;
    [self.view addSubview:self.CollectionView];
    [self.CollectionView registerNib:[UINib nibWithNibName:@"PopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PopCollectionViewCell"];
}

#pragma mark 返回段数
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 段的Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

#pragma mark 设置item内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PopCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PopCollectionViewCell" forIndexPath:indexPath];
    cell.popImageView.image       = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.popImageView.contentMode = UIViewContentModeCenter;
    return cell;
}

#pragma mark 设置item Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((300-3)/4,(100-1)/2);
}

#pragma mark 设置最小的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

#pragma mark 设置最小的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

#pragma mark 距离上下左右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0.5,0.5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (callBackDelegate) { [callBackDelegate callbackWithActionId:indexPath.row]; }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
