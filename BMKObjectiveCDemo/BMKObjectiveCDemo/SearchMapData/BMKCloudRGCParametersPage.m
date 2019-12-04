//
//  BMKCloudRGCParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCloudRGCParametersPage.h"

@interface BMKCloudRGCParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *geoTableIDLabel;
@property (nonatomic, strong) UILabel *latitudeLabel;
@property (nonatomic, strong) UILabel *longitudeLabel;
@property (nonatomic, strong) UITextField *geoTableIDTextField;
@property (nonatomic, strong) UITextField *latitudeTextField;
@property (nonatomic, strong) UITextField *longitudeTextField;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKCloudRGCParametersPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setupTextFieldDelegate];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"自定义参数";
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.geoTableIDLabel];
    [self.backgroundScrollView addSubview:self.latitudeLabel];
    [self.backgroundScrollView addSubview:self.longitudeLabel];
    [self.backgroundScrollView addSubview:self.geoTableIDTextField];
    [self.backgroundScrollView addSubview:self.latitudeTextField];
    [self.backgroundScrollView addSubview:self.longitudeTextField];
    [self.backgroundScrollView addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _geoTableIDTextField.delegate = self;
    _latitudeTextField.delegate = self;
    _longitudeTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_latitudeTextField] || [textField isEqual:_longitudeTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 90);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    //初始化请求参数类BMKCloudReverseGeoCodeSearchInfo的实例
    BMKCloudReverseGeoCodeSearchInfo *info = [self setupCloudRGCSearchInfo];
    if (self.searchDataBlock) {
        self.searchDataBlock(info);
    }
}

- (BMKCloudReverseGeoCodeSearchInfo *)setupCloudRGCSearchInfo {
    //初始化请求参数类BMKCloudReverseGeoCodeSearchInfo的实例
    BMKCloudReverseGeoCodeSearchInfo *cloudRGCSearchInfo = [[BMKCloudReverseGeoCodeSearchInfo alloc] init];
    //geo table表主键，必选
    cloudRGCSearchInfo.geoTableId = [_geoTableIDTextField.text intValue];
    //经纬度坐标
    cloudRGCSearchInfo.reverseGeoPoint = CLLocationCoordinate2DMake([_latitudeTextField.text floatValue], [_longitudeTextField.text floatValue]);
    return cloudRGCSearchInfo;
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 270 + 100);
    }
    return _backgroundScrollView;
}

- (UILabel *)geoTableIDLabel {
    if (!_geoTableIDLabel) {
        _geoTableIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _geoTableIDLabel.font = [UIFont systemFontOfSize:17];
        _geoTableIDLabel.text = @"geo table 表主键（必选）";
    }
    return _geoTableIDLabel;
}

- (UILabel *)latitudeLabel {
    if (!_latitudeLabel) {
        _latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _latitudeLabel.font = [UIFont systemFontOfSize:17];
        _latitudeLabel.text = @"纬度坐标（必选）";
    }
    return _latitudeLabel;
}

- (UILabel *)longitudeLabel {
    if (!_longitudeLabel) {
        _longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _longitudeLabel.font = [UIFont systemFontOfSize:17];
        _longitudeLabel.text = @"经度坐标（必选）";
    }
    return _longitudeLabel;
}

- (UITextField *)geoTableIDTextField {
    if (!_geoTableIDTextField) {
        _geoTableIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _geoTableIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _geoTableIDTextField;
}

- (UITextField *)latitudeTextField {
    if (!_latitudeTextField) {
        _latitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _latitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _latitudeTextField;
}

- (UITextField *)longitudeTextField {
    if (!_longitudeTextField) {
        _longitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _longitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _longitudeTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 300, 160, 35)];
        [_searchButton addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.clipsToBounds = YES;
        _searchButton.layer.cornerRadius = 16;
        [_searchButton setTitle:@"检索数据" forState:UIControlStateNormal];
        _searchButton.titleLabel.textColor = [UIColor whiteColor];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _searchButton.backgroundColor = COLOR(0x3385FF);
    }
    return _searchButton;
}

@end
