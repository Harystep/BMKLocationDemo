//
//  BMKBaiduMapPOINearbySearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKBaiduMapPOINearbySearchPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKBaiduMapPOINearbySearchPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKBaiduMapPOINearbySearchPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self openBaiduMapPoiNearbySearch];
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
    self.title = @"百度地图-POI周边检索";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - BaiduMapPoiNearbySearch
- (void)openBaiduMapPoiNearbySearch {
    //初始化调起百度地图POI周边范围参数类
    BMKOpenPoiNearbyOption *option = [[BMKOpenPoiNearbyOption alloc] init];
    //指定返回自定义scheme
    option.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //调起百度地图客户端失败后，是否支持调起web地图，默认：YES
    option.isSupportWeb = YES;
    //关键字
    option.keyword = @"美食";
    //中心点经纬度坐标
    option.location = CLLocationCoordinate2DMake(39.915, 116.360582);
    //半径
    option.radius = 1000;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开百度地图客户端" message:@"百度地图-POI周边检索" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /**
         调起百度地图客户端POI周边范围界面
         
         @param para 调起POI周边范围时传入的参数
         @return 结果状态码
         */
        [BMKOpenPoi openBaiduMapPoiNearbySearch:option];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:openAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

@end
