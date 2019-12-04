//
//  BMKLocalAsyncTilePage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/19.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKLocalAsyncTileMapPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKLocalAsyncTileMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKLocalAsyncTileMapPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self createLocalAsyncTile];
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
}

- (void)createLocalAsyncTile {
    //设置中心点经纬度坐标
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.923018, 116.404440);
    //设置经纬度范围
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.013142, 0.011678);
    /**
     限制地图的显示范围：地图状态改变时，该范围不会在地图显示范围外。
     设置成功后，会调整地图显示该范围
     */
    _mapView.limitMapRegion = BMKCoordinateRegionMake(center, span);
    //初始化BMKLocalAsyncTileLayer的实例
    BMKLocalAsyncTileLayer *asyncTile = [[BMKLocalAsyncTileLayer alloc] init];
    //asyncTile的可渲染区域，默认世界范围
    asyncTile.visibleMapRect = BMKMapRectMake(32995300, 35855667, 1300, 1900);
    //asyncTile的最大Zoom值，默认21，且不能小于minZoom
    asyncTile.maxZoom = 18;
    //asyncTile的最小Zoom值，默认3
    asyncTile.minZoom = 15;
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:
     方法来生成标注对应的View
     @param overlay 要添加的overlay
     */
    [_mapView addOverlay:asyncTile];
    _mapView.zoomLevel = 16;
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
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

@end

#pragma mark - BMKLocalAsyncTileLayer
@implementation BMKLocalAsyncTileLayer

/**
 通过异步方法获取瓦片数据
 
 @param x 瓦片图层x坐标
 @param y 瓦片图层y坐标
 @param zoom 瓦片图层的比例尺大小
 @param result block回调：x,y,zoom）对应瓦片的UIImage对象和error信息
 */
- (void)loadTileForX:(NSInteger)x y:(NSInteger)y zoom:(NSInteger)zoom result:(void (^)(UIImage *tileImage, NSError *error))result {
    NSString *imageName = [NSString stringWithFormat:@"%ld_%ld_%ld.jpg", (long)zoom, (long)x, (long)y];
    UIImage *image = [UIImage imageNamed:imageName];
    result(image, nil);
}

@end

