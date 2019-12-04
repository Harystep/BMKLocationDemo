//
//  BMKCloudLocalParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCloudLocalParametersPage.h"

@interface BMKCloudLocalParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UILabel *akLabel;
@property (nonatomic, strong) UILabel *snLabel;
@property (nonatomic, strong) UILabel *geoTableIDLabel;
@property (nonatomic, strong) UILabel *keywordLabel;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UILabel *sortbyLabel;
@property (nonatomic, strong) UILabel *filterLabel;
@property (nonatomic, strong) UILabel *pageIndexLabel;
@property (nonatomic, strong) UILabel *pageSizeLabel;
@property (nonatomic, strong) UILabel *regionLabel;
@property (nonatomic, strong) UITextField *akTextField;
@property (nonatomic, strong) UITextField *snTextField;
@property (nonatomic, strong) UITextField *geoTableIDTextField;
@property (nonatomic, strong) UITextField *keywordTextField;
@property (nonatomic, strong) UITextField *tagsTextField;
@property (nonatomic, strong) UITextField *sortbyTextField;
@property (nonatomic, strong) UITextField *filterTextField;
@property (nonatomic, strong) UITextField *pageIndexTextField;
@property (nonatomic, strong) UITextField *pageSizeTextField;
@property (nonatomic, strong) UITextField *regionTextField;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKCloudLocalParametersPage

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
    [self.backgroundScrollView addSubview:self.keywordLabel];
    [self.backgroundScrollView addSubview:self.tagsLabel];
    [self.backgroundScrollView addSubview:self.sortbyLabel];
    [self.backgroundScrollView addSubview:self.filterLabel];
    [self.backgroundScrollView addSubview:self.pageIndexLabel];
    [self.backgroundScrollView addSubview:self.pageSizeLabel];
    [self.backgroundScrollView addSubview:self.akTextField];
    [self.backgroundScrollView addSubview:self.snTextField];
    [self.backgroundScrollView addSubview:self.geoTableIDTextField];
    [self.backgroundScrollView addSubview:self.keywordTextField];
    [self.backgroundScrollView addSubview:self.tagsTextField];
    [self.backgroundScrollView addSubview:self.sortbyTextField];
    [self.backgroundScrollView addSubview:self.filterTextField];
    [self.backgroundScrollView addSubview:self.pageSizeTextField];
    [self.backgroundScrollView addSubview:self.pageIndexTextField];
    [self.backgroundScrollView addSubview:self.regionLabel];
    [self.backgroundScrollView addSubview:self.regionTextField];
    [self.backgroundScrollView addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _akTextField.delegate = self;
    _snTextField.delegate = self;
    _geoTableIDTextField.delegate = self;
    _keywordTextField.delegate = self;
    _tagsTextField.delegate = self;
    _sortbyTextField.delegate = self;
    _filterTextField.delegate = self;
    _pageSizeTextField.delegate = self;
    _pageIndexTextField.delegate = self;
    _regionTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_pageSizeTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 630);
        }];
    }
    if ([textField isEqual:_pageIndexTextField] || [textField isEqual:_snTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 720);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    BMKCloudLocalSearchInfo *info = [self setupCloudLocalSearchInfo];
    if (self.searchDataBlock) {
        self.searchDataBlock(info);
    }
}

- (BMKCloudLocalSearchInfo *)setupCloudLocalSearchInfo {
    //实例化本地云检索参数信息类对象
    BMKCloudLocalSearchInfo *cloudLocalSearchInfo = [[BMKCloudLocalSearchInfo alloc] init];
    //access_key（必选），最大长度50
    cloudLocalSearchInfo.ak = _akTextField.text;
    //geo table 表主键（必选）
    cloudLocalSearchInfo.geoTableId = [_geoTableIDTextField.text intValue];
    //用户的权限签名，最大长度50
    cloudLocalSearchInfo.sn = _snTextField.text;
    //检索关键字，最长45个字符
    cloudLocalSearchInfo.keyword = _keywordTextField.text;
    //标签，空格分隔的多字符串，最长45个字符，样例：美食 小吃
    cloudLocalSearchInfo.tags = _tagsTextField.text;
    //排序字段，ortby={keyname}:1 升序；sortby={keyname}:-1 降序
    cloudLocalSearchInfo.sortby = _sortbyTextField.text;
    //过滤条件，可选:'|'竖线分隔的多个key-value对,price:9.99,19.99|time:2012,2012
    cloudLocalSearchInfo.filter = _filterTextField.text;
    //分页数量，默认为10，最多为50
    cloudLocalSearchInfo.pageSize = [_pageSizeTextField.text floatValue] == 0 ? 10 : [_pageSizeTextField.text floatValue];
    //分页索引，默认为0
    cloudLocalSearchInfo.pageIndex = [_pageIndexTextField.text floatValue];
    //区域名称(市或区的名字，如北京市，海淀区)，必选， 最长25个字符
    cloudLocalSearchInfo.region = _regionTextField.text;
    return cloudLocalSearchInfo;
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 900 + 100);
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
        _snLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 830, KScreenWidth - 20, 30)];
        _snLabel.font = [UIFont systemFontOfSize:17];
        _snLabel.text = @"用户的权限签名";
    }
    return _snLabel;
}

- (UILabel *)keywordLabel {
    if (!_keywordLabel) {
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _keywordLabel.font = [UIFont systemFontOfSize:17];
        _keywordLabel.text = @"关键字";
    }
    return _keywordLabel;
}

- (UILabel *)tagsLabel {
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _tagsLabel.font = [UIFont systemFontOfSize:17];
        _tagsLabel.text = @"标签";
    }
    return _tagsLabel;
}

- (UILabel *)sortbyLabel {
    if (!_sortbyLabel) {
        _sortbyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 470, KScreenWidth - 20, 30)];
        _sortbyLabel.font = [UIFont systemFontOfSize:17];
        _sortbyLabel.text = @"排序字段";
    }
    return _sortbyLabel;
}

- (UILabel *)filterLabel {
    if (!_filterLabel) {
        _filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 560, KScreenWidth - 20, 30)];
        _filterLabel.font = [UIFont systemFontOfSize:17];
        _filterLabel.text = @"过滤字段";
    }
    return _filterLabel;
}

- (UILabel *)pageSizeLabel {
    if (!_pageSizeLabel) {
        _pageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 650, KScreenWidth - 20, 30)];
        _pageSizeLabel.font = [UIFont systemFontOfSize:17];
        _pageSizeLabel.text = @"分页数量";
    }
    return _pageSizeLabel;
}

- (UILabel *)pageIndexLabel {
    if (!_pageIndexLabel) {
        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 740, KScreenWidth - 20, 30)];
        _pageIndexLabel.font = [UIFont systemFontOfSize:17];
        _pageIndexLabel.text = @"分页索引";
    }
    return _pageIndexLabel;
}

- (UILabel *)regionLabel {
    if (!_regionLabel) {
        _regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 40, 30)];
        _regionLabel.font = [UIFont systemFontOfSize:17];
        _regionLabel.text = @"区域名称：市或区的名字（必选）";
    }
    return _regionLabel;
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
        _snTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 865, KScreenWidth - 40, 35)];
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

- (UITextField *)keywordTextField {
    if (!_keywordTextField) {
        _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _keywordTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _keywordTextField;
}

- (UITextField *)tagsTextField {
    if (!_tagsTextField) {
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _tagsTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _tagsTextField;
}

- (UITextField *)sortbyTextField {
    if (!_sortbyTextField) {
        _sortbyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 505, KScreenWidth - 40, 35)];
        _sortbyTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _sortbyTextField;
}

- (UITextField *)filterTextField {
    if (!_filterTextField) {
        _filterTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 595, KScreenWidth - 40, 35)];
        _filterTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _filterTextField;
}

- (UITextField *)pageSizeTextField {
    if (!_pageSizeTextField) {
        _pageSizeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 685, KScreenWidth - 40, 35)];
        _pageSizeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageSizeTextField;
}

- (UITextField *)pageIndexTextField {
    if (!_pageIndexTextField) {
        _pageIndexTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 775, KScreenWidth - 40, 35)];
        _pageIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageIndexTextField;
}

- (UITextField *)regionTextField {
    if (!_regionTextField) {
        _regionTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _regionTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _regionTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 930, 160, 35)];
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
