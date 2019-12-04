//
//  BMKDistrictSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKDistrictSearchPage.h"
#import "BMKDistrictParametersPage.h"

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKDistrictSearchDelegate
 获取search的回调方法
 */
@interface BMKDistrictSearchPage ()<BMKMapViewDelegate, BMKDistrictSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKDistrictSearchPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self createSearchToolView];
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"行政区边界检索";
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc]initWithCustomView:self.customButton];
    self.navigationItem.rightBarButtonItem = customButton;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

- (void)createSearchToolView{
    [self createToolBarsWithItemArray:
     @[@{@"leftItemTitle":@"城 市：",
         @"rightItemText":@"北京",
         @"rightItemPlaceholder":@"输入城市"},
       @{@"leftItemTitle":@"区 县：",
         @"rightItemText":@"海淀",
         @"rightItemPlaceholder":@"输入区或县"}
       ]];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    BMKDistrictSearchOption *districtOption = [[BMKDistrictSearchOption alloc] init];
    districtOption.city = self.dataArray[0];
    districtOption.district = self.dataArray[1];
    [self searchData:districtOption];
}

- (void)searchData:(BMKDistrictSearchOption *)option {
    //初始化BMKDistrictSearch实例
    BMKDistrictSearch *districtSearch = [[BMKDistrictSearch alloc] init];
    //设置行政区域检索的代理
    districtSearch.delegate = self;
    //初始化请求参数类BMKDistrictSearchOption的实例
    BMKDistrictSearchOption *districtOption = [[BMKDistrictSearchOption alloc] init];
    //城市名，必选
    districtOption.city = option.city;
    //区县名字，可选
    districtOption.district = option.district;
    /**
     行政区域检索：异步方法，返回结果在BMKDistrictSearchDelegate的
     onGetDistrictResult里
     
     districtOption 公交线路检索信息类
     return 成功返回YES，否则返回NO
     */
    BOOL flag = [districtSearch districtSearch:districtOption];
    if (flag) {
        NSLog(@"行政区域检索发送成功");
    } else {
        NSLog(@"行政区域检索发送失败");
    }
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKDistrictParametersPage *page = [[BMKDistrictParametersPage alloc] init];
    page.searchDataBlock = ^(BMKDistrictSearchOption *option) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"城 市：",
             @"rightItemText":option.city,
             @"rightItemPlaceholder":@"输入城市"},
           @{@"leftItemTitle":@"区 县：",
             @"rightItemText":option.district,
             @"rightItemPlaceholder":@"输入区或县"}
           ]];
        [self searchData:option];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKDistrictSearchDelegate
/**
 行政区域检索结果回调
 
 @param searcher 检索对象
 @param result 行政区域检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
    [_mapView removeOverlays:_mapView.overlays];
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR) {
        for (NSString *path in result.paths) {
            BMKPolygon *polygon = [self transferPathStringToPolygon:path];
            /**
             向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
             来生成标注对应的View
             
             @param overlay 要添加的overlay
             */
            [_mapView addOverlay:polygon];
        }
        _mapView.centerCoordinate = result.center;
        NSString *message = [NSString stringWithFormat:@"行政区域编码：%ld\n行政区域名称：%@\n行政区域中心点：%f,%f", (long)result.code, result.name, result.center.latitude, result.center.longitude];
        [self alertMessage:message];
    }
}

- (BMKPolygon *)transferPathStringToPolygon:(NSString *)path {
    NSUInteger pathCount = [path componentsSeparatedByString:@";"].count;
    if (pathCount > 0) {
        BMKMapPoint points[pathCount];
        NSArray *pointsArray = [path componentsSeparatedByString:@";"];
        for (NSUInteger i = 0; i < pathCount; i ++) {
            if ([pointsArray[i] rangeOfString:@","].location != NSNotFound) {
                NSArray *coordinates = [pointsArray[i] componentsSeparatedByString:@","];
                points[i] = BMKMapPointMake([coordinates.firstObject doubleValue], [coordinates .lastObject doubleValue]);
            }
        }
        /**
         根据多个点生成多边形
         
         points 直角坐标点数组，这些点将被拷贝到生成的多边形对象中
         count 点的个数
         新生成的多边形对象
         */
        BMKPolygon *polygon = [BMKPolygon polygonWithPoints:points count:pathCount];
        return polygon;
    }
    return nil;
}

#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        //初始化一个overlay并返回相应的BMKPolygonView的实例
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        //设置polygonView的画笔（边框）颜色
        polygonView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
        //设置polygonView的填充色
        polygonView.fillColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.4];
        //设置polygonView的线宽度
        polygonView.lineWidth = 1;
        //lineDash属性已废弃，请使用lineDashType配置虚线样式
//        polygonView.lineDash = YES;
        polygonView.lineDashType = kBMKLineDashTypeSquare;
        return polygonView;
    }
    return nil;
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue - 35 * 2)];
    }
    return _mapView;
}

- (UIButton *)customButton {
    if (!_customButton) {
        _customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_customButton setTitle:@"详细参数" forState:UIControlStateNormal];
        [_customButton setTitle:@"详细参数" forState:UIControlStateHighlighted];
        [_customButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_customButton setFrame:CGRectMake(0, 3, 69, 20)];
        [_customButton addTarget:self action:@selector(clickCustomButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
}

@end
