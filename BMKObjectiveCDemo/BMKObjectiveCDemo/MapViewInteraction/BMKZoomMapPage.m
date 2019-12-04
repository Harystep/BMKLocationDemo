//
//  BMKZoomMapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKZoomMapPage.h"

#define kHeight_BottomControlView  120

//开发者通过此delegate获取mapView的回调方法
@interface BMKZoomMapPage ()<BMKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UIPickerView *zoomPickerView;
@property (nonatomic, strong) NSMutableArray *zoomDatas;
@end

@implementation BMKZoomMapPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setupPicker];
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
    self.title = @"方法交互（缩放地图）";
    [self.view addSubview:self.bottomControlView];
    [self.view addSubview:self.zoomPickerView];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    _mapView.zoomLevel = [_zoomDatas[0] floatValue];
}

- (void)setupPicker {
    _zoomPickerView.delegate = self;
    _zoomPickerView.dataSource = self;
    _zoomDatas = [NSMutableArray array];
    for (NSUInteger i = 4; i < 22; i ++) {
        NSString *zoomString = [NSString stringWithFormat:@"%lu", (unsigned long)i];
        [_zoomDatas addObject:zoomString];
    }
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _zoomDatas.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    /**
     设置地图比例尺级别
     2D地图：4-21级
     3D地图：19-21级
     卫星图：4-20级
     路况交通图：7-20级
     城市热力图：11-20级
     室内图：17-22级
     */
    [_mapView setZoomLevel:[_zoomDatas[row] integerValue]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375 * widthScale, 200 * heightScale)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [dataLabel setFont:[UIFont systemFontOfSize:22]];
    dataLabel.text = _zoomDatas[row];
    return dataLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _zoomDatas[row];
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

- (UIPickerView *)zoomPickerView {
    if (!_zoomPickerView) {
        _zoomPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(100 * widthScale, 483 * heightScale, 175 * widthScale, 120 * heightScale)];
        [_zoomPickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _zoomPickerView;
}
@end
