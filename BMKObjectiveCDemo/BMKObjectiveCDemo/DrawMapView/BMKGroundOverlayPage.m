//
//  BMKGroundOverlayPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKGroundOverlayPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKGroundOverlayPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKGroundOverlay *ground; //当前界面的图层
@end

@implementation BMKGroundOverlayPage

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
    self.title = @"图层绘制";
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
    [_mapView addOverlay:self.ground];
}

#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKGroundOverlay class]]) {
        //初始化一个overlay并返回相应的BMKGroundOverlayView的实例
        BMKGroundOverlayView *groundView = [[BMKGroundOverlayView alloc] initWithGroundOverlay:overlay];
        return groundView;
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

- (BMKGroundOverlay *)ground {
    if (!_ground) {
        CLLocationCoordinate2D coords[2] = {0};
        coords[0] = CLLocationCoordinate2DMake(39.910, 116.370);
        coords[1] = CLLocationCoordinate2DMake(39.950, 116.430);
        //表示一个经纬度区域
        BMKCoordinateBounds bound;
        //东北角点经纬度坐标
        bound.southWest = coords[0];
        //西南角点经纬度坐标
        bound.northEast = coords[1];
        /**
         根据指定区域生成一个图层
         
         @param bounds 指定的经纬度区域
         @param icon 绘制使用的图片
         @return 新生成的BMKGroundOverlay实例
         */
        _ground = [BMKGroundOverlay groundOverlayWithBounds:bound icon:[UIImage imageNamed:@"groundIcon.png"]];
        //图片纹理透明度，最终透明度 = 纹理透明度 * alpha，取值范围为[0.0f, 1.0f]，默认为1.0f
        _ground.alpha = 0.8;
    }
    return _ground;
}

@end
