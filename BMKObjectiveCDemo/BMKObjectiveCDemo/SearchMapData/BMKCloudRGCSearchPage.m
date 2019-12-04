//
//  BMKCloudRGCSearchPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//
/**
 本示例代码使用了测试ak和测试数据，开发者在检索自己LBS数据之前，需替换 cloudLocalSearch.ak和cloudLocalSearch.geoTableId的值
 1、替换cloudLocalSearch.ak的值：
   （1）请访问http://lbsyun.baidu.com/apiconsole/key申请一个“服务端”的ak，其他类型的ak无效；
   （2）将申请的ak替换cloudLocalSearch.ak的值；
 2、替换cloudLocalSearch.geoTableId值：
   （1）申请完服务端ak后访问http://lbsyun.baidu.com/datamanager/datamanage创建一张表；
   （2）在“表名称”处自由填写表的名称，如MyData，点击保存；
   （3）“创建”按钮右方将会出现形如“MyData(34195)”字样，其中的“34195”即为geoTableId的值；
   （4）添加或修改字段：点击“字段”标签修改和添加字段；
   （5）添加数据：
       a、标注模式：“数据” ->“标注模式”，输入要添加的地址然后“百度一下”，点击地图蓝色图标，再点击保存即可；
       b、批量模式： “数据” ->“批量模式”，可上传文件导入，具体文件格式要求请参见当页的“批量导入指南”；
   （6）选择左边“设置”标签，“是否发布到检索”选择“是”，然后"保存"；
   （7）数据发布后，替换cloudLocalSearch.geoTableId的值即可；
 备注：切记添加、删除或修改数据后要再次发布到检索，否则将会出现检索不到修改后数据的情况
 */

#import "BMKCloudRGCSearchPage.h"
#import "BMKCloudRGCParametersPage.h"

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKCloudSearchDelegate
 获取search的回调方法
 */
@interface BMKCloudRGCSearchPage ()<BMKMapViewDelegate, BMKCloudSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKCloudRGCSearchPage

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
    self.title = @"云RGC检索";
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

- (void)createSearchToolView {
    [self createToolBarsWithItemArray:
     @[@{@"leftItemTitle":@"geotable表主键：",
         @"rightItemText":@"186459",
         @"rightItemPlaceholder":@"输入表主键"},
       @{@"leftItemTitle":@"纬 度：",
         @"rightItemText":@"39.915",
         @"rightItemPlaceholder":@"输入纬度"},
       @{@"leftItemTitle":@"经 度：",
         @"rightItemText":@"116.404",
         @"rightItemPlaceholder":@"输入经度"}
       ]];
}

#pragma mark - Search Data
- (void)setupDefaultData {
    //初始化请求参数类BMKCloudReverseGeoCodeSearchInfo的实例
    BMKCloudReverseGeoCodeSearchInfo *reverseGeoCodeInfo = [[BMKCloudReverseGeoCodeSearchInfo alloc]init];
    //geo table表主键，必选
    reverseGeoCodeInfo.geoTableId = [self.dataArray[0] intValue];
    //经纬度
    reverseGeoCodeInfo.reverseGeoPoint = CLLocationCoordinate2DMake([self.dataArray[1] floatValue], [self.dataArray[2] floatValue]);
    [self searchData:reverseGeoCodeInfo];
}

- (void)searchData:(BMKCloudReverseGeoCodeSearchInfo *)info {
    //初始化BMKBMKCloudSearch实例
    BMKCloudSearch *cloudSearch = [[BMKCloudSearch alloc] init];
    //设置云RGC检索的代理
    cloudSearch.delegate = self;
    //初始化请求参数类BMKCloudReverseGeoCodeSearchInfo的实例
    BMKCloudReverseGeoCodeSearchInfo *reverseGeoCodeInfo = [[BMKCloudReverseGeoCodeSearchInfo alloc]init];
    //geo table表主键，必选
    reverseGeoCodeInfo.geoTableId = info.geoTableId;
    //经纬度
    reverseGeoCodeInfo.reverseGeoPoint = info.reverseGeoPoint;
    /**
     云RGC检索：根据地理坐标获取地址信息，异步方法，返回结果在BMKCloudSearchDelegate的
     onGetCloudReverseGeoCodeResult里
     
     reverseGeoCodeInfo 云RGC检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [cloudSearch cloudReverseGeoCodeSearch:reverseGeoCodeInfo];
    if (flag) {
        NSLog(@"云RGC检索发送成功");
    } else {
        NSLog(@"云RGC检索发送失败");
        [self alertMessage:@"请申请一个“服务端”的ak"];
    }
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKCloudRGCParametersPage *page = [[BMKCloudRGCParametersPage alloc] init];
        page.searchDataBlock = ^(BMKCloudReverseGeoCodeSearchInfo *info) {
            [self createToolBarsWithItemArray:
             @[@{@"leftItemTitle":@"geotable表主键：",
                 @"rightItemText":[NSString stringWithFormat:@"%ld", (long)info.geoTableId],
                 @"rightItemPlaceholder":@"输入表主键"},
               @{@"leftItemTitle":@"纬 度：",
                 @"rightItemText":[NSString stringWithFormat:@"%f", info.reverseGeoPoint.latitude],
                 @"rightItemPlaceholder":@"输入纬度"},
               @{@"leftItemTitle":@"经 度：",
                 @"rightItemText":[NSString stringWithFormat:@"%f", info.reverseGeoPoint.longitude],
                 @"rightItemPlaceholder":@"输入经度"}
               ]];
            [self searchData:info];
        };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKCloudSearchDelegate
/**
 RGC云检索结果回调
 
 @param cloudRGCResult RGC云检索结果
 @param type 返回结果类型：BMK_CLOUD_RGC_SEARCH
 @param errorCode 错误码，@see BMKCloudErrorCode
 */
- (void)onGetCloudReverseGeoCodeResult:(BMKCloudReverseGeoCodeResult *)cloudRGCResult searchType:(BMKCloudSearchType)type errorCode:(NSInteger)errorCode {
    //云检索结果百度地图POI信息类
    BMKCloudMapPOIInfo *mapPOIInfo = cloudRGCResult.poiList.firstObject;
    //云检索结果信息类
    BMKCloudPOIInfo *POIInfo = [[BMKCloudPOIInfo alloc] init];
    if (cloudRGCResult.customPoiList.count > 0) {
        POIInfo = cloudRGCResult.customPoiList[0];
    }
    NSString *message = [NSString stringWithFormat:@"街道号码：%@\n街道名称：%@\n区县名称：%@\n城市名称：%@\n省份名称：%@\n国家：%@\n国家代码：%@\n行政区域编码：%@\n地址纬度：%f\n地址经度：%f\n用户定义的位置描述：%@\n推荐的位置描述：%@\n名称：%@\nPOI的UID：%@\nPOI纬度：%f\nPOI经度：%f\n地址：%@\n标签：%@\n距离：%f\n位置点的方向：%@\nPOI数据id：%@\n所属table的id：%d\n名称：%@\n地址：%@\n所属省份：%@\n所属城市：%@\n所属区县：%@\n所处位置的纬度：%f\n所处位置的经度：%f\n标签：%@距离：%f\n权重：%f\n自定义列：%@\n创建时间：%d\n修改时间：%d\n类型：%d\n位置点的方向：%@", cloudRGCResult.addressDetail.streetNumber, cloudRGCResult.addressDetail.streetName, cloudRGCResult.addressDetail.district, cloudRGCResult.addressDetail.city, cloudRGCResult.addressDetail.province, cloudRGCResult.addressDetail.country, cloudRGCResult.addressDetail.countryCode, cloudRGCResult.addressDetail.adCode, cloudRGCResult.location.latitude, cloudRGCResult.location.longitude, cloudRGCResult.customLocationDescription, cloudRGCResult.recommendedLocationDescription, mapPOIInfo.name, mapPOIInfo.uid, mapPOIInfo.pt.latitude, mapPOIInfo.pt.longitude, mapPOIInfo.address, mapPOIInfo.tags, mapPOIInfo.distance, mapPOIInfo.direction, POIInfo.poiId, POIInfo.geotableId, POIInfo.title, POIInfo.address, POIInfo.province, POIInfo.city, POIInfo.district, POIInfo.latitude, POIInfo.longitude, POIInfo.tags, POIInfo.distance, POIInfo.weight, POIInfo.customDict[@"coord_type"], POIInfo.creattime, POIInfo.modifytime, POIInfo.type, POIInfo.direction];
    [self alertMessage:message];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue - 35 * 3)];
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
