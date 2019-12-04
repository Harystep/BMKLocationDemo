//
//  BMKShowPOIAnnotationPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKShowPOIAnnotationPage.h"

#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKShowPOIAnnotationPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISwitch *POISwitch;
@property (nonatomic, strong) UILabel *POILabel;
@end

@implementation BMKShowPOIAnnotationPage

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
    self.title = @"方法交互（控制地图标注显示）";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.POISwitch];
    [self.bottomControlView addSubview:self.POILabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //设置地图是否显示POI标注(不包含室内图标注)，默认YES
    _mapView.showMapPoi = NO;
}

#pragma mark - Responding events
- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //设置地图显示POI标注
        _mapView.showMapPoi = YES;
    } else {
        //设置不显示POI标注
        _mapView.showMapPoi = NO;
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

- (UISwitch *)POISwitch {
    if (!_POISwitch) {
        _POISwitch = [[UISwitch alloc] initWithFrame:CGRectMake(105 * widthScale, 17, 48 * widthScale, 26)];
        [_POISwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _POISwitch;
}

- (UILabel *)POILabel {
    if (!_POILabel) {
        _POILabel = [[UILabel alloc] initWithFrame:CGRectMake(165 * widthScale, 20, 160 * widthScale, 20)];
        _POILabel.textColor = COLOR(0x3385FF);
        _POILabel.font = [UIFont systemFontOfSize:14];
        _POILabel.text = @"底图标注";
    }
    return _POILabel;
}
@end
