//
//  BMKPOIIndoorSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOIIndoorSearchPage.h"
#import "BMKPOIIndoorParametersPage.h"

static NSString *cellIdentifier = @"com.Baidu.BMKPOIIndoorTableViewCell";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKPoiSearchDelegate
 获取search的回调方法
 */
@interface BMKPOIIndoorSearchPage ()<BMKMapViewDelegate, BMKPoiSearchDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKBaseIndoorMapInfo *baseIndoorMapInfo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, assign) BOOL isFromParametersPage;
@end

@implementation BMKPOIIndoorSearchPage

#pragma mark - Initialization method
- (instancetype)init {
    if (self) {
        self = [super init];
        //初始化BMKBaseIndoorMapInfo的实例
        BMKBaseIndoorMapInfo *indoorMapInfo = [[BMKBaseIndoorMapInfo alloc] init];
        _baseIndoorMapInfo = indoorMapInfo;
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMapView];
    [self configUI];
    [self createTableView];
    [self createSearchToolView];
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"POI室内检索";
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc]initWithCustomView:self.customButton];
    self.navigationItem.rightBarButtonItem = customButton;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.view addSubview:self.tableView];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //设置当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.917, 116.379);
    //设置地图比例尺级别
    _mapView.zoomLevel = 20;
    //设定地图是否显示室内图（包含室内图标注），默认不显示
    _mapView.baseIndoorMapEnabled = YES;
    //设置地图View的delegate
    _mapView.delegate = self;
}

- (void)createSearchToolView {
    [self createToolBarsWithItemArray:
     @[@{@"leftItemTitle":@"室内ID：",
         @"rightItemText":@"1261284358413615103",
         @"rightItemPlaceholder":@"输入indoorID"},
       @{@"leftItemTitle":@"关键字：",
         @"rightItemText":@"小吃",
         @"rightItemPlaceholder":@"输入keyword"}
       ]];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    //初始化请求参数类BMKPoiIndoorSearchOption的实例
    BMKPOIIndoorSearchOption *indoorOption = [[BMKPOIIndoorSearchOption alloc] init];
    //室内ID，必选
    indoorOption.indoorID = _baseIndoorMapInfo.strID;
    //楼层设置后，会优先获取该楼层的室内POI，然后是其它楼层的，可选
    indoorOption.floor = _baseIndoorMapInfo.strFloor;
    //检索关键字
    indoorOption.keyword = @"小吃";
    [self searchData:indoorOption];
}

- (void)searchData:(BMKPOIIndoorSearchOption *)option {
    //初始化BMKPoiSearch实例
    BMKPoiSearch *search = [[BMKPoiSearch alloc] init];
    //设置POI检索的代理
    search.delegate = self;
    //初始化请求参数类BMKPoiIndoorSearchOption的实例
    BMKPOIIndoorSearchOption *indoorOption = [[BMKPOIIndoorSearchOption alloc] init];
    //室内检索唯一标识符，必选
    indoorOption.indoorID = option.indoorID;
    //室内检索关键字，必选
    indoorOption.keyword = option.keyword;
    //楼层（可选），设置后，会优先获取该楼层的室内POI，然后是其它楼层的。如“F3”,"B3"等。
    indoorOption.floor = option.floor;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    indoorOption.pageIndex = option.pageIndex;
    //单次召回POI数量，默认为10条记录，最大返回20条
    indoorOption.pageSize = option.pageSize;
    /**
     POI室内检索：异步方法，返回结果在BMKPoiSearchDelegate的
     onGetPoiIndoorResult里
     
     option POI室内检索参数类（BMKPoiIndoorSearchOption）
     return 成功返回YES，否则返回NO
     */
    BOOL flag = [search poiIndoorSearch:indoorOption];
    if(flag) {
        NSLog(@"POI室内检索成功");
    } else {
        NSLog(@"POI室内检索失败");
    }
}

- (void)createTableView {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKPOIIndoorParametersPage *page = [[BMKPOIIndoorParametersPage alloc] init];
    page.searchDataBlock = ^(BMKPOIIndoorSearchOption *option, BOOL isFromParametersPage) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"室内ID：",
             @"rightItemText":option.indoorID,
             @"rightItemPlaceholder":@"输入indoorID"},
           @{@"leftItemTitle":@"关键字：",
             @"rightItemText":option.keyword,
             @"rightItemPlaceholder":@"输入keyword"}
           ]];
        [self searchData:option];
        _isFromParametersPage = isFromParametersPage;
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKPoiSearchDelegate
/**
 POI室内检索结果回调
 
 @param searcher 检索对象
 @param poiIndoorResult POI室内检索结果
 @param errorCode 错误码，@see BMKCloudErrorCode
 */
- (void)onGetPoiIndoorResult:(BMKPoiSearch *)searcher result:(BMKPOIIndoorSearchResult *)poiIndoorResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //室内POI信息类POI
        BMKPoiIndoorInfo *POIIndoorInfo = poiIndoorResult.poiIndoorInfoList.firstObject;
        //设置当前地图的中心点
        _mapView.centerCoordinate = POIIndoorInfo.pt;
        NSString *message = [NSString stringWithFormat:@"总结果数：%ld\n当前页的POI结果数：%ld\n总页数：%ld\n当前页的页数索引：%ld\nPOI名称：%@\nPOI唯一标识符：%@\n室内ID：%@\n所在楼层：%@\n地址：%@\n所在城市：%@\n电话号码：%@\n纬度坐标：%f\n经度坐标：%f\n标签：%@\n价格：%f\n星级：%ld\n是否有团购：%d\n是否有外卖：%d\n是否排队：%d\n团购数：%ld\n折扣数：%ld\n", (long)poiIndoorResult.totalPOINum, (long)poiIndoorResult.curPOINum, (long)poiIndoorResult.totalPageNum, (long)poiIndoorResult.curPageIndex, POIIndoorInfo.name, POIIndoorInfo.UID, POIIndoorInfo.indoorID, POIIndoorInfo.floor, POIIndoorInfo.address, POIIndoorInfo.city, POIIndoorInfo.phone, POIIndoorInfo.pt.latitude, POIIndoorInfo.pt.longitude, POIIndoorInfo.tag, POIIndoorInfo.price, (long)POIIndoorInfo.starLevel, POIIndoorInfo.grouponFlag, POIIndoorInfo.takeoutFlag, POIIndoorInfo.waitedFlag, (long)POIIndoorInfo.grouponNum, (long)POIIndoorInfo.discount];
        [self alertMessage:message];
    } else {
        [self alertMessage:@"检索失败"];
    }
}

- (void)alertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检索结果" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _isFromParametersPage = false;
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BMKMapViewDelegate
/**
 地图View进入/移出室内图会调用此方法
 
 @param mapView 地图View
 @param flag YES:进入室内图，NO：移出室内图
 @param info 室内图信息
 */
- (void)mapview:(BMKMapView *)mapView baseIndoorMapWithIn:(BOOL)flag baseIndoorMapInfo:(BMKBaseIndoorMapInfo *)info {
    _tableView.hidden = YES;
    if (info && info.arrStrFloors.count > 0) {
        //室内ID
        _baseIndoorMapInfo.strID = info.strID;
        //当前楼层
        _baseIndoorMapInfo.strFloor = info.strFloor;
        //所有楼层信息
        _baseIndoorMapInfo.arrStrFloors = info.arrStrFloors;
        _tableView.hidden = NO;
        [_tableView reloadData];
        
        if (!_isFromParametersPage) {
            [self createToolBarsWithItemArray:
             @[@{@"leftItemTitle":@"室内ID：",
                 @"rightItemText":info.strID,
                 @"rightItemPlaceholder":@"输入indoorID"},
               @{@"leftItemTitle":@"关键字：",
                 @"rightItemText":@"小吃",
                 @"rightItemPlaceholder":@"输入keyword"}
               ]];
        }
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *floor = [NSString stringWithFormat:@"%@", _baseIndoorMapInfo.arrStrFloors[indexPath.row]];
    cell.textLabel.text = floor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //所有楼层信息
    return _baseIndoorMapInfo.arrStrFloors.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     设置室内图楼层
     baseIndoorMapInfo.arrStrFloors 楼层
     baseIndoorMapInfo.strID 室内图ID
     切换结果
     */
    BMKSwitchIndoorFloorError error = [_mapView switchBaseIndoorMapFloor:_baseIndoorMapInfo.arrStrFloors[indexPath.row] withID:_baseIndoorMapInfo.strID];
    //BMKSwitchIndoorFloorError错误码：切换楼层成功
    if (error == BMKSwitchIndoorFloorSuccess) {
        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20 * widthScale, KScreenHeight - 150 - 100 - kViewTopHeight, 75 * widthScale, 150) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)customButton {
    if (!_customButton) {
        _customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_customButton setTitle:@"详细参数" forState:UIControlStateNormal];
        [_customButton setTitle:@"详细参数" forState:UIControlStateHighlighted];
        [_customButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_customButton setFrame:CGRectMake(0, 3, 69, 20)];
        [_customButton addTarget:self action:@selector(clickCustomButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
}

@end
