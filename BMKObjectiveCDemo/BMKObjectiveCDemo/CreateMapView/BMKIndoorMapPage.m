//
//  BMKIndoorMapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKIndoorMapPage.h"

#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKIndoorMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISwitch *indoorMapSwitch;
@property (nonatomic, strong) UISwitch *POISwitch;
@property (nonatomic, strong) UILabel *indoorMapLabel;
@property (nonatomic, strong) UILabel *POILabel;
@end

@implementation BMKIndoorMapPage

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
    self.title = @"室内地图";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.indoorMapSwitch];
    [self.bottomControlView addSubview:self.POISwitch];
    [self.bottomControlView addSubview:self.indoorMapLabel];
    [self.bottomControlView addSubview:self.POILabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //设置当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.917215, 116.380341);
    //设置地图比例尺级别
    _mapView.zoomLevel = 19;
}

#pragma mark - Responding events
- (void)mapSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //设置显示室内图
        _mapView.baseIndoorMapEnabled = YES;
    } else {
        //设置不显示室内图
        _mapView.baseIndoorMapEnabled = NO;
    }
}

- (void)POISwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //设置显示室内图标注
        _mapView.showIndoorMapPoi = YES;
    } else {
        //设置不显示室内图标注
        _mapView.showIndoorMapPoi = NO;
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

- (UISwitch *)indoorMapSwitch {
    if (!_indoorMapSwitch) {
        _indoorMapSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(51 * widthScale, 17, 48 * widthScale, 26)];
        [_indoorMapSwitch addTarget:self action:@selector(mapSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _indoorMapSwitch;
}
- (UISwitch *)POISwitch {
    if (!_POISwitch) {
        _POISwitch = [[UISwitch alloc] initWithFrame:CGRectMake(215 * widthScale, 17, 48 * widthScale, 26)];
        [_POISwitch addTarget:self action:@selector(POISwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _POISwitch;
}
- (UILabel *)indoorMapLabel {
    if (!_indoorMapLabel) {
        _indoorMapLabel = [[UILabel alloc] initWithFrame:CGRectMake(109 * widthScale, 20, 100 * widthScale, 20)];
        _indoorMapLabel.textColor = COLOR(0x3385FF);
        _indoorMapLabel.font = [UIFont systemFontOfSize:14];
        _indoorMapLabel.text = @"室内图";
    }
    return _indoorMapLabel;
}

- (UILabel *)POILabel {
    if (!_POILabel) {
        _POILabel = [[UILabel alloc] initWithFrame:CGRectMake(270 * widthScale, 20, 100 * widthScale, 20)];
        _POILabel.textColor = COLOR(0x3385FF);
        _POILabel.font = [UIFont systemFontOfSize:14];
        _POILabel.text = @"室内图标注";
    }
    return _POILabel;
}

@end
