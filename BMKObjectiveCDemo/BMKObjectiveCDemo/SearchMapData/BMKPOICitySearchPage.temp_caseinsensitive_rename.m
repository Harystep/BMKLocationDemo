//
//  BMKPoiCitySearchPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOICitySearchPage.h"

#define kHeight_BottomControlView  60
//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKPoiCitySearch";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKPoiSearchDelegate
 获取search的回调方法
 */
@interface BMKPOICitySearchPage ()<BMKMapViewDelegate, BMKPoiSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKPoiCitySearchPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    //初始化BMKPoiSearch实例
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    //设置poi检索的代理
    poiSearch.delegate = self;
    //初始化请求参数类BMKCitySearchOption的实例
    BMKPOICitySearchOption *cityOption = [[BMKPOICitySearchOption alloc]init];
    //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
    cityOption.city= @"北京";
    //是否请求门址信息列表，默认为YES
//    cityOption.requestPoiAddressInfoList = YES;
    //检索关键字
    cityOption.keyword = @"小吃";
    //分页索引，默认为0，可选
    cityOption.pageIndex = 0;
    //分页数量，默认为10，最多为50，可选
//    cityOption.pageCapacity = 10;
    /**
     城市POI检索：异步方法，返回结果在BMKPoiSearchDelegate的onGetPoiResult里
     
     cityOption 城市内搜索的搜索参数类（BMKCitySearchOption）
     成功返回YES，否则返回NO
     */
    BOOL flag = [poiSearch poiSearchInCity:cityOption];
    if(flag) {
        NSLog(@"poi城市内检索成功");
    } else {
        NSLog(@"poi城市内检索失败");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = COLOR(0xFFFFFF);
    self.view.backgroundColor = COLOR(0xFFFFFF);
    self.title = @"poi城市内检索";
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - BMKPoiSearchDelegate
/**
 poi检索返回结果回调
 
 @param searcher 检索对象
 @param poiResult poi检索结果列表
 @param error 错误码
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)error {
    /**
     移除一组标注
     
     @param annotations 要移除的标注数组
     */
    [_mapView removeAnnotations:_mapView.annotations];
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (NSUInteger i = 0; i < poiResult.poiInfoList.count; i ++) {
            //poi信息类的实例
            BMKPoiInfo* poi = poiResult.poiInfoList[i];
            //标注
            BMKPointAnnotation* annotaiton = [[BMKPointAnnotation alloc]init];
            //设置标注的经纬度坐标
            annotaiton.coordinate = poi.pt;
            //设置标注的标题
            annotaiton.title = poi.name;
            [annotations addObject:annotaiton];
        }
        //将一组标注添加到当前地图View中
        [_mapView addAnnotations:annotations];
    }
    //poi信息类的实例
    BMKPoiInfo *poiInfo = poiResult.poiInfoList[0];
    //城市列表信息类的实例
//    BMKCityListInfo *cityListInfo = poiResult.cityList[0];
//    //poi门址信息类的实例
//    BMKPoiAddressInfo *poiAddrsInfo = poiResult.poiAddressInfoList[0];
//    //POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
//    NSString *message = [NSString stringWithFormat:@"总结果数：%d\n当前页的结果数：%d\n总页数：%d\n当前页的索引：%d\n是否返回有门址信息列表：%d\n名称：%@\npoi的uid：%@\n地址：%@\n所在城市：%@\n电话号码：%@\n邮编：%@\n类型：%d\n纬度：%f\n经度：%f\n是否有全景：%d\n城市名称：%@\n该城市所含搜索结果数目：%d\n名称：%@\n地址：%@\n纬度：%f\n经度：%f", poiResult.totalPoiNum, poiResult.currPoiNum, poiResult.pageNum, poiResult.pageIndex, poiResult.isHavePoiAddressInfoList, poiInfo.name, poiInfo.uid, poiInfo.address, poiInfo.city, poiInfo.phone, poiInfo.postcode, poiInfo.epoitype,poiInfo.pt.latitude, poiInfo.pt.longitude, poiInfo.panoFlag, cityListInfo.city, cityListInfo.num, poiAddrsInfo.name, poiAddrsInfo.address, poiAddrsInfo.pt.latitude, poiAddrsInfo.pt.longitude];
//    [self alertMessage:message];
}

- (void)alertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检索结果" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BMKMapViewDelegate
/**
 根据anntation生成对应的annotationView
 
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    /**
     根据指定标识查找一个可被复用的标注，用此方法来代替新创建一个标注，返回可被复用的标注
     */
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
    if (!annotationView) {
        /**
         初始化并返回一个annotationView
         
         @param annotation 关联的annotation对象
         @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
         @return 初始化成功则返回annotationView，否则返回nil
         */
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
        /**
         标注的颜色，有BMKPinAnnotationColorRed, BMKPinAnnotationColorGreen,
         BMKPinAnnotationColorPurple三种
         */
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        //设置从天而降的动画效果
        ((BMKPinAnnotationView *)annotationView).animatesDrop = YES;
    }
    //annotationView关联的annotation
    annotationView.annotation = annotation;
    return annotationView;
}

#pragma mark - lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kViewTopHeight)];
    }
    return _mapView;
}

@end
