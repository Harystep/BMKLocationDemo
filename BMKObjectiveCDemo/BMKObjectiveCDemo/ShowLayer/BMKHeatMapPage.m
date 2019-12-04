//
//  BMKHeatMapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKHeatMapPage.h"

#define kHeight_SegMentBackgroud  60
#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKHeatMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISegmentedControl *heatMapSegmentControl;
@property (nonatomic, strong) UISwitch *heatMapSwitch;
@property (nonatomic, strong) UILabel *heatMapLabel;
@end

@implementation BMKHeatMapPage

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
    self.title = @"热力图展示";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.heatMapSwitch];
    [self.view addSubview:self.heatMapSegmentControl];
    [self.bottomControlView addSubview:self.heatMapLabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Responding events
- (void)segmentControlDidChangeValue:(UISwitch *)sender {
    NSUInteger selectedIndex = [_heatMapSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 1:
            //设置当前地图类型为卫星地图
            [_mapView setMapType:BMKMapTypeSatellite];
            break;
        default:
            //设置当前地图类型为标准地图
            [_mapView setMapType:BMKMapTypeStandard];
            break;
    }
}

- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //显示热力图
        _mapView.baiduHeatMapEnabled = YES;
    } else {
        //不显示热力图
        _mapView.baiduHeatMapEnabled = NO;
    }
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kHeight_SegMentBackgroud, KScreenWidth, KScreenHeight - kViewTopHeight - kHeight_SegMentBackgroud - kHeight_BottomControlView - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

-(UIView *)bottomControlView {
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue, KScreenWidth, kHeight_BottomControlView)];
    }
    return _bottomControlView;
}

- (UISegmentedControl *)heatMapSegmentControl {
    if (!_heatMapSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"标准地图",@"卫星地图",nil];
        _heatMapSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _heatMapSegmentControl.frame = CGRectMake(10 * widthScale, 12.5, 355 * widthScale, 35);
        [_heatMapSegmentControl setTitle:@"标准地图" forSegmentAtIndex:0];
        [_heatMapSegmentControl setTitle:@"卫星地图" forSegmentAtIndex:1];
        _heatMapSegmentControl.selectedSegmentIndex = 0;
        [_heatMapSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _heatMapSegmentControl;
}

- (UISwitch *)heatMapSwitch {
    if (!_heatMapSwitch) {
        _heatMapSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(125 * widthScale, 17, 48 * widthScale, 26)];
        [_heatMapSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _heatMapSwitch;
}

- (UILabel *)heatMapLabel {
    if (!_heatMapLabel) {
        _heatMapLabel = [[UILabel alloc] initWithFrame:CGRectMake(181 * widthScale, 20, 100 * widthScale, 20)];
        _heatMapLabel.textColor = COLOR(0x3385FF);
        _heatMapLabel.font = [UIFont systemFontOfSize:14];
        _heatMapLabel.text = @"热力图";
    }
    return _heatMapLabel;
}

@end
