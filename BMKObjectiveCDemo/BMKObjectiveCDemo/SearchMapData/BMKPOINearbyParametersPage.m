//
//  BMKPOINearbyParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOINearbyParametersPage.h"
#import "BMKPOIFilterParametersPage.h"

@interface BMKPOINearbyParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *keywordsLabel;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UILabel *longitudeLabel;
@property (nonatomic, strong) UILabel *latitudeLabel;
@property (nonatomic, strong) UILabel *radiusLabel;
@property (nonatomic, strong) UILabel *pageIndexLabel;
@property (nonatomic, strong) UILabel *pageSizeLabel;
@property (nonatomic, strong) UITextField *keywordsTextField;
@property (nonatomic, strong) UITextField *tagsTextField;
@property (nonatomic, strong) UITextField *longitudeTextField;
@property (nonatomic, strong) UITextField *latitudeTextField;
@property (nonatomic, strong) UITextField *radiusTextField;
@property (nonatomic, strong) UITextField *pageIndexTextField;
@property (nonatomic, strong) UITextField *pageSizeTextField;
@property (nonatomic, strong) UISegmentedControl *scopeSegmentControl;
@property (nonatomic, strong) UILabel *isRadiusLimitLabel;
@property (nonatomic, strong) UISwitch *isRadiusLimitSwitch;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) BMKPOINearbySearchOption *nearbyOption; //POI周边检索参数信息
@end

@implementation BMKPOINearbyParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //实例化POI周边检索参数信息类对象
        _nearbyOption = [[BMKPOINearbySearchOption alloc] init];
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
    [self.backgroundScrollView addSubview:self.keywordsLabel];
    [self.backgroundScrollView addSubview:self.tagsLabel];
    [self.backgroundScrollView addSubview:self.longitudeLabel];
    [self.backgroundScrollView addSubview:self.latitudeLabel];
    [self.backgroundScrollView addSubview:self.radiusLabel];
    [self.backgroundScrollView addSubview:self.pageIndexLabel];
    [self.backgroundScrollView addSubview:self.pageSizeLabel];
    [self.backgroundScrollView addSubview:self.keywordsTextField];
    [self.backgroundScrollView addSubview:self.tagsTextField];
    [self.backgroundScrollView addSubview:self.longitudeTextField];
    [self.backgroundScrollView addSubview:self.latitudeTextField];
    [self.backgroundScrollView addSubview:self.radiusTextField];
    [self.backgroundScrollView addSubview:self.pageSizeTextField];
    [self.backgroundScrollView addSubview:self.pageIndexTextField];
    [self.backgroundScrollView addSubview:self.scopeSegmentControl];
    [self.backgroundScrollView addSubview:self.isRadiusLimitLabel];
    [self.backgroundScrollView addSubview:self.isRadiusLimitSwitch];
    [self.backgroundScrollView addSubview:self.searchButton];
    [self.backgroundScrollView addSubview:self.filterButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _keywordsTextField.delegate = self;
    _tagsTextField.delegate = self;
    _longitudeTextField.delegate = self;
    _latitudeTextField.delegate = self;
    _radiusTextField.delegate = self;
    _pageIndexTextField.delegate = self;
    _pageSizeTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_longitudeTextField] || [textField isEqual:_pageIndexTextField] || [textField isEqual:_pageSizeTextField]) {
        [UIView animateWithDuration:0.4 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 450);
        }];
    }
}

#pragma mark - Responding events
- (void)isRadiusLimiSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        /**
         是否严格限定召回结果在设置检索半径范围内。默认值为false。
         值为true代表检索结果严格限定在半径范围内；值为false时不严格限定。
         注意：值为true时会影响返回结果中total准确性及每页召回poi数量，我们会逐步解决此类问题。
         */
        _nearbyOption.isRadiusLimit = YES;
    } else {
        _nearbyOption.isRadiusLimit = NO;
    }
}

- (void)segmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_scopeSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            //检索结果详细程度：基本信息
            _nearbyOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
            break;
        default:
            //检索结果详细程度：详细信息
            _nearbyOption.scope = BMK_POI_SCOPE_DETAIL_INFORMATION;
            break;
    }
}

- (void)clickSearchButton {
   [self.navigationController popViewControllerAnimated:YES];
   [self setupPOINearbySearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(_nearbyOption);
    }
}

- (void)clickFilterButton {
    BMKPOIFilterParametersPage *page = [[BMKPOIFilterParametersPage alloc] init];
    page.filterDataBlock = ^(BMKPOISearchFilter *filter) {
        //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
        _nearbyOption.filter = filter;
    };
    page.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.navigationController pushViewController:page animated:YES];
}

- (void)setupPOINearbySearchOption {
    /**
     检索关键字，必选。
     在周边检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
     最多支持10个关键字。
     */
    _nearbyOption.keywords = [_keywordsTextField.text componentsSeparatedByString:@","];
    //检索中心点的经纬度，必选
    _nearbyOption.location = CLLocationCoordinate2DMake([_latitudeTextField.text floatValue], [_longitudeTextField.text floatValue]);
    /**
     检索分类，可选。
     该字段与keywords字段组合进行检索。
     支持多个分类，如美食和酒店。每个分类对应数组中一个元素
     */
    if ((_tagsTextField.text).length > 0) {
        _nearbyOption.tags = [_tagsTextField.text componentsSeparatedByString:@","];
    }
    /**
     检索半径，单位是米。
     当半径过大，超过中心点所在城市边界时，会变为城市范围检索，检索范围为中心点所在城市
     */
    _nearbyOption.radius = [_radiusTextField.text floatValue];
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    _nearbyOption.pageIndex = [_pageIndexTextField.text integerValue];
    //单次召回POI数量，默认为10条记录，最大返回20条
    _nearbyOption.pageSize =  [_pageSizeTextField.text intValue];
}

#pragma mark - Lazy loading
- (UILabel *)keywordsLabel {
    if (!_keywordsLabel) {
        _keywordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _keywordsLabel.text = @"关键字（必选）";
        _keywordsLabel.font = [UIFont systemFontOfSize:17];
    }
    return _keywordsLabel;
}

- (UILabel *)tagsLabel {
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _tagsLabel.text = @"分类";
        _tagsLabel.font = [UIFont systemFontOfSize:17];
    }
    return _tagsLabel;
}

- (UILabel *)latitudeLabel {
    if (!_latitudeLabel) {
        _latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _latitudeLabel.text = @"纬度坐标（必选）";
        _latitudeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _latitudeLabel;
}

- (UILabel *)longitudeLabel {
    if (!_longitudeLabel) {
        _longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _longitudeLabel.text = @"经度坐标（必选）";
        _longitudeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _longitudeLabel;
}

- (UILabel *)radiusLabel {
    if (!_radiusLabel) {
        _radiusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _radiusLabel.text = @"半径";
        _radiusLabel.font = [UIFont systemFontOfSize:17];
    }
    return _radiusLabel;
}

- (UILabel *)pageIndexLabel {
    if (!_pageIndexLabel) {
        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 470, KScreenWidth - 20, 30)];
        _pageIndexLabel.text = @"分页";
        _pageIndexLabel.font = [UIFont systemFontOfSize:17];
    }
    return _pageIndexLabel;
}

- (UILabel *)pageSizeLabel {
    if (!_pageSizeLabel) {
        _pageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 560, KScreenWidth - 20, 30)];
        _pageSizeLabel.text = @"数量";
        _pageSizeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _pageSizeLabel;
}

- (UILabel *)isRadiusLimitLabel {
    if (!_isRadiusLimitLabel) {
        _isRadiusLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 705, KScreenWidth - 20, 30)];
        _isRadiusLimitLabel.text = @"是否严格限定召回结果在设置检索半径范围内";
        _isRadiusLimitLabel.font = [UIFont systemFontOfSize:17];
    }
    return _isRadiusLimitLabel;
}

- (UITextField *)keywordsTextField {
    if (!_keywordsTextField) {
        _keywordsTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _keywordsTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _keywordsTextField;
}

- (UITextField *)tagsTextField {
    if (!_tagsTextField) {
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _tagsTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _tagsTextField;
}

- (UITextField *)longitudeTextField {
    if (!_longitudeTextField) {
        _longitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _longitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _longitudeTextField;
}

- (UITextField *)latitudeTextField {
    if (!_latitudeTextField) {
        _latitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _latitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _latitudeTextField;
}

- (UITextField *)radiusTextField {
    if (!_radiusTextField) {
        _radiusTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _radiusTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _radiusTextField;
}

- (UITextField *)pageSizeTextField {
    if (!_pageSizeTextField) {
        _pageSizeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 595, KScreenWidth - 40, 35)];
        _pageSizeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageSizeTextField;
}

- (UITextField *)pageIndexTextField {
    if (!_pageIndexTextField) {
        _pageIndexTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 505, KScreenWidth - 40, 35)];
        _pageIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageIndexTextField;
}

- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 775 + 100);
    }
    return _backgroundScrollView;
}

- (UISwitch *)isRadiusLimitSwitch {
    if (!_isRadiusLimitSwitch) {
       _isRadiusLimitSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 740, 120, 35)];
        [_isRadiusLimitSwitch addTarget:self action:@selector(isRadiusLimiSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _isRadiusLimitSwitch;
}

- (UISegmentedControl *)scopeSegmentControl {
    if (!_scopeSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"检索基本信息",@"检索详细信息", nil];
        _scopeSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _scopeSegmentControl.frame = CGRectMake(20, 650, KScreenWidth - 40, 35);
        [_scopeSegmentControl setTitle:@"检索基本信息" forSegmentAtIndex:0];
        [_scopeSegmentControl setTitle:@"检索详细信息" forSegmentAtIndex:1];
        _scopeSegmentControl.selectedSegmentIndex = 0;
        [_scopeSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _scopeSegmentControl;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(197 * widthScale, 805, 159 * widthScale, 35)];
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
        _filterButton = [[UIButton alloc] initWithFrame:CGRectMake(19 * widthScale, 805, 159 * widthScale, 35)];
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
