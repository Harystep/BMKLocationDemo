//
//  BMKArclineOverlayPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKArclineOverlayPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKArclineOverlayPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKArcline *arcline; //当前界面的曲线
@end

@implementation BMKArclineOverlayPage

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
    self.title = @"曲线绘制";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
     来生成标注对应的View
     
     @param overlay 要添加的overlay
     */
    [_mapView addOverlay:self.arcline];
}

#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        //初始化一个overlay并返回相应的BMKArclineView的实例
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        //设置arclineView的画笔颜色
        arclineView.strokeColor = [UIColor blueColor];
        //设置arclineView为虚线样式
        //lineDash属性已废弃，since5.0.0请使用lineDashType配置虚线样式
//        arclineView.lineDash = YES;
        arclineView.lineDashType = kBMKLineDashTypeSquare;
        //设置arclineView的线宽度
        arclineView.lineWidth = 6.0;
        return arclineView;
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

- (BMKArcline *)arcline {
    if (!_arcline) {
        CLLocationCoordinate2D coords[3] = {0};
        coords[0] = CLLocationCoordinate2DMake(40.065, 116.124);
        coords[1] = CLLocationCoordinate2DMake(40.125, 116.304);
        coords[2] = CLLocationCoordinate2DMake(40.065, 116.404);
        /**
         根据指定经纬度生成一段圆弧
         
         @param coords 指定的经纬度坐标点数组(需传入3个点)
         @return 新生成的BMKArcline实例
         */
        _arcline = [BMKArcline arclineWithCoordinates:coords];
    }
    return _arcline;
}

@end
