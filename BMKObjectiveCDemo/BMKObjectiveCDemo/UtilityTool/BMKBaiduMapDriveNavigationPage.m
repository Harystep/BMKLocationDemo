//
//  BMKBaiduMapDriveNavigationPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKBaiduMapDriveNavigationPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKBaiduMapDriveNavigationPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKBaiduMapDriveNavigationPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self openBaiduMapNavigation];
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
    self.title = @"百度地图—驾车导航";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - BaiduMapNavigation
- (void)openBaiduMapNavigation {
    //初始化调启导航时的参数管理类
    BMKNaviPara *para = [[BMKNaviPara alloc]init];
    //实例化线路检索节点信息类对象
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    start.pt = CLLocationCoordinate2DMake(39.90868, 116.204);
    //指定起点名称
    start.name = @"我的位置";
    //所在城市ID
    start.cityID = 0;
    //所在城市
    start.cityName = @"";
    //指定起点
    para.startPoint = start;
    //实例化线路检索节点信息类对象
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    end.pt = CLLocationCoordinate2DMake(39.90868, 116.3956);
    //指定终点名称
    end.name = @"天安门";
    //指定终点
    para.endPoint = end;
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //应用名称
    para.appName = @"baidumap";
    //调起百度地图客户端驾车导航失败后，是否支持调起web地图，默认：YES（步行、骑行导航设置该参数无效）
    para.isSupportWeb = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开百度地图客户端" message:@"百度地图-驾车导航" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /**
         调起百度地图客户端驾车导航界面
         
         @param para 调起驾车导航时传入的参数
         @return 结果状态码
         */
        [BMKNavigation openBaiduMapNavigation:para];
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
