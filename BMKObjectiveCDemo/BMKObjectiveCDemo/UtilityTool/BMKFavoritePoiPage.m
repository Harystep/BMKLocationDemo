//
//  BMKFavoritePOIPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKFavoritePOIPage.h"

#define kHeight_SegMentBackgroud  60
//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKFavoritePOI";

//开发者通过此delegate获取mapView的回调方法
@interface BMKFavoritePOIPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UISegmentedControl *favoritesSegmentControl;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) BMKFavPoiManager *favPoiManager;
@property (nonatomic, strong) NSMutableArray *annotations;
@end

@implementation BMKFavoritePOIPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        _favPoiManager = [[BMKFavPoiManager alloc] init];
        _coordinate = CLLocationCoordinate2DMake(0, 0);
        _annotations = [NSMutableArray array];
    }
    return self;
}

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
    self.title = @"收藏夹功能";
    [self.view addSubview:self.favoritesSegmentControl];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Responding events
- (void)segmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_favoritesSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            [self saveFavorites];
            break;
        default:
            [self deleteFavorites];
            break;
    }
}

#pragma mark - Favorites
- (void)deleteFavorites {
    /**
      清空所有收藏点
     
      @return 成功返回YES，失败返回NO
     */
    [_favPoiManager clearAllFavPois];
    /**
     移除一组标注
     
     @param annotations 要移除的标注数组
     */
    [_mapView removeAnnotations:_annotations];
    [_annotations removeAllObjects];
}

- (void)saveFavorites {
    for (NSUInteger i = 0; i < 10; i ++) {
        BMKFavPoiInfo *favPoiInfo = [[BMKFavPoiInfo alloc] init];
        favPoiInfo.pt = CLLocationCoordinate2DMake(40.04 + i * 0.01, 116.27 + i * 0.01);
        favPoiInfo.poiName = [NSString stringWithFormat:@"%.f,%.f", _coordinate.latitude, _coordinate.longitude];
        [_favPoiManager addFavPoi:favPoiInfo];
    }
    NSArray *favPois = [_favPoiManager getAllFavPois];
    for (NSUInteger i = 0; i < favPois.count; i ++) {
        BMKFavPoiInfo *favPoiInfo = favPois[i];
        //初始化标注类BMKPointAnnotation的实例
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        //设置标注的经纬度坐标
        annotation.coordinate = favPoiInfo.pt;
        //设置标注的标题
        annotation.title = favPoiInfo.poiName;
        [_annotations addObject:annotation];
    }
    //将一组标注添加到当前地图View中
    [_mapView addAnnotations:_annotations];
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
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kHeight_SegMentBackgroud, KScreenWidth, KScreenHeight - kViewTopHeight - kHeight_SegMentBackgroud - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

- (UISegmentedControl *)favoritesSegmentControl {
    if (!_favoritesSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"添加",@"删除",nil];
        _favoritesSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _favoritesSegmentControl.frame = CGRectMake(10*widthScale, 12.5, 355*widthScale, 35);
        [_favoritesSegmentControl setTitle:@"添加" forSegmentAtIndex:0];
        [_favoritesSegmentControl setTitle:@"删除" forSegmentAtIndex:1];
        _favoritesSegmentControl.selectedSegmentIndex = 1;
        [_favoritesSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _favoritesSegmentControl;
}

@end
