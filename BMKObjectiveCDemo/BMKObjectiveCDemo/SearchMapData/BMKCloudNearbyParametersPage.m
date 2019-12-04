//
//  BMKCloudNearbyParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCloudNearbyParametersPage.h"

@interface BMKCloudNearbyParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
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
@property (nonatomic, strong) UITextField *akTextField;
@property (nonatomic, strong) UITextField *snTextField;
@property (nonatomic, strong) UITextField *geoTableIDTextField;
@property (nonatomic, strong) UITextField *keywordTextField;
@property (nonatomic, strong) UITextField *tagsTextField;
@property (nonatomic, strong) UITextField *sortbyTextField;
@property (nonatomic, strong) UITextField *filterTextField;
@property (nonatomic, strong) UITextField *pageIndexTextField;
@property (nonatomic, strong) UITextField *pageSizeTextField;
@property (nonatomic, strong) UILabel *radiusLabel;;
@property (nonatomic, strong) UITextField *radiusTextField;
@property (nonatomic, strong) UILabel *latitudeLabel;
@property (nonatomic, strong) UILabel *longitudeLabel;
@property (nonatomic, strong) UITextField *latitudeTextField;
@property (nonatomic, strong) UITextField *longitudeTextField;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKCloudNearbyParametersPage

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
    [self.backgroundScrollView addSubview:self.radiusLabel];
    [self.backgroundScrollView addSubview:self.radiusTextField];
    [self.backgroundScrollView addSubview:self.latitudeLabel];
    [self.backgroundScrollView addSubview:self.longitudeLabel];
    [self.backgroundScrollView addSubview:self.latitudeTextField];
    [self.backgroundScrollView addSubview:self.longitudeTextField];
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
    _pageIndexTextField.delegate = self;
    _pageSizeTextField.delegate = self;
    _radiusTextField.delegate = self;
    _latitudeTextField.delegate = self;
    _longitudeTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_snTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 810);
        }];
    }
    if ([textField isEqual:_keywordTextField] || [textField isEqual:_tagsTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 900);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    BMKCloudNearbySearchInfo *info = [self setupCloudNearbySearchInfo];
    if (self.searchDataBlock) {
        self.searchDataBlock(info);
    }
}

- (BMKCloudNearbySearchInfo *)setupCloudNearbySearchInfo {
    //实例化周边云检索参数信息类对象
    BMKCloudNearbySearchInfo *cloudNearbySearchInfo = [[BMKCloudNearbySearchInfo alloc] init];
    //access_key（必选），最大长度50
    cloudNearbySearchInfo.ak = _akTextField.text;
    //geo table 表主键（必选）
    cloudNearbySearchInfo.geoTableId =[_geoTableIDTextField.text intValue];
    //用户的权限签名，最大长度50
    cloudNearbySearchInfo.sn = _snTextField.text;
    //检索关键字，最长45个字符
    cloudNearbySearchInfo.keyword = _keywordTextField.text;
    //标签，空格分隔的多字符串，最长45个字符，样例：美食 小吃
    cloudNearbySearchInfo.tags = _tagsTextField.text;
    //排序字段，sortby={keyname}:1 升序；sortby={keyname}:-1 降序
    cloudNearbySearchInfo.sortby = _sortbyTextField.text;
    //过滤条件，'|'竖线分隔的多个key-value对,price:9.99,19.99|time:2012,2012
    cloudNearbySearchInfo.filter = _filterTextField.text;
    //分页数量，默认为10，最多为50
    cloudNearbySearchInfo.pageSize = [_pageSizeTextField.text floatValue] == 0 ? 10 : [_pageSizeTextField.text floatValue];
    //分页索引，默认为0
    cloudNearbySearchInfo.pageIndex = [_pageIndexTextField.text floatValue];
    //周边检索半径
    cloudNearbySearchInfo.radius = [_radiusTextField.text intValue];
    //检索的中心点，英文逗号分隔的经纬度(116.4321,38.76623)，最长25个字符
    cloudNearbySearchInfo.location = [NSString stringWithFormat:@"%@,%@", _longitudeTextField.text, _latitudeTextField.text];
    return cloudNearbySearchInfo;
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 1080 + 100);
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
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 920, KScreenWidth - 20, 30)];
        _keywordLabel.font = [UIFont systemFontOfSize:17];
        _keywordLabel.text = @"关键字";
    }
    return _keywordLabel;
}

- (UILabel *)tagsLabel {
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 1010, KScreenWidth - 20, 30)];
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

- (UILabel *)radiusLabel {
    if (!_radiusLabel) {
        _radiusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _radiusLabel.font = [UIFont systemFontOfSize:17];
        _radiusLabel.text = @"半径（必选）";
    }
    return _radiusLabel;
}

- (UILabel *)latitudeLabel {
    if (!_latitudeLabel) {
        _latitudeLabel =[[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _latitudeLabel.font = [UIFont systemFontOfSize:17];
        _latitudeLabel.text = @"纬度（必选）";
    }
    return _latitudeLabel;
}

- (UILabel *)longitudeLabel {
    if (!_longitudeLabel) {
        _longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _longitudeLabel.font = [UIFont systemFontOfSize:17];
        _longitudeLabel.text = @"经度（必选）";
    }
    return _longitudeLabel;
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
        _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 955, KScreenWidth - 40, 35)];
        _keywordTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _keywordTextField;
}

- (UITextField *)tagsTextField {
    if (!_tagsTextField) {
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 1045, KScreenWidth - 40, 35)];
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

- (UITextField *)radiusTextField {
    if (!_radiusTextField) {
        _radiusTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _radiusTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _radiusTextField;
}

- (UITextField *)latitudeTextField {
    if (!_latitudeTextField) {
        _latitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _latitudeTextField.borderStyle =UITextBorderStyleRoundedRect;
    }
    return _latitudeTextField;
}

- (UITextField *)longitudeTextField {
    if (!_longitudeTextField) {
        _longitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _longitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _longitudeTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 1100, 160, 35)];
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
