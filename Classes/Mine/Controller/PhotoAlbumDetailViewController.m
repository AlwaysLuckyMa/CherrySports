//
//  PhotoAlbumDetailViewController.m
//  RenWoXing
//
//  Created by 李昞辰 on 16/4/25.
//  Copyright © 2016年 一休休休休. All rights reserved.
//

#import "PhotoAlbumDetailViewController.h"
#import "PhotoAlbumImageScrollView.h"
#import "PhotoAlbumCollectionCell.h"
#define ZOOM_STEP 1.5

@interface PhotoAlbumDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, photoCollectDelegate>

@property (nonatomic, strong)UILabel *pageLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIScrollView *photoScrollV; /** 滚动的scrollView */
@property (nonatomic, strong)UIScrollView *zoomScrollV; /** 缩放的scrollView */

@property (nonatomic, assign)CGFloat tempWidth;
@property (nonatomic, assign)CGFloat tempHeight;

@property (nonatomic, strong)UIImageView *imageV;

// dkb
@property (nonatomic, strong)UICollectionView *myCollection;
//@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, assign)NSInteger number;

@end

@implementation PhotoAlbumDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate{
    return NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    WS(weakSelf);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveOk) name:@"ImageSaveOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveNo) name:@"ImageSaveNO" object:nil];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // item大小
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    // 最小行间距
    flowLayout.minimumLineSpacing = 0;
    // 最小列间距
    flowLayout.minimumInteritemSpacing = 5;
    // 上左下右
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.myCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    self.myCollection.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.myCollection];
    
    [self.myCollection registerClass:[PhotoAlbumCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.myCollection.delegate = self;
    self.myCollection.dataSource = self;
    self.myCollection.pagingEnabled = YES; // 按页滚动
    self.myCollection.contentOffset = CGPointMake(SCREEN_WIDTH * _index, SCREEN_HEIGHT);
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self.myCollection addGestureRecognizer:tap];
    
    // 数字下的View
    UIView *pageV = [AppTools createViewBackground:[UIColor colorWithWhite:0 alpha:0.5]];
    [self.view addSubview:pageV];
    [pageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_offset(0);
        make.height.mas_offset(55);
        
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    // 别忘记设置尺寸
    backBtn.size = CGSizeMake(19, 34);
    // 让按钮内部的所有内容左对齐
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        [button sizeToFit]; 尺寸跟随里面的内容
    // contentEdgeInsets内边距
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [pageV addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(28);
        make.width.height.mas_offset(30);
        make.left.mas_offset(20);
        
    }];
    
    // 数字
    _pageLabel = [AppTools createLabelText:[NSString stringWithFormat:@"%ld / %ld",  (long)(_index + 1), (long)_dataArray.count] Color:[UIColor whiteColor] Font:14.0f TextAlignment:NSTextAlignmentCenter];
    [pageV addSubview:_pageLabel];
    [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(35);
        make.height.mas_offset(15);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    // titleName
//    _nameLabel = [AppTools createLabelText:[NSString stringWithFormat:@"%@", [_dataArray[_index] name]] Color:[UIColor whiteColor] Font:14.0f TextAlignment:NSTextAlignmentCenter];
    _nameLabel = [UILabel new];
    _nameLabel.text = @"保存";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
//    _nameLabel.backgroundColor = [UIColor redColor];
    _nameLabel.userInteractionEnabled = YES;
    [self.view addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.width.height.mas_equalTo(50);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelACtion)];
    [_nameLabel addGestureRecognizer:tap];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger num = scrollView.contentOffset.x;
    _number = num / SCREEN_WIDTH;
    _pageLabel.text = [NSString stringWithFormat:@"%zd / %zd", _number+1, _dataArray.count];
    NSlog(@"num = %ld", num);
}

- (void)labelACtion
{
    PhotoAlbumList *model = [PhotoAlbumList new];
    model = _dataArray[_number];
    UIImageView *imageView = [UIImageView new];
    NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:model.tPhotoImg]];
    [imageView sd_setImageWithURL:url];
    UIImageWriteToSavedPhotosAlbum(imageView.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(void*)contextInfo

{
    if(!error) {
        
        [self saveOk];
//        
//        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"提示"message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
//        
//        [alert show];
        
    }else{
        [self saveNo];
    }
}

- (void)saveOk
{
    [self showHint:@"保存成功"];
}

- (void)saveNo
{
    [self showHint:@"保存成功"];
}

#pragma mark - collection && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    PhotoAlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.cellDelegate = self;
    PhotoAlbumList *model = _dataArray[indexPath.row];
    model.number = indexPath.row;
    cell.photoListModel = model;
    
//    NSLog(@"%@", cell.imageStr);
    
    return cell;
}

- (void)reloadIndex:(NSInteger)index
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                [_myCollection reloadItemsAtIndexPaths:@[indexPath]];
            });
        });
    });
}

// 实现代理套代理方法
- (void)CollectAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)backBtnAction {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
