//
//  BMKMulti-MapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKMultiMapPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKMultiMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *upsideMapView; //当前界面上方的mapView
@property (nonatomic, strong) BMKMapView *undersideMapView; //当前界面下方的mapView
@property (nonatomic, strong) UIButton *coverMapButton;
@end

@implementation BMKMultiMapPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //设置upsideMapView的代理
    _upsideMapView.delegate = self;
    //设置undersideMapView的代理
    _undersideMapView.delegate = self;
    //当upsideMapView即将被显示的时候调用，恢复之前存储的upsideMapView状态
    [_upsideMapView viewWillAppear];
    //当undersideMapView即将被显示的时候调用，恢复之前存储的undersideMapView状态
    [_undersideMapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    _upsideMapView.delegate = nil;
    _undersideMapView.delegate = nil;
    //当upsideMapView即将被隐藏的时候调用，存储当前upsideMapView的状态
    [_upsideMapView viewWillDisappear];
    //当undersideMapView即将被隐藏的时候调用，存储当前undersideMapView的状态
    [_undersideMapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.title = @"多地图展示";
    UIBarButtonItem *coverMapButton = [[UIBarButtonItem alloc]initWithCustomView:self.coverMapButton];
    self.navigationItem.rightBarButtonItem = coverMapButton;
}

- (void)createMapView {
    //将upsideMapView添加到当前视图中
    [self.view addSubview:self.upsideMapView];
    //将undersideMapView添加到当前视图中
    [self.view addSubview:self.undersideMapView];
    //设置upsideMapView为标准地图类型
    _upsideMapView.mapType = BMKMapTypeStandard;
    //设置undersideMapView为卫星地图类型
    _undersideMapView.mapType = BMKMapTypeSatellite;
}

#pragma mark - Responding events
- (void)clickCoverMapButton {
    BMKCoverWithMapPage *page = [[BMKCoverWithMapPage alloc] init];
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - Lazy loading
- (BMKMapView *)upsideMapView {
    if (!_upsideMapView) {
        _upsideMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, (KScreenHeight - kViewTopHeight) / 2.0)];
    }
    return _upsideMapView;
}

- (BMKMapView *)undersideMapView {
    if (!_undersideMapView) {
        _undersideMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, (KScreenHeight - kViewTopHeight) / 2.0, KScreenWidth, (KScreenHeight - kViewTopHeight) / 2.0)];
    }
    return _undersideMapView;
}

- (UIButton *)coverMapButton {
    if (!_coverMapButton) {
        _coverMapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_coverMapButton setTitle:@"覆盖地图" forState:UIControlStateNormal];
        [_coverMapButton setTitle:@"覆盖地图" forState:UIControlStateHighlighted];
        [_coverMapButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_coverMapButton setFrame:CGRectMake(0, 3, 69, 20)];
        [_coverMapButton addTarget:self action:@selector(clickCoverMapButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverMapButton;
}

@end

#pragma mark - BMKCoverWithMapPage
//开发者通过此delegate获取mapView的回调方法
@interface BMKCoverWithMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKCoverWithMapPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:NO];
    [_mapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *cancelCoverMapButton = [[UIBarButtonItem alloc] initWithTitle:@"取消覆盖" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelCoverMapButton)];
    self.navigationItem.rightBarButtonItem = cancelCoverMapButton;
    [self.view addSubview:self.mapView];
}

- (void)createMapView {
    //设置mapView的代理
    _mapView.delegate = self;
    //设置地图类型为标准地图
    _mapView.mapType = BMKMapTypeStandard;
}

#pragma mark - Responding events
- (void)clickCancelCoverMapButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

@end
