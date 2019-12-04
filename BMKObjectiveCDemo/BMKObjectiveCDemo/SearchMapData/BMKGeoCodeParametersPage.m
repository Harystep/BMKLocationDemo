//
//  BMKGeoCodeParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKGeoCodeParametersPage.h"

@interface BMKGeoCodeParametersPage ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKGeoCodeParametersPage

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
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.cityLabel];
    [self.view addSubview:self.addressTextField];
    [self.view addSubview:self.cityTextField];
    [self.view addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _addressTextField.delegate = self;
    _cityTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    BMKGeoCodeSearchOption *geoCodeOption = [self setupGeoCodeSearchOption];
    if (self.searchDataBlock) {
     self.searchDataBlock(geoCodeOption);
    }
}

- (BMKGeoCodeSearchOption *)setupGeoCodeSearchOption {
    //实例化正地理编码参数信息类对象
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    /**
     待解析的地址，必选
     可以输入2种样式的值，分别是：
     1、标准的结构化地址信息，如北京市海淀区上地十街十号 【推荐，地址结构越完整，解析精度越高】
     2、支持“*路与*路交叉口”描述方式，如北一环路和阜阳路的交叉路口
     注意：第二种方式并不总是有返回结果，只有当地址库中存在该地址描述时才有返回
    */
    geoCodeOption.address = _addressTextField.text;
    /**
      地址所在的城市名，可选
      用于指定上述地址所在的城市，当多个城市都有上述地址时，该参数起到过滤作用
      注意：指定该字段，不会限制坐标召回城市
     */
    geoCodeOption.city = _cityTextField.text;
    return geoCodeOption;
}

#pragma mark - Lazy loading
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _addressLabel.font = [UIFont systemFontOfSize:17];
        _addressLabel.text = @"地址（必选）";
    }
    return _addressLabel;
}

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _cityLabel.font = [UIFont systemFontOfSize:17];
        _cityLabel.text = @"城市";
    }
    return _cityLabel;
}

- (UITextField *)addressTextField {
    if (!_addressTextField) {
        _addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _addressTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _addressTextField;
}

- (UITextField *)cityTextField {
    if (!_cityTextField) {
        _cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _cityTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _cityTextField;
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
