//
//  BMKDrivingRouteSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKDrivingRouteSearchPage.h"
#import "BMKDrivingRouteParametersPage.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKDrivingRouteSearch";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKRouteSearchDelegate
 获取drivingRouteSearch的回调方法
 **/
@interface BMKDrivingRouteSearchPage ()<BMKMapViewDelegate, BMKRouteSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton; //自定义检索参数按钮
@property (nonatomic, strong) BMKRouteSearch *drivingRouteSearch;
@end

@implementation BMKDrivingRouteSearchPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self createSearchToolView];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"驾车路线";
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc]initWithCustomView:self.customButton];
    self.navigationItem.rightBarButtonItem = customButton;
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

- (void)createSearchToolView {
    [self createToolBarsWithItemArray:
     @[@{@"leftItemTitle":@"起点名称：",
         @"rightItemText":@"天安门",
         @"rightItemPlaceholder":@"输入起点名称"},
       @{@"leftItemTitle":@"起点所在城市：",
         @"rightItemText":@"北京市",
         @"rightItemPlaceholder":@"输入起点城市"},
       @{@"leftItemTitle":@"终点名称：",
         @"rightItemText":@"百度科技园",
         @"rightItemPlaceholder":@"输入终点名称"},
       @{@"leftItemTitle":@"终点所在城市：",
         @"rightItemText":@"北京市",
         @"rightItemPlaceholder":@"输入终点城市"}
       ]];
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKDrivingRouteParametersPage *page = [[BMKDrivingRouteParametersPage alloc] init];
    page.searchDataBlock = ^(BMKDrivingRoutePlanOption *option) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"起点名称：",
             @"rightItemText":option.from.name,
             @"rightItemPlaceholder":@"输入起点名称"},
           @{@"leftItemTitle":@"起点所在城市：",
             @"rightItemText":option.from.cityName,
             @"rightItemPlaceholder":@"输入起点城市"},
           @{@"leftItemTitle":@"终点名称：",
             @"rightItemText":option.to.name,
             @"rightItemPlaceholder":@"输入终点名称"},
           @{@"leftItemTitle":@"终点所在城市：",
             @"rightItemText":option.to.cityName,
             @"rightItemPlaceholder":@"输入终点城市"}
           ]];
        [self searchData:option];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    BMKDrivingRoutePlanOption *drivingRoutePlanOption = [[BMKDrivingRoutePlanOption alloc] init];
    //实例化线路检索节点信息类对象
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    //起点名称
    start.name = self.dataArray[0];
    //起点所在城市
    start.cityName = self.dataArray[1];
    //实例化线路检索节点信息类对象
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    //终点名称
    end.name = self.dataArray[2];
    //终点所在城市
    end.cityName = self.dataArray[3];
    //检索的起点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
    drivingRoutePlanOption.from = start;
    //检索的终点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
    drivingRoutePlanOption.to = end;
    [self searchData:drivingRoutePlanOption];
}

- (void)searchData:(BMKDrivingRoutePlanOption *)option {
    //初始化BMKRouteSearch实例
    _drivingRouteSearch = [[BMKRouteSearch alloc]init];
    //设置驾车路径的规划
    _drivingRouteSearch.delegate = self;
    /*
     线路检索节点信息类，一个路线检索节点可以通过经纬度坐标或城市名加地名确定
     */
    //实例化线路检索节点信息类对象
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    //起点名称
    start.name = option.from.name;
    //起点所在城市，注：cityName和cityID同时指定时，优先使用cityID
    start.cityName = option.from.cityName;
    //起点所在城市ID，注：cityName和cityID同时指定时，优先使用cityID
    if ((option.from.cityName.length > 0 && option.from.cityID != 0) || (option.from.cityName.length == 0 && option.from.cityID != 0))  {
        start.cityID = option.from.cityID;
    }
    //起点坐标
    start.pt = option.from.pt;
    //实例化线路检索节点信息类对象
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    //终点名称
    end.name = option.to.name;
    //终点所在城市，注：cityName和cityID同时指定时，优先使用cityID
    end.cityName = option.to.cityName;
    //终点所在城市ID，注：cityName和cityID同时指定时，优先使用cityID
    if ((option.to.cityName.length > 0 && option.to.cityID != 0) || (option.to.cityName.length == 0 && option.to.cityID != 0))  {
        end.cityID = option.to.cityID;
    }
    //终点坐标
    end.pt = option.to.pt;
    //初始化请求参数类BMKDrivingRoutePlanOption的实例
    BMKDrivingRoutePlanOption *drivingRoutePlanOption = [[BMKDrivingRoutePlanOption alloc]init];
    //检索的起点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
    drivingRoutePlanOption.from = start;
    //检索的终点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
    drivingRoutePlanOption.to = end;
    //
    drivingRoutePlanOption.wayPointsArray = option.wayPointsArray;
    /*
     驾车策略，默认使用BMK_DRIVING_TIME_FIRST
     BMK_DRIVING_BLK_FIRST：躲避拥堵
     BMK_DRIVING_TIME_FIRST：最短时间
     BMK_DRIVING_DIS_FIRST：最短路程
     BMK_DRIVING_FEE_FIRST：少走高速
     */
    drivingRoutePlanOption.drivingPolicy = option.drivingPolicy;
    /*
     路线中每一个step的路况，默认使用BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE
     BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE：不带路况
     BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE：道路和路况
     */
    drivingRoutePlanOption.drivingRequestTrafficType = option.drivingRequestTrafficType;
    /**
     发起驾乘路线检索请求，异步函数，返回结果在BMKRouteSearchDelegate的onGetDrivingRouteResult中
     */
    BOOL flag = [_drivingRouteSearch drivingSearch:drivingRoutePlanOption];
    if(flag) {
        NSLog(@"驾车检索成功");
    } else {
        NSLog(@"驾车检索失败");
    }
}

#pragma mark - BMKRouteSearchDelegate
/**
 返回驾车路线检索结果

 @param searcher 检索对象
 @param result 检索结果，类型为BMKDrivingRouteResult
 @param error 错误码 @see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //+polylineWithPoints: count:坐标点的个数
        __block NSUInteger pointCount = 0;
        //获取所有驾车路线中第一条路线
        BMKDrivingRouteLine *routeline = (BMKDrivingRouteLine *)result.routes.firstObject;
        //遍历驾车路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取驾车路线中的每条路段
            BMKDrivingStep *step = routeline.steps[idx];
            //初始化标注类BMKPointAnnotation的实例
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            //设置标注的经纬度坐标为子路段的入口经纬度
            annotation.coordinate = step.entrace.location;
            //设置标注的标题为子路段的说明
            annotation.title = step.entraceInstruction;
            /**
             
             当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
             来生成标注对应的View
             @param annotation 要添加的标注
             */
            [_mapView addAnnotation:annotation];
            //统计路段所经过的地理坐标集合内点的个数
            pointCount += step.pointsCount;
        }];
        
        //+polylineWithPoints: count:指定的直角坐标点数组
        BMKMapPoint *points = new BMKMapPoint[pointCount];
        __block NSUInteger j = 0;
        //遍历驾车路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取驾车路线中的每条路段
            BMKDrivingStep *step = routeline.steps[idx];
            //遍历每条路段所经过的地理坐标集合点
            for (NSUInteger i = 0; i < step.pointsCount; i ++) {
                //将每条路段所经过的地理坐标点赋值给points
                points[j].x = step.points[i].x;
                points[j].y = step.points[i].y;
                j ++;
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
        //根据polyline设置地图范围
        [self mapViewFitPolyline:polyline withMapView:self.mapView];
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
            NSString *file = [[bundle resourcePath] stringByAppendingPathComponent:@"images/icon_nav_bus"];
            //annotationView显示的图片，默认是大头针
            annotationView.image = [UIImage imageWithContentsOfFile:file];
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
        //设置polygonView的线宽度
        polylineView.lineWidth = 4.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue - 35 * 4)];
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
