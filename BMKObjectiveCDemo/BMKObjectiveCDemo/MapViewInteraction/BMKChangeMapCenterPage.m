//
//  BMKChangeMapCenterPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKChangeMapCenterPage.h"

#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKChangeMapCenterPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISwitch *changeMapSwitch;
@property (nonatomic, strong) UILabel *changeMapLabel;
@end

@implementation BMKChangeMapCenterPage

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
    self.title = @"方法交互（设置地图中心点）";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.changeMapSwitch];
    [self.bottomControlView addSubview:self.changeMapLabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Responding events
- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //设置中心点经纬度坐标
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(35.718, 111.581);
        /**
         设定地图中心点坐标
         @param coordinate 要设定的地图中心点坐标，用经纬度表示
         @param animated 是否采用动画效果
         */
        [_mapView setCenterCoordinate:center animated:YES];
    } else {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.915526, 116.403847);
        [_mapView setCenterCoordinate:center animated:YES];
    }
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

- (UISwitch *)changeMapSwitch {
    if (!_changeMapSwitch) {
        _changeMapSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(105 * widthScale, 17, 48 * widthScale, 26)];
        [_changeMapSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _changeMapSwitch;
}

- (UILabel *)changeMapLabel {
    if (!_changeMapLabel) {
        _changeMapLabel = [[UILabel alloc] initWithFrame:CGRectMake(165 * widthScale, 20, 160 * widthScale, 20)];
        _changeMapLabel.textColor = COLOR(0x3385FF);
        _changeMapLabel.font = [UIFont systemFontOfSize:14];
        _changeMapLabel.text = @"改变地图中心点";
    }
    return _changeMapLabel;
}
@end
