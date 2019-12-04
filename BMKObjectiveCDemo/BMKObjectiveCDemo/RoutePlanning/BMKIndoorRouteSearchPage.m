//
//  BMKIndoorRouteSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKIndoorRouteSearchPage.h"
#import "BMKIndoorRouteParametersPage.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKIndoorRouteSearch";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKRouteSearchDelegate
 获取indoorRouteSearch的回调方法
 **/
@interface BMKIndoorRouteSearchPage ()<BMKMapViewDelegate, BMKRouteSearchDelegate, BMKPoiSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKRouteSearch *indoorRouteSearch;
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKIndoorRouteSearchPage

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
    self.title = @"室内路线";
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc]initWithCustomView:self.customButton];
    self.navigationItem.rightBarButtonItem = customButton;
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //地图显示室内图
    _mapView.baseIndoorMapEnabled = YES;
    //设置当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.916958, 116.379278);
    //设置地图比例尺级别
    _mapView.zoomLevel = 19;
}

- (void)createSearchToolView {
    [self createToolBarsWithItemArray:
     @[@{@"leftItemTitle":@"起点所在楼层：",
         @"rightItemText":@"F1",
         @"rightItemPlaceholder":@"输入起点所在楼层"},
       @{@"leftItemTitle":@"起点坐标：",
         @"rightItemText":@"39.917380,116.37978",
         @"rightItemPlaceholder":@"输入起点坐标"},
       @{@"leftItemTitle":@"终点所在楼层：",
         @"rightItemText":@"F6",
         @"rightItemPlaceholder":@"输入终点所在楼层"},
       @{@"leftItemTitle":@"终点坐标：",
         @"rightItemText":@"39.917239,116.37955",
         @"rightItemPlaceholder":@"输入终点坐标"}
       ]];
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKIndoorRouteParametersPage *page = [[BMKIndoorRouteParametersPage alloc] init];
    page.searchDataBlock = ^(BMKIndoorRoutePlanOption *option) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"起点所在楼层：",
             @"rightItemText":option.from.floor,
             @"rightItemPlaceholder":@"输入起点所在楼层"},
           @{@"leftItemTitle":@"起点坐标：",
             @"rightItemText":[NSString stringWithFormat:@"%f,%f", option.from.pt.latitude, option.from.pt.longitude],
             @"rightItemPlaceholder":@"输入起点坐标"},
           @{@"leftItemTitle":@"终点所在楼层：",
             @"rightItemText":option.to.floor,
             @"rightItemPlaceholder":@"输入终点所在楼层"},
           @{@"leftItemTitle":@"终点坐标：",
             @"rightItemText":[NSString stringWithFormat:@"%f,%f", option.to.pt.latitude, option.to.pt.longitude],
             @"rightItemPlaceholder":@"输入终点坐标"}
           ]];
        [self searchData:option];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    
    //初始化请求参数类BMKIndoorRoutePlanOption的实例
    BMKIndoorRoutePlanOption *indoorRoutePlanOption = [[BMKIndoorRoutePlanOption alloc]init];
    //实例化室内线路检索节点信息类对象
    BMKIndoorPlanNode *start = [[BMKIndoorPlanNode alloc] init];
    //起点所在楼层
    start.floor = self.dataArray[0];
    //起点坐标
    start.pt = CLLocationCoordinate2DMake([[self.dataArray[1] componentsSeparatedByString:@","][0] floatValue], [[self.dataArray[1] componentsSeparatedByString:@","][1] floatValue]);
    //实例化室内线路检索节点信息类对象
    BMKIndoorPlanNode *end = [[BMKIndoorPlanNode alloc] init];
    //终点所在楼层
    end.floor = self.dataArray[2];
    //终点坐标
    end.pt = CLLocationCoordinate2DMake([[self.dataArray[3] componentsSeparatedByString:@","][0] floatValue], [[self.dataArray[3] componentsSeparatedByString:@","][1] floatValue]);
    //检索的起点
    indoorRoutePlanOption.from = start;
    //检索的终点
    indoorRoutePlanOption.to = end;
    [self searchData:indoorRoutePlanOption];
}

- (void)searchData:(BMKIndoorRoutePlanOption *)option {
    //初始化BMKRouteSearch实例
    _indoorRouteSearch = [[BMKRouteSearch alloc] init];
    //设置室内路线规划的代理
    _indoorRouteSearch.delegate = self;
    //初始化BMKIndoorPlanNode实例，检索起点
    BMKIndoorPlanNode *start = [[BMKIndoorPlanNode alloc]init];
    //起点所在楼层
    start.floor = option.from.floor;
    //起点坐标
    start.pt = option.from.pt;
    //初始化BMKIndoorPlanNode实例，检索终点
    BMKIndoorPlanNode* end = [[BMKIndoorPlanNode alloc]init];
    //终点所在楼层
    end.floor = option.to.floor;
    //终点坐标
    end.pt = option.to.pt;
    //初始化请求参数类BMKIndoorRoutePlanOption的实例
    BMKIndoorRoutePlanOption *indoorRoutePlanOption = [[BMKIndoorRoutePlanOption alloc]init];
    //检索的起点
    indoorRoutePlanOption.from = start;
    //检索的终点
    indoorRoutePlanOption.to = end;
    /**
     发起室内路线检索请求，异步函数，返回结果在BMKRouteSearchDelegate的onGetIndoorRouteResult中
     */
    BOOL flag = [_indoorRouteSearch indoorRoutePlanSearch:indoorRoutePlanOption];
    if(flag) {
        NSLog(@"室内路线检索成功");
    } else {
        NSLog(@"室内路线检索失败");
    }
}

#pragma mark - BMKRouteSearchDelegate
/**
 返回室内路线检索结果

 @param searcher 检索对象
 @param result 检索结果，类型为BMKIndoorRouteResult
 @param error 错误码，@see BMKSearchErrorCode
 */
- (void)onGetIndoorRouteResult:(BMKRouteSearch *)searcher result:(BMKIndoorRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //+polylineWithPoints: count:坐标点的个数
        __block NSUInteger pointCount = 0;
        //获取所有室内公交路线中第一条路线
        BMKIndoorRouteLine *routeline = (BMKIndoorRouteLine *)result.routes.firstObject;
        //遍历室内路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取室内路线中的每条路段
            BMKIndoorRouteStep *step = routeline.steps[idx];
            //初始化标注类BMKPointAnnotation的实例
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            //设置标注的经纬度坐标为子路段的入口经纬度
            annotation.coordinate = step.entrace.location;
            //设置标注的标题为子路段的说明
            annotation.title = step.instructions;
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
        //遍历室内路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取室内路线中的每条路段
            BMKIndoorRouteStep *step = routeline.steps[idx];
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
            //annotationView显示的图片，默认是大头针
            annotationView.image = [UIImage imageNamed:@"stairsIcon"];
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
