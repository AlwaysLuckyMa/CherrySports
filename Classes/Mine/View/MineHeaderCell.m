//
//  HeaderCell.m
//  CherrySports
//
//  Created by 吴庭宇 on 2016/10/28.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "MineHeaderCell.h"

@interface HeaderCell ()

//上下分割线
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *lineTopView;
/**动态，关注，粉丝imageView*/
@property (nonatomic,strong)UIImageView *imageTitle;
//数字label
@property (nonatomic,strong)UILabel *numLabel;
//文字label
@property (nonatomic,strong)UILabel *strLabel;
//垂直分割线
@property (nonatomic,strong)UIImageView *leftVerticalView;
@property (nonatomic,strong)UIImageView *rightVerticalView;

@end
@implementation HeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.lineTopView];
    [self.contentView addSubview:self.imageTitle];
    [self.contentView addSubview:self.leftVerticalView];
    [self.contentView addSubview:self.rightVerticalView];
    //初始化数组
    self.titleArr = [[NSArray alloc]init];
    self.numberStr = [[NSArray alloc]init];
    self.titleArr = @[@"动态",@"关注",@"粉丝"];
    
    //numberStr测试用
    /**在imageView上添加上下的数字 和文字label**/
    self.numberStr = @[@"10",@"21",@"50"];
    for (int i = 0; i<self.numberStr.count; i++) {
        self.numLabel = [[UILabel alloc]init];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
//        self.numLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:10];
        self.numLabel.font = [UIFont systemFontOfSize:10.0f];
        self.numLabel.frame = CGRectMake(i*SCREEN_WIDTH/3, 15, SCREEN_WIDTH/3, 10);
        self.numLabel.text = self.numberStr[i];
        [self.imageTitle addSubview:self.numLabel];
    }
    for (int i = 0; i<self.titleArr.count; i++) {
        self.strLabel = [[UILabel alloc]init];
        
        self.strLabel.textColor = TEXT_COLOR_LIGHT;
        self.strLabel.textAlignment = NSTextAlignmentCenter;
        self.strLabel.font = [UIFont systemFontOfSize:10];
        self.strLabel.frame = CGRectMake(i*SCREEN_WIDTH/3, 28, SCREEN_WIDTH/3, 10);
        self.strLabel.text = self.titleArr[i];
        [self.imageTitle addSubview:self.strLabel];
    }
    
//    //积分
//    for (int i = 0; i<self.titleArr.count; i++) {
//        UILabel * creditsLabel = [[UILabel alloc] init];
//        creditsLabel.numberOfLines = 0;
//        creditsLabel.textColor = [UIColor blackColor];
//        creditsLabel.text = [NSString stringWithFormat:@"%@\n%@",self.numberStr[i],self.titleArr[i]];
//        creditsLabel.textAlignment = NSTextAlignmentCenter;
//        creditsLabel.font = [UIFont systemFontOfSize:10];
//        creditsLabel.frame = CGRectMake(SCREEN_WIDTH/3 * i, 6, SCREEN_WIDTH/3, 40);
//        [self.imageTitle addSubview:creditsLabel];
//    }
}
#pragma mark-- 懒加载

-(UIImageView *)leftVerticalView
{
    if (!_leftVerticalView) {
        _leftVerticalView =[UIImageView new];
        [_leftVerticalView setImage:[UIImage imageNamed:@"verticalline"]];
    }return _leftVerticalView;
}
-(UIImageView *)rightVerticalView
{
    if (!_rightVerticalView) {
        _rightVerticalView = [UIImageView new];
        [_rightVerticalView setImage:[UIImage imageNamed:@"verticalline"]];
    }return _rightVerticalView;
}
-(UIImageView *)imageTitle
{
    if (!_imageTitle) {
        _imageTitle =[[UIImageView alloc]init];
        _imageTitle.userInteractionEnabled =YES;
        
    }return _imageTitle;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView =[UIView new];
        _lineView.backgroundColor =LINE_COLOR;
    }
    return _lineView;
}
-(UIView *)lineTopView
{
    if (!_lineTopView) {
        _lineTopView =[UIView new];
        _lineTopView.backgroundColor =TEXT_COLOR_LIGHT;
    }
    return _lineTopView;
}
-(UIImageView *)headView
{
    if (!_headView) {
        _headView =[UIImageView new];
        _headView.backgroundColor =[UIColor redColor];
        //切割成圆形
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 32.5;
    }
    return _headView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel =[UILabel new];
        _titleLabel.text =@"";
//        _titleLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:12];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _titleLabel;
}
-(UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel =[UILabel new];
        _subtitleLabel.text =@"";
        _subtitleLabel.textColor = TEXT_COLOR_LIGHT;
        _subtitleLabel.font =[UIFont systemFontOfSize:10];
    }
    return _subtitleLabel;
}
#pragma mark --布局
-(void)layoutSubviews
{
    //leftVerticalView
    [_leftVerticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH/3-1);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(52-16);
    }];
    //rightVerticalView
    [_rightVerticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SCREEN_WIDTH/3);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(52-16);
    }];
    //imageTitle
    [_imageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(52);
    }];
    //_lineView
    [_lineTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-52);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    //_lineView
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    //头像
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(18);
        make.width.and.height.mas_equalTo(65);
    }];
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_right).offset(20);
        make.top.mas_equalTo(34);
        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(40);
    }];
    //子标题
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_right).offset(20);
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(300);
        make.bottom.mas_equalTo(-88);
    }];
    
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
