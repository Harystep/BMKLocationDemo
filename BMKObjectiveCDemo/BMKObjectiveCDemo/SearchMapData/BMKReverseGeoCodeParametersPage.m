//
//  BMKReverseGeoCodeParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKReverseGeoCodeParametersPage.h"

@interface BMKReverseGeoCodeParametersPage ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *longitudeLabel;
@property (nonatomic, strong) UILabel *latitudeLabel;
@property (nonatomic, strong) UITextField *longitudeTextField;
@property (nonatomic, strong) UITextField *latitudeTextField;;
@property (nonatomic, strong) UISwitch *isLatestAdminSwitch;
@property (nonatomic, strong) UILabel *isLatestAdminLabel;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, assign) BOOL isLatestAdmin;
@end

@implementation BMKReverseGeoCodeParametersPage

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
    [self.view addSubview:self.latitudeLabel];
    [self.view addSubview:self.longitudeLabel];
    [self.view addSubview:self.longitudeTextField];
    [self.view addSubview:self.latitudeTextField];
    [self.view addSubview:self.isLatestAdminLabel];
    [self.view addSubview:self.isLatestAdminSwitch];
    [self.view addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _longitudeTextField.delegate = self;
    _latitudeTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [self setupReverseGeoCodeSearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(reverseGeoCodeSearchOption);
    }
}

- (BMKReverseGeoCodeSearchOption *)setupReverseGeoCodeSearchOption {
    //初始化请求参数类BMKReverseGeoCodeOption的实例
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    //待解析的经纬度坐标（必选）
    reverseGeoCodeSearchOption.location = CLLocationCoordinate2DMake([_latitudeTextField.text floatValue], [_longitudeTextField.text floatValue]);
    //是否访问最新版行政区划数据（仅对中国数据生效）
    reverseGeoCodeSearchOption.isLatestAdmin = _isLatestAdmin;
    return reverseGeoCodeSearchOption;
}

- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //访问最新版行政区划数据（仅对中国数据生效）
        _isLatestAdmin = YES;
    } else {
        //不访问最新版行政区划数据（仅对中国数据生效）
        _isLatestAdmin = NO;
    }
}

#pragma mark - Lazy loading
- (UILabel *)latitudeLabel {
    if (!_latitudeLabel) {
        _latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _latitudeLabel.font = [UIFont systemFontOfSize:17];
        _latitudeLabel.text = @"纬度（必选）";
    }
    return _latitudeLabel;
}

- (UILabel *)longitudeLabel {
    if (!_longitudeLabel) {
        _longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _longitudeLabel.text = @"经度（必选）";
        _longitudeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _longitudeLabel;
}

- (UILabel *)isLatestAdminLabel {
    if (!_isLatestAdminLabel) {
        _isLatestAdminLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _isLatestAdminLabel.text = @"是否访问最新版行政区划数据";
        _isLatestAdminLabel.numberOfLines = 1;
        _isLatestAdminLabel.font = [UIFont systemFontOfSize:17];
    }
    return _isLatestAdminLabel;
}

- (UISwitch *)isLatestAdminSwitch {
    if (!_isLatestAdminSwitch) {
        _isLatestAdminSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 235, 120, 35)];
        [_isLatestAdminSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _isLatestAdminSwitch;
}

- (UITextField *)latitudeTextField {
    if (!_latitudeTextField) {
        _latitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _latitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _latitudeTextField;
}

- (UITextField *)longitudeTextField {
    if (!_longitudeTextField) {
        _longitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
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
