//
//  BMKURLTileMapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/19.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKURLTileMapPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKURLTileMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKURLTileLayer *tileLayer; //在线瓦片图
@end

@implementation BMKURLTileMapPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self createURLTile];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"瓦片图展示";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeNone;
}

- (void)createURLTile {
    //设置中心点经纬度坐标
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.924257, 116.403263);
    //设置经纬度范围
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.038325, 0.028045);
    /**
     限制地图的显示范围：地图状态改变时，该范围不会在地图显示范围外。
     设置成功后，会调整地图显示该范围
     */
    _mapView.limitMapRegion = BMKCoordinateRegionMake(center, span);
    /**
     @brief 通过提供url模板的方法，提供数据源。不应该继承该类，且必须通过initWithURLTemplate:
     方法来初始化，瓦片图片是jpeg或者png格式，size为256x256
     */
    BMKURLTileLayer *urlTile = [[BMKURLTileLayer alloc] initWithURLTemplate:@" http://online1.map.bdimg.com/tile/?qt=vtile&x={x}&y={y}&z={z}&styles=pl&scaler=1&udt=20190528"];
    //urlTile的可渲染区域，默认世界范围
    urlTile.visibleMapRect = BMKMapRectMake(32994258, 35853667, 3122, 5541);
    //urlTile的最大Zoom值，默认21，且不能小于minZoom
    urlTile.maxZoom = 21;
    //urlTile的最小Zoom值，默认3
    urlTile.minZoom = 4;
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:
     方法来生成标注对应的View
     @param overlay 要添加的overlay
     */
    [_mapView addOverlay:urlTile];
    self.tileLayer = urlTile;
}

#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKTileLayer class]]) {
        BMKTileLayerView *view = [[BMKTileLayerView alloc] initWithTileLayer:overlay];
        return view;
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

@end
