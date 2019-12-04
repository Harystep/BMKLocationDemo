//
//  BMKCircleOverlayPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCircleOverlayPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKCircleOverlayPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKCircle *circle; //当前界面的圆
@end

@implementation BMKCircleOverlayPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
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
    self.title = @"圆形绘制";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;

    // 添加圆形镂空
    CLLocationCoordinate2D coor;
    coor.latitude = 39.945;
    coor.longitude = 116.404;
    BMKCircle *circleHole = [BMKCircle circleWithCenterCoordinate:coor radius:800];

    // 添加多边形镂空
    CLLocationCoordinate2D coords[3] = {0};
    coords[0].latitude = 39.945;
    coords[0].longitude = 116.404;
    coords[1].latitude = 39.915;
    coords[1].longitude = 116.454;
    coords[2].latitude = 39.915;
    coords[2].longitude = 116.354;

    BMKPolygon  *polygonHole = [BMKPolygon polygonWithCoordinates:coords count:3];

    self.circle.hollowShapes = @[circleHole,polygonHole];
    /**
    向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
    来生成标注对应的View

    @param overlay 要添加的overlay
    */
    [_mapView addOverlay:self.circle];
    }

#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKCircle class]]) {
        //初始化一个overlay并返回相应的BMKCircleView的实例
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithCircle:overlay];
        //设置circleView的填充色
        circleView.fillColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:0.5];
        //设置circleView的画笔（边框）颜色
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.5];
        //设置circleView的轮廓宽度
        circleView.lineWidth = 5.0;
        return circleView;
    }
    return nil;
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

- (BMKCircle *)circle {
    if (!_circle) {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(39.915, 116.404);
        /**
         根据中心点和半径生成圆
         
         @param coord 中心点的经纬度坐标
         @param radius 半径，单位：米
         @return 新生成的BMKCircle实例
         */
        _circle = [BMKCircle circleWithCenterCoordinate:coor radius:5000];
    }
    return _circle;
}

@end
