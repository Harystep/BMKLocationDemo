//
//  BMKPolylineOverlayPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPolylineOverlayPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKPolylineOverlayPage ()<BMKMapViewDelegate>
///当前界面的mapView
@property (nonatomic, strong) BMKMapView *mapView;
///当前界面的透明纹理折线
@property (nonatomic, strong) BMKPolyline *polyline;
///当前界面的分段颜色的折线
@property (nonatomic, strong) BMKPolyline *colorfulPolyline;
///当前界面分段纹理的折线
@property (nonatomic, strong) BMKPolyline *mulTexturePolyline;
///当前界面虚折线
@property (nonatomic, strong) BMKPolyline *dashPolyline;

@end

@implementation BMKPolylineOverlayPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
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
    self.title = @"折线绘制";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
     来生成标注对应的View
     @param overlay 要添加的overlay
     */
    //透明纹理折线,向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法来生成标注对应的View
    [_mapView addOverlay:self.polyline];
   
    //分段颜色折线,向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法来生成标注对应的View
    [_mapView addOverlay:self.colorfulPolyline];
    
    //分段纹理折线,向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法来生成标注对应的View
    [_mapView addOverlay:self.mulTexturePolyline];
    
    //虚折线,向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法来生成标注对应的View
    [_mapView addOverlay:self.dashPolyline];
}

#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        //初始化一个overlay并返回相应的BMKPolylineView的实例
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
        if ([overlay isEqual:_polyline]) {
            //设置polylineView的画笔宽度为24
            polylineView.lineWidth = 24.0f;
            /**
             *加载纹理图片
             @param textureImage 图片对象，opengl要求图片宽高必须是2的n次幂，如果图片对象为nil，则清空原有纹理
             @return openGL纹理ID, 若纹理加载失败返回0
             */
            [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"textureArrow.png"]];
        } else if ([overlay isEqual:_colorfulPolyline]) {
            //设置polylineView的画笔宽度为12
            polylineView.lineWidth = 12.f;
            /**
             分段设置polylineView的颜色
             注：初始化UIColor请使用-initWithRed:green:blue:alpha:，若使用[UIColor **Color]
             个别case转换成RGB后会有问题
             */
            polylineView.colors = [NSArray arrayWithObjects:
                                   [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5],
                                   [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:1],nil];
            //lineCapType,默认是kBMKLineCapButt (不支持虚线)
            polylineView.lineCapType = kBMKLineCapRound;
        }else if ([overlay isEqual:_mulTexturePolyline]) {
            polylineView.lineWidth = 12.f;
            /**
             *加载分段纹理绘制 所需的纹理图片
             @param textureImages 必须UIImage数组，opengl要求图片宽高必须是2的n次幂，否则，返回NO，无法分段纹理绘制
             @return 是否成功
             */
            [polylineView loadStrokeTextureImages:@[[UIImage imageNamed:@"traffic_texture_congestion"],
                                                    [UIImage imageNamed:@"traffic_texture_slow"],
                                                    [UIImage imageNamed:@"traffic_texture_smooth"],
                                                    [UIImage imageNamed:@"traffic_texture_unknown"]]];
            //LineJoinType,默认是kBMKLineJoinBevel（不支持虚线）
            //拐角处圆角衔接
            polylineView.lineJoinType = kBMKLineJoinRound;
//            //拐角处平角衔接
//            polylineView.lineJoinType = kBMKLineJoinBevel;
//            //拐角处尖角衔接，ps尖角连接(尖角过长(大于线宽)按平角处理)
//            polylineView.lineJoinType = kBMKLineJoinMiter;
        }else if ([overlay isEqual:_dashPolyline]) {
            //设置polylineView的画笔颜色为蓝色
            polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
            //设置polylineView的画笔宽度为12
            polylineView.lineWidth = 12.f;
            //虚线类型, since 5.0.0，默认kMALineDashTypeNone(仅支持颜色虚线)
            //圆点虚线样式
            polylineView.lineDashType = kBMKLineDashTypeDot;
        }else{
        
        }
        return polylineView;
    }
    return nil;
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

- (BMKPolyline *)polyline {
    if (!_polyline) {
        CLLocationCoordinate2D coords[3] = {0};
        coords[0] = CLLocationCoordinate2DMake(40.055134, 116.400101);
        coords[1] = CLLocationCoordinate2DMake(39.983081, 116.393202);
        coords[2] = CLLocationCoordinate2DMake(39.903423, 116.327661);
        /**
         *根据指定坐标点生成一段折线
         *@param coords 指定的经纬度坐标点数组
         *@param count 坐标点的个数
         *@return 新生成的折线对象
         */
        _polyline = [BMKPolyline polylineWithCoordinates:coords count:3];
    }
    return _polyline;
}

- (BMKPolyline *)colorfulPolyline {
    if (!_colorfulPolyline) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0] = CLLocationCoordinate2DMake(39.965, 116.404);
        coords[1] = CLLocationCoordinate2DMake(39.925, 116.454);
        coords[2] = CLLocationCoordinate2DMake(39.955, 116.494);
        coords[3] = CLLocationCoordinate2DMake(39.905, 116.554);
        coords[4] = CLLocationCoordinate2DMake(39.965, 116.604);
        //构建分段颜色索引数组
        NSArray *colorIndexs = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:3], nil];
        
        /**
         *根据指定坐标点生成一段折线
         *
         *分段纹理绘制：其对应的BMKPolylineView必须使用 - (BOOL)loadStrokeTextureImages:(NSArray <UIImage *>*)textureImages; 加载纹理图片；否则使用默认的灰色纹理绘制
         *分段颜色绘制：其对应的BMKPolylineView必须设置colors属性
         *
         *@param coords 指定的经纬度坐标点数组
         *@param count 坐标点的个数
         *@param textureIndex 纹理索引数组（颜色索引数组），成员为NSNumber,且为非负数，负数按0处理
         *@return 新生成的折线对象
         */
        _colorfulPolyline = [BMKPolyline polylineWithCoordinates:coords count:5 textureIndex:colorIndexs];
    }
    return _colorfulPolyline;
}

-(BMKPolyline *)mulTexturePolyline{
    if (!_mulTexturePolyline) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0] = CLLocationCoordinate2DMake(40.071608, 116.257414);
        coords[1] = CLLocationCoordinate2DMake(40.012062, 116.257414);
        coords[2] = CLLocationCoordinate2DMake(40.012062, 116.347891);
        coords[3] = CLLocationCoordinate2DMake(40.071608, 116.347891);
        coords[4] = CLLocationCoordinate2DMake(40.071608, 116.257414);
        
        //构建分段纹理索引数组
        NSArray *textureIndexs = @[@(0),@(1),@(2),@(3)];
        /**
         *根据指定坐标点生成一段折线
         *
         *分段纹理绘制：其对应的BMKPolylineView必须使用 - (BOOL)loadStrokeTextureImages:(NSArray <UIImage *>*)textureImages; 加载纹理图片；否则使用默认的灰色纹理绘制
         *分段颜色绘制：其对应的BMKPolylineView必须设置colors属性
         *
         *@param coords 指定的经纬度坐标点数组
         *@param count 坐标点的个数
         *@param textureIndex 纹理索引数组（颜色索引数组），成员为NSNumber,且为非负数，负数按0处理
         *@return 新生成的折线对象
         */
        _mulTexturePolyline = [BMKPolyline polylineWithCoordinates:coords count:5 textureIndex:textureIndexs];
    }
    return _mulTexturePolyline;
}

-(BMKPolyline *)dashPolyline{
    if (!_dashPolyline) {
        CLLocationCoordinate2D coords[3] = {0};
        coords[0] = CLLocationCoordinate2DMake(39.815, 116.304);
        coords[1] = CLLocationCoordinate2DMake(39.895, 116.354);
        coords[2] = CLLocationCoordinate2DMake(39.815, 116.360);
        /**
         *根据指定坐标点生成一段折线
         *@param coords 指定的经纬度坐标点数组
         *@param count 坐标点的个数
         *@return 新生成的折线对象
         */
        _dashPolyline = [BMKPolyline polylineWithCoordinates:coords count:3];
    }
    return _dashPolyline;
}

@end
