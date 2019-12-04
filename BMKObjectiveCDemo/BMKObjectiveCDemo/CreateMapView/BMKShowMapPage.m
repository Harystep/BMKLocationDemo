//
//  BMKShowMapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKShowMapPage.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#define kHeight_SegMentBackgroud  0.0
#define kHeight_BottomControlView  0.0

//开发者通过此delegate获取mapView的回调方法
@interface BMKShowMapPage ()<BMKMapViewDelegate, BMKLocationManagerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@property (nonatomic, strong) BMKLocationManager *locationManager;/** locationManager*/
@property (nonatomic, strong) BMKPointAnnotation *annotation ;/** 标记*/
@property (nonatomic, strong) NSMutableArray *annotationArr;/** 标记数组*/
@property (nonatomic, strong) NSMutableArray *circleArr;/** 圆形数组*/


@end

@implementation BMKShowMapPage

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
    self.title = @"显示地图";
}

- (void)createMapView {
    [self initUserLocationManager];
}
#pragma mark 初始化locationManager
- (void)initUserLocationManager {
    //因为mapView是在一个分离出来的view中创建的，所以在这里将signSetTypeView中的mapView赋给当前viewcontroller的mapView；
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    
    // self.mapView是BMKMapView对象
    //精度圈设置
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    //设置显示精度圈，默认YES
    param.isAccuracyCircleShow = YES;
    //精度圈 边框颜色
    param.accuracyCircleStrokeColor = [UIColor colorWithRed:242/255.0 green:129/255.0 blue:126/255.0 alpha:1];
    //精度圈 填充颜色
    param.accuracyCircleFillColor = [UIColor colorWithRed:242/255.0 green:129/255.0 blue:126/255.0 alpha:0.3];
    [self.mapView updateLocationViewWithParam:param];
    
    self.userLocation = [[BMKUserLocation alloc] init];
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    //_locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 15;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 15;
    //请求一次定位
    [self requestLocation];
}
#pragma mark 请求定位
- (void)requestLocation {
    
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        if (location) {//得到定位信息，添加annotation
            
            if (location.location) {
                NSLog(@"LOC = %@",location.location);
            }
            if (location.rgcData) {
                NSLog(@"rgc = %@",[location.rgcData description]);
            }
            
            if (!location) {
                return;
            }
            if (!self.userLocation) {
                self.userLocation = [[BMKUserLocation alloc] init];
            }
            self.userLocation.location = location.location;
            [self.mapView updateLocationData:self.userLocation];
            CLLocationCoordinate2D mycoordinate = location.location.coordinate;
            self.mapView.centerCoordinate = mycoordinate;
            
            //打印经纬度
            NSLog(@"didUpdateUserLocation lat %f,long %f",location.location.coordinate.latitude,location.location.coordinate.longitude);
            [self createAnnotationWithLatitude:location.location.coordinate.latitude longitude:location.location.coordinate.longitude];
        }
        NSLog(@"netstate = %d",state);
    }];
}


#pragma mark - 创建标注
-(void)createAnnotationWithLatitude:(double)latitude longitude:(double)longitude{
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    //执行 addAnnotation：方法后才会走<BMKMapViewDelegate>代理方法
    [self.mapView addAnnotation:annotation];
}

#pragma mark - <BMKMapViewDelegate>
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    annotationView.image = [UIImage imageNamed:@"hd_location"];
    return annotationView;
    
}

//长按地图选点
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    
    if (self.annotationArr.count > 0) {
        [mapView removeAnnotations:self.annotationArr];
        [self.annotationArr removeAllObjects];
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = coordinate;
        [self.annotationArr addObject:annotation];
        [mapView addAnnotations:self.annotationArr];
    } else {
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = coordinate;
        [self.annotationArr addObject:annotation];
        [mapView addAnnotations:self.annotationArr];
    }
    //弹出半径选择框
//    [self showLocationSelectRadiusViewWithCoordinate:coordinate];
}
#pragma mark 弹出位置弹框
//- (void)showLocationSelectRadiusViewWithCoordinate:(CLLocationCoordinate2D)coordinate {
//    ExtraActLocationSignPopView *popView = [ExtraActLocationSignPopView new];
//    [popView show];
//    @weakify(self);
//    [popView.locatioonSureSignal subscribeNext:^(NSString *x) {
//        @strongify(self);
//        self.viewModel.radius = x;
//        CGFloat radius = [x floatValue];
//        [self circleWithCenterWithCoordinate2D:coordinate radius:radius];
//    }];
//}
#pragma mark 添加区域圆形覆盖
- (void)circleWithCenterWithCoordinate2D:(CLLocationCoordinate2D )coor radius:(CGFloat)radius {
    
    NSLog(@"coordinate lat %f,long %f",coor.latitude,coor.longitude);
    //赋予点击选点值
//    self.viewModel.lat = [NSString stringWithFormat:@"%f", coor.latitude];
//    self.viewModel.lng = [NSString stringWithFormat:@"%f",coor.longitude];
    
    if (self.circleArr.count > 0) {
        [_mapView removeOverlays:self.circleArr];
        [self.circleArr removeAllObjects];
        
        BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:radius];
        [self.circleArr addObject:circle];
        [_mapView addOverlays:self.circleArr];
    } else {
        BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:radius];
        [self.circleArr addObject:circle];
        [_mapView addOverlays:self.circleArr];
    }
}

#pragma mark 重绘overlay
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [UIColor colorWithRed:33/255.0 green:196/255.0 blue:206/255.0 alpha:0.3];
        circleView.strokeColor = [UIColor colorWithRed:33/255.0 green:196/255.0 blue:206/255.0 alpha:1];
        circleView.lineWidth = 1.0;
        return circleView;
    }
    return nil;
}

#pragma mark - Responding events
- (void)segmentControlDidChangeValue:(id)sender {
//    NSUInteger selectedIndex = [_mapSegmentControl selectedSegmentIndex];
    switch (3) {
        case 1:
            //设置当前地图类型为卫星地图
            [_mapView setMapType:BMKMapTypeSatellite];
            break;
        case 2:
            //设置当前地图类型为空白地图
            [_mapView setMapType:BMKMapTypeNone];
            break;
        default:
            //设置当前地图类型为标准地图
            [_mapView setMapType:BMKMapTypeStandard];
            break;
    }
}

- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_map_config" ofType:@"json"];
           //设置个性化地图样式
        [self.mapView setCustomMapStylePath:path];
        //开启个性化地图样式
        [self.mapView setCustomMapStyleEnable:YES];
    } else {
        //关闭个性化地图样式
        [self.mapView setCustomMapStyleEnable:NO];
    }
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kHeight_SegMentBackgroud, KScreenWidth, KScreenHeight - kViewTopHeight - kHeight_SegMentBackgroud - kHeight_BottomControlView - KiPhoneXSafeAreaDValue)];
        _mapView.zoomLevel = 19;//地图等级，数字越大越清晰
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
- (NSMutableArray *)annotationArr {
    
    if (!_annotationArr) {
        _annotationArr = [NSMutableArray array];
    }
    return _annotationArr;
}

- (NSMutableArray *)circleArr {
    if (!_circleArr) {
        _circleArr = [NSMutableArray array];
    }
    return _circleArr;
}
@end
