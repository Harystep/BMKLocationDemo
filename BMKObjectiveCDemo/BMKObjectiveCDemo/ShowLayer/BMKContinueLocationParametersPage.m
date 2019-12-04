//
//  BMKContinueLocationParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/23.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKContinueLocationParametersPage.h"

@interface BMKContinueLocationParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *distanceFilterLabel;
@property (nonatomic, strong) UITextField *distanceFilterTextField;
@property (nonatomic, strong) UILabel *desireAccuracyLabel;
@property (nonatomic, strong) UITextField *desireAccuracyTextField;
@property (nonatomic, strong) UILabel *headingFilterLabel;
@property (nonatomic, strong) UITextField *headingFilterTextField;
@property (nonatomic, strong) UILabel *pausesLocationUpdatesAutomaticallyLabel;
@property (nonatomic, strong) UISwitch *pausesLocationUpdatesAutomaticallySwitch;
@property (nonatomic, strong) UILabel *allowsBackgroundLocationUpdatesLabel;
@property (nonatomic, strong) UISwitch *allowsBackgroundLocationUpdatesSwitch;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) BMKLocationManager *locationManager;
@end

@implementation BMKContinueLocationParametersPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setupTextFieldDelegate];
}

- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.distanceFilterLabel];
    [self.backgroundScrollView addSubview:self.distanceFilterTextField];
    [self.backgroundScrollView addSubview:self.desireAccuracyLabel];
    [self.backgroundScrollView addSubview:self.desireAccuracyTextField];
    [self.backgroundScrollView addSubview:self.headingFilterLabel];
    [self.backgroundScrollView addSubview:self.headingFilterTextField];
    [self.backgroundScrollView addSubview:self.pausesLocationUpdatesAutomaticallyLabel];
    [self.backgroundScrollView addSubview:self.pausesLocationUpdatesAutomaticallySwitch];
    [self.backgroundScrollView addSubview:self.allowsBackgroundLocationUpdatesLabel];
    [self.backgroundScrollView addSubview:self.allowsBackgroundLocationUpdatesSwitch];
    [self.backgroundScrollView addSubview:self.finishButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _distanceFilterTextField.delegate = self;
    _desireAccuracyTextField.delegate = self;
    _headingFilterTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_headingFilterTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 180);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)pausesLocationUpdatesAutomaticallySwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        _pausesLocationUpdatesAutomatically = YES;
    } else {
        _pausesLocationUpdatesAutomatically = NO;
    }
}

- (void)allowsBackgroundLocationUpdatesSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        _allowsBackgroundLocationUpdates = YES;
    } else {
        _allowsBackgroundLocationUpdates = NO;
    }
}

- (void)clickFinishButton {
    self.locationManager.desiredAccuracy = [_desireAccuracyTextField.text floatValue];
    self.locationManager.distanceFilter = [_distanceFilterTextField.text floatValue];
    //定位是否会被系统自动暂停
    self.locationManager.allowsBackgroundLocationUpdates = _allowsBackgroundLocationUpdates;
    //是否允许后台定位更新
    self.locationManager.pausesLocationUpdatesAutomatically = _pausesLocationUpdatesAutomatically;
    if (self.setupContinueLocationBlock) {
        self.setupContinueLocationBlock(self.locationManager);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy loading
- (UILabel *)distanceFilterLabel {
    if (!_distanceFilterLabel) {
        _distanceFilterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20 * 2, 30)];
        _distanceFilterLabel.text = @"定位的最小更新距离";
        _distanceFilterLabel.font = [UIFont systemFontOfSize:17];
    }
    return _distanceFilterLabel;
}

- (UILabel *)desireAccuracyLabel {
    if (!_desireAccuracyLabel) {
        _desireAccuracyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20 * 2, 30)];
        _desireAccuracyLabel.text = @"定位精度";
        _desireAccuracyLabel.font = [UIFont systemFontOfSize:17];
    }
    return _desireAccuracyLabel;
}

- (UILabel *)headingFilterLabel {
    if (!_headingFilterLabel) {
        _headingFilterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20 * 2, 30)];
        _headingFilterLabel.text = @"定位最小更新角度";
        _headingFilterLabel.font = [UIFont systemFontOfSize:17];
    }
    return _headingFilterLabel;
}

- (UILabel *)pausesLocationUpdatesAutomaticallyLabel {
    if (!_pausesLocationUpdatesAutomaticallyLabel) {
        _pausesLocationUpdatesAutomaticallyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20 * 2, 30)];
        _pausesLocationUpdatesAutomaticallyLabel.text = @"定位是否会被系统自动暂停";
        _pausesLocationUpdatesAutomaticallyLabel.font = [UIFont systemFontOfSize:17];
    }
    return _pausesLocationUpdatesAutomaticallyLabel;
}

- (UILabel *)allowsBackgroundLocationUpdatesLabel {
    if (!_allowsBackgroundLocationUpdatesLabel) {
        _allowsBackgroundLocationUpdatesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20 * 2, 30)];
        _allowsBackgroundLocationUpdatesLabel.text = @"是否允许后台定位更新";
        _allowsBackgroundLocationUpdatesLabel.font = [UIFont systemFontOfSize:17];
    }
    return _allowsBackgroundLocationUpdatesLabel;
}

- (UISwitch *)pausesLocationUpdatesAutomaticallySwitch {
    if (!_pausesLocationUpdatesAutomaticallySwitch) {
        _pausesLocationUpdatesAutomaticallySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 325, 120, 35)];
        [_pausesLocationUpdatesAutomaticallySwitch addTarget:self action:@selector(pausesLocationUpdatesAutomaticallySwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        [_pausesLocationUpdatesAutomaticallySwitch setOn:_pausesLocationUpdatesAutomatically];
    }
    return _pausesLocationUpdatesAutomaticallySwitch;
}

- (UISwitch *)allowsBackgroundLocationUpdatesSwitch {
    if (!_allowsBackgroundLocationUpdatesSwitch) {
        _allowsBackgroundLocationUpdatesSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 415, 120, 35)];
        [_allowsBackgroundLocationUpdatesSwitch addTarget:self action:@selector(allowsBackgroundLocationUpdatesSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        [_allowsBackgroundLocationUpdatesSwitch setOn:_allowsBackgroundLocationUpdates];
    }
    return _allowsBackgroundLocationUpdatesSwitch;
}


- (UITextField *)distanceFilterTextField {
    if (!_distanceFilterTextField) {
        _distanceFilterTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 20 * 2, 35)];
        _distanceFilterTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _distanceFilterTextField;
}

- (UITextField *)desireAccuracyTextField {
    if (!_desireAccuracyTextField) {
        _desireAccuracyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 20 * 2, 35)];
        _desireAccuracyTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _desireAccuracyTextField;
}

- (UITextField *)headingFilterTextField {
    if (!_headingFilterTextField) {
        _headingFilterTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 20 * 2, 35)];
        _headingFilterTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _headingFilterTextField;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 480, 160, 35)];
        [_finishButton addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.clipsToBounds = YES;
        _finishButton.layer.cornerRadius = 16;
        [_finishButton setTitle:@"OK" forState:UIControlStateNormal];
        _finishButton.titleLabel.textColor = [UIColor whiteColor];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _finishButton.backgroundColor = COLOR(0x3385FF);
    }
    return _finishButton;
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        _locationManager.allowsBackgroundLocationUpdates = NO;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth,  KScreenHeight);
    }
    return _backgroundScrollView;
}
@end
