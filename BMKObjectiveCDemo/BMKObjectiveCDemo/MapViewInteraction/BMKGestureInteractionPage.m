//
//  BMKGestureInteractionPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKGestureInteractionPage.h"

#define kHeight_BottomControlView  146

//开发者通过此delegate获取mapView的回调方法
@interface BMKGestureInteractionPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISwitch *gesturesSwitch;
@property (nonatomic, strong) UISwitch *zoomGestureSwitch;
@property (nonatomic, strong) UISwitch *translationGestureSwitch;
@property (nonatomic, strong) UISwitch *rotationGestureSwitch;
@property (nonatomic, strong) UISwitch *overlookGestureSwitch;
@property (nonatomic, strong) UILabel *gesturesLabel;
@property (nonatomic, strong) UILabel *zoomGestureLabel;
@property (nonatomic, strong) UILabel *translationGestureLabel;
@property (nonatomic, strong) UILabel *rotationGestureLabel;
@property (nonatomic, strong) UILabel *overLookGestureLabel;
@end

@implementation BMKGestureInteractionPage

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
    self.title = @"手势交互";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.gesturesSwitch];
    [self.bottomControlView addSubview:self.zoomGestureSwitch];
    [self.bottomControlView addSubview:self.translationGestureSwitch];
    [self.bottomControlView addSubview:self.rotationGestureSwitch];
    [self.bottomControlView addSubview:self.overlookGestureSwitch];
    [self.bottomControlView addSubview:self.gesturesLabel];
    [self.bottomControlView addSubview:self.zoomGestureLabel];
    [self.bottomControlView addSubview:self.translationGestureLabel];
    [self.bottomControlView addSubview:self.rotationGestureLabel];
    [self.bottomControlView addSubview:self.overLookGestureLabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //地图View不支持用户多点缩放(双指)
    _mapView.zoomEnabled = NO;
    //地图View不支持用户缩放(双击或双指单击)
    _mapView.zoomEnabledWithTap = NO;
    //地图View不支持用户移动地图
    _mapView.scrollEnabled = NO;
    //地图View不支持旋转
    _mapView.rotateEnabled = NO;
    //地图View不支持俯仰角
    _mapView.overlookEnabled = NO;
}

#pragma mark - Responding events
- (void)gesturesSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //支持用户多点缩放(双指)
        _mapView.zoomEnabled = YES;
        //支持用户缩放(双击或双指单击)
        _mapView.zoomEnabledWithTap = YES;
        //支持用户移动地图
        _mapView.scrollEnabled = YES;
        //支持旋转
        _mapView.rotateEnabled = YES;
        //支持俯仰角
        _mapView.overlookEnabled = YES;
    } else {
        //不支持用户多点缩放(双指)
        _mapView.zoomEnabled = NO;
        //不支持用户缩放(双击或双指单击)
        _mapView.zoomEnabledWithTap = NO;
        //不支持用户移动地图
        _mapView.scrollEnabled = NO;
        //不支持旋转
        _mapView.rotateEnabled = NO;
        //不支持俯仰角
        _mapView.overlookEnabled = NO;
    }
}

- (void)zoomGestureSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //支持用户多点缩放(双指)
        _mapView.zoomEnabled = YES;
        //支持用户缩放(双击或双指单击)
        _mapView.zoomEnabledWithTap = YES;
    } else {
        //不支持用户多点缩放(双指)
        _mapView.zoomEnabled = NO;
        //不支持用户缩放(双击或双指单击)
        _mapView.zoomEnabledWithTap = NO;
    }
}

- (void)translationGestureSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //支持用户移动地图
        _mapView.scrollEnabled = YES;
    } else {
        //不支持用户移动地图
        _mapView.scrollEnabled = NO;
    }
}

- (void)rotationGestureSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //支持旋转
        _mapView.rotateEnabled = YES;
        //旋转角度为45度，范围为－180～180度
        //_mapView.rotation = 45;
    } else {
        //不支持旋转
        _mapView.rotateEnabled = NO;
        //旋转角度为0度，范围为－180～180度
        //_mapView.rotation = 0;
    }
}

- (void)overlookGestureSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //支持俯仰角
        _mapView.overlookEnabled = YES;
        //俯仰角为-30度，范围为－45～0度
       // _mapView.overlooking = -30;
    } else {
        //不支持俯仰角
        _mapView.overlookEnabled = NO;
        //俯仰角为-30度，范围为－45～0度
        //_mapView.overlooking = 0;
    }
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

- (UISwitch *)gesturesSwitch {
    if (!_gesturesSwitch) {
        _gesturesSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(38 * widthScale, 17, 48 * widthScale, 26)];
        [_gesturesSwitch addTarget:self action:@selector(gesturesSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _gesturesSwitch;
}

- (UISwitch *)zoomGestureSwitch {
    if (!_zoomGestureSwitch) {
        _zoomGestureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(38 * widthScale, 17 * 2 + 26, 48 * widthScale, 26)];
        [_zoomGestureSwitch addTarget:self action:@selector(zoomGestureSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _zoomGestureSwitch;
}

- (UISwitch *)translationGestureSwitch {
    if (!_translationGestureSwitch) {
        _translationGestureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200 * widthScale, 17 * 2 + 26, 48 * widthScale, 26)];
        [_translationGestureSwitch addTarget:self action:@selector(translationGestureSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _translationGestureSwitch;
}

- (UISwitch *)rotationGestureSwitch {
    if (!_rotationGestureSwitch) {
        _rotationGestureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(38 * widthScale, 17 * 3 + 26 * 2, 48 * widthScale, 26)];
        [_rotationGestureSwitch addTarget:self action:@selector(rotationGestureSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _rotationGestureSwitch;
}

- (UISwitch *)overlookGestureSwitch {
    if (!_overlookGestureSwitch) {
        _overlookGestureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200 * widthScale, 17 * 3 + 26 * 2, 48 * widthScale, 26)];
        [_overlookGestureSwitch addTarget:self action:@selector(overlookGestureSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _overlookGestureSwitch;
}

- (UILabel *)gesturesLabel {
    if (!_gesturesLabel) {
        _gesturesLabel = [[UILabel alloc] initWithFrame:CGRectMake(106 * widthScale, 20, 120 * widthScale, 20)];
        _gesturesLabel.textColor = COLOR(0x3385FF);
        _gesturesLabel.font = [UIFont systemFontOfSize:14];
        _gesturesLabel.text = @"所有手势";
    }
    return _gesturesLabel;
}

- (UILabel *)zoomGestureLabel {
    if (!_zoomGestureLabel) {
        _zoomGestureLabel = [[UILabel alloc] initWithFrame:CGRectMake(106 * widthScale, 20 + 17 + 26, 100 * widthScale, 20)];
        _zoomGestureLabel.textColor = COLOR(0x3385FF);
        _zoomGestureLabel.font = [UIFont systemFontOfSize:14];
        _zoomGestureLabel.text = @"缩放";
    }
    return _zoomGestureLabel;
}

- (UILabel *)translationGestureLabel {
    if (!_translationGestureLabel) {
        _translationGestureLabel = [[UILabel alloc] initWithFrame:CGRectMake(260 * widthScale, 20 + 17 + 26, 100 * widthScale, 20)];
        _translationGestureLabel.textColor = COLOR(0x3385FF);
        _translationGestureLabel.font = [UIFont systemFontOfSize:14];
        _translationGestureLabel.text = @"平移";
    }
    return _translationGestureLabel;
}

- (UILabel *)rotationGestureLabel {
    if (!_rotationGestureLabel) {
        _rotationGestureLabel = [[UILabel alloc] initWithFrame:CGRectMake(106 * widthScale, 20 + (17 + 26) * 2, 100 * widthScale, 20)];
        _rotationGestureLabel.textColor = COLOR(0x3385FF);
        _rotationGestureLabel.font = [UIFont systemFontOfSize:14];
        _rotationGestureLabel.text = @"旋转";
    }
    return _rotationGestureLabel;
}

- (UILabel *)overLookGestureLabel {
    if (!_overLookGestureLabel) {
        _overLookGestureLabel = [[UILabel alloc] initWithFrame:CGRectMake(260 * widthScale, 20 + (17 + 26) * 2, 100 * widthScale, 20)];
        _overLookGestureLabel.textColor = COLOR(0x3385FF);
        _overLookGestureLabel.font = [UIFont systemFontOfSize:14];
        _overLookGestureLabel.text = @"俯视";
    }
    return _overLookGestureLabel;
}

@end
