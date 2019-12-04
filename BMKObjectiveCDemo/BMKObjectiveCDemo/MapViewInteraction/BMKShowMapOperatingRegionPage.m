//
//  BMKShowMapOperatingRegionPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/4/15.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKShowMapOperatingRegionPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKShowMapOperatingRegionPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKShowMapOperatingRegionPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
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
    self.title = @"方法交互（设置地图操作区）";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Padding" style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton)];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    /**
     地图预留边界，默认：UIEdgeInsetsZero。
     注：设置后，会根据mapPadding调整logo、比例尺、指南针的位置。
     当updateTargetScreenPtWhenMapPaddingChanged==YES时，地图中心(屏幕坐标
     BMKMapStatus.targetScreenPt)跟着改变
     */
    _mapView.mapPadding = UIEdgeInsetsMake(0, 0, 0, 100);
}

#pragma mark - Responding events
- (void)clickBarButton {
    //设置中心点经纬度坐标
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(39.9087677478, 116.3975780499);
    //设置经纬度范围
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.1, 0.1);
    /**
     构造BMKCoordinateRegion对象
     centerCoordinate 中心点经纬度坐标
     span 经纬度的范围
     返回根据指定参数生成的BMKCoordinateRegion对象
     */
    BMKCoordinateRegion region = BMKCoordinateRegionMake(centerCoordinate, span);
    /**
     将经纬度矩形区域转换为View矩形区域
     region 待转换的经纬度矩形
     mapView 指定相对的View
     返回转换后的View矩形区域
     */
    CGRect fitRect = [_mapView convertRegion:region toRectToView:_mapView];
    /**
     将View矩形区域转换成直角地理坐标矩形区域
     fitRect 待转换的View矩形区域
     mapView rect坐标所在的view
     返回转换后的直角地理坐标矩形区域
     */
    BMKMapRect fitMapRect = [_mapView convertRect:fitRect toMapRectFromView:_mapView];
    /**
     设定当前地图的显示范围,采用直角坐标系表示
     fitMapRect 要设定的地图范围，用直角坐标系表示
     animate 是否采用动画效果
     */
    [_mapView setVisibleMapRect:fitMapRect animated:YES];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

@end
