//
//  BMKRoutePlanShareURLPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKRoutePlanShareURLPage.h"
#import <MessageUI/MessageUI.h>

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法，
 通过BMKShareURLSearchDelegate获取BMKShareURLSearch
 的回调方法
 **/
@interface BMKRoutePlanShareURLPage ()<BMKMapViewDelegate, BMKShareURLSearchDelegate,  MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKRoutePlanShareURLPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self requestRoutePlanShareURL];
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
    self.title = @"路线规划短串分享URL";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - RequestShareURL
- (void)requestRoutePlanShareURL {
    //初始化请求参数类BMKRoutePlanShareURLOption的实例
    BMKRoutePlanShareURLOption *option = [[BMKRoutePlanShareURLOption alloc] init];
    /**
     BMK_ROUTE_PLAN_SHARE_URL_TYPE_DRIVE：驾车路线规划短串分享
     BMK_ROUTE_PLAN_SHARE_URL_TYPE_WALK：步行路线规划短串分享
     BMK_ROUTE_PLAN_SHARE_URL_TYPE_RIDE：骑行路线规划短串分享
     BMK_ROUTE_PLAN_SHARE_URL_TYPE_TRANSIT：公交路线规划短串分享
     **/
    option.routePlanType = BMK_ROUTE_PLAN_SHARE_URL_TYPE_DRIVE;
    //起终点通过关键字指定时，必须指定
    option.cityID = 131;
    //分享的是第几条线路
    option.routeIndex = 0;
    //初始化BMKPlanNode的实例，线路检索起点
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    //名称
    start.name = @"百度大厦";
    //城市ID
    start.cityID = 131;
    //起点，可通过关键字、坐标两种方式指定，使用关键字时必须指定from.cityID
    option.from = start;
    //初始化BMKPlanNode的实例，线路检索终点
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    //名称
    end.name = @"天安门";
    //城市ID
    end.cityID = 131;
    //终点，可通过关键字、坐标两种方式指定，使用关键字时必须指定to.cityID
    option.to = end;
    //初始化BMKShareURLSearch实例，短串检索
    BMKShareURLSearch *shareurlSearch = [[BMKShareURLSearch alloc] init];
    //设置shareurlSearch的代理
    shareurlSearch.delegate = self;
    /**
      获取路线规划短串分享url，异步方法，
      返回结果在BMKShareUrlSearchDelegate的onGetRoutePlanShareURLResult里
     
      routePlanShareUrlSearchOption 取路线规划短串分享检索信息类
      成功返回YES，否则返回NO
     */
    BOOL flag = [shareurlSearch requestRoutePlanShareURL:option];
    if (flag) {
        NSLog(@"路线规划短串分享URL获取成功");
    } else {
        NSLog(@"路线规划短串分享URL获取失败");
    }
}

#pragma mark - Responding events
- (void)alertMessage:(NSString *)message {
    NSAssert(message && message.length > 0, @"提示信息不能为空");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"路线规划短串分享URL" message:message preferredStyle:UIAlertControllerStyleAlert];
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

#pragma mark - BMKShareURLSearchDelegate
/**
 返回路线规划分享url
 
 @param searcher 检索对象
 @param result 检索结果：url
 @param error 错误码 
 */
- (void)onGetRoutePlanShareURLResult:(BMKShareURLSearch *)searcher result:(BMKShareURLResult *)result errorCode:(BMKSearchErrorCode)error {
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
