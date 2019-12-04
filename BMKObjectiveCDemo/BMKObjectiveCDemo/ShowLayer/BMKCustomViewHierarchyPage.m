//
//  BMKCustomViewHierarchyPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCustomViewHierarchyPage.h"

#define kHeight_BottomControlView  60
//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKCustomViewHierarchy";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKLocationManagerDelegate
 获取locationManager的回调方法
 */
@interface BMKCustomViewHierarchyPage ()<BMKMapViewDelegate, BMKLocationManagerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView; //底部容器视图
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) UIButton *hierarchyButton;
@property (nonatomic, strong) BMKLocationViewDisplayParam *param; //定位图层自定义样式参数
@property (nonatomic, strong) BMKPointAnnotation *annotation; //annotation实例
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@end

@implementation BMKCustomViewHierarchyPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self addLocationAnnotation];
    [self setupLocationManager];
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
    self.title = @"定位展示（自定义覆盖层级）";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.hierarchyButton];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

- (void)setupLocationManager {
    //开启定位服务
    [self.locationManager startUpdatingLocation];
    //设置显示定位图层
    _mapView.showsUserLocation = YES;
    //配置定位图层个性化样式，初始化BMKLocationViewDisplayParam的实例
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    //设置定位图标(屏幕坐标)X轴偏移量为0
    param.locationViewOffsetX = 0;
    //设置定位图标(屏幕坐标)Y轴偏移量为0
    param.locationViewOffsetY = 0;
    //设置定位图层locationView在最上层(也可设置为在下层)
    param.locationViewHierarchy = LOCATION_VIEW_HIERARCHY_TOP;
    //设置显示精度圈
    param.isAccuracyCircleShow = YES;
    //更新定位图层个性化样式
    [_mapView updateLocationViewWithParam:param];
    self.param = param;
}

- (void)addLocationAnnotation {
    //初始化标注类BMKPointAnnotation的实例
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    /**
     
     当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
     来生成标注对应的View
     @param annotation 要添加的标注
     */
    [_mapView addAnnotation:annotation];
    _annotation = annotation;
}

#pragma mark - Responding events
- (void)clickHierarchyButton {
    _param.locationViewHierarchy == LOCATION_VIEW_HIERARCHY_BOTTOM ?
    //LocationView在mapview上显示的层级：locationView在最上层
    _param.locationViewHierarchy = LOCATION_VIEW_HIERARCHY_TOP :
    //LocationView在mapview上显示的层级：locationView在最下层
    _param.locationViewHierarchy = LOCATION_VIEW_HIERARCHY_BOTTOM;
    //更新定位图层个性化样式
    [_mapView updateLocationViewWithParam:_param];
}

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
    //设置标注的经纬度坐标
    _annotation.coordinate = self.userLocation.location.coordinate;
}

#pragma mark - BMKMapViewDelegate
/**
 根据anntation生成对应的annotationView
 
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        /**
         根据指定标识查找一个可被复用的标注，用此方法来代替新创建一个标注，返回可被复用的标注
         */
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
        if (!annotationView) {
            /**
             初始化并返回一个annotationView
             
             @param annotation 关联的annotation对象
             @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
             @return 初始化成功则返回annotationView，否则返回nil
             */
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
            //获取图片路径
            NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mapapi.bundle"]];
            NSString *file = [[bundle resourcePath] stringByAppendingPathComponent:@"images/baidumap_logo"];
            //设置annotationView显示的图片，默认是大头针
            annotationView.image = [UIImage imageWithContentsOfFile:file];
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - Lazy loading
- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化BMKLocationManager(定位)的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置BMKLocationService的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

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

- (UIButton *)hierarchyButton {
    if (!_hierarchyButton) {
        _hierarchyButton = [[UIButton alloc] initWithFrame:CGRectMake(108 * widthScale, 12.5, 159 * widthScale, 35)];
        [_hierarchyButton addTarget:self action:@selector(clickHierarchyButton) forControlEvents:UIControlEventTouchUpInside];
        [_hierarchyButton setTitle:@"切换覆盖层级" forState:UIControlStateNormal];
        _hierarchyButton.clipsToBounds = YES;
        _hierarchyButton.layer.cornerRadius = 16;
        _hierarchyButton.titleLabel.textColor = [UIColor whiteColor];
        _hierarchyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _hierarchyButton.backgroundColor = COLOR(0x3385FF);
    }
    return _hierarchyButton;
}

@end
