//
//  daTouZenVC.m
//  气泡Demo
//
//  Created by 嘟嘟 on 2017/8/4.
//  Copyright © 2017年 MC. All rights reserved.
//  纬度,经度|纬度,经度

#import "daTouZenVC.h"

#import "luShuModel.h"
#import "AddCell.h"
#import "StartCell.h"
#import "FinishCell.h"
#import "TableViewCell.h"

#import "NoteXMLParser.h" //xml解析

@interface daTouZenVC ()
<
    BMKMapViewDelegate,
    BMKLocationServiceDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    BMKRouteSearchDelegate,
    BMKGeoCodeSearchDelegate,   //反地理编码代理
    BMKGeneralDelegate
>
{
    BMKMapView                   * _mapView;              //地图对象
    BMKLocationService           * _locService;           //定位
    BMKAnnotationView            * _annotationView;       //大头针
    BMKGeoCodeSearch             * _getCodeSearch;        //geo搜索服务
    BMKReverseGeoCodeOption      * _reverseGeoCodeOption; //反geo检索信息类
    BMKReverseGeoCodeResult      * _reverseGeoCodeResult; //反地址编码结果
    BMKPointAnnotation           * _CustomPoint;          //大头针
    BMKPolyline                  * _polyline;             //画线
    UIView                       * _LatView;              //选点中心点
    UIView                       * _tableViewBgView;      //地图选点view
    UITableView                  * _tableView;            //选点tableView
    NSMutableArray               * _dataArr;              //数据数组
    NSMutableArray               * _lastCoor;             //保存大头针最后插的位置
    NSMutableArray               * _GPSDataArr;           //保存数据列表
    UIButton                     * _startBtn;             //开始
    UIButton                     * _PassingBtn;           //途经点
    UIButton                     * _finishBtn;            //结束
    BOOL                           _selectStar;           //开始选择    bool
    BOOL                           _selectCenterCell;     //单选选择    bool
    BOOL                           _selectFinish;         //终点       bool
    BOOL                           _noAdd;                //是否往数组里加载model
    BOOL                           _add;                  //是否设置途经点cell为真
    NSInteger                      _indexRow;             //当前选择的    index
    NSIndexPath                  * _index;                //点前选择的行数 index.row
    CGFloat                        _AnnType;              //大头针图片显示类型
    NSString                     * _endStr ;              //裁剪后的字符串
    CLLocationCoordinate2D         _CenterCoordinate2D;   //中心点坐标
}

@end

@implementation daTouZenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationController];
    
    [self initArrayAndOther];   //初始数组和其他
    
    [self addRawData];          //加载初始数据
    
    [self createMapView];       //初始化地图
    
    [self createCenterImage];   //创建中间显示大头针
    
    [self createTableView];     //创建tableview
  
    [self createCoorCenterBtn]; //回到地图中心点btn
}

- (void)initArrayAndOther
{
    _selectStar       = YES;
    _selectFinish     = YES;
    _noAdd            = YES;
    _selectCenterCell = YES;
    _endStr           = @"";
    _add              = YES;
    _dataArr          = [NSMutableArray array];
    _lastCoor         = [NSMutableArray array];
}

#pragma mark - 初始化原始实数据
- (void)addRawData
{
    for (NSInteger i = 0; i < 3; i++)
    {
        luShuModel * model = [[luShuModel alloc]init];
        [_dataArr addObject:model];
        [_lastCoor addObject:model];
    }
}

#pragma mark - 初始化地图
- (void)createMapView
{
    _mapView                                   = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1/2)];
    _mapView.mapType                           = BMKMapTypeStandard; //标准地图  BMKMapTypeSatellite
    _mapView.userTrackingMode                  = BMKUserTrackingModeFollow;
    _mapView.zoomLevel                         = 17; //最佳缩放度
    _mapView.zoomEnabled                       = YES;
    _mapView.delegate                          = self;
    _mapView.showsUserLocation                 = YES;//显示定位图层  设置为no不定位到当前位置
    
    BMKLocationViewDisplayParam * displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid            = YES;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow          = NO;//精度圈是否显示  小蓝圈
    displayParam.locationViewImgName           = @"icon";//定位图标名称
    displayParam.locationViewOffsetX           = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY           = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
    [self.view addSubview:_mapView];
    
    _locService                                = [[BMKLocationService alloc]init];//初始化BMKLocationService
    _locService.delegate                       = self;
    [_locService startUserLocationService]; //启动LocationService
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(reloadView:) name:@"reload_GPX" object:nil];
}

#pragma mark  实时更新用户位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _CenterCoordinate2D = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
}

#pragma mark 地图区域改变完成
- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
    [self loadDataLocation:mapView.centerCoordinate]; //地理反编码
    
    CGFloat image_w  = 20;
    CGFloat image_H  = 43;
    
    _startBtn.frame    = CGRectMake((SCREEN_WIDTH - image_w) / 2, (SCREEN_HEIGHT / 4) - image_H, image_w, image_H);
    [_startBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_start_cilck@2x"] forState:UIControlStateNormal];
    
    _PassingBtn.frame  = CGRectMake((SCREEN_WIDTH - image_w) / 2, (SCREEN_HEIGHT / 4) - image_H, image_w, image_H);
    [_PassingBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_marker_click@2x"] forState:UIControlStateNormal];
    
    _finishBtn.frame   = CGRectMake((SCREEN_WIDTH - image_w) / 2, (SCREEN_HEIGHT / 4) - image_H, image_w, image_H);
    [_finishBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_end_click@2x"] forState:UIControlStateNormal];
}

#pragma mark annotation添加标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.animatesDrop          = NO;// 设置该标注点动画显示
    newAnnotationView.annotation            = annotation;
    if (_AnnType == 0)
    {
        newAnnotationView.image            = [UIImage imageNamed:@"roadbook_map_start@2x"];   //把大头针换成别的图片
    }
    else if(_AnnType == 1)
    {
        newAnnotationView.image            = [UIImage imageNamed:@"roadbook_map_end@2x"];   //把大头针换成别的图片
    }
    else if(_AnnType == 3)
    {
        newAnnotationView.image            = [UIImage imageNamed:@"69E713204237B72CD831E4D17A73BB1B"];   //把大头针换成别的图片
    }
    return newAnnotationView;
}

#pragma mark - 地理反编码
- (void)loadDataLocation:(CLLocationCoordinate2D )location2D
{
    if (_getCodeSearch == nil)
    {
        _getCodeSearch                     = [[BMKGeoCodeSearch alloc]init];//初始化地理编码类
        _getCodeSearch.delegate            = self;
    }
    
    if (_reverseGeoCodeOption == nil)
    {
        _reverseGeoCodeOption              = [[BMKReverseGeoCodeOption alloc] init];//初始化反地理编码类
    }
    
    _reverseGeoCodeOption.reverseGeoPoint = location2D; //需要逆地理编码的坐标位置
    [_getCodeSearch reverseGeoCode:_reverseGeoCodeOption];
}

#pragma mark 检索结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (_noAdd)
    {
        BMKAddressComponent *component = [[BMKAddressComponent alloc]init];
        component                      = result.addressDetail;
        
        NSString * cityStr             = [NSString stringWithFormat:@"%@%@%@%@",component.province,component.city,component.streetName,component.streetNumber];
        
        luShuModel * model             = [[luShuModel alloc]init];
        
        model.city                     = cityStr;
        CLLocationCoordinate2D coor;
        coor.latitude                  = result.location.latitude;
        coor.longitude                 = result.location.longitude;
        model.coor                     = coor;
        [_dataArr replaceObjectAtIndex:_indexRow withObject:model];
        
        NSIndexPath *indexPath         = [NSIndexPath indexPathForRow:_indexRow inSection:0]; //刷新当前cell
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        CGFloat image_w                = 20;
        CGFloat image_H                = 30;
        _startBtn.frame                = CGRectMake((SCREEN_WIDTH - image_w) / 2, (SCREEN_HEIGHT / 4) - image_H, image_w, image_H);
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_start@2x"] forState:UIControlStateNormal];
        
        _PassingBtn.frame              = CGRectMake((SCREEN_WIDTH - image_w) / 2, (SCREEN_HEIGHT / 4) - image_H, image_w, image_H);
        [_PassingBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_marker@2x"] forState:UIControlStateNormal];
        
        _finishBtn.frame               = CGRectMake((SCREEN_WIDTH - image_w) / 2, (SCREEN_HEIGHT / 4) - image_H, image_w, image_H);
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_end@2x"] forState:UIControlStateNormal];
    }
}

- (void)createCenterImage
{
    CGFloat btn_X = (SCREEN_WIDTH - 20) / 2;
    CGFloat btn_Y = (SCREEN_HEIGHT / 4) - 43;
    CGFloat btn_W = 20;
    CGFloat btn_H = 43;
    
    _startBtn            = [[UIButton alloc]initWithFrame:CGRectMake(btn_X,btn_Y,btn_W,btn_H)];
    [_startBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_start_cilck@2x"] forState:UIControlStateNormal];
    [self.view addSubview:_startBtn];
    
    _PassingBtn          = [[UIButton alloc]initWithFrame:CGRectMake(btn_X,btn_Y,btn_W,btn_H)];
    _PassingBtn.hidden   = YES;
    [_PassingBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_marker_click@2x@2x"] forState:UIControlStateNormal];
    [self.view addSubview:_PassingBtn];
    
    _finishBtn        = [[UIButton alloc]initWithFrame:CGRectMake(btn_X,btn_Y,btn_W,btn_H)];
    _finishBtn.hidden = YES;
    [_finishBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_end_click@2x"] forState:UIControlStateNormal];
    [self.view addSubview:_finishBtn];
}

#pragma mark - 创建tableview
- (void)createTableView
{
    //tableView背景View
    _tableViewBgView                 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame)  , SCREEN_WIDTH, SCREEN_HEIGHT / 2 - 64)];
    _tableViewBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableViewBgView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor       = [UIColor grayColor];
    _tableView.delegate              = self;
    _tableView.dataSource            = self;
    [_tableViewBgView addSubview:_tableView];
    
    UIView * tableHeadview           = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
        UILabel * label                  = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH, 25)];
        label.backgroundColor            = [UIColor whiteColor];
        label.text                       = @"   请拖动地图";
        label.font                       = [UIFont systemFontOfSize:11];
        [tableHeadview addSubview:label];
    _tableView.tableHeaderView       = tableHeadview;
    
    UIView * tableFooterview         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 7)];
    tableFooterview.backgroundColor  = [UIColor clearColor];
        UIButton * footerBtn                  = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - (SCREEN_WIDTH - 40)) / 2, ((SCREEN_HEIGHT / 7 - 40) /2), SCREEN_WIDTH - 40, 40)];
        footerBtn.backgroundColor             = [UIColor blueColor];
        [footerBtn setTitle:@"预览" forState:UIControlStateNormal];
        footerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [footerBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterview addSubview:footerBtn];
    _tableView.tableFooterView       = tableFooterview;

    
    [_tableView registerNib:[UINib nibWithNibName:@"AddCell"        bundle:nil] forCellReuseIdentifier:@"addCell" ];
    [_tableView registerNib:[UINib nibWithNibName:@"StartCell"      bundle:nil] forCellReuseIdentifier:@"startId" ];
    [_tableView registerNib:[UINib nibWithNibName:@"FinishCell"     bundle:nil] forCellReuseIdentifier:@"finishId"];
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell"  bundle:nil] forCellReuseIdentifier:@"cccc"    ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArr.count - 2)
    {
        return SCREEN_HEIGHT / 2 / 9;
    }
    return SCREEN_HEIGHT / 2 / 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *startCellID = @"startId";
        StartCell       * startCell  = [tableView dequeueReusableCellWithIdentifier:startCellID];
        _selectStar?(startCell.startCellLabel.textColor = [UIColor redColor]):(startCell.startCellLabel.textColor = [UIColor blackColor]);
        
        luShuModel *model            = _dataArr[indexPath.row];
        ([model.city length]==0)?(startCell.startCellLabel.text = @"请设置起始点"):(startCell.startCellLabel.text = model.city);
        
        return startCell;
    }
    
    if (indexPath.row == _dataArr.count - 1)
    {
        static NSString * finishCellID = @"finishId";
        FinishCell      * finishCell   = [tableView dequeueReusableCellWithIdentifier:finishCellID];
        !_selectFinish?(finishCell.finishCellLabel.textColor = [UIColor redColor]):(finishCell.finishCellLabel.textColor = [UIColor blackColor]);
        
        luShuModel *model              = _dataArr[indexPath.row];
        ([model.city length]==0)?(finishCell.finishCellLabel.text = @"请设置终点"):(finishCell.finishCellLabel.text = model.city);
        
        return finishCell;
    }
    
    if (indexPath.row ==_dataArr.count - 2 )
    {
        static NSString * addCellID = @"addCell";
        AddCell         * addCell   = [tableView dequeueReusableCellWithIdentifier:addCellID];
        addCell.addCellblock = ^()
        {
            luShuModel * lastModel  = _dataArr[indexPath.row - 1];
            
            if (lastModel.coor.longitude == 0)
            {
                [self showHint:@"请添加途经点"];
                return ;
            }
            else
            {
                _startBtn  .hidden = YES;
                _PassingBtn.hidden = NO;
                _finishBtn .hidden = YES;
                _selectStar        = NO;
                _selectFinish      = YES;
                _add               = YES;
                _selectCenterCell  = YES;
                
                luShuModel * model = [[luShuModel alloc]init];
                [_dataArr  insertObject:model atIndex:_dataArr.count  - 2];
                [_lastCoor insertObject:model atIndex:_lastCoor.count - 2];
                
                [self loopThroughAndAddEachPin]; //把所有当前还没有插到地图的点插上去
                [self tableView:_tableView didSelectRowAtIndexPath:indexPath]; //选中当前cell
                
                [_tableView reloadData];
            }
        };
        return addCell;
    }
    static NSString *cellID = @"cccc";
    TableViewCell * cell                   = [tableView dequeueReusableCellWithIdentifier:cellID];
    (_index == indexPath)?((_selectCenterCell)?(cell.centerCellLabel.textColor = [UIColor blackColor]):(cell.centerCellLabel.textColor = [UIColor redColor])):(cell.centerCellLabel.textColor = [UIColor blackColor]);
    luShuModel * model                     = _dataArr[indexPath.row];
    ([model.city length]==0)?(cell.centerCellLabel.text = @"请设置途经点"):(cell.centerCellLabel.text = model.city);
    return cell;
}

#pragma mark cell选择代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexRow              = indexPath.row;
    _index                 = indexPath;
    CGFloat image_w        = 20;
    CGFloat image_H        = 43;
    
    if (indexPath.row     == 0)
    {
        _AnnType           = 0;
        _startBtn  .hidden = NO;
        _PassingBtn.hidden = YES;
        _finishBtn .hidden = YES;
        _startBtn  .frame  = CGRectMake((SCREEN_WIDTH - image_w) / 2, (SCREEN_HEIGHT / 4) - image_H, image_w, image_H);
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"roadbook_map_start_cilck@2x"] forState:UIControlStateNormal];
        
        if (_selectStar)
        {
            _selectStar             = !_selectStar;
            _startBtn  .hidden      = YES;
            _PassingBtn.hidden      = YES;
            _noAdd                  = NO; //是否添加model
            
            luShuModel * model      = _dataArr[indexPath.row];
            
            _CustomPoint            = [[BMKPointAnnotation alloc] init];
            _CustomPoint.title      = @"起始";
            _CustomPoint.subtitle   = model.city;
            _CustomPoint.coordinate = model.coor;
            
            [_mapView addAnnotation:_CustomPoint];
            
            luShuModel * lastModel  = [[luShuModel alloc]init];
            lastModel.title         = @"起始";
            lastModel.coor          = model.coor;
            lastModel.city          = model.city;
            [_lastCoor replaceObjectAtIndex:0 withObject:lastModel];
            
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        else
        {
            _selectStar               = !_selectStar;
            _startBtn  .hidden        = NO;
            _PassingBtn.hidden        = YES;
            _noAdd                    = YES;//是否添加model
            
            luShuModel *model         = _lastCoor[0];
            _mapView.centerCoordinate = model.coor;   //回到地图中心点
            
            //移除当前大头针
            for (_CustomPoint in _mapView.annotations)
            {
                if (_CustomPoint.coordinate.latitude  == model.coor.latitude && _CustomPoint.coordinate.longitude == model.coor.longitude)
                {
                    [_mapView removeAnnotation:_CustomPoint];
                }
            }
            
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    else if (indexPath.row == _dataArr.count - 1) //终点cell
    {
        if (_selectFinish)
        {
            if (_selectStar) //当起始点坐标没有落下时 做处理
            {
                [self loopThroughAndAddEachPin];
                _selectStar = NO;
            }
            
            _AnnType                  = 1;
            _selectFinish             = !_selectFinish;
            _startBtn  .hidden        = YES;
            _finishBtn .hidden        = NO;
            _PassingBtn.hidden        = YES;
            _noAdd                    = YES;//是否添加model
            
            [self loopThroughAndAddEachPin];
            
            luShuModel * model        = _lastCoor[_dataArr.count - 1];
            
            if ((model.coor.latitude == 0) && (model.coor.longitude == 0)) //当点击终点坐标时 model为空处理
            {
                luShuModel * model         = _lastCoor[indexPath.row - 2]; //当终点model为空时 取到上一个坐标点的坐标(indexPath.row - 1 的坐标是添加途经点的cell)
                _mapView.centerCoordinate  = model.coor;   //回到地图中心点
            }
            else
            {
                _mapView.centerCoordinate  = model.coor;   //回到地图中心点
            }
            
            for (_CustomPoint in _mapView.annotations)
            {
                if ((_CustomPoint.coordinate.latitude  == model.coor.latitude) && (_CustomPoint.coordinate.longitude == model.coor.longitude))
                {
                    [_mapView removeAnnotation:_CustomPoint];
                }
            }
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            _AnnType               = 1;
            _finishBtn .hidden     = YES;
            _PassingBtn.hidden     = YES;
            _selectFinish          = !_selectFinish;
            _noAdd                 = NO; //是否添加model
            _selectCenterCell      = NO;
            
            [self loopThroughAndAddEachPin];
        }
    }
    else   //途经点cell
    {
        if (!_selectFinish) //当终点坐标没有落下时 做处理
        {
            [self loopThroughAndAddEachPin];
            _selectFinish = YES;
        }
        
        if (_selectStar)   //当起始点坐标没有落下时 做处理
        {
            [self loopThroughAndAddEachPin];
            _selectStar = NO;
        }
        if (_add)
        {
            [self loopThroughAndAddEachPin];               //顺序不能变
            
            _AnnType                 = 3;
            _add                     = !_add;              //用于判断是否点击了加号
            _selectCenterCell        = !_selectCenterCell; //用于判断当前选择的cell颜色是否为红
            _PassingBtn.hidden       = NO;
            _startBtn  .hidden       = YES;
            _finishBtn .hidden       = YES;
            _noAdd                   = YES;                //是否添加model
           
            luShuModel * model       = _lastCoor[indexPath.row];
            if ((model.coor.latitude == 0) && (model.coor.longitude == 0))
            {
                luShuModel * nilModel     = _lastCoor[indexPath.row -1];
                _mapView.centerCoordinate = nilModel.coor;   //回到地图中心点
            }
            else
            {
                _mapView.centerCoordinate = model.coor;      //回到地图中心点
            }
            
            //遍历所有大头针
            for (_CustomPoint in _mapView.annotations)
            {
                //找到与当前匹配的大头针 并将其移除
                if (_CustomPoint.coordinate.latitude == model.coor.latitude && _CustomPoint.coordinate.longitude == model.coor.longitude)
                {
                    [_mapView removeAnnotation:_CustomPoint];
                }
            }
        }
        else
        {
            [self loopThroughAndAddEachPin];                 //顺序不能变
            
            _add                     = !_add;
            _selectCenterCell        = !_selectCenterCell;
            _AnnType                 = 3;
            _PassingBtn.hidden       = YES;
            _startBtn  .hidden       = YES;
            _finishBtn .hidden       = YES;
            _noAdd                   =  NO;                   //是否添加model
        }
    }
}

#pragma mark - tableView左划删除 代理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexRow = indexPath.row;
    _index    = indexPath;     //判断是否选择当前cell 用于单选 cell的文字变化
    
    if (_dataArr.count <= 3)
    {
        _startBtn  .hidden  = YES;
        _PassingBtn.hidden  = YES;
        _finishBtn .hidden  = YES;
        return;
    }
    
    luShuModel * model = _dataArr[indexPath.row];
    for (_CustomPoint in _mapView.annotations)
    {
        if (_CustomPoint.coordinate.latitude  == model.coor.latitude && _CustomPoint.coordinate.longitude == model.coor.longitude)
        {
            [_mapView removeAnnotation:_CustomPoint];
            [_lastCoor removeObjectAtIndex:indexPath.row];
            [_dataArr  removeObjectAtIndex:indexPath.row];
        }
    }
    [_tableView reloadData];
}

#pragma mark 是否允许删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 )
    {
        return NO;
    }
    
    if (indexPath.row == _dataArr.count - 1)
    {
        return NO;
    }

    return YES;//不允许编辑
}

#pragma mark 删除 （必须写代理不然不执行）
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _dataArr.count - 2)
    {
        return @"添加";
    }
    return @"删除";
}

#pragma mark - 循环并添加每个大头针
- (void)loopThroughAndAddEachPin
{
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (NSInteger i = 0; i < _dataArr.count; i++)
    {
        luShuModel * model = _dataArr[i];
        
        if (i == 0) //起始点cell
        {
            _AnnType                = 0;
            _CustomPoint            = [[BMKPointAnnotation alloc] init];
            _CustomPoint.title      = @"起始";
            _CustomPoint.subtitle   = model.city;
            _CustomPoint.coordinate = model.coor;
            [_mapView addAnnotation:_CustomPoint];
            
            luShuModel * lastModel  = [[luShuModel alloc]init];
            lastModel.coor          = model.coor;
            lastModel.city          = model.city;
            [_lastCoor replaceObjectAtIndex:i withObject:lastModel];
        }
        else
        {
            if (i == _dataArr.count - 2)        //添加途经点cell
            {
                luShuModel * lastModel     = [[luShuModel alloc]init];
                [_lastCoor replaceObjectAtIndex:i withObject:lastModel];
            }
            else if (i == _dataArr.count - 1)   //终点cell
            {
               _AnnType                    = 1;
               _CustomPoint                = [[BMKPointAnnotation alloc] init];
               _CustomPoint.title          = @"终点";
               _CustomPoint.subtitle       = model.city;
               _CustomPoint.coordinate     = model.coor;
               [_mapView addAnnotation:_CustomPoint];
               
               luShuModel * lastModel      = [[luShuModel alloc]init];
               lastModel.coor              = model.coor;
               lastModel.city              = model.city;
               [_lastCoor replaceObjectAtIndex:i withObject:lastModel];
            }
            else //途径点cell
            {
               _AnnType                    = 3;
               _CustomPoint                = [[BMKPointAnnotation alloc] init];
               _CustomPoint.title          = @"途经点";
               _CustomPoint.subtitle       = model.city;
               _CustomPoint.coordinate     = model.coor;
               [_mapView addAnnotation:_CustomPoint];
               
               luShuModel * lastModel      = [[luShuModel alloc]init];
               lastModel.coor              = model.coor;
               lastModel.city              = model.city;
               [_lastCoor replaceObjectAtIndex:i withObject:lastModel];
            }
        }
        [_tableView reloadData];
    }
}

#pragma mark - 上传服务器将所有大头针落下
- (void)endloopThroughAndAddEachPin
{
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (NSInteger i = 0; i < _dataArr.count; i++)
    {
        luShuModel * model = _dataArr[i];
        
        if (i == 0) //起始点cell
        {
            _selectStar             = NO;
            _CustomPoint            = [[BMKPointAnnotation alloc] init];
            _CustomPoint.title      = @"起始";
            _CustomPoint.subtitle   = model.city;
            _CustomPoint.coordinate = model.coor;
            _AnnType                = 0;
            [_mapView addAnnotation:_CustomPoint];
            
            luShuModel * lastModel  = [[luShuModel alloc]init];
            lastModel.coor          = model.coor;
            lastModel.city          = model.city;
            [_lastCoor replaceObjectAtIndex:i withObject:lastModel];
        }
        else
        {
            if (i == _dataArr.count - 2)        //添加途经点cell
            {
                luShuModel * lastModel     = [[luShuModel alloc]init];
                [_lastCoor replaceObjectAtIndex:i withObject:lastModel];
            }
            else if (i == _dataArr.count - 1)   //终点cell
            {
                _selectFinish               = YES;
                _AnnType                    = 1;
                _CustomPoint                = [[BMKPointAnnotation alloc] init];
                _CustomPoint.title          = @"终点";
                _CustomPoint.subtitle       = model.city;
                _CustomPoint.coordinate     = model.coor;
                [_mapView addAnnotation:_CustomPoint];
                
                luShuModel * lastModel      = [[luShuModel alloc]init];
                lastModel.coor              = model.coor;
                lastModel.city              = model.city;
                [_lastCoor replaceObjectAtIndex:i withObject:lastModel];
            }
            else //途径点cell
            {
                _selectCenterCell           = YES;
                _AnnType                    = 3;
                _CustomPoint                = [[BMKPointAnnotation alloc] init];
                _CustomPoint.title          = @"途经点";
                _CustomPoint.subtitle       = model.city;
                _CustomPoint.coordinate     = model.coor;
                [_mapView addAnnotation:_CustomPoint];
                
                luShuModel * lastModel      = [[luShuModel alloc]init];
                lastModel.coor              = model.coor;
                lastModel.city              = model.city;
                [_lastCoor replaceObjectAtIndex:i withObject:lastModel];
            }
            
        }
        
        [_tableView reloadData];
        
    }
}


#pragma mark - 设置导航控制器
- (void)setNavigationController
{
    self.view.backgroundColor                     = [UIColor whiteColor];
    // 导航栏颜色
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[AppTools imageWithColor:NAVIGATIONBAR_COLOR]
                                                  forBarMetrics:UIBarMetricsDefault];
    // 标题
    UILabel *titleLabel                           = [AppTools createLabelText:@"路书制作" Color:[UIColor whiteColor] Font:16 TextAlignment:NSTextAlignmentCenter];
    titleLabel.font                               = [UIFont systemFontOfSize:16];
    titleLabel.frame                              = CGRectMake(0, 0, 100, 30);
    titleLabel.userInteractionEnabled             = YES;
    self.navigationItem.titleView                 = titleLabel;
    
    // 设置导航栏左侧按钮
    UIBarButtonItem * multiItem                   = [UIBarButtonItem itemWithImage:@"determine@2x"
                                                                         highImage:@"determine@2x"
                                                                            target:self
                                                                            action:@selector(righrClick)];
    
    self.navigationItem.rightBarButtonItems       = @[multiItem];
    
}

//预览
- (void)preview
{
    UIImageView * image =[[UIImageView alloc]initWithFrame:self.view.frame];
    image.image = [self getCapture];
    [self.view addSubview:image];
}

#pragma mark - 上传服务器所有坐标点
- (void)righrClick
{
    [self endloopThroughAndAddEachPin]; //如果还有大头针没有落下做处理
    _startBtn  .hidden  = YES;          //隐藏开始浮动btn
    _PassingBtn.hidden  = YES;          //隐藏途经点浮动btn
    _finishBtn .hidden  = YES;          //隐藏终点浮动btn
    _noAdd              =  NO;          //关闭添加model
    _add                =  NO;          //
    
    if (_selectStar)
    {
        [self showHint:@"请设置起点"];
        return;
    }

    luShuModel * LastModel = _dataArr[_dataArr.count -1];
    if (LastModel.coor.latitude == 0)
    {
        [self showHint:@"请设置终点"];
        return;
    }
    
    if (!_selectCenterCell)
    {
        [self showHint:@"请确认途经点"];
        return;
    }
    
    if (!_selectFinish)
    {
        [self showHint:@"请确认终点"];
        return;
    }

    for (NSInteger i = 0; i< _lastCoor.count; i++)
    {
        luShuModel * model  = _lastCoor[i];
        if (model.coor.latitude == 0)
        {
            continue;
        }
        NSString  * coorStr = [NSString stringWithFormat:@"%f,%f",model.coor.latitude,model.coor.longitude];
        NSString  * endStr  = [NSString stringWithFormat:@"%@|%@",_endStr,coorStr];
        _endStr = endStr;
    }
    // 去除 字符串第一个 ，
    NSMutableString * urlString = [NSMutableString stringWithString:_endStr];
    [urlString deleteCharactersInRange:NSMakeRange(0, 1)];
    
    //请求服务器
    NSDictionary * userIdDic = @{@"dicKey":@"coordinate", @"data":urlString};
    NSArray      * postArr   = @[userIdDic];
    NSString     * url       = [NSString stringWithFormat:@"%@/roadBook/createRoadBook?",SERVER_URL];

    [ServerUtility POSTAction:url param:postArr target:nil finish:^(NSData *data, NSDictionary *obj, NSError *error)
    {
         if (error == nil)
         {
             NSString * gpxUrl      = obj[@"gpxFileUri"];
             NSString * GPXFileName = [gpxUrl substringFromIndex:gpxUrl.length - 21]; //截取掉下标21之前的字符串
             [ServerUtility downloadUrl:gpxUrl GPXFileblock:^(NSURL *gpxFileUrl)      //下载gpx文件
             {
                 NoteXMLParser * XML = [[NoteXMLParser alloc]init];                   // 苹果自带XML解析
                 XML.gpxFileName     = GPXFileName;
                 [XML start];//开始解析
             }
                   loadDownFileProgress:^(CGFloat progress, CGFloat total, CGFloat current)
             {
//                 NSlog(@"gpx文件加载%.2f",progress);
             }];
         }
        
        NSlog(@"error------%@",error);
    }];
    
}

#pragma mark - 处理通知 画线
- (void)reloadView:(NSNotification*)notification
{
    NSlog(@"1994-notification------%@",notification);
    NSMutableArray * resList     = [notification object];
    _GPSDataArr                  = resList;

    for (int i = 0; i<= _GPSDataArr.count ;i++)
    {
        NSString * locationStr1  = [_GPSDataArr objectAtIndex:i][@"Location_XML"];
        NSArray  * temp1         = [locationStr1 componentsSeparatedByString:@","];
        NSString * latitudeStr1  = temp1[0];
        NSString * longitudeStr1 = temp1[1];
        
        if(_GPSDataArr.count - 1 < i + 1) //当到最后一个坐标点的时候取消画线，结束循环
        {
            break;
        }
        
        //从位置数组中取出最新的位置数据
        NSString * locationStr2  = [_GPSDataArr objectAtIndex:i+1][@"Location_XML"];
        NSArray  * temp2         = [locationStr2 componentsSeparatedByString:@","];
        NSString * latitudeStr2  = temp2[0];
        NSString * longitudeStr2 = temp2[1];
        
        CLLocationCoordinate2D commonPolylineCoords[2];
        commonPolylineCoords[0].latitude  = [latitudeStr1 doubleValue];
        commonPolylineCoords[0].longitude = [longitudeStr1 doubleValue];
        
        commonPolylineCoords[1].latitude  = [latitudeStr2 doubleValue];
        commonPolylineCoords[1].longitude = [longitudeStr2 doubleValue];
        
        _polyline = [BMKPolyline polylineWithCoordinates:commonPolylineCoords count:2];
        
        [_mapView addOverlay:_polyline];//将线段对象画在地图中
    }
}

#pragma mark - 根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView * polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor       = [[UIColor redColor]  colorWithAlphaComponent:1];
        polylineView.lineWidth         = 3.5;
        return polylineView;
    }
    return nil;
}

#pragma mark - 返回定位坐标点
- (void)createCoorCenterBtn
{
    UIButton * coorCenterBtn             = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40,SCREEN_HEIGHT / 2 - 40,30,30)];
    coorCenterBtn.backgroundColor        = [UIColor redColor];
    [coorCenterBtn addTarget:self action:@selector(coorCenterClock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coorCenterBtn];
}

- (void)coorCenterClock
{
    _mapView.centerCoordinate = _CenterCoordinate2D;   //回到地图中心点
}

#pragma mark - scroll的全部截屏
- (UIImage*)getCapture
{
    UIImage     * viewImage        = nil;
    UITableView * scrollView       = _tableView;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame          = scrollView.frame;
        
        scrollView.contentOffset   = CGPointZero;
        scrollView.frame           = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset   = savedContentOffset;
        scrollView.frame           = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    return viewImage;
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
