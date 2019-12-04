//
//  BMKPOICityParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOICityParametersPage.h"
#import "BMKPOIFilterParametersPage.h"

@interface BMKPOICityParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *keywordLabel;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *pageIndexLabel;
@property (nonatomic, strong) UILabel *pageSizeLabel;
@property (nonatomic, strong) UITextField *keywordTextField;
@property (nonatomic, strong) UITextField *tagsTextField;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UITextField *pageIndexTextField;
@property (nonatomic, strong) UITextField *pageSizeTextField;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UISegmentedControl *scopeSegmentControl;
@property (nonatomic, strong) UILabel *isCityLimitLabel;
@property (nonatomic, strong) UISwitch *isCityLimitSwitch;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) BMKPOICitySearchOption *cityOption; //POI城市检索参数信息
@end

@implementation BMKPOICityParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //实例化POI城市检索参数信息类对象
        _cityOption = [[BMKPOICitySearchOption alloc] init];
    }
    return self;
}

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"自定义参数";
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.keywordLabel];
    [self.backgroundScrollView addSubview:self.tagsLabel];
    [self.backgroundScrollView addSubview:self.cityLabel];
    [self.backgroundScrollView addSubview:self.pageIndexLabel];
    [self.backgroundScrollView addSubview:self.pageSizeLabel];
    [self.backgroundScrollView addSubview:self.keywordTextField];
    [self.backgroundScrollView addSubview:self.tagsTextField];
    [self.backgroundScrollView addSubview:self.cityTextField];
    [self.backgroundScrollView addSubview:self.pageIndexTextField];
    [self.backgroundScrollView addSubview:self.pageSizeTextField];
    [self.backgroundScrollView addSubview:self.scopeSegmentControl];
    [self.backgroundScrollView addSubview:self.isCityLimitLabel];
    [self.backgroundScrollView addSubview:self.isCityLimitSwitch];
    [self.backgroundScrollView addSubview:self.filterButton];
    [self.backgroundScrollView addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _keywordTextField.delegate = self;
    _tagsTextField.delegate = self;
    _cityTextField.delegate = self;
    _pageSizeTextField.delegate = self;
    _pageIndexTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_pageSizeTextField] || [textField isEqual:_pageIndexTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 270);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)segmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_scopeSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            //检索结果详细程度：基本信息
            _cityOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
            break;
        default:
            //检索结果详细程度：详细信息
            _cityOption.scope = BMK_POI_SCOPE_DETAIL_INFORMATION;
            break;
    }
}

- (void)isCityLimitSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //区域数据返回限制，可选，为true时，仅返回city对应区域内数据
        _cityOption.isCityLimit = YES;
    } else {
        //区域数据返回限制，可选，设置为不做限制
        _cityOption.isCityLimit = NO;
    }
}

- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    [self setupPOICitySearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(_cityOption);
    }
}

- (void)clickFilterButton {
    BMKPOIFilterParametersPage *page = [[BMKPOIFilterParametersPage alloc] init];
    page.filterDataBlock = ^(BMKPOISearchFilter *filter) {
        //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
        _cityOption.filter = filter;
    };
    page.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.navigationController pushViewController:page animated:YES];
}

- (void)setupPOICitySearchOption {
    //检索关键字，必选。举例：天安门
    _cityOption.keyword = _keywordTextField.text;
    //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
    _cityOption.city = _cityTextField.text;
    if ((_tagsTextField.text).length > 0) {
        //检索分类，与keyword字段组合进行检索，多个分类以","分隔。举例：美食,酒店
      _cityOption.tags = [_tagsTextField.text componentsSeparatedByString:@","];
    }
    //单次召回POI数量，默认为10条记录，最大返回20条
    _cityOption.pageSize =  [_pageSizeTextField.text intValue];
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    _cityOption.pageIndex = [_pageIndexTextField.text integerValue];
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
         _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 595 + 100);
    }
    return _backgroundScrollView;
}

- (UILabel *)keywordLabel {
    if (!_keywordLabel) {
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _keywordLabel.text = @"关键字（必选）";
        _keywordLabel.font = [UIFont systemFontOfSize:17];
    }
    return _keywordLabel;
}

- (UILabel *)tagsLabel {
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _tagsLabel.text = @"分类";
        _tagsLabel.font = [UIFont systemFontOfSize:17];
    }
    return _tagsLabel;
}

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _cityLabel.text = @"城市（必选）";
        _cityLabel.font = [UIFont systemFontOfSize:17];
    }
    return _cityLabel;
}

- (UILabel *)pageIndexLabel {
    if (!_pageIndexLabel) {
        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _pageIndexLabel.text = @"分页页码";
        _pageIndexLabel.font = [UIFont systemFontOfSize:17];
    }
    return _pageIndexLabel;
}

- (UILabel *)pageSizeLabel {
    if (!_pageSizeLabel) {
        _pageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _pageSizeLabel.text = @"召回数量";
        _pageSizeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _pageSizeLabel;
}

- (UITextField *)keywordTextField {
    if (!_keywordTextField) {
        _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _keywordTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _keywordTextField;
}

- (UITextField *)tagsTextField {
    if (!_tagsTextField) {
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _tagsTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _tagsTextField;
}

- (UITextField *)cityTextField {
    if (!_cityTextField) {
        _cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _cityTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _cityTextField;
}

- (UITextField *)pageSizeTextField {
    if (!_pageSizeTextField) {
        _pageSizeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _pageSizeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageSizeTextField;
}

- (UITextField *)pageIndexTextField {
    if (!_pageIndexTextField) {
        _pageIndexTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _pageIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageIndexTextField;
}

- (UISegmentedControl *)scopeSegmentControl {
    if (!_scopeSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"检索基本信息",@"检索详细信息", nil];
        _scopeSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _scopeSegmentControl.frame = CGRectMake(20, 470, KScreenWidth - 40, 35);
        [_scopeSegmentControl setTitle:@"检索基本信息" forSegmentAtIndex:0];
        [_scopeSegmentControl setTitle:@"检索详细信息" forSegmentAtIndex:1];
        _scopeSegmentControl.selectedSegmentIndex = 0;
        [_scopeSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _scopeSegmentControl;
}

- (UILabel *)isCityLimitLabel {
    if (!_isCityLimitLabel) {
        _isCityLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 525, KScreenWidth - 20, 30)];
        _isCityLimitLabel.text = @"区域数据返回是否限制";
        _isCityLimitLabel.font = [UIFont systemFontOfSize:17];
    }
    return _isCityLimitLabel;
}

- (UISwitch *)isCityLimitSwitch {
    if (!_isCityLimitSwitch) {
        _isCityLimitSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 560, 120, 35)];
        [_isCityLimitSwitch addTarget:self action:@selector(isCityLimitSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _isCityLimitSwitch;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(197 * widthScale, 625, 159 * widthScale, 35)];
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

- (UIButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [[UIButton alloc] initWithFrame:CGRectMake(19 * widthScale, 625, 159 * widthScale, 35)];
        [_filterButton addTarget:self action:@selector(clickFilterButton) forControlEvents:UIControlEventTouchUpInside];
        _filterButton.clipsToBounds = YES;
        _filterButton.layer.cornerRadius = 16;
        [_filterButton setTitle:@"设置过滤参数" forState:UIControlStateNormal];
        _filterButton.titleLabel.textColor = [UIColor whiteColor];
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _filterButton.backgroundColor = COLOR(0x3385FF);
    }
    return _filterButton;
}

@end
