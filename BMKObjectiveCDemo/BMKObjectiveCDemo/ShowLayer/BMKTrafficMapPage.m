//
//  BMKTrafficMapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKTrafficMapPage.h"

#define kHeight_SegMentBackgroud  60
#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKTrafficMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISegmentedControl *trafficMapSegmentControl;
@property (nonatomic, strong) UISwitch *trafficMapSwitch;
@property (nonatomic, strong) UILabel *trafficMapLabel;
@end

@implementation BMKTrafficMapPage

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
    self.title = @"路况图展示";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.trafficMapSwitch];
    [self.view addSubview:self.trafficMapSegmentControl];
    [self.bottomControlView addSubview:self.trafficMapLabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Responding events
- (void)segmentControlDidChangeValue:(UISwitch *)sender {
    NSUInteger selectedIndex = [_trafficMapSegmentControl selectedSegmentIndex];
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
        //显示路况图层
        _mapView.trafficEnabled = YES;
    } else {
        //不显示路况图层
        _mapView.trafficEnabled = NO;
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

- (UISegmentedControl *)trafficMapSegmentControl {
    if (!_trafficMapSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"标准地图",@"卫星地图",nil];
        _trafficMapSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _trafficMapSegmentControl.frame = CGRectMake(10 * widthScale, 12.5, 355 * widthScale, 35);
        [_trafficMapSegmentControl setTitle:@"标准地图" forSegmentAtIndex:0];
        [_trafficMapSegmentControl setTitle:@"卫星地图" forSegmentAtIndex:1];
        _trafficMapSegmentControl.selectedSegmentIndex = 0;
        [_trafficMapSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _trafficMapSegmentControl;
}

- (UISwitch *)trafficMapSwitch {
    if (!_trafficMapSwitch) {
        _trafficMapSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(125 * widthScale, 17, 48 * widthScale, 26)];
        [_trafficMapSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _trafficMapSwitch;
}

- (UILabel *)trafficMapLabel {
    if (!_trafficMapLabel) {
        _trafficMapLabel = [[UILabel alloc] initWithFrame:CGRectMake(181 * widthScale, 20, 100 * widthScale, 20)];
        _trafficMapLabel.textColor = COLOR(0x3385FF);
        _trafficMapLabel.font = [UIFont systemFontOfSize:14];
        _trafficMapLabel.text = @"路况图";
    }
    return _trafficMapLabel;
}

@end
