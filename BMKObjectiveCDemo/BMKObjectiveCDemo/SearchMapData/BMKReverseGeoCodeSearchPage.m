//
//  BMKReverseGeoCodeSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/19.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKReverseGeoCodeSearchPage.h"
#import "BMKReverseGeoCodeParametersPage.h"

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKGeoCodeSearchDelegate
 获取search的回调方法
 */
@interface BMKReverseGeoCodeSearchPage ()<BMKMapViewDelegate, BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKReverseGeoCodeSearchPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
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
    self.title = @"反地理编码";
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc]initWithCustomView:self.customButton];
    self.navigationItem.rightBarButtonItem = customButton;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

- (void)createSearchToolView {
    [self createToolBarsWithItemArray:
     @[@{@"leftItemTitle":@"纬 度：",
         @"rightItemText":@"40.049850",
         @"rightItemPlaceholder":@"输入纬度"},
       @{@"leftItemTitle":@"经 度：",
         @"rightItemText":@"116.279920",
         @"rightItemPlaceholder":@"输入经度"}
       ]];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    //初始化请求参数类BMKReverseGeoCodeOption的实例
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    //经纬度
    reverseGeoCodeOption.location = CLLocationCoordinate2DMake([self.dataArray[0] floatValue], [self.dataArray[1] floatValue]);
    //是否访问最新版行政区划数据（仅对中国数据生效）
    reverseGeoCodeOption.isLatestAdmin = YES;
    [self searchData:reverseGeoCodeOption];
}

- (void)searchData:(BMKReverseGeoCodeSearchOption *)option {
    //初始化BMKGeoCodeSearch实例
    BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    //设置反地理编码检索的代理
    geoCodeSearch.delegate = self;
    //初始化请求参数类BMKReverseGeoCodeOption的实例
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    // 待解析的经纬度坐标（必选）
    reverseGeoCodeOption.location = option.location;
    //是否访问最新版行政区划数据（仅对中国数据生效）
    reverseGeoCodeOption.isLatestAdmin = option.isLatestAdmin;
    /**
     根据地理坐标获取地址信息：异步方法，返回结果在BMKGeoCodeSearchDelegate的
     onGetAddrResult里
     
     reverseGeoCodeOption 反geo检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    if (flag) {
        NSLog(@"反地理编码检索成功");
    } else {
        NSLog(@"反地理编码检索失败");
    }
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKReverseGeoCodeParametersPage *page = [[BMKReverseGeoCodeParametersPage alloc] init];
    page.searchDataBlock = ^(BMKReverseGeoCodeSearchOption *option) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"纬 度：",
             @"rightItemText":[NSString stringWithFormat:@"%f", option.location.latitude],
             @"rightItemPlaceholder":@"输入纬度"},
           @{@"leftItemTitle":@"经 度：",
             @"rightItemText":[NSString stringWithFormat:@"%f", option.location.longitude],
             @"rightItemPlaceholder":@"输入经度"}
           ]];
        [self searchData:option];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 反向地理编码检索结果回调
 
 @param searcher 检索对象
 @param result 反向地理编码检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    
    BMKPoiInfo *POIInfo = result.poiList.firstObject;
    BMKSearchRGCRegionInfo *regionInfo = [[BMKSearchRGCRegionInfo alloc] init];
    if (result.poiRegions.count > 0) {
        regionInfo = result.poiRegions[0];
    }
    
    NSString *message = [NSString stringWithFormat:@"经度：%f\n纬度：%f\n地址名称：%@\n商圈名称：%@\n可信度：%ld\n国家名称：%@\n省份名称：%@\n城市名称：%@\n区县名称：%@\n乡镇：%@\n街道名称：%@\n街道号码：%@\n行政区域编码：%@\n国家代码：%@\n方向：%@\n距离：%@\nPOI名称：%@\nPOI经纬坐标：%f\nPOI纬度坐标：%f\nPOI地址信息：%@\nPOI电话号码：%@\nPOI的唯一标识符：%@\nPOI所在省份：%@\nPOI所在城市：%@\nPOI所在行政区域：%@\n街景ID：%@\n是否有详情信息：%d\nPOI方向：%@\nPOI距离：%ld\nPOI邮编：%ld\nPOI类别tag：%@\n相对位置关系：%@\n归属区域面名称：%@\n归属区域面类型：%@\n语义化结果描述：%@", result.location.longitude, result.location.latitude, result.address, result.businessCircle, (long)result.confidence, result.addressDetail.country, result.addressDetail.province, result.addressDetail.city, result.addressDetail.district, result.addressDetail.town, result.addressDetail.streetName, result.addressDetail.streetNumber, result.addressDetail.adCode, result.addressDetail.countryCode, result.addressDetail.direction, result.addressDetail.distance, POIInfo.name, POIInfo.pt.longitude, POIInfo.pt.latitude, POIInfo.address, POIInfo.phone, POIInfo.UID, POIInfo.province, POIInfo.city, POIInfo.area, POIInfo.streetID, POIInfo.hasDetailInfo, POIInfo.direction, (long)POIInfo.distance, (long)POIInfo.zipCode,POIInfo.tag, regionInfo.regionDescription, regionInfo.regionName, regionInfo.regionTag, result.sematicDescription];
    
    [self alertMessage:message];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue - 35 * 2)];
    }
    return _mapView;
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
