//
//  BMKThreeDimensionalBuildingPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKThreeDimensionalBuildingPage.h"

#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKThreeDimensionalBuildingPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISwitch *threeDimensionalSwitch;
@property (nonatomic, strong) UILabel *threeDimensionalLabel;
@end

@implementation BMKThreeDimensionalBuildingPage

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
    //关闭个性化地图
    [BMKMapView enableCustomMapStyle:NO];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"3D楼宇展示";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.threeDimensionalSwitch];
    [self.bottomControlView addSubview:self.threeDimensionalLabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //地图比例尺放大为20级
    _mapView.zoomLevel = 20;
    //地图支持俯仰角
    _mapView.overlookEnabled = YES;
    //地图俯仰角为-30度，范围为－45～0度
    _mapView.overlooking = -30;
    //不显示3D楼宇
    _mapView.buildingsEnabled = NO;
}

#pragma mark - Responding events
- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //显示3D楼宇
        _mapView.buildingsEnabled = YES;
        [_mapView mapForceRefresh];
    } else {
        //不显示3D楼宇
        _mapView.buildingsEnabled = NO;
        [_mapView mapForceRefresh];
    }
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

-(UIView *)bottomControlView {
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue, KScreenWidth, kHeight_BottomControlView)];
    }
    return _bottomControlView;
}

- (UISwitch *)threeDimensionalSwitch {
    if (!_threeDimensionalSwitch) {
        _threeDimensionalSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(125 * widthScale, 17, 48 * widthScale, 26)];
        [_threeDimensionalSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _threeDimensionalSwitch;
}

- (UILabel *)threeDimensionalLabel {
    if (!_threeDimensionalLabel) {
        _threeDimensionalLabel = [[UILabel alloc] initWithFrame:CGRectMake(181 * widthScale, 20, 100 * widthScale, 20)];
        _threeDimensionalLabel.textColor = COLOR(0x3385FF);
        _threeDimensionalLabel.font = [UIFont systemFontOfSize:14];
        _threeDimensionalLabel.text = @"3D 楼宇";
    }
    return _threeDimensionalLabel;
}
@end
