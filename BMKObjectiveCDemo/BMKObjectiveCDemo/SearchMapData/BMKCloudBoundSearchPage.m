//
//  BMKCloudBoundSearchPage.m
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

#import "BMKCloudBoundSearchPage.h"
#import "BMKCloudBoundParametersPage.h"

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKCloudSearchDelegate
 获取search的回调方法
 */
@interface BMKCloudBoundSearchPage ()<BMKMapViewDelegate, BMKCloudSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation BMKCloudBoundSearchPage

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
    self.title = @"矩形云检索";
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
     @[@{@"leftItemTitle":@"access_key：",
         @"rightItemText":@"t28NGyaIH4BXKoOv48RDKW4Dupz42dl3",
         @"rightItemPlaceholder":@"输入access_key"},
       @{@"leftItemTitle":@"geotable表主键：",
         @"rightItemText":@"186459",
         @"rightItemPlaceholder":@"输入表主键"},
       @{@"leftItemTitle":@"矩形区域：",
         @"rightItemText":@"116.277367,40.048032;116.282631,40.051318",
         @"rightItemPlaceholder":@"输入矩形区域经纬度"}
       ]];
}


#pragma mark - Search Data
- (void)setupDefaultData {
    //初始化请求参数类BMKCloudBoundSearchInfo的实例
    BMKCloudBoundSearchInfo *cloudBoundInfo = [[BMKCloudBoundSearchInfo alloc]init];
    //access_key，最大长度50，必选
    cloudBoundInfo.ak = self.dataArray[0];
    //geo table表主键，必选
    cloudBoundInfo.geoTableId = [self.dataArray[1] intValue];
    //矩形区域，左下角和右上角的经纬度坐标点，用;号分隔(116.30,36.20;117.30,37.20)，最长不超过25个字符
    cloudBoundInfo.bounds = self.dataArray[2];
    [self searchData:cloudBoundInfo];
}

- (void)searchData:(BMKCloudBoundSearchInfo *)info {
    //初始化BMKBMKCloudSearch实例
    BMKCloudSearch *cloudSearch = [[BMKCloudSearch alloc] init];
    //设置矩形云检索的代理
    cloudSearch.delegate = self;
    //初始化请求参数类BMKCloudBoundSearchInfo的实例
    BMKCloudBoundSearchInfo *cloudBoundInfo = [[BMKCloudBoundSearchInfo alloc]init];
    //access_key，最大长度50，必选
    cloudBoundInfo.ak = info.ak;
    //用户的权限签名，最大长度50，可选
    cloudBoundInfo.sn = info.sn;
    //geo table表主键，必选
    cloudBoundInfo.geoTableId = info.geoTableId;
    //检索关键字
    cloudBoundInfo.keyword = info.keyword;
    //标签，空格分隔的多字符串，最长45个字符，样例：美食 小吃，可选
    cloudBoundInfo.tags = info.tags;
    /**
     排序字段，可选： sortby={keyname}:1 升序；sortby={keyname}:-1 降序
     以下keyname为系统预定义的：
     1.distance 距离排序
     2.weight 权重排序
     默认为按weight排序
     如果需要自定义排序则指定排序字段，样例：按照价格由便宜到贵排序sortby=price:1
     */
    //排序字段，可选： sortby={keyname}:1 升序；sortby={keyname}:-1 降序
    cloudBoundInfo.sortby = info.sortby;
    /**
     过滤条件，可选
     '|'竖线分隔的多个key-value对
     key为筛选字段的名称(存储服务中定义)
     value可以是整形或者浮点数的一个区间：格式为“small,big”逗号分隔的2个数字
     样例：筛选价格为9.99到19.99并且生产时间为2013年的项：price:9.99,19.99|time:2012,2012
     */
    //过滤条件，可选:'|'竖线分隔的多个key-value对,price:9.99,19.99|time:2012,2012
    cloudBoundInfo.filter = info.filter;
    //分页索引，默认为0，可选
    cloudBoundInfo.pageIndex = info.pageIndex;
    //分页数量，默认为10，最多为50，可选
    cloudBoundInfo.pageSize = info.pageSize;
    //矩形区域，左下角和右上角的经纬度坐标点，用;号分隔(116.30,36.20;117.30,37.20)，最长不超过25个字符
    cloudBoundInfo.bounds = info.bounds;
    /**
     矩形云检索，异步方法，返回结果在BMKCloudSearchDelegate的
     onGetCloudPoiResult里
     
     cloudBoundInfo 矩形云检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [cloudSearch boundSearchWithSearchInfo:cloudBoundInfo];
    if(flag) {
        NSLog(@"矩形云检索成功");
    } else {
        NSLog(@"矩形云检索失败");
        [self alertMessage:@"请申请一个“服务端”的ak"];
    }
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKCloudBoundParametersPage *page = [[BMKCloudBoundParametersPage alloc] init];
        page.searchDataBlock = ^(BMKCloudBoundSearchInfo *info) {
            [self createToolBarsWithItemArray:
             @[@{@"leftItemTitle":@"access_key：",
                 @"rightItemText":info.ak,
                 @"rightItemPlaceholder":@"输入access_key"},
               @{@"leftItemTitle":@"geotable表主键：",
                 @"rightItemText":[NSString stringWithFormat:@"%d", info.geoTableId],
                 @"rightItemPlaceholder":@"输入表主键"},
               @{@"leftItemTitle":@"矩形区域：",
                 @"rightItemText":info.bounds,
                 @"rightItemPlaceholder":@"输入矩形区域经纬度"}
               ]];
            [self searchData:info];
        };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKCloudSearchDelegate
/**
 POI云检索结果回调
 
 @param poiResultList POI云检索结果列表
 @param type 返回结果类型：BMK_CLOUD_LOCAL_SEARCH,BMK_CLOUD_NEARBY_SEARCH,BMK_CLOUD_BOUND_SEARCH
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetCloudPoiResult:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error {
    //云检索结果列表类
    BMKCloudPOIList *cloudPOI = poiResultList.firstObject;
    //云检索结果信息类
    BMKCloudPOIInfo *POIInfo = cloudPOI.POIs.firstObject;
    NSString *message = [NSString stringWithFormat:@"检索状态：%ld\n结果总数：%ld\n当前页返回数量：%ld\n页数：%ld\npoi的UID：%@\n所属table的id:%d\n名称：%@\n地址：%@\n省份：%@\n城市：%@\n区县：%@\n纬度：%f\n经度：%f\n标签：%@\n距离：%f\n权重：%f\n自定义列：%@\n创建时间：%d\n修改时间：%d\n类型：%d\n方向：%@", (long)cloudPOI.status, (long)cloudPOI.total, (long)cloudPOI.size, (long)cloudPOI.pageNum, POIInfo.poiId, POIInfo.geotableId, POIInfo.title, POIInfo.address, POIInfo.province, POIInfo.city, POIInfo.district, POIInfo.latitude, POIInfo.longitude, POIInfo.tags, POIInfo.distance, POIInfo.weight, POIInfo.customDict[@"coord_type"], POIInfo.creattime, POIInfo.modifytime, POIInfo.type, POIInfo.direction];
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
