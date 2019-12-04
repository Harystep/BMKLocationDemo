//
//  BMKPOIDetailSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOIDetailSearchPage.h"
#import "BMKPOIDetailParametersPage.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKPOIDetailSearch";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKPoiSearchDelegate
 获取search的回调方法
 */
@interface BMKPOIDetailSearchPage ()<BMKMapViewDelegate, BMKPoiSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKPOIDetailSearchPage

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
    self.title = @"POI详情检索";
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

- (void)createSearchToolView{
    [self createToolBarsWithItemArray:
     @[@{@"leftItemTitle":@"POI的UID：",
         @"rightItemText":@"ba97895c02a6ddc7f60e775f",
         @"rightItemPlaceholder":@"输入POI的UID"},
       ]];
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKPOIDetailParametersPage *page = [[BMKPOIDetailParametersPage alloc] init];
    page.searchDataBlock = ^(BMKPOIDetailSearchOption *option) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"POI的UID：",
             @"rightItemText":[option.poiUIDs componentsJoinedByString:@","],
             @"rightItemPlaceholder":@"输入POI的UID"},
           ]];
        [self searchData:option];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    BMKPOIDetailSearchOption *detailOption = [[BMKPOIDetailSearchOption alloc] init];
    //POI的UID，从POI检索返回的BMKPoiResult结构中获取
    detailOption.poiUIDs = [self.dataArray[0] componentsSeparatedByString:@","];
    [self searchData:detailOption];
}

- (void)searchData:(BMKPOIDetailSearchOption *)option {
    //初始化BMKPoiSearch实例
    BMKPoiSearch *POISearch = [[BMKPoiSearch alloc] init];
    //设置POI检索的代理
    POISearch.delegate = self;
    //初始化请求参数类BMKPoiDetailSearchOption的实例
    BMKPOIDetailSearchOption *detailOption = [[BMKPOIDetailSearchOption alloc] init];
    //POI的唯一标识符集合，必选
    detailOption.poiUIDs = option.poiUIDs;
    /**
     POI检索结果详细程度
     
     BMK_POI_SCOPE_BASIC_INFORMATION: 基本信息
     BMK_POI_SCOPE_DETAIL_INFORMATION: 详细信息
     */
    detailOption.scope = option.scope;
    /**
     根据POI UID 发起POI详情检索：异步方法，返回结果在BMKPoiSearchDelegate
     的onGetPoiDetailResult里
     detailOption POI详情检索参数类
     成功返回YES，否则返回NO
     */
    BOOL flag = [POISearch poiDetailSearch:detailOption];
    if(flag) {
        NSLog(@"POI详情检索成功");
    } else {
        NSLog(@"POI详情检索失败");
    }
}

#pragma mark - BMKPoiSearchDelegate
/**
 POI详情检索结果回调
 
 @param searcher 检索对象
 @param poiDetailResult POI详情检索结果
 @param errorCode 错误码，@see BMKCloudErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPOIDetailSearchResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        BMKPoiInfo *info = poiDetailResult.poiInfoList.firstObject;
        //设置当前地图的中心点
        _mapView.centerCoordinate = info.pt;
        NSString *basicMessage = [NSString stringWithFormat:@"检索结果总数：%ld\n名称：%@\n纬度：%f\n经度：%f\n地址：%@\n电话：%@\nUID：%@\n省份：%@\n城市：%@\n行政区域：%@\n街景图ID：%@\n是否有详情信息：%d\n", (long)poiDetailResult.totalPOINum, info.name, info.pt.latitude, info.pt.longitude, info.address, info.phone, info.UID, info.province, info.city, info.area, info.streetID, info.hasDetailInfo];
        NSString *detailMessage = @"";
        if (info.hasDetailInfo) {
            BMKPOIDetailInfo *detailInfo = info.detailInfo;
            detailMessage = [NSString stringWithFormat:@"距离中心点的距离：%ld\n类型：%@\n标签：%@\n导航引导点坐标纬度：%f\n导航引导点坐标经度：%f\n详情页URL：%@\n商户的价格：%f\n营业时间：%@\n总体评分：%f\n口味评分：%f\n服务评分：%f\n环境评分：%f\n星级评分：%f\n卫生评分：%f\n技术评分：%f\n图片数目：%ld\n团购数目：%ld\n优惠数目：%ld\n评论数目：%ld\n收藏数目：%ld\n签到数目：%ld", (long)detailInfo.distance, detailInfo.type, detailInfo.tag, detailInfo.naviLocation.latitude, detailInfo.naviLocation.longitude, detailInfo.detailURL, detailInfo.price, detailInfo.openingHours, detailInfo.overallRating, detailInfo.tasteRating, detailInfo.serviceRating, detailInfo.environmentRating, detailInfo.facilityRating, detailInfo.hygieneRating, detailInfo.technologyRating, (long)detailInfo.imageNumber, (long)detailInfo.grouponNumber, (long)detailInfo.discountNumber, (long)detailInfo.commentNumber, (long)detailInfo.favoriteNumber, (long)detailInfo.checkInNumber];
        }
        [self alertMessage:[NSString stringWithFormat:@"%@%@", basicMessage, detailMessage]];
    }
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue - 35)];
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
