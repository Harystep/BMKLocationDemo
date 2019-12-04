//
//  BMKStatusChangeListenerPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKStatusChangeListenerPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKStatusChangeListenerPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKStatusChangeListenerPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self setupMapStatus];
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
    self.title = @"事件交互（地图状态控制监听）";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - MapStatus
- (void)setupMapStatus {
    //初始化BMKMapStatus（地图状态类）的一个实例
    BMKMapStatus *mapStatus = [[BMKMapStatus alloc] init];
    //设置缩放级别:[4~19]
    mapStatus.fLevel = 18;
    //设置旋转角度
    mapStatus.fRotation = 45;
    //设置俯视角度（范围:[-45~0]）
    mapStatus.fOverlooking = -30;
    //设置屏幕中心点坐标（超过屏幕外无效）
    mapStatus.targetScreenPt = CGPointMake(100, 300);
    //设置地理中心点的经纬度坐标
    mapStatus.targetGeoPt = CLLocationCoordinate2DMake(40.051233, 116.282048);
    /**
     设置地图状态
     @param mapStatus 地图状态信息
     */
    [_mapView setMapStatus:mapStatus];
    /**
     获取地图状态
     返回地图状态信息
     */
    BMKMapStatus *currentMapStatus = [_mapView getMapStatus];
    NSString *message = [NSString stringWithFormat:@"缩放级别：%f\n旋转角度：%f\n俯视角度：%f\n屏幕中心点坐标：(%f,%f)\n地理中心点坐标：(%f,%f\n当前地图范围：\norigin(%.2f,%.2f)\nsize(%.2f,%.2f)", currentMapStatus.fLevel, currentMapStatus.fRotation, currentMapStatus.fOverlooking, currentMapStatus.targetScreenPt.x, currentMapStatus.targetScreenPt.y, currentMapStatus.targetGeoPt.latitude, currentMapStatus.targetGeoPt.longitude, currentMapStatus.visibleMapRect.origin.x, currentMapStatus.visibleMapRect.origin.y, currentMapStatus.visibleMapRect.size.width, currentMapStatus.visibleMapRect.size.height];
    [self alertMessage:message];
}

#pragma mark - Responding events
- (void)alertMessage:(NSString *)message {
    NSAssert(message && message.length > 0, @"提示信息不能为空");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"地图状态" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
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
