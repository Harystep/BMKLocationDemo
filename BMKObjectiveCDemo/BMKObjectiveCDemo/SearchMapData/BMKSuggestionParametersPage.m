//
//  BMKSuggestionParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKSuggestionParametersPage.h"

@interface BMKSuggestionParametersPage ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *keywordLabel;
@property (nonatomic, strong) UILabel *cityNameLabel;
@property (nonatomic, strong) UITextField *keywordTextField;
@property (nonatomic, strong) UITextField *cityNameTextField;
@property (nonatomic, strong) UILabel *isCityLimitLabel;
@property (nonatomic, strong) UISwitch *isCityLimitSwitch;
@property (nonatomic, assign) BOOL isCityLimit;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKSuggestionParametersPage

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
    [self.view addSubview:self.keywordLabel];
    [self.view addSubview:self.cityNameLabel];
    [self.view addSubview:self.keywordTextField];
    [self.view addSubview:self.cityNameTextField];
    [self.view addSubview:self.isCityLimitLabel];
    [self.view addSubview:self.isCityLimitSwitch];
    [self.view addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _keywordTextField.delegate = self;
    _cityNameTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
   [self.navigationController popViewControllerAnimated:YES];
    //初始化请求参数类BMKSuggestionSearchOption的实例
    BMKSuggestionSearchOption *suggestionOption = [self setupSuggestionSearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(suggestionOption);
    }
}

- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //只返回指定城市检索结果，默认为NO（海外区域暂不支持设置cityLimit）
        _isCityLimit = YES;
    } else {
        _isCityLimit = NO;
    }
}

- (BMKSuggestionSearchOption *)setupSuggestionSearchOption {
    //初始化请求参数类BMKSuggestionSearchOption的实例
    BMKSuggestionSearchOption *suggestionOption = [[BMKSuggestionSearchOption alloc] init];
    //检索关键字
    suggestionOption.keyword = _keywordTextField.text;
    //城市名
    suggestionOption.cityname = _cityNameTextField.text;
    //是否只返回指定城市检索结果（默认：NO）（提示：海外区域暂不支持设置cityLimit）
    suggestionOption.cityLimit = _isCityLimit;
    return suggestionOption;
}

#pragma mark - Lazy loading
- (UILabel *)keywordLabel {
    if (!_keywordLabel) {
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _keywordLabel.text = @"关键字（必选）";
        _keywordLabel.font = [UIFont systemFontOfSize:17];
    }
    return _keywordLabel;
}

- (UILabel *)cityNameLabel {
    if (!_cityNameLabel) {
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _cityNameLabel.text = @"城市";
        _cityNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _cityNameLabel;
}

- (UILabel *)isCityLimitLabel {
    if (!_isCityLimitLabel) {
        _isCityLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _isCityLimitLabel.text = @"是否只返回指定城市检索结果";
        _isCityLimitLabel.font = [UIFont systemFontOfSize:17];
    }
    return _isCityLimitLabel;
}

- (UISwitch *)isCityLimitSwitch {
    if (!_isCityLimitSwitch) {
        _isCityLimitSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 235, 120, 35)];
         [_isCityLimitSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _isCityLimitSwitch;
}

- (UITextField *)keywordTextField {
    if (!_keywordTextField) {
        _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _keywordTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _keywordTextField;
}

- (UITextField *)cityNameTextField {
    if (!_cityNameTextField) {
        _cityNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _cityNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _cityNameTextField;
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
