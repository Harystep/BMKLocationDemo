//
//  BMKCustomOverlayPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCustomOverlayPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKCustomOverlayPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView

@end

@implementation BMKCustomOverlayPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self createCustomOverlay];
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
    self.title = @"自定义绘制";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

- (void)createCustomOverlay {
    //地理坐标点，用直角地理坐标表示
    //BMKMapPoint points[2];
    BMKMapPoint *points = new BMKMapPoint[2];
    /**
     将经纬度坐标转换为投影后的直角地理坐标
     @param coordinate 待转换的经纬度坐标
     @return 转换后的直角地理坐标
     */
    points[0] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915, 116.404));
    points[1] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(40.015, 116.404));
    //初始化一个自定义图层的实例（继承于BMKShape）
    CustomOverlay *customOverlay = [[CustomOverlay alloc] initWithPoints:points count:2];
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
     来生成标注对应的View
     
     @param overlay 要添加的overlay
     */
    [_mapView addOverlay:customOverlay];
    
    BMKMapPoint polygonPoints[3];
    polygonPoints[0] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915, 116.504));
    polygonPoints[1] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(40.015, 116.504));
    polygonPoints[2] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.965, 116.604));
    CustomOverlay *customPolygon = [[CustomOverlay alloc] initWithPoints:polygonPoints count:3];
    customPolygon.fillColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    customPolygon.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
     来生成标注对应的View
     
     @param overlay 要添加的overlay
     */
    [_mapView addOverlay:customPolygon];
    
    BMKMapPoint polygonPoints2[3];
    polygonPoints2[0] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.999, 116.509));
    polygonPoints2[1] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(40.025, 116.599));
    polygonPoints2[2] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.999, 116.699));
    CustomOverlay *customPolygon2 = [[CustomOverlay alloc] initWithPoints:polygonPoints2 count:3];
    customPolygon2.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    customPolygon2.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
     来生成标注对应的View
     
     @param overlay 要添加的overlay
     */
    [_mapView addOverlay:customPolygon2];
}

#pragma mark - BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        //初始化一个overlay并返回相应的CustomOverlayView的实例
        CustomOverlayView *customView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        //设置customView的画笔（边框）颜色
        customView.strokeColor = ((CustomOverlay*)overlay).strokeColor;
        //设置customView的填充色
        customView.fillColor = ((CustomOverlay*)overlay).fillColor;
        //设置customView的线宽度
        customView.lineWidth = 5.0;
        return customView;
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

@end

#pragma mark - CustomOverlay
@implementation CustomOverlay
- (id)initWithPoints:(BMKMapPoint *)points count:(NSUInteger)count {
    self = [super init];
    if (points != nil && count > 0) {
        _points = new BMKMapPoint[count];
        memcpy(_points, points, sizeof(BMKMapPoint) *count);
        _pointCount = count;
    }
    return self;
}

+ (CustomOverlay *)customWithPoints:(BMKMapPoint *)points count:(NSUInteger)count {
    CustomOverlay *polygon = [[CustomOverlay alloc] initWithPoints:points count:count];
    return polygon;
}

- (BMKMapRect)boundingMapRect {
    if (_points != nil && _pointCount > 0) {
        //矩形，用直角地理坐标表示，设置屏幕左上点对应的直角地理坐标
        _boundingMapRect.origin = _points[0];
        //宽度范围
        _boundingMapRect.size.width = 0;
        //高度范围
        _boundingMapRect.size.height = 0;
        for (int i = 0; i < _pointCount; i++) {
            _boundingMapRect = [CustomOverlay mapRectUnionWithPoint:_boundingMapRect point:_points[i]];
        }
        if (_boundingMapRect.size.width == 0) {
            _boundingMapRect.size.width = 1;
        }
        if (_boundingMapRect.size.height == 0) {
            _boundingMapRect.size.height = 1;
        }
    }
    return _boundingMapRect;
}

+ (BMKMapRect)mapRectUnionWithPoint:(BMKMapRect)rect point:(BMKMapPoint)point {
    BMKMapRect mapRect;
    double temp = MAX(rect.origin.x + rect.size.width, point.x);
    mapRect.origin.x = MIN(rect.origin.x, point.x);
    mapRect.size.width = temp - mapRect.origin.x;
    temp = MAX(rect.origin.y + rect.size.height, point.y);
    mapRect.origin.y = MIN(rect.origin.y, point.y);
    mapRect.size.height = temp - mapRect.origin.y;
    return mapRect;
}
@end

#pragma mark - CustomOverlayView
@implementation CustomOverlayView
- (CustomOverlay *)customOverlay {
    return (CustomOverlay *)self.overlay;
}

/**
 绘制方法(子类需要重载来实现)
 */
- (void)glRender {
    CustomOverlay *customOverlay = self.customOverlay;
    if (customOverlay.pointCount >= 3) {
        //纹理图片是否缩放（tileTexture为YES时生效），默认NO
        self.keepScale = NO;
        /**
         使用OpenGLES 绘制线 已废弃
         
         @param points 直角坐标点
         @param pointCount 点个数
         @param strokeColor 线颜色
         @param lineWidth OpenGLES支持线宽尺寸
         @param looped 是否闭合, 如polyline会设置NO, polygon会设置YES.
         @param lineDash 是否虚线样式
         */
        
//        [self renderLinesWithPoints:customOverlay.points pointCount:customOverlay.pointCount strokeColor:self.strokeColor lineWidth:self.lineWidth looped:YES lineDash:YES];
        /**
         *使用OpenGLES 指定颜色绘制线 since 5.0.0
         @param points 直角坐标点
         @param pointCount 点个数
         @param strokeColor 线颜色
         @param lineWidth OpenGLES支持线宽尺寸
         @param looped 是否闭合, 如polyline会设置NO, polygon会设置YES.
         @param lineDashType 虚线样式
         */
        [self renderLinesWithPoints:customOverlay.points pointCount:customOverlay.pointCount strokeColor:self.strokeColor lineWidth:self.lineWidth looped:YES lineDashType:kBMKLineDashTypeDot];
        /**
         使用OpenGLES 绘制区域
         
         @param points 直角坐标点
         @param pointCount 点个数
         @param fillColor 填充颜色
         @param usingTriangleFan YES对应GL_TRIANGLE_FAN, NO对应GL_TRIANGLES
         */
        [self renderRegionWithPoints:customOverlay.points pointCount:customOverlay.pointCount fillColor:self.fillColor usingTriangleFan:YES];
    } else {
        /**
         加载纹理图片
         
         textureImage 图片对象，openGL要求图片宽高必须是2的n次幂，如果图片对象为nil，则清空原有纹理
         返回openGL纹理ID, 若纹理加载失败返回0
         */
        GLuint testureID = [self loadStrokeTextureImage:[UIImage imageNamed:@"textureArrow.png"]];
        if (testureID) {
            /**
             使用OpenGLES 按指定纹理绘制线
             
             @param points 直角坐标点
             @param pointCount 点个数
             @param lineWidth OpenGLES支持线宽尺寸
             @param textureID 纹理ID,使用- (void)loadStrokeTextureImage:(UIImage *)textureImage;加载
             @param looped 是否闭合, 如polyline会设置NO, polygon会设置YES.
             */
            [self renderTexturedLinesWithPoints:customOverlay.points pointCount:customOverlay.pointCount lineWidth:30 textureID:testureID looped:NO];
        } else {
            /**
             使用OpenGLES 绘制线
             
             @param points 直角坐标点
             @param pointCount 点个数
             @param strokeColor 线颜色
             @param lineWidth OpenGLES支持线宽尺寸
             @param looped 是否闭合, 如polyline会设置NO, polygon会设置YES.
             */
            [self renderLinesWithPoints:customOverlay.points pointCount:customOverlay.pointCount strokeColor:self.strokeColor lineWidth:self.lineWidth looped:NO];
        }
    }
}

@end
