//
//  BMKLocationShareURLPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKLocationShareURLPage.h"
#import <MessageUI/MessageUI.h>

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法，
 通过BMKShareURLSearchDelegate获取BMKShareURLSearch
 的回调方法
 **/
@interface BMKLocationShareURLPage ()<BMKMapViewDelegate, BMKShareURLSearchDelegate, MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKLocationShareURLPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self requestLocationShareURL];
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
    self.title = @"反Geo短串分享URL";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - RequestShareURL
- (void)requestLocationShareURL {
    //初始化请求参数类BMKLocationShareURLOption的实例
    BMKLocationShareURLOption *option = [[BMKLocationShareURLOption alloc]init];
    //通过短URL调起客户端时作为附加信息显示在名称下面
    option.snippet = @"北京市海淀区西北旺东路10号院";
    //名称
    option.name = @"位置检索";
    //经纬度
    option.location = CLLocationCoordinate2DMake(40.0498500000,116.2799200000);
    //初始化BMKShareURLSearch实例
    BMKShareURLSearch *shareurlSearch = [[BMKShareURLSearch alloc] init];
    //设置shareurlSearch的代理
    shareurlSearch.delegate = self;
    /**
     获取反geo短串分享url，异步方法，返回结果在BMKShareUrlSearchDelegate
     的onGetLocationShareURLResult里
     
     reverseGeoShareUrlSearchOption 反geo短串分享检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [shareurlSearch requestLocationShareURL:option];
    if(flag) {
        NSLog(@"反Geo短串分享URL获取成功");
    } else {
        NSLog(@"反Geo短串分享URL获取失败");
    }
}

#pragma mark - Responding events
- (void)alertMessage:(NSString *)message {
    NSAssert(message && message.length > 0, @"提示信息不能为空");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"反Geo短串分享URL" message:message preferredStyle:UIAlertControllerStyleAlert];
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
 返回位置信息分享url
 
 @param searcher 检索对象
 @param result 检索结果：url
 @param error 错误码
 */
- (void)onGetLocationShareURLResult:(BMKShareURLSearch *)searcher result:(BMKShareURLResult *)result errorCode:(BMKSearchErrorCode)error {
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
