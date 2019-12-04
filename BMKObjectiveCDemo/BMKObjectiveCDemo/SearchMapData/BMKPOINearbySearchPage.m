//
//  BMKPOINearbySearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOINearbySearchPage.h"
#import "BMKPOINearbyParametersPage.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKPOINearbySearch";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKPoiSearchDelegate
 获取search的回调方法
 */
@interface BMKPOINearbySearchPage ()<BMKMapViewDelegate, BMKPoiSearchDelegate, UITextFieldDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, strong) UITextField *keywordTextField;
@property (nonatomic, strong) UITextField *lonTextField;
@property (nonatomic, strong) UITextField *latTextField;
@end

@implementation BMKPOINearbySearchPage

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
    self.title = @"POI周边检索";
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
         @"rightItemText":@"40.049557",
         @"rightItemPlaceholder":@"输入latitude"},
       @{@"leftItemTitle":@"经 度：",
         @"rightItemText":@"116.279295",
         @"rightItemPlaceholder":@"输入longitude"},
       @{@"leftItemTitle":@"关键字：",
         @"rightItemText":@"小吃",
         @"rightItemPlaceholder":@"输入关键字"}
       ]];
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKPOINearbyParametersPage *page = [[BMKPOINearbyParametersPage alloc] init];
    page.searchDataBlock = ^(BMKPOINearbySearchOption *option) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"纬 度：",
             @"rightItemText":[NSString stringWithFormat:@"%f", option.location.latitude],
             @"rightItemPlaceholder":@"输入latitude"},
           @{@"leftItemTitle":@"经 度：",
             @"rightItemText":[NSString stringWithFormat:@"%f", option.location.longitude],
             @"rightItemPlaceholder":@"输入longitude"},
           @{@"leftItemTitle":@"关键字：",
             @"rightItemText":[option.keywords componentsJoinedByString:@","],
             @"rightItemPlaceholder":@"输入关键字"}
           ]];
        [self searchData:option];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    //初始化请求参数类BMKNearbySearchOption的实例
    BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc]init];
    //检索关键字
    nearbyOption.keywords = [self.dataArray[2] componentsSeparatedByString:@","];
    //检索的中心点
    nearbyOption.location = CLLocationCoordinate2DMake([self.dataArray[0] floatValue], [self.dataArray[1] floatValue]);
    [self searchData:nearbyOption];
}

- (void)searchData:(BMKPOINearbySearchOption *)option {
    //初始化BMKPoiSearch实例
    BMKPoiSearch *POISearch = [[BMKPoiSearch alloc] init];
    //设置POI检索的代理
    POISearch.delegate = self;
    //初始化请求参数类BMKNearbySearchOption的实例
    BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc]init];
    /**
     检索关键字，必选。
     在周边检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
     最多支持10个关键字。
     */
    nearbyOption.keywords = option.keywords;
    //检索中心点的经纬度，必选
    nearbyOption.location = option.location;
    /**
     检索半径，单位是米。
     当半径过大，超过中心点所在城市边界时，会变为城市范围检索，检索范围为中心点所在城市
     */
    nearbyOption.radius = option.radius;
    /**
     检索分类，可选。
     该字段与keywords字段组合进行检索。
     支持多个分类，如美食和酒店。每个分类对应数组中一个元素
     */
    nearbyOption.tags = option.tags;
    /**
     是否严格限定召回结果在设置检索半径范围内。默认值为false。
     值为true代表检索结果严格限定在半径范围内；值为false时不严格限定。
     注意：值为true时会影响返回结果中total准确性及每页召回poi数量，我们会逐步解决此类问题。
     */
    nearbyOption.isRadiusLimit = option.isRadiusLimit;
    /**
     POI检索结果详细程度
     
     BMK_POI_SCOPE_BASIC_INFORMATION: 基本信息
     BMK_POI_SCOPE_DETAIL_INFORMATION: 详细信息
     */
    nearbyOption.scope = option.scope;
    //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
    nearbyOption.filter = option.filter;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    nearbyOption.pageIndex = option.pageIndex;
    //单次召回POI数量，默认为10条记录，最大返回20条。
    nearbyOption.pageSize = option.pageSize;
    /**
     根据中心点、半径和检索词发起周边检索：异步方法，返回结果在BMKPoiSearchDelegate
     的onGetPoiResult里
     
     nearbyOption 周边搜索的搜索参数类
     成功返回YES，否则返回NO
     */
    BOOL flag = [POISearch poiSearchNearBy:nearbyOption];
    if(flag) {
        NSLog(@"POI周边检索成功");
    } else {
        NSLog(@"POI周边检索失败");
    }
}

#pragma mark - BMKPoiSearchDelegate
/**
 POI检索返回结果回调
 
 @param searcher 检索对象
 @param poiResult POI检索结果列表
 @param error 错误码
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)error {
    /**
     移除一组标注
     
     @param annotations 要移除的标注数组
     */
    [_mapView removeAnnotations:_mapView.annotations];
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (NSUInteger i = 0; i < poiResult.poiInfoList.count; i ++) {
            //POI信息类的实例
            BMKPoiInfo *POIInfo = poiResult.poiInfoList[i];
            //初始化标注类BMKPointAnnotation的实例
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
            //设置标注的经纬度坐标
            annotation.coordinate = POIInfo.pt;
            //设置标注的标题
            annotation.title = POIInfo.name;
            [annotations addObject:annotation];
        }
        //将一组标注添加到当前地图View中
        [_mapView addAnnotations:annotations];
        BMKPointAnnotation *annotation = annotations[0];
        //设置当前地图的中心点
        _mapView.centerCoordinate = annotation.coordinate;
    }
    //POI信息类的实例
    BMKPoiInfo *info = poiResult.poiInfoList[0];
    NSString *basicMessage = [NSString stringWithFormat:@"检索结果总数：%ld\n总页数：%ld\n当前页的结果数：%ld\n当前页的页数索引：%ld\n名称：%@\n纬度：%f\n经度：%f\n地址：%@\n电话：%@\nUID：%@\n省份：%@\n城市：%@\n行政区域：%@\n街景图ID：%@\n是否有详情信息：%d\n", (long)poiResult.totalPOINum, (long)poiResult.totalPageNum, (long)poiResult.curPOINum, (long)poiResult.curPageIndex, info.name, info.pt.latitude, info.pt.longitude, info.address, info.phone, info.UID, info.province, info.city, info.area, info.streetID, info.hasDetailInfo];
    NSString *detailMessage = @"";
    if (info.hasDetailInfo) {
        BMKPOIDetailInfo *detailInfo = info.detailInfo;
        detailMessage = [NSString stringWithFormat:@"距离中心点的距离：%ld\n类型：%@\n标签：%@\n导航引导点坐标纬度：%f\n导航引导点坐标经度：%f\n详情页URL：%@\n商户的价格：%f\n营业时间：%@\n总体评分：%f\n口味评分：%f\n服务评分：%f\n环境评分：%f\n星级评分：%f\n卫生评分：%f\n技术评分：%f\n图片数目：%ld\n团购数目：%ld\n优惠数目：%ld\n评论数目：%ld\n收藏数目：%ld\n签到数目：%ld", (long)detailInfo.distance, detailInfo.type, detailInfo.tag, detailInfo.naviLocation.latitude, detailInfo.naviLocation.longitude, detailInfo.detailURL, detailInfo.price, detailInfo.openingHours, detailInfo.overallRating, detailInfo.tasteRating, detailInfo.serviceRating, detailInfo.environmentRating, detailInfo.facilityRating, detailInfo.hygieneRating, detailInfo.technologyRating, (long)detailInfo.imageNumber, (long)detailInfo.grouponNumber, (long)detailInfo.discountNumber, (long)detailInfo.commentNumber, (long)detailInfo.favoriteNumber, (long)detailInfo.checkInNumber];
    }
    [self alertMessage:[NSString stringWithFormat:@"%@%@", basicMessage, detailMessage]];
}

#pragma mark - BMKMapViewDelegate
/**
 根据anntation生成对应的annotationView
 
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    /**
     根据指定标识查找一个可被复用的标注，用此方法来代替新创建一个标注，返回可被复用的标注
     */
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
    if (!annotationView) {
        /**
         初始化并返回一个annotationView
         
         @param annotation 关联的annotation对象
         @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
         @return 初始化成功则返回annotationView，否则返回nil
         */
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
        /**
         annotationView的颜色： BMKPinAnnotationColorRed，BMKPinAnnotationColorGreen，
         BMKPinAnnotationColorPurple
         */
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        //设置从天而降的动画效果
        ((BMKPinAnnotationView *)annotationView).animatesDrop = YES;
    }
    //annotationView关联的annotation
    annotationView.annotation = annotation;
    return annotationView;
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue - 35 * 3)];
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
