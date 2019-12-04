//
//  BMKCustomizationMapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCustomizationMapPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKCustomizationMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UISegmentedControl *mapSegmentControl;
@end

@implementation BMKCustomizationMapPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //设置midnightMapView的代理
    _mapView.delegate = self;
    //当midnightMapView即将被显示的时候调用，恢复之前存储的midnightMapView状态
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
    self.title = @"个性化地图";
}

- (void)createMapView {
    //将midnightMapView添加到当前视图中
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapSegmentControl];
    [self segmentControlDidChangeValue:self];
}

#pragma mark - Responding events
- (void)segmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_mapSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            //设置本地个性化地图样式
            [self setLocalCustomMap];
            break;
        case 1:
            //设置在线个性化地图样式
            [self setOnlineCustomMap];
            break;
        case 2:
            //关闭个性化地图样式
            [self.mapView setCustomMapStyleEnable:NO];
            break;
        default:
            //默认设置本地个性化地图样式
            [self setLocalCustomMap];
            break;
    }
}

//加载本地个性化文件
- (void)setLocalCustomMap {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_map_config" ofType:@"json"];
    //设置个性化地图样式
    [self.mapView setCustomMapStylePath:path];
    [self.mapView setCustomMapStyleEnable:YES];
}

//加载在线个性化文件，在线个性化地图可以通过官网个性化地图编辑器创建 http://lbsyun.baidu.com/index.php?title=open/custom
- (void)setOnlineCustomMap {
    //设置在线个性化地图样式
    BMKCustomMapStyleOption *option = [[BMKCustomMapStyleOption alloc] init];
    //请输入您的在线个性化样式ID
    option.customMapStyleID = @"4e7360bde67c***d6e69bc6a2c53059c";
    //获取本地个性化地图模板文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_map_config" ofType:@"json"];
    //在线样式ID加载失败后会加载此路径的文件
    option.customMapStyleFilePath = path;
    [self.mapView setCustomMapStyleWithOption:option preLoad:^(NSString *path) {
        NSLog(@"预加载个性化文件路径：%@",path);
    } success:^(NSString *path) {
        NSLog(@"在线个性化文件路径：%@",path);
    } failure:^(NSError *error, NSString *path) {
        NSLog(@"设置在线个性化地图失败：%@---%@",error.userInfo,path);
    }];
    [self.mapView setCustomMapStyleEnable:YES];
}
#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 60, KScreenWidth, KScreenHeight - kViewTopHeight - 60)];
    }
    return _mapView;
}

- (UISegmentedControl *)mapSegmentControl {
    if (!_mapSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"本地个性化",@"在线个性化",@"关闭个性化",nil];
        _mapSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _mapSegmentControl.frame = CGRectMake(10 * widthScale, 12.5, 355 * widthScale, 35);
        [_mapSegmentControl setTitle:@"本地个性化" forSegmentAtIndex:0];
        [_mapSegmentControl setTitle:@"在线个性化" forSegmentAtIndex:1];
        [_mapSegmentControl setTitle:@"关闭个性化" forSegmentAtIndex:2];
        _mapSegmentControl.selectedSegmentIndex = 0;
        [_mapSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _mapSegmentControl;
}

@end
