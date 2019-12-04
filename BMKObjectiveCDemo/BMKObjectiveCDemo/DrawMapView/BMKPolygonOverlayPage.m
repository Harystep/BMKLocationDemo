//
//  BMKPolygonOverlayPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPolygonOverlayPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKPolygonOverlayPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKPolygon *polygon; //当前界面的多边形
@end

@implementation BMKPolygonOverlayPage

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
    self.title = @"多边形绘制";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    
    // 添加圆形镂空
    CLLocationCoordinate2D circleHoleCoor;
    circleHoleCoor.latitude = 39.945;
    circleHoleCoor.longitude = 116.324;
    BMKCircle *circleHole = [BMKCircle circleWithCenterCoordinate:circleHoleCoor radius:800];
    
    // 添加多边形镂空
    CLLocationCoordinate2D coords[3] = {0};
    coords[0].latitude = 39.945;
    coords[0].longitude = 116.354;
    coords[1].latitude = 39.915;
    coords[1].longitude = 116.354;
    coords[2].latitude = 39.915;
    coords[2].longitude = 116.304;
    
    BMKPolygon  *polygonHole = [BMKPolygon polygonWithCoordinates:coords count:3];
    
    self.polygon.hollowShapes = @[circleHole,polygonHole];
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
     来生成标注对应的View
     
     @param overlay 要添加的overlay
     */
    [_mapView addOverlay:self.polygon];
}

#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        //初始化一个overlay并返回相应的BMKPolygonView的实例
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithPolygon:overlay];
        //设置polygonView的画笔（边框）颜色
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:0.5 alpha:1];
        //设置polygonView的填充色
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.5];
        //设置polygonView的线宽度
        polygonView.lineWidth = 2.0;
        //设置polygonView为虚线样式
        //lineDash属性已废弃，since5.0.0请使用lineDashType配置虚线样式
//        polygonView.lineDash = YES;
        polygonView.lineDashType = kBMKLineDashTypeSquare;
        return polygonView;
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

- (BMKPolygon *)polygon {
    if (!_polygon) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0] = CLLocationCoordinate2DMake(39.965, 116.304);
        coords[1] = CLLocationCoordinate2DMake(39.865, 116.304);
        coords[2] = CLLocationCoordinate2DMake(39.865, 116.404);
        coords[3] = CLLocationCoordinate2DMake(39.905, 116.354);
        coords[4] = CLLocationCoordinate2DMake(39.965, 116.404);
        /**
         根据多个经纬点生成多边形
         
         @param coords 经纬度坐标点数组
         @param count 点的个数
         @return 新生成的BMKPolygon实例
         */
        _polygon = [BMKPolygon polygonWithCoordinates:coords count:5];
    }
    return _polygon;
}

@end
