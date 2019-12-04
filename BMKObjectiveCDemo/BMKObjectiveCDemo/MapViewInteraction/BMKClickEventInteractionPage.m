//
//  BMKClickEventInteractionPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKClickEventInteractionPage.h"

#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKClickEventInteractionPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UILabel *notesLabel;
@end

@implementation BMKClickEventInteractionPage

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
    self.title = @"事件交互（点击）";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.notesLabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Responding events
- (void)alertMessage:(NSString *)message {
    NSAssert(message && message.length > 0, @"提示信息不能为空");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"事件描述" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BMKMapViewDelegate
/**
 长按地图时会回调此方法

 @param mapView 地图View
 @param coordinate 返回长按地图坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    NSString *message = [NSString stringWithFormat:@"长按：latitude:%f,longitude:%f", coordinate.latitude, coordinate.longitude];
    [self alertMessage:message];
}

/**
 双击地图时会回调此方法

 @param mapView 地图View
 @param coordinate 返回双击地图坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSString *message = [NSString stringWithFormat:@"双击：latitude:%f,longitude:%f", coordinate.latitude, coordinate.longitude];
    [self alertMessage:message];
}

/**
 点击地图标注会回调此方法

 @param mapView 地图View
 @param mapPoi 返回点击地图地图坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi {
    NSString *message = [NSString stringWithFormat:@"单击POI标注：%@(latitude:%f,longitude:%f)", mapPoi.text, mapPoi.pt.latitude, mapPoi.pt.longitude];
    [self alertMessage:message];
}

/**
 点击地图非标注区域会回调此方法

 @param mapView 地图View
 @param coordinate 返回点击地图非标注区域地图坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSString *message = [NSString stringWithFormat:@"单击空白处：latitude:%f,longitude:%f", coordinate.latitude, coordinate.longitude];
    [self alertMessage:message];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

-(UIView *)bottomControlView{
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue, KScreenWidth, kHeight_BottomControlView)];
    }
    return _bottomControlView;
}

- (UILabel *)notesLabel {
    if (!_notesLabel) {
        _notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(38 * widthScale, 0, 300 * widthScale, 60)];
        _notesLabel.text = @"请双击、长按、单击地图空白区域、单击地图POI标注";
        _notesLabel.font = [UIFont systemFontOfSize:16];
        _notesLabel.numberOfLines = 0;
    }
    return _notesLabel;
}

@end
