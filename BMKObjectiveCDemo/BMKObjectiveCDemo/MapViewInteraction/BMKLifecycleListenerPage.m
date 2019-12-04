//
//  BMKLifecycleListenerPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKLifecycleListenerPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKLifecycleListenerPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) UILabel *notesLabel;
@end

@implementation BMKLifecycleListenerPage

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
    self.title = @"事件交互（地图生命周期监听）";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    [self.mapView addSubview:self.notesLabel];
}

#pragma mark - BMKMapViewDelegate
/**
 地图加载完成时会调用此方法

 @param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    _notesLabel.text = @"地图加载完成";
}

/**
 地图渲染完成时会调用此方法

 @param mapView 地图View
 */
- (void)mapViewDidFinishRendering:(BMKMapView *)mapView {
    _notesLabel.text = @"地图渲染完成";
}

/**
 地图渲染每一帧画面过程中，以及每次需要重新绘制地图时(例如添加覆盖物)都会调用此方法

 @param mapView 地图View
 @param status 地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    _notesLabel.text = @"地图已加载完成\n地图正在渲染绘制";
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

- (UILabel *)notesLabel {
    if (!_notesLabel) {
        _notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 * widthScale, 260 * heightScale, 275 * widthScale, 60 * heightScale)];
        _notesLabel.backgroundColor = [UIColor blackColor];
        _notesLabel.textColor = [UIColor whiteColor];
        _notesLabel.textAlignment = NSTextAlignmentCenter;
        _notesLabel.font = [UIFont systemFontOfSize:17];
        _notesLabel.alpha = 0.5;
        _notesLabel.numberOfLines = 0;
    }
    return _notesLabel;
}

@end
