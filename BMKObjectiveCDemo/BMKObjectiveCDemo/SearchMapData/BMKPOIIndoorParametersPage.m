//
//  BMKPOIIndoorParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOIIndoorParametersPage.h"

@interface BMKPOIIndoorParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *indoorIDLabel;
@property (nonatomic, strong) UILabel *keywordLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UILabel *pageIndexLabel;
@property (nonatomic, strong) UILabel *pageSizeLabel;
@property (nonatomic, strong) UITextField *indoorIDTextField;
@property (nonatomic, strong) UITextField *keywordTextField;
@property (nonatomic, strong) UITextField *floorTextField;
@property (nonatomic, strong) UITextField *pageIndexTextField;
@property (nonatomic, strong) UITextField *pageSizeTextField;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@end

@implementation BMKPOIIndoorParametersPage

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
    [self.backgroundScrollView addSubview:self.indoorIDLabel];
    [self.backgroundScrollView addSubview:self.keywordLabel];
    [self.backgroundScrollView addSubview:self.floorLabel];
    [self.backgroundScrollView addSubview:self.pageIndexLabel];
    [self.backgroundScrollView addSubview:self.pageSizeLabel];
    [self.backgroundScrollView addSubview:self.indoorIDTextField];
    [self.backgroundScrollView addSubview:self.keywordTextField];
    [self.backgroundScrollView addSubview:self.floorTextField];
    [self.backgroundScrollView addSubview:self.pageIndexTextField];
    [self.backgroundScrollView addSubview:self.pageSizeTextField];
    [self.backgroundScrollView addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _indoorIDTextField.delegate = self;
    _keywordTextField.delegate = self;
    _floorTextField.delegate = self;
    _pageIndexTextField.delegate = self;
    _pageSizeTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_floorTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 180);
        }];
    }
    if ([textField isEqual:_pageSizeTextField] || [textField isEqual:_pageIndexTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 270);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
   [self.navigationController popViewControllerAnimated:YES];
    BMKPOIIndoorSearchOption *POIIndoorSearchOption = [self setupPOIIndoorSearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(POIIndoorSearchOption, YES);
    }
}

- (BMKPOIIndoorSearchOption *)setupPOIIndoorSearchOption {
    //初始化请求参数类BMKPoiIndoorSearchOption的实例
    BMKPOIIndoorSearchOption *POIIndoorSearchOption = [[BMKPOIIndoorSearchOption alloc] init];
    //室内检索唯一标识符，必选
    POIIndoorSearchOption.indoorID = _indoorIDTextField.text;
    //室内检索关键字，必选
    POIIndoorSearchOption.keyword = _keywordTextField.text;
    //楼层（可选），设置后，会优先获取该楼层的室内POI，然后是其它楼层的。如“F3”,"B3"等
    POIIndoorSearchOption.floor = _floorTextField.text;
    //单次召回POI数量，默认为10条记录，最大返回20条
    POIIndoorSearchOption.pageSize = [_pageSizeTextField.text intValue] == 0 ? 10 : [_pageSizeTextField.text intValue];
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    POIIndoorSearchOption.pageIndex =  [_pageIndexTextField.text intValue];
    return POIIndoorSearchOption;
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 450 + 100);
    }
    return _backgroundScrollView;
}

- (UILabel *)indoorIDLabel {
    if (!_indoorIDLabel) {
        _indoorIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _indoorIDLabel.text = @"室内ID（必选）";
    }
    return _indoorIDLabel;
}

- (UILabel *)keywordLabel {
    if (!_keywordLabel) {
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _keywordLabel.text = @"关键字（必选）";
    }
    return _keywordLabel;
}

- (UILabel *)floorLabel {
    if (!_floorLabel) {
        _floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _floorLabel.text = @"楼层";
    }
    return _floorLabel;
}

- (UILabel *)pageSizeLabel {
    if (!_pageSizeLabel) {
        _pageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _pageSizeLabel.text = @"数量";
    }
    return _pageSizeLabel;
}

- (UILabel *)pageIndexLabel {
    if (!_pageIndexLabel) {
        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _pageIndexLabel.text = @"分页";
    }
    return _pageIndexLabel;
}

- (UITextField *)indoorIDTextField {
    if (!_indoorIDTextField) {
        _indoorIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _indoorIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _indoorIDTextField;
}

- (UITextField *)keywordTextField {
    if (!_keywordTextField) {
        _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _keywordTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _keywordTextField;
}

- (UITextField *)floorTextField {
    if (!_floorTextField) {
        _floorTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _floorTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _floorTextField;
}

- (UITextField *)pageSizeTextField {
    if (!_pageSizeTextField) {
        _pageSizeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _pageSizeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageSizeTextField;
}

- (UITextField *)pageIndexTextField {
    if (!_pageIndexTextField) {
        _pageIndexTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _pageIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageIndexTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 480, 160, 35)];
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
