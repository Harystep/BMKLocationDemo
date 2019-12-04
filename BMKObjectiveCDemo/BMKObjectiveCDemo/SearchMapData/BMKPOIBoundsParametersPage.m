//
//  BMKPOIBoundsParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOIBoundsParametersPage.h"
#import "BMKPOIFilterParametersPage.h"

@interface BMKPOIBoundsParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *keywordsLabel;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UILabel *leftBottomLongitudeLabel;
@property (nonatomic, strong) UILabel *leftBottomLatitudeLabel;
@property (nonatomic, strong) UILabel *rightTopLongitudeLabel;
@property (nonatomic, strong) UILabel *rightTopLatitudeLabel;
@property (nonatomic, strong) UILabel *pageIndexLabel;
@property (nonatomic, strong) UILabel *pageSizeLabel;
@property (nonatomic, strong) UITextField *keywordsTextField;
@property (nonatomic, strong) UITextField *tagsTextField;
@property (nonatomic, strong) UITextField *leftBottomLongitudeTextField;
@property (nonatomic, strong) UITextField *leftBottomLatitudeTextField;
@property (nonatomic, strong) UITextField *rightTopLongitudeTextField;
@property (nonatomic, strong) UITextField *rightTopLatitudeTextField;
@property (nonatomic, strong) UITextField *pageIndexTextField;
@property (nonatomic, strong) UITextField *pageSizeTextField;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UISegmentedControl *scopeSegmentControl;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) BMKPOIBoundSearchOption *boundsOption; //POI矩形区域检索参数信息
@end

@implementation BMKPOIBoundsParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //实例化POI矩形区域检索参数信息类对象
        _boundsOption = [[BMKPOIBoundSearchOption alloc] init];
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
    [self.backgroundScrollView addSubview:self.leftBottomLongitudeLabel];
    [self.backgroundScrollView addSubview:self.leftBottomLatitudeLabel];
    [self.backgroundScrollView addSubview:self.rightTopLongitudeLabel];
    [self.backgroundScrollView addSubview:self.rightTopLatitudeLabel];
    [self.backgroundScrollView addSubview:self.pageIndexLabel];
    [self.backgroundScrollView addSubview:self.pageSizeLabel];
    [self.backgroundScrollView addSubview:self.keywordsTextField];
    [self.backgroundScrollView addSubview:self.tagsTextField];
    [self.backgroundScrollView addSubview:self.leftBottomLatitudeTextField];
    [self.backgroundScrollView addSubview:self.leftBottomLongitudeTextField];
    [self.backgroundScrollView addSubview:self.rightTopLatitudeTextField];
    [self.backgroundScrollView addSubview:self.rightTopLongitudeTextField];
    [self.backgroundScrollView addSubview:self.pageIndexTextField];
    [self.backgroundScrollView addSubview:self.pageSizeTextField];
    [self.backgroundScrollView addSubview:self.scopeSegmentControl];
    [self.backgroundScrollView addSubview:self.filterButton];
    [self.backgroundScrollView addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _keywordsTextField.delegate = self;
    _tagsTextField.delegate = self;
    _leftBottomLatitudeTextField.delegate = self;
    _leftBottomLongitudeTextField.delegate = self;
    _rightTopLatitudeTextField.delegate = self;
    _rightTopLongitudeTextField.delegate = self;
    _pageSizeTextField.delegate = self;
    _pageIndexTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_tagsTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 450);
        }];
    }
    if ([textField isEqual:_pageSizeTextField] || [textField isEqual:_pageIndexTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 540);
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
            _boundsOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
            break;
        default:
            //检索结果详细程度：详细信息
            _boundsOption.scope = BMK_POI_SCOPE_DETAIL_INFORMATION;
            break;
    }
}

- (void)clickSearchButton {
   [self.navigationController popViewControllerAnimated:YES];
   [self setupPOIBoundSearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(_boundsOption);
    }
}

- (void)clickFilterButton {
    BMKPOIFilterParametersPage *page = [[BMKPOIFilterParametersPage alloc] init];
    page.filterDataBlock = ^(BMKPOISearchFilter *filter) {
        //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
        _boundsOption.filter = filter;
    };
    page.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.navigationController pushViewController:page animated:YES];
}

- (void)setupPOIBoundSearchOption {
    /**
     检索关键字，必选。
     在矩形检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
     最多支持10个关键字。
     */
    _boundsOption.keywords = [_keywordsTextField.text componentsSeparatedByString:@","];
    //矩形检索区域的左下角经纬度坐标，必选
    _boundsOption.leftBottom = CLLocationCoordinate2DMake([_leftBottomLatitudeTextField.text floatValue], [_leftBottomLongitudeTextField.text floatValue]);
    //矩形检索区域的右上角经纬度坐标，必选
    _boundsOption.rightTop = CLLocationCoordinate2DMake([_rightTopLatitudeTextField.text floatValue], [_rightTopLongitudeTextField.text floatValue]);
    if ((_tagsTextField.text).length > 0) {
     _boundsOption.tags = [_tagsTextField.text componentsSeparatedByString:@","];
    }
    //单次召回POI数量，默认为10条记录，最大返回20条
    _boundsOption.pageSize = [_pageSizeTextField.text intValue];
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    _boundsOption.pageIndex = [_pageIndexTextField.text integerValue];
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 775 + 100);
    }
    return _backgroundScrollView;
}

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
        _tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 470, KScreenWidth - 20, 30)];
        _tagsLabel.text = @"分类";
        _tagsLabel.font = [UIFont systemFontOfSize:17];
    }
    return _tagsLabel;
}

- (UILabel *)leftBottomLatitudeLabel {
    if (!_leftBottomLatitudeLabel) {
        _leftBottomLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _leftBottomLatitudeLabel.text = @"左下角纬度（必选）";
        _leftBottomLatitudeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _leftBottomLatitudeLabel;
}

- (UILabel *)leftBottomLongitudeLabel {
    if (!_leftBottomLongitudeLabel) {
        _leftBottomLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _leftBottomLongitudeLabel.text = @"左下角经度（必选）";
        _leftBottomLongitudeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _leftBottomLongitudeLabel;
}

- (UILabel *)rightTopLatitudeLabel {
    if (!_rightTopLatitudeLabel) {
        _rightTopLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _rightTopLatitudeLabel.text = @"右上角纬度（必选）";
        _rightTopLatitudeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _rightTopLatitudeLabel;
}

- (UILabel *)rightTopLongitudeLabel {
    if (!_rightTopLongitudeLabel) {
        _rightTopLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _rightTopLongitudeLabel.text = @"右上角经度（必选）";
        _rightTopLongitudeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _rightTopLongitudeLabel;
}

- (UILabel *)pageSizeLabel {
    if (!_pageSizeLabel) {
        _pageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 650, KScreenWidth - 20, 30)];
        _pageSizeLabel.text = @"数量";
        _pageSizeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _pageSizeLabel;
}

- (UILabel *)pageIndexLabel {
    if (!_pageIndexLabel) {
        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 560, KScreenWidth - 20, 30)];
        _pageIndexLabel.text = @"分页";
        _pageIndexLabel.font = [UIFont systemFontOfSize:17];
    }
    return _pageIndexLabel;
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
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 505, KScreenWidth - 40, 35)];
        _tagsTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _tagsTextField;
}

- (UITextField *)leftBottomLongitudeTextField {
    if (!_leftBottomLongitudeTextField) {
        _leftBottomLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _leftBottomLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _leftBottomLongitudeTextField;
}

- (UITextField *)leftBottomLatitudeTextField {
    if (!_leftBottomLatitudeTextField) {
        _leftBottomLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _leftBottomLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _leftBottomLatitudeTextField;
}

- (UITextField *)rightTopLongitudeTextField {
    if (!_rightTopLongitudeTextField) {
        _rightTopLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _rightTopLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _rightTopLongitudeTextField;
}

- (UITextField *)rightTopLatitudeTextField {
    if (!_rightTopLatitudeTextField) {
        _rightTopLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _rightTopLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _rightTopLatitudeTextField;
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
        _pageIndexTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 595, KScreenWidth - 40, 35)];
        _pageIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageIndexTextField;
}

- (UISegmentedControl *)scopeSegmentControl {
    if (!_scopeSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"检索基本信息",@"检索详细信息", nil];
        _scopeSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _scopeSegmentControl.frame = CGRectMake(20, 740, KScreenWidth - 40, 35);
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
