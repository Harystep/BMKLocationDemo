//
//  BMKCloudDetailParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCloudDetailParametersPage.h"

@interface BMKCloudDetailParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *akLabel;
@property (nonatomic, strong) UILabel *snLabel;
@property (nonatomic, strong) UILabel *geoTableIDLabel;
@property (nonatomic, strong) UILabel *uidLabel;
@property (nonatomic, strong) UITextField *akTextField;
@property (nonatomic, strong) UITextField *snTextField;
@property (nonatomic, strong) UITextField *geoTableIDTextField;
@property (nonatomic, strong) UITextField *uidTextField;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKCloudDetailParametersPage

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
    [self.backgroundScrollView addSubview:self.akLabel];
    [self.backgroundScrollView addSubview:self.snLabel];
    [self.backgroundScrollView addSubview:self.geoTableIDLabel];
    [self.backgroundScrollView addSubview:self.akTextField];
    [self.backgroundScrollView addSubview:self.snTextField];
    [self.backgroundScrollView addSubview:self.geoTableIDTextField];
    [self.backgroundScrollView addSubview:self.uidLabel];
    [self.backgroundScrollView addSubview:self.uidTextField];
    [self.backgroundScrollView addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _akTextField.delegate = self;
    _snTextField.delegate = self;
    _geoTableIDTextField.delegate = self;
    _uidTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_geoTableIDTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 90);
        }];
    }
    if ([textField isEqual:_uidTextField] || [textField isEqual:_snTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 180);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    BMKCloudDetailSearchInfo *info = [self setupCloudDetailSearchInfo];
    if (self.searchDataBlock) {
        self.searchDataBlock(info);
    }
}

- (BMKCloudDetailSearchInfo *)setupCloudDetailSearchInfo {
    //初始化请求参数类BMKCloudDetailSearchInfo的实例
    BMKCloudDetailSearchInfo *cloudDetailSearchInfo = [[BMKCloudDetailSearchInfo alloc] init];
    //access_key，最大长度50，必选
    cloudDetailSearchInfo.ak = _akTextField.text;
    //geo table表主键，必选
    cloudDetailSearchInfo.geoTableId = [_geoTableIDTextField.text intValue];
    //用户的权限签名，最大长度50，可选
    cloudDetailSearchInfo.sn = _snTextField.text;
    //UID为POI点的唯一标识符
    cloudDetailSearchInfo.uid = _uidTextField.text;
    return cloudDetailSearchInfo;
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 360 + 100);
    }
    return _backgroundScrollView;
}

- (UILabel *)akLabel {
    if (!_akLabel) {
        _akLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _akLabel.font = [UIFont systemFontOfSize:17];
        _akLabel.text = @"access_key（必选）";
    }
    return _akLabel;
}

- (UILabel *)geoTableIDLabel {
    if (!_geoTableIDLabel) {
        _geoTableIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _geoTableIDLabel.font = [UIFont systemFontOfSize:17];
        _geoTableIDLabel.text = @"geo table 表主键（必选）";
    }
    return _geoTableIDLabel;
}

- (UILabel *)snLabel {
    if (!_snLabel) {
        _snLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _snLabel.font = [UIFont systemFontOfSize:17];
        _snLabel.text = @"用户的权限签名";
    }
    return _snLabel;
}

- (UILabel *)uidLabel {
    if (!_uidLabel) {
        _uidLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _uidLabel.font = [UIFont systemFontOfSize:17];
        _uidLabel.text = @"POI的ID值（必选）";
    }
    return _uidLabel;
}

- (UITextField *)akTextField {
    if (!_akTextField) {
        _akTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _akTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _akTextField;
}

- (UITextField *)snTextField {
    if (!_snTextField) {
        _snTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _snTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _snTextField;
}

- (UITextField *)geoTableIDTextField {
    if (!_geoTableIDTextField) {
        _geoTableIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _geoTableIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _geoTableIDTextField;
}

- (UITextField *)uidTextField {
    if (!_uidTextField) {
        _uidTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _uidTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _uidTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 390, 160, 35)];
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
