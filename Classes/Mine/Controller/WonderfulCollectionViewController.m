//
//  ViewController.m
//  图片放大
//
//  Created by 嘟嘟 on 2017/6/23.
//  Copyright © 2017年 MC. All rights reserved.
//
#define SCR_W [UIScreen mainScreen].bounds.size.width
#define SCR_H [UIScreen mainScreen].bounds.size.height

#import "WonderfulCollectionViewController.h"
#import "Demo_CollectionViewCell.h"

#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"
#import "UIButton+XLExtension.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "shareArr.h"
#import "wonderfull.h"
#import "KBDataBaseSingle.h"
#import "DialogView.h"
@interface WonderfulCollectionViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    XLPhotoBrowserDelegate,
    XLPhotoBrowserDatasource
>

@property (nonatomic,strong) UICollectionViewFlowLayout * FlowLayout;
@property (nonatomic,strong) UICollectionView           * Demo_collcetionView;
@property (nonatomic , strong) NSString * indexStrNum; //点击button返回数字XLScrollview

@property (nonatomic , strong) NSMutableArray  *Wonderful_HD_Pic_Arr;
@property (nonatomic , strong) NSMutableArray  *Wonderful_small_pic_Arr;
@property (nonatomic , assign) NSInteger page;//下拉刷新page数
@property (strong,nonatomic) UIImageView *nothingImageView;
@property (nonatomic , strong)DialogView * dialogView;
@end

@implementation WonderfulCollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    
    [self createCollection];//创建Collection
    [self loadImgData];//加载数据
    
    
//   self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"201"]];
    
}

- (void)createBg
{
    _dialogView = [[DialogView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_dialogView];
    [_dialogView nothingImageView];

}

-(UIImageView *) nothingImageView {
    
    if (!_nothingImageView) {
        WS(weakSelf);
        _nothingImageView = [[UIImageView alloc] init];
        _nothingImageView.image = [UIImage imageNamed:@"nothing"];
        _nothingImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_nothingImageView];
        [self.nothingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf);
            //        make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
    }
    return _nothingImageView;
}

- (void)createNav
{
    self.page = 1;
    // 标题
    UILabel *titleLabel = [AppTools createLabelText:@"精彩瞬间" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.Wonderful_small_pic_Arr = [NSMutableArray array];
    self.Wonderful_HD_Pic_Arr = [NSMutableArray array];
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNoti:) name:@"NOTI" object:nil];
}

#pragma mark - XLPhotoBrowserDatasource

#pragma mark 返回占位图片
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSIndexPath *indexPathFromSectionRow = [NSIndexPath indexPathForItem:index inSection:0];
    Demo_CollectionViewCell *cell = (Demo_CollectionViewCell *)[self.Demo_collcetionView cellForItemAtIndexPath:indexPathFromSectionRow];
    return cell.DEMO_collecrionCell.image;//占位图
}

#pragma mark 返回指定位置图片的UIImageView,用于做图片浏览器弹出放大和消失回缩动画等
- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    NSIndexPath *indexPathFromSectionRow = [NSIndexPath indexPathForItem:index inSection:0];
    Demo_CollectionViewCell *cell = (Demo_CollectionViewCell *)[self.Demo_collcetionView cellForItemAtIndexPath:indexPathFromSectionRow];
    return cell.DEMO_collecrionCell;
}

#pragma mark 返回高清大图索引
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSMutableArray * DB_Arr = [KBDataBaseSingle sharDataBase].selecturlAllData;
    
    if (DB_Arr != nil) {
        
        for (NSString *url in DB_Arr) {
            
            if ([url isEqualToString:self.Wonderful_HD_Pic_Arr[index]]) {
                return [NSURL URLWithString:_Wonderful_HD_Pic_Arr[index]];;
            }
        }
    }
    
    return [NSURL URLWithString:_Wonderful_small_pic_Arr[index]];
}


#pragma mark - XLPhotoBrowserDelegate
- (void)createCollection
{
    self.FlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.FlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.Demo_collcetionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCR_W, SCR_H-56) collectionViewLayout:self.FlowLayout];
    self.Demo_collcetionView.backgroundColor = [UIColor clearColor];
    self.Demo_collcetionView.delegate = self;
    self.Demo_collcetionView.dataSource = self;
    
    [self.Demo_collcetionView registerNib:[UINib nibWithNibName:@"Demo_CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"customCell"];
    [self tableViewRefresh]; //上下拉刷新
    
    [self.view addSubview:self.Demo_collcetionView];
}

#pragma mark 返回段数
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 段的Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _Wonderful_small_pic_Arr.count;
}

#pragma mark 设置item内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Demo_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"customCell" forIndexPath:indexPath];
    [cell.DEMO_collecrionCell sd_setImageWithURL:_Wonderful_small_pic_Arr[indexPath.row] placeholderImage:[UIImage imageNamed:@"201.png"]];
    cell.DEMO_collecrionCell.contentMode= UIViewContentModeScaleAspectFill;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark 设置item Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCR_W - 30) / 2 ,(((SCR_W - 30 ) / 2 ) * 5 ) / 6);
}

#pragma mark 设置最小的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark 设置最小的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark 距离上下左右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了UICollectionView----%ld个",(long)indexPath.row);
    
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.row imageCount:_Wonderful_small_pic_Arr.count  datasource:self];// 快速创建并进入浏览模式
    
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:nil
                            delegate:self
                   cancelButtonTitle:nil //取消
                   deleteButtonTitle:nil //删除
                   otherButtonTitles:@"保存图片",nil];
    
    // 自定义一些属性
    browser.pageDotColor = [UIColor clearColor]; ///< 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor clearColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    
}

//ActionSheet索引 19940201
- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    switch (actionSheetindex) {
            
        case 0: // 保存
        {
            NSLog(@"保存--点击索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            [browser saveCurrentShowImage];
        }
            break;
        default:
        {
            NSLog(@"点击索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
        }
            break;
    }
}

- (void)loadImgData{
    
    NSDictionary * userIdDic   = @{@"dicKey":@"tAppUserId",
                                   @"data":USERID}; //用户ID
    
    NSString     * pageStr     = [NSString stringWithFormat:@"%zi",_page];
    NSDictionary * pageDic     = @{@"dicKey":@"page",
                                   @"data":pageStr};
    
    NSDictionary * tIdDic      = @{@"dicKey":@"tGamesId",
                                   @"data":self.tGameId};
    
    NSArray      * postArr     = @[tIdDic, userIdDic,pageDic];
    
    NSString     * url         = [NSString stringWithFormat:@"%@/user/selectUserGamesPhoto", SERVER_URL];
    
     __weak typeof(self)weak_self = self;
    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil)
        {
           
            NSArray *picArr = [obj objectForKey:@"userGamesPhotoPoList"];
            
            if (picArr.count<=0) {  //最新更改   移除刷新
                if (weak_self.Wonderful_small_pic_Arr.count<=0) {
                    [self createBg];
                }

                [_Demo_collcetionView.mj_header endRefreshing];
                [_Demo_collcetionView.mj_footer endRefreshing];
                [_Demo_collcetionView.mj_header removeFromSuperview];
                [_Demo_collcetionView.mj_footer removeFromSuperview];
                return ;
            }
            for (NSDictionary *dic in picArr)
            {
               [weak_self.Wonderful_HD_Pic_Arr addObject:[NSString stringWithFormat:@"%@%@",SERVER_URLL,dic[@"tDownloadPhotoImg"]]];
               [weak_self.Wonderful_small_pic_Arr addObject:[NSString stringWithFormat:@"%@%@",SERVER_URLL,dic[@"tPhotoImg"]]];

//                NSLog(@"1994-%@----%@",[NSString stringWithFormat:@"%@%@",SERVER_URLL,dic[@"tPhotoImg"]],
//                      [NSString stringWithFormat:@"%@%@",SERVER_URLL,dic[@"tDownloadPhotoImg"]]);
            }
            
            [shareArr getURLArrShare].urlArr = weak_self.Wonderful_HD_Pic_Arr;
    
            [_Demo_collcetionView reloadData];
            [_Demo_collcetionView.mj_header endRefreshing];
            [_Demo_collcetionView.mj_footer endRefreshing];
            
            
            
        }
        else
        {
            NSLog(@"error");
            [self showHint:@"亲，网络开小差了"];
            [_Demo_collcetionView.mj_header endRefreshing];
            [_Demo_collcetionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 接收通知
- (void)receiveNoti:(NSNotification *)noti
{
    _indexStrNum =noti.userInfo[@"num"];
    NSInteger num = [_indexStrNum intValue];

    [[KBDataBaseSingle sharDataBase]insertNewArrModel:[shareArr getURLArrShare].urlArr[num]];
    
}

//下拉加载
- (void)tableViewRefresh
{
    _Demo_collcetionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self loadImgData]; //加载
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
