//
//  BMKGeoCodeSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKGeoCodeSearchPage.h"
#import "BMKGeoCodeParametersPage.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKGeoCodeSearch";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKGeoCodeSearchDelegate
 获取search的回调方法
 */
@interface BMKGeoCodeSearchPage ()<BMKMapViewDelegate, BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKGeoCodeSearchPage

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
    self.title = @"地理编码";
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
     @[@{@"leftItemTitle":@"城 市：",
         @"rightItemText":@"北京",
         @"rightItemPlaceholder":@"输入城市"},
       @{@"leftItemTitle":@"地 址：",
         @"rightItemText":@"百度科技园",
         @"rightItemPlaceholder":@"输入keyword"}
       ]];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeOption.address = self.dataArray[1];
    geoCodeOption.city = self.dataArray[0];
    [self searchData:geoCodeOption];
}

- (void)searchData:(BMKGeoCodeSearchOption *)option {
    //初始化BMKGeoCodeSearch实例
    BMKGeoCodeSearch *geoCodeSearch =[[BMKGeoCodeSearch alloc]init];
    //设置地理编码检索的代理
    geoCodeSearch.delegate = self;
    //初始化请求参数类BMKBMKGeoCodeSearchOption的实例
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    /**
     待解析的地址。必选。
     可以输入2种样式的值，分别是：
     1、标准的结构化地址信息，如北京市海淀区上地十街十号 【推荐，地址结构越完整，解析精度越高】
     2、支持“*路与*路交叉口”描述方式，如北一环路和阜阳路的交叉路口
     注意：第二种方式并不总是有返回结果，只有当地址库中存在该地址描述时才有返回。
     */
    geoCodeOption.address = option.address;
    /**
     地址所在的城市名。可选。
     用于指定上述地址所在的城市，当多个城市都有上述地址时，该参数起到过滤作用。
     注意：指定该字段，不会限制坐标召回城市。
     */
    geoCodeOption.city = option.city;
    /**
     根据地址名称获取地理信息：异步方法，返回结果在BMKGeoCodeSearchDelegate的
     onGetAddrResult里
     
     geoCodeOption geo检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [geoCodeSearch geoCode:geoCodeOption];
    if(flag) {
        NSLog(@"地理编码检索成功");
    } else {
        NSLog(@"地理检索失败");
    }
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKGeoCodeParametersPage *page = [[BMKGeoCodeParametersPage alloc] init];
    page.searchDataBlock = ^(BMKGeoCodeSearchOption *geoCodeOption) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"城 市：",
             @"rightItemText":geoCodeOption.city,
             @"rightItemPlaceholder":@"输入城市"},
           @{@"leftItemTitle":@"地 址：",
             @"rightItemText":geoCodeOption.address,
             @"rightItemPlaceholder":@"输入keyword"}
           ]];
        [self searchData:geoCodeOption];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 正向地理编码检索结果回调
 
 @param searcher 检索对象
 @param result 正向地理编码检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    /**
     移除一组标注
     
     @param annotations 要移除的标注数组
     */
    [_mapView removeAnnotations:_mapView.annotations];
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR) {
        NSString *message = [NSString stringWithFormat:@"纬度：%f\n经度：%f\n是否精确查找：%ld\n可信度：%ld\n地址类型：%@", result.location.latitude, result.location.longitude, (long)result.precise, (long)result.confidence, result.level];
        [self alertMessage:message];
        
        //初始化标注类BMKPointAnnotation的实例
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        //设置标注的经纬度坐标
        annotation.coordinate = result.location;
        /**
         
         当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
         来生成标注对应的View
         @param annotation 要添加的标注
         */
        [_mapView addAnnotation:annotation];
        //设置当前地图的中心点
        _mapView.centerCoordinate = annotation.coordinate;
    }
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
