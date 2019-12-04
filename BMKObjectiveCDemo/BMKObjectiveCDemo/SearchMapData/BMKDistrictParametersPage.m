//
//  BMKDistrictParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKDistrictParametersPage.h"

@interface BMKDistrictParametersPage ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *citylabel;
@property (nonatomic, strong) UILabel *districtLabel;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UITextField *districtTextField;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKDistrictParametersPage

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
    [self.view addSubview:self.citylabel];
    [self.view addSubview:self.districtLabel];
    [self.view addSubview:self.cityTextField];
    [self.view addSubview:self.districtTextField];
    [self.view addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _districtTextField.delegate = self;
    _cityTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
   [self.navigationController popViewControllerAnimated:YES];
    BMKDistrictSearchOption *districtOption = [self setupDistrictSearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(districtOption);
    }
}

- (BMKDistrictSearchOption *)setupDistrictSearchOption {
    //初始化请求参数类BMKDistrictSearchOption的实例
    BMKDistrictSearchOption *districtOption = [[BMKDistrictSearchOption alloc] init];
    //城市名，必选
    districtOption.city = _cityTextField.text;
    //区县名字，可选
    districtOption.district = _districtTextField.text;
    return districtOption;
}

#pragma mark - Lazy loading
- (UILabel *)citylabel {
    if (!_citylabel) {
        _citylabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _citylabel.text = @"城市（必选）";
        _citylabel.font = [UIFont systemFontOfSize:17];
    }
    return _citylabel;
}

- (UILabel *)districtLabel {
    if (!_districtLabel) {
        _districtLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _districtLabel.text = @"区县";
        _districtLabel.font = [UIFont systemFontOfSize:17];
    }
    return _districtLabel;
}

- (UITextField *)cityTextField {
    if (!_cityTextField) {
        _cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _cityTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _cityTextField;
}

- (UITextField *)districtTextField {
    if (!_districtTextField) {
        _districtTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _districtTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _districtTextField;
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
