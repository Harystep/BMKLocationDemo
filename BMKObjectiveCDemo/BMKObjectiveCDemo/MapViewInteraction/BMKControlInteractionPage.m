//
//  BMKControlInteractionPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKControlInteractionPage.h"
#import <BMKLocationkit/BMKLocationComponent.h>

#define kHeight_BottomControlView  120
static  NSUInteger logoEnumValue = 0;

//开发者通过此delegate获取mapView的回调方法
@interface BMKControlInteractionPage ()<BMKMapViewDelegate, BMKLocationManagerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISwitch *scaleSwitch;
@property (nonatomic, strong) UISwitch *compassSwitch;
@property (nonatomic, strong) UILabel *scaleLabel;
@property (nonatomic, strong) UILabel *compassLabel;
@property (nonatomic, strong) UIButton *logoPositionButton;
@property (nonatomic, strong) UIButton *compassPositionButton;
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

@end

@implementation BMKControlInteractionPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //当mapview即将被显式的时候调用，恢复之前存储的mapview状态。
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
    self.title = @"控件交互";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.scaleSwitch];
    [self.bottomControlView addSubview:self.compassSwitch];
    [self.bottomControlView addSubview:self.scaleLabel];
    [self.bottomControlView addSubview:self.compassLabel];
    [self.bottomControlView addSubview:self.logoPositionButton];
    [self.bottomControlView addSubview:self.compassPositionButton];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //实例化BMKLocationManager定位信息类对象
    self.locationManager = [[BMKLocationManager alloc] init];
    //设置BMKLocationManager的代理
    self.locationManager.delegate = self;
}

#pragma mark - Responding events
- (void)scaleSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //设置显示比例尺
        _mapView.showMapScaleBar = YES;
        //设置比例尺的位置，以BMKMapView左上角为原点，向右向下增长
        _mapView.mapScaleBarPosition = CGPointMake(100, 200);
    } else {
        //设置不显示比例尺
        _mapView.showMapScaleBar = NO;
    }
}

- (void)clickLogoPositionButton {
    logoEnumValue > 5 ? logoEnumValue = 0 : logoEnumValue;
    switch (logoEnumValue) {
        case 0:
            //设置logo位置位于地图左下方
            _mapView.logoPosition = BMKLogoPositionLeftBottom;
            break;
        case 1:
            //设置logo位置位于地图左上方
            _mapView.logoPosition = BMKLogoPositionLeftTop;
            break;
        case 2:
            //设置logo位置位于地图中下方
            _mapView.logoPosition = BMKLogoPositionCenterBottom;
            break;
        case 3:
            //设置logo位置位于地图中上方
            _mapView.logoPosition = BMKLogoPositionCenterTop;
            break;
        case 4:
            //设置logo位置位于地图右下方
            _mapView.logoPosition = BMKLogoPositionRightBottom;
            break;
        default:
            //设置logo位置位于地图右上方
            _mapView.logoPosition = BMKLogoPositionRightTop;
            break;
    }
    logoEnumValue ++;
}

- (void)clickCompassPositionButton {
    //设置指南针的位置
    [_mapView setCompassPosition:CGPointMake(100, 100)];
}

- (void)compassSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //开启定位服务
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        //显示定位图层
        _mapView.showsUserLocation = YES;
        //设置指南针的图片
        [_mapView setCompassImage:[UIImage imageNamed:@"textureArrow"]];
        //0度不显示指南针
        _mapView.rotation = 10;
    } else {
        //关闭定位服务
        [self.locationManager stopUpdatingLocation];
        [self.locationManager stopUpdatingHeading];
        //不显示定位图层
        _mapView.showsUserLocation = NO;
        _mapView.rotation = 0;
    }
}

#pragma mark - BMKLocationManagerDelegate

/**
 @brief 连续定位回调函数。
 @param manager 定位BMKLocationManager类
 @param location 定位结果，参考BMKLocation
 @param error 错误信息
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    self.userLocation.location = location.location;
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
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

- (UISwitch *)scaleSwitch {
    if (!_scaleSwitch) {
        _scaleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(38 * widthScale, 17, 48 * widthScale, 26)];
        [_scaleSwitch addTarget:self action:@selector(scaleSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _scaleSwitch;
}

- (UISwitch *)compassSwitch {
    if (!_compassSwitch) {
        _compassSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200 * widthScale, 17, 48 * widthScale, 26)];
        [_compassSwitch addTarget:self action:@selector(compassSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _compassSwitch;
}

- (UILabel *)scaleLabel {
    if (!_scaleLabel) {
        _scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 * widthScale, 20, 100 * widthScale, 20)];
        _scaleLabel.textColor = COLOR(0x3385FF);
        _scaleLabel.font = [UIFont systemFontOfSize:14];
        _scaleLabel.text = @"比例尺";
    }
    return _scaleLabel;
}

- (UILabel *)compassLabel {
    if (!_compassLabel) {
        _compassLabel = [[UILabel alloc] initWithFrame:CGRectMake(260 * widthScale, 20, 100 * widthScale, 20)];
        _compassLabel.textColor = COLOR(0x3385FF);
        _compassLabel.font = [UIFont systemFontOfSize:14];
        _compassLabel.text = @"指南针";
        
    }
    return _compassLabel;
}

- (UIButton *)logoPositionButton {
    if (!_logoPositionButton) {
        _logoPositionButton = [[UIButton alloc] initWithFrame:CGRectMake(19 * widthScale, 72.5, 159 * widthScale, 35)];
        [_logoPositionButton addTarget:self action:@selector(clickLogoPositionButton) forControlEvents:UIControlEventTouchUpInside];
        _logoPositionButton.clipsToBounds = YES;
        _logoPositionButton.layer.cornerRadius = 16;
        [_logoPositionButton setTitle:@"logo位置" forState:UIControlStateNormal];
        _logoPositionButton.backgroundColor = COLOR(0x3385FF);
        _logoPositionButton.titleLabel.textColor = [UIColor whiteColor];
        _logoPositionButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _logoPositionButton;
}

- (UIButton *)compassPositionButton {
    if (!_compassPositionButton) {
        _compassPositionButton = [[UIButton alloc] initWithFrame:CGRectMake(197 * widthScale, 72.5, 159 * widthScale, 35)];
        [_compassPositionButton addTarget:self action:@selector(clickCompassPositionButton) forControlEvents:UIControlEventTouchUpInside];
        [_compassPositionButton setTitle:@"指南针位置" forState:UIControlStateNormal];
        _compassPositionButton.clipsToBounds = YES;
        _compassPositionButton.layer.cornerRadius = 16;
        _compassPositionButton.titleLabel.textColor = [UIColor whiteColor];
        _compassPositionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _compassPositionButton.backgroundColor = COLOR(0x3385FF);
    }
    return _compassPositionButton;
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.allowsBackgroundLocationUpdates = NO;
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}
@end
