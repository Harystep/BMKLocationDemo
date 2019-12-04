//
//  BMKBusLineParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKBusLineParametersPage.h"

@interface BMKBusLineParametersPage ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *busLineUIDLabel;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UITextField *busLineUIDTextField;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKBusLineParametersPage

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
    [self.view addSubview:self.cityLabel];
    [self.view addSubview:self.busLineUIDLabel];
    [self.view addSubview:self.cityTextField];
    [self.view addSubview:self.busLineUIDTextField];
    [self.view addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _busLineUIDTextField.delegate = self;
    _cityTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    //初始化请求参数类BMKBusLineSearchOption的实例
    BMKBusLineSearchOption *busLineption = [self setupBusLineSearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(busLineption);
    }
}

- (BMKBusLineSearchOption *)setupBusLineSearchOption {
    //实例化公交线路检索信息类对象
    BMKBusLineSearchOption *busLineOption = [[BMKBusLineSearchOption alloc] init];
    //城市名
    busLineOption.city = _cityTextField.text;
    //公交线路的UID
    busLineOption.busLineUid = _busLineUIDTextField.text;
    return busLineOption;
}

#pragma mark - Lazy loading
- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _cityLabel.text = @"城市(必选)";
        _cityLabel.font = [UIFont systemFontOfSize:17];
    }
    return _cityLabel;
}

- (UILabel *)busLineUIDLabel {
    if (!_busLineUIDLabel) {
        _busLineUIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _busLineUIDLabel.text = @"公交线路的UID（必选）";
        _busLineUIDLabel.font = [UIFont systemFontOfSize:17];
    }
    return _busLineUIDLabel;
}

- (UITextField *)cityTextField {
    if (!_cityTextField) {
        _cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _cityTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _cityTextField;
}

- (UITextField *)busLineUIDTextField {
    if (!_busLineUIDTextField) {
        _busLineUIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _busLineUIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _busLineUIDTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 210, 160, 35)];
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
