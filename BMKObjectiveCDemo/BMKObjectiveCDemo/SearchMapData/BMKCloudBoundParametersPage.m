//
//  BMKCloudBoundParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCloudBoundParametersPage.h"

@interface BMKCloudBoundParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
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
@property (nonatomic, strong) UILabel *leftBottomLatitudeLabel;
@property (nonatomic, strong) UILabel *leftBottomLongitudeLabel;
@property (nonatomic, strong) UILabel *rightTopLatitudeLabel;
@property (nonatomic, strong) UILabel *rightTopLongitudeLabel;
@property (nonatomic, strong) UITextField *leftBottomLatitudeTextField;
@property (nonatomic, strong) UITextField *leftBottomLongitudeTextField;
@property (nonatomic, strong) UITextField *rightTopLatitudeTextField;
@property (nonatomic, strong) UITextField *rightTopLongitudeTextField;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKCloudBoundParametersPage

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
    [self.backgroundScrollView addSubview:self.leftBottomLatitudeLabel];
    [self.backgroundScrollView addSubview:self.leftBottomLongitudeLabel];
    [self.backgroundScrollView addSubview:self.rightTopLatitudeTextField];
    [self.backgroundScrollView addSubview:self.rightTopLongitudeTextField];
    [self.backgroundScrollView addSubview:self.leftBottomLongitudeTextField];
    [self.backgroundScrollView addSubview:self.leftBottomLatitudeTextField];
    [self.backgroundScrollView addSubview:self.rightTopLatitudeLabel];
    [self.backgroundScrollView addSubview:self.rightTopLongitudeLabel];
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
    _leftBottomLatitudeTextField.delegate = self;
    _leftBottomLongitudeTextField.delegate = self;
    _rightTopLatitudeTextField.delegate = self;
    _rightTopLongitudeTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_filterTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 900);
        }];
    }
    if ([textField isEqual:_pageSizeTextField] || [textField isEqual:_pageIndexTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 990);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    BMKCloudBoundSearchInfo *info = [self setupCloudBoundSearchInfo];
    if (self.searchDataBlock) {
        self.searchDataBlock(info);
    }
}

- (BMKCloudBoundSearchInfo *)setupCloudBoundSearchInfo {
    //初始化请求参数类BMKCloudBoundSearchInfo的实例
    BMKCloudBoundSearchInfo *cloudBoundSearchInfo = [[BMKCloudBoundSearchInfo alloc] init];
    //access_key，最大长度50，必选
    cloudBoundSearchInfo.ak = _akTextField.text;
    //geo table表主键，必选
    cloudBoundSearchInfo.geoTableId = [_geoTableIDTextField.text intValue];
    //用户的权限签名，最大长度50，可选
    cloudBoundSearchInfo.sn = _snTextField.text;
    //检索关键字，最长45个字符
    cloudBoundSearchInfo.keyword = _keywordTextField.text;
    //标签，空格分隔的多字符串，最长45个字符，样例：美食 小吃，可选
    cloudBoundSearchInfo.tags = _tagsTextField.text;
    /**
     排序字段，可选： sortby={keyname}:1 升序；sortby={keyname}:-1 降序
     以下keyname为系统预定义的：
     1.distance 距离排序
     2.weight 权重排序
     默认为按weight排序
     如果需要自定义排序则指定排序字段，样例：按照价格由便宜到贵排序sortby=price:1
     */
    cloudBoundSearchInfo.sortby = _sortbyTextField.text;
    /**
     过滤条件，可选
     '|'竖线分隔的多个key-value对
     key为筛选字段的名称(存储服务中定义)
     value可以是整形或者浮点数的一个区间：格式为“small,big”逗号分隔的2个数字
     样例：筛选价格为9.99到19.99并且生产时间为2013年的项：price:9.99,19.99|time:2012,2012
     */
    cloudBoundSearchInfo.filter = _filterTextField.text;
    //分页数量，默认为10，最多为50，可选
    cloudBoundSearchInfo.pageSize = [_pageSizeTextField.text floatValue] == 0 ? 10 : [_pageSizeTextField.text floatValue];
    //分页索引，默认为0，可选
    cloudBoundSearchInfo.pageIndex = [_pageIndexTextField.text floatValue];
    /**
     矩形区域，左下角和右上角的经纬度坐标点，用;号分隔(116.30,36.20;117.30,37.20)，
     最长不超过25个字符
     */
    cloudBoundSearchInfo.bounds = [NSString stringWithFormat:@"(%f,%f;%f,%f)", [_leftBottomLatitudeTextField.text floatValue], [_leftBottomLongitudeTextField.text floatValue], [_rightTopLongitudeTextField.text floatValue], [_rightTopLatitudeTextField.text floatValue]];
    return cloudBoundSearchInfo;
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 1170 + 100);
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

- (UILabel *)leftBottomLatitudeLabel {
    if (!_leftBottomLatitudeLabel) {
        _leftBottomLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _leftBottomLatitudeLabel.font = [UIFont systemFontOfSize:17];
        _leftBottomLatitudeLabel.text = @"左下角纬度坐标（必选）";
    }
    return _leftBottomLatitudeLabel;
}

- (UILabel *)leftBottomLongitudeLabel {
    if (!_leftBottomLongitudeLabel) {
        _leftBottomLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _leftBottomLongitudeLabel.font = [UIFont systemFontOfSize:17];
        _leftBottomLongitudeLabel.text = @"左下角经度坐标（必选）";
    }
    return _leftBottomLongitudeLabel;
}

- (UILabel *)rightTopLatitudeLabel {
    if (!_rightTopLatitudeLabel) {
        _rightTopLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _rightTopLatitudeLabel.font = [UIFont systemFontOfSize:17];
        _rightTopLatitudeLabel.text = @"右上角纬度坐标（必选）";
    }
    return _rightTopLatitudeLabel;
}

- (UILabel *)rightTopLongitudeLabel {
    if (!_rightTopLongitudeLabel) {
        _rightTopLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 470, KScreenWidth - 20, 30)];
        _rightTopLongitudeLabel.font = [UIFont systemFontOfSize:17];
        _rightTopLongitudeLabel.text = @"右上角经度坐标（必选）";
    }
    return _rightTopLongitudeLabel;
}

- (UILabel *)snLabel {
    if (!_snLabel) {
        _snLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 560, KScreenWidth - 20, 30)];
        _snLabel.font = [UIFont systemFontOfSize:17];
        _snLabel.text = @"用户的权限签名";
    }
    return _snLabel;
}

- (UILabel *)keywordLabel {
    if (!_keywordLabel) {
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 650, KScreenWidth - 20, 30)];
        _keywordLabel.font = [UIFont systemFontOfSize:17];
        _keywordLabel.text = @"关键字";
    }
    return _keywordLabel;
}

- (UILabel *)tagsLabel {
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 740, KScreenWidth - 20, 30)];
        _tagsLabel.font = [UIFont systemFontOfSize:17];
        _tagsLabel.text = @"标签";
    }
    return _tagsLabel;
}

- (UILabel *)sortbyLabel {
    if (!_sortbyLabel) {
        _sortbyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 830, KScreenWidth - 20, 30)];
        _sortbyLabel.font = [UIFont systemFontOfSize:17];
        _sortbyLabel.text = @"排序字段";
    }
    return _sortbyLabel;
}

- (UILabel *)filterLabel {
    if (!_filterLabel) {
        _filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 920, KScreenWidth - 20, 30)];
        _filterLabel.font = [UIFont systemFontOfSize:17];
        _filterLabel.text = @"过滤字段";
    }
    return _filterLabel;
}

- (UILabel *)pageSizeLabel {
    if (!_pageSizeLabel) {
        _pageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 1010, KScreenWidth - 20, 30)];
        _pageSizeLabel.font = [UIFont systemFontOfSize:17];
        _pageSizeLabel.text = @"分页数量";
    }
    return _pageSizeLabel;
}

- (UILabel *)pageIndexLabel {
    if (!_pageIndexLabel) {
        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 1100, KScreenWidth - 20, 30)];
        _pageIndexLabel.font = [UIFont systemFontOfSize:17];
        _pageIndexLabel.text = @"分页索引";
    }
    return _pageIndexLabel;
}

- (UITextField *)akTextField {
    if (!_akTextField) {
        _akTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _akTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _akTextField;
}

- (UITextField *)leftBottomLatitudeTextField {
    if (!_leftBottomLatitudeTextField) {
        _leftBottomLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _leftBottomLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _leftBottomLatitudeTextField;
}

- (UITextField *)leftBottomLongitudeTextField {
    if (!_leftBottomLongitudeTextField) {
        _leftBottomLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _leftBottomLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _leftBottomLongitudeTextField;
}

- (UITextField *)rightTopLatitudeTextField {
    if (!_rightTopLongitudeTextField) {
        _rightTopLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _rightTopLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _rightTopLatitudeTextField;
}

- (UITextField *)rightTopLongitudeTextField {
    if (!_rightTopLongitudeTextField) {
        _rightTopLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 505, KScreenWidth - 40, 35)];
        _rightTopLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _rightTopLongitudeTextField;
}

- (UITextField *)snTextField {
    if (!_snTextField) {
        _snTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 595, KScreenWidth - 40, 35)];
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
        _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 685, KScreenWidth - 40, 35)];
        _keywordTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _keywordTextField;
}

- (UITextField *)tagsTextField {
    if (!_tagsTextField) {
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 775, KScreenWidth - 40, 35)];
        _tagsTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _tagsTextField;
}

- (UITextField *)sortbyTextField {
    if (!_sortbyTextField) {
        _sortbyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 865, KScreenWidth - 40, 35)];
        _sortbyTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _sortbyTextField;
}

- (UITextField *)filterTextField {
    if (!_filterTextField) {
        _filterTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 955, KScreenWidth - 40, 35)];
        _filterTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _filterTextField;
}

- (UITextField *)pageSizeTextField {
    if (!_pageSizeTextField) {
        _pageSizeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 1045, KScreenWidth - 40, 35)];
        _pageSizeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageSizeTextField;
}

- (UITextField *)pageIndexTextField {
    if (!_pageIndexTextField) {
        _pageIndexTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 1135, KScreenWidth - 40, 35)];
        _pageIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageIndexTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 1200, 160, 35)];
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
