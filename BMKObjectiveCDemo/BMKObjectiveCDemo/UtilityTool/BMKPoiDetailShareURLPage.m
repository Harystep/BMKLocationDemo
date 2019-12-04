//
//  BMKPOIDetailShareURLPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOIDetailShareURLPage.h"
#import <MessageUI/MessageUI.h>

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法，通过BMKPoiSearchDelegate
 获取BMKPoiSearch的回调方法，通过BMKShareURLSearchDelegate获取BMKShareURLSearch
 的回调方法
 **/
@interface BMKPOIDetailShareURLPage ()<BMKMapViewDelegate, BMKPoiSearchDelegate, BMKShareURLSearchDelegate, MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKPOIDetailShareURLPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self searchDefaultData];
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
    self.title = @"POI详情短串分享URL";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark SearchDefaultData
- (void)searchDefaultData {
    //初始化BMKPoiSearch实例
    BMKPoiSearch *search = [[BMKPoiSearch alloc] init];
    //设置BMKPoiSearch实例的代理
    search.delegate = self;
    //初始化请求参数类BMKCitySearchOption的实例
    BMKPOICitySearchOption *option = [[BMKPOICitySearchOption alloc]init];
    //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
    option.city= @"北京";
    //检索关键字
    option.keyword = @"百度科技园";
    /**
     城市POI检索：异步方法，返回结果在BMKPoiSearchDelegate的onGetPoiResult里
     
     cityOption 城市内搜索的搜索参数类（BMKCitySearchOption）
     成功返回YES，否则返回NO
     */
    [search poiSearchInCity:option];
}

#pragma mark - Responding events
- (void)alertMessage:(NSString *)message {
    NSAssert(message && message.length > 0, @"提示信息不能为空");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"POI详情短串分享URL" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MFMessageComposeViewController *messageCompose = [[MFMessageComposeViewController alloc] init];
        messageCompose.messageComposeDelegate = self;
        messageCompose.body = [NSString stringWithFormat:@"%@", message];
        [self presentViewController:messageCompose animated:YES completion:nil];
    }];
    [alert addAction:shareAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BMKPoiSearchDelegate
/**
 POI检索返回结果回调
 
 @param searcher 检索对象
 @param poiResult POI检索结果列表
 @param errorCode 错误码
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //POI信息类的实例
        BMKPoiInfo *POI = [poiResult.poiInfoList objectAtIndex:0];
        //初始化请求参数类BMKPoiDetailShareURLOption的实例
        BMKPoiDetailShareURLOption *detailShareUrlSearchOption = [[BMKPoiDetailShareURLOption alloc]init];
        //POI的UID
        detailShareUrlSearchOption.uid = POI.UID;
        //初始化BMKShareURLSearch的实例
        BMKShareURLSearch *shareurlSearch = [[BMKShareURLSearch alloc] init];
        //设置shareurlSearch的代理
        shareurlSearch.delegate = self;
        /**
          获取POI详情短串分享url，异步方法，
          返回结果在BMKShareUrlSearchDelegate的onGetPoiDetailShareURLResult里
         
          poiDetailShareUrlSearchOption poi详情短串分享检索信息类
          成功返回YES，否则返回NO
         */
        BOOL flag = [shareurlSearch requestPoiDetailShareURL:detailShareUrlSearchOption];
        if(flag) {
            NSLog(@"POI详情短串分享URL获取成功");
        } else {
            NSLog(@"POI详情短串分享URL获取失败");
        }
    } 
}

#pragma mark - BMKShareURLSearchDelegate
/**
 返回POI详情分享url
 
 @param searcher 检索对象
 @param result 检索结果：url
 @param error 错误码
 */
- (void)onGetPoiDetailShareURLResult:(BMKShareURLSearch *)searcher result:(BMKShareURLResult *)result errorCode:(BMKSearchErrorCode)error {
    NSString *message = [NSString stringWithFormat:@"分享的POI短串为：%@", result.url];
    [self alertMessage:message];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

@end
