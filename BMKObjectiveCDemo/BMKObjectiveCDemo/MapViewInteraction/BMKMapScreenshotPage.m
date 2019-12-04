//
//  BMKMapScreenshotPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKMapScreenshotPage.h"

#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKMapScreenshotPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UIButton *subregionButton;
@property (nonatomic, strong) UIButton *regionButton;
@end

@implementation BMKMapScreenshotPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
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
    self.title = @"方法交互（截图）";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.regionButton];
    [self.bottomControlView addSubview:self.subregionButton];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Responding events
- (void)clickRegionButton {
    /**
     获得地图当前可视区域截图
     返回地图view范围内的截取的UIImage
     */
    UIImage *regionImage = [_mapView takeSnapshot];
    UIImageWriteToSavedPhotosAlbum(regionImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)clickSubregionButton {
    UIImage *subregionImage = [_mapView takeSnapshot:CGRectMake(20 * widthScale, kViewTopHeight, 375 * widthScale, 200)];
    UIImageWriteToSavedPhotosAlbum(subregionImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"";
    if (error) {
        message = @"保存到相册失败!";
    } else {
        message = @"保存到相册成功!";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"地图截图" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert  addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

-(UIView *)bottomControlView{
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue, KScreenWidth, kHeight_BottomControlView)];
    }
    return _bottomControlView;
}

- (UIButton *)subregionButton {
    if (!_subregionButton) {
        _subregionButton = [[UIButton alloc] initWithFrame:CGRectMake(19 * widthScale, 12.5, 159 * widthScale, 35)];
        [_subregionButton addTarget:self action:@selector(clickSubregionButton) forControlEvents:UIControlEventTouchUpInside];
        _subregionButton.clipsToBounds = YES;
        _subregionButton.layer.cornerRadius = 16;
        [_subregionButton setTitle:@"截图选取区域" forState:UIControlStateNormal];
        _subregionButton.titleLabel.textColor = [UIColor whiteColor];
        _subregionButton.backgroundColor = COLOR(0x3385FF);
        _subregionButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _subregionButton;
}

- (UIButton *)regionButton {
    if (!_regionButton) {
        _regionButton = [[UIButton alloc] initWithFrame:CGRectMake(197 * widthScale, 12.5, 159 * widthScale, 35)];
        [_regionButton addTarget: self action:@selector(clickRegionButton) forControlEvents:UIControlEventTouchUpInside];
        _regionButton.clipsToBounds = YES;
        _regionButton.layer.cornerRadius = 16;
        [_regionButton setTitle:@"截图全部地图" forState:UIControlStateNormal];
        _regionButton.backgroundColor = COLOR(0x3385FF);
        _regionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _regionButton.titleLabel.textColor = [UIColor whiteColor];
    }
    return _regionButton;
}

@end
