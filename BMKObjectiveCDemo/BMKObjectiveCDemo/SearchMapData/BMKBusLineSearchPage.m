//
//  BMKBusLineSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKBusLineSearchPage.h"
#import "BMKBusLineParametersPage.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKBusLineSearch";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKBusLineSearchDelegate
 获取search的回调方法
 */
@interface BMKBusLineSearchPage ()<BMKMapViewDelegate, BMKBusLineSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKBusLineSearchPage

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
    self.title = @"公交线路检索";
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
       @{@"leftItemTitle":@"公交线UID：",
         @"rightItemText":@"566982672f9427deb23c814d",
         @"rightItemPlaceholder":@"输入busLineUid"}
       ]];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    //初始化请求参数类BMKBusLineSearchOption的实例
    BMKBusLineSearchOption *buslineOption = [[BMKBusLineSearchOption alloc]init];
    //城市名
    buslineOption.city = self.dataArray[0];
    //公交线路的UID
    buslineOption.busLineUid = self.dataArray[1];
    [self searchData:buslineOption];
}

- (void)searchData:(BMKBusLineSearchOption *)option {
    //初始化BMKBusLineSearch实例
    BMKBusLineSearch *busLineSearch = [[BMKBusLineSearch alloc] init];
    //设置公交路线检索的代理
    busLineSearch.delegate = self;
    //初始化请求参数类BMKBusLineSearchOption的实例
    BMKBusLineSearchOption *buslineOption = [[BMKBusLineSearchOption alloc]init];
    //城市名
    buslineOption.city= option.city;
    //公交线路的UID
    buslineOption.busLineUid = option.busLineUid;
    /**
     公交详情检索，异步方法，返回结果在BMKBusLineSearchDelegate的
     onGetBusDetailResult里
     
     busLineOption 公交线路检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [busLineSearch busLineSearch:buslineOption];
    if(flag) {
        NSLog(@"公交路线检索成功");
    } else {
        NSLog(@"公交路线检索失败");
    }
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKBusLineParametersPage *page = [[BMKBusLineParametersPage alloc] init];
    page.searchDataBlock = ^(BMKBusLineSearchOption *option) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"城 市：",
             @"rightItemText":option.city,
             @"rightItemPlaceholder":@"输入城市"},
           @{@"leftItemTitle":@"公交线UID：",
             @"rightItemText":option.busLineUid,
             @"rightItemPlaceholder":@"输入busLineUid"}
           ]];
        [self searchData:option];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKBusLineSearchDelegate
/**
 公交路线检索结果回调
 
 @param searcher 检索对象
 @param busLineResult 公交路线检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetBusDetailResult:(BMKBusLineSearch *)searcher result:(BMKBusLineResult *)busLineResult errorCode:(BMKSearchErrorCode)error {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR) {
        NSString *message = [NSString stringWithFormat:@"公交公司：%@\n线路名称：%@\n线路方向：%@\n线路ID：%@\n首班车时间：%@\n末班车时间：%@\n起步票价：%.1f\n全程票价：%.1f",busLineResult.busCompany, busLineResult.busLineName, busLineResult.busLineDirection, busLineResult.uid, busLineResult.startTime, busLineResult.endTime, busLineResult.basicPrice, busLineResult.totalPrice];
        [self alertMessage:message];
        //遍历所有公交站点信息,成员类型为BMKBusStation
        [busLineResult.busStations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //公交站点信息
            BMKBusStation *station = busLineResult.busStations[idx];
            //初始化标注类BMKPointAnnotation的实例
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            //设置标注的经纬度坐标
            annotation.coordinate = station.location;
            //设置地图的中心点
            _mapView.centerCoordinate = annotation.coordinate;
            _mapView.zoomLevel = 12;
            //设置标注的标题
            annotation.title = station.title;
            /**
             
             当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
             来生成标注对应的View
             @param annotation 要添加的标注
             */
            [_mapView addAnnotation:annotation];
        }];
        
        __block NSInteger pointCount = 0;
        //遍历公交路线分段信息，成员类型为BMKBusStep
        [busLineResult.busSteps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //公交线路中的一个路段
            BMKBusStep *step = [busLineResult.busSteps objectAtIndex:idx];
            pointCount += step.pointsCount;
        }];
        //地理坐标点，用直角地理坐标表示
        BMKMapPoint *points = new BMKMapPoint[pointCount];
        [busLineResult.busSteps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //公交线路中的一个路段
            BMKBusStep *step = busLineResult.busSteps[idx];
            for (int i = 0; i < step.pointsCount; i ++) {
                points[i].x = step.points[i].x;
                points[i].y = step.points[i].y;
            }
        }];
        //根据指定直角坐标点生成一段折线
        BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:pointCount];
        /**
         向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
         来生成标注对应的View
         
         @param overlay 要添加的overlay
         */
        [_mapView addOverlay:polyline];
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
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        /**
         根据指定标识查找一个可被复用的标注，用此方法来代替新创建一个标注，返回可被复用的标注
         */
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
        if (!annotationView) {
            /**
             初始化并返回一个annotationView
             
             @param annotation 关联的annotation对象
             @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
             @return 初始化成功则返回annotationView，否则返回nil
             */
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
            NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mapapi.bundle"]];
            NSString *image = [[bundle resourcePath] stringByAppendingPathComponent:@"images/icon_nav_bus"];
            //annotationView显示的图片，默认是大头针
            annotationView.image = [UIImage imageWithContentsOfFile:image];
        }
        return annotationView;
    }
    return nil;
}

/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        //初始化一个overlay并返回相应的BMKPolylineView的实例
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        //设置polylineView的画笔颜色
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        //设置polylineView的线宽度
        polylineView.lineWidth = 4.0;
        return polylineView;
    }
    return nil;
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
