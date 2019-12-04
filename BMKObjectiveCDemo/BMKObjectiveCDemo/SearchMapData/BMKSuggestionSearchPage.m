//
//  BMKSuggestionSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKSuggestionSearchPage.h"
#import "BMKSuggestionParametersPage.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKSuggestionSearch";

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKSuggestionSearchDelegate
 获取search的回调方法
 */
@interface BMKSuggestionSearchPage ()<BMKMapViewDelegate, BMKSuggestionSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKSuggestionSearchPage

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
    self.title = @"关键词匹配检索";
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
       @{@"leftItemTitle":@"关键字：",
         @"rightItemText":@"中关村",
         @"rightItemPlaceholder":@"输入keyword"}
       ]];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    BMKSuggestionSearchOption *suggestionOption = [[BMKSuggestionSearchOption alloc] init];
    suggestionOption.keyword = self.dataArray[1];
    suggestionOption.cityname = self.dataArray[0];
    suggestionOption.cityLimit = NO;
    [self searchData:suggestionOption];
}

- (void)searchData:(BMKSuggestionSearchOption *)option {
    //初始化BMKSuggestionSearch实例
    BMKSuggestionSearch *suggestionSearch = [[BMKSuggestionSearch alloc] init];
    //设置关键词检索的代理
    suggestionSearch.delegate = self;
    //初始化请求参数类BMKSuggestionSearchOption的实例
    BMKSuggestionSearchOption* suggestionOption = [[BMKSuggestionSearchOption alloc] init];
    //城市名
    suggestionOption.cityname = option.cityname;
    //检索关键字
    suggestionOption.keyword  = option.keyword;
    //是否只返回指定城市检索结果，默认为NO（海外区域暂不支持设置cityLimit）
    suggestionOption.cityLimit = option.cityLimit;
    /**
     关键词检索，异步方法，返回结果在BMKSuggestionSearchDelegate
     的onGetSuggestionResult里
     
     suggestionOption sug检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [suggestionSearch suggestionSearch:suggestionOption];
    if(flag) {
        NSLog(@"关键词检索成功");
    } else {
        NSLog(@"关键词检索失败");
    }
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKSuggestionParametersPage *page = [[BMKSuggestionParametersPage alloc] init];
    page.searchDataBlock = ^(BMKSuggestionSearchOption *option) {
        [self createToolBarsWithItemArray:
         @[@{@"leftItemTitle":@"城 市：",
             @"rightItemText":option.cityname,
             @"rightItemPlaceholder":@"输入城市"},
           @{@"leftItemTitle":@"关键字：",
             @"rightItemText":option.keyword,
             @"rightItemPlaceholder":@"输入keyword"}
           ]];
        [self searchData:option];
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKSuggestionSearchDelegate
/**
 关键字检索结果回调
 
 @param searcher 检索对象
 @param result 关键字检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    /**
     移除一组标注
     
     @param annotations 要移除的标注数组
     */
    [_mapView removeAnnotations:_mapView.annotations];
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (BMKSuggestionInfo *sugInfo in result.suggestionList) {
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor = sugInfo.location;
            annotation.coordinate = coor;
            _mapView.centerCoordinate = coor;
            [annotations addObject:annotation];
        }
        //将一组标注添加到当前地图View中
        [_mapView addAnnotations:annotations];
    }
    
    BMKSuggestionInfo *sugInfo = result.suggestionList.firstObject;
    NSString *message = [NSString stringWithFormat:@"key：%@\n城市：%@\n区县：%@\nPOI的唯一标识：%@\n纬度：%f\n经度：%f",sugInfo.key,sugInfo.city,sugInfo.district,sugInfo.uid,sugInfo.location.latitude,sugInfo.location.longitude];
    [self alertMessage:message];
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
         annotationView的颜色： BMKPinAnnotationColorRed，BMKPinAnnotationColorGreen，
         BMKPinAnnotationColorPurple
         */
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        //设置从天而降的动画效果
        ((BMKPinAnnotationView *)annotationView).animatesDrop = YES;
    }
    //annotationView关联的annotation
    annotationView.annotation = annotation;
    return annotationView;
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
