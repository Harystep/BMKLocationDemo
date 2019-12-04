//
//  BMKPOIDetailParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOIDetailParametersPage.h"

@interface BMKPOIDetailParametersPage ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *POIUIDsLabel;
@property (nonatomic, strong) UITextField *POIUIDsTextField;
@property (nonatomic, strong) UISegmentedControl *scopeSegmentControl;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, assign) BMKPOISearchScopeType scopeType; //检索结果详细程度
@end

@implementation BMKPOIDetailParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //POI检索结果详细程度：基本信息
        _scopeType = BMK_POI_SCOPE_BASIC_INFORMATION;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"自定义参数";
    [self.view addSubview:self.POIUIDsLabel];
    [self.view addSubview:self.POIUIDsTextField];
    [self.view addSubview:self.searchButton];
    [self.view addSubview:self.scopeSegmentControl];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _POIUIDsTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
   [self.navigationController popViewControllerAnimated:YES];
    BMKPOIDetailSearchOption *POIDetailSearchOption = [self setupPOIDetailSearchOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(POIDetailSearchOption);
    }
}

- (BMKPOIDetailSearchOption *)setupPOIDetailSearchOption {
    //初始化请求参数类BMKPoiDetailSearchOption的实例
    BMKPOIDetailSearchOption *POIDetailSearchOption = [[BMKPOIDetailSearchOption alloc] init];
    //POI的唯一标识符集合，必选
    POIDetailSearchOption.poiUIDs = [_POIUIDsTextField.text componentsSeparatedByString:@","];
    /**
     POI检索结果详细程度
     
     BMK_POI_SCOPE_BASIC_INFORMATION: 基本信息
     BMK_POI_SCOPE_DETAIL_INFORMATION: 详细信息
     */
    POIDetailSearchOption.scope = _scopeType;
    return POIDetailSearchOption;
}

- (void)segmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_scopeSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            //检索结果详细程度：基本信息
            _scopeType = BMK_POI_SCOPE_BASIC_INFORMATION;
            break;
        default:
            //检索结果详细程度：详细信息
            _scopeType = BMK_POI_SCOPE_DETAIL_INFORMATION;
            break;
    }
}

#pragma mark - Lazy loading
- (UILabel*)POIUIDsLabel {
    if (!_POIUIDsLabel) {
        _POIUIDsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _POIUIDsLabel.text = @"POI的UID（必选，多个用英文逗号隔开）";
    }
    return _POIUIDsLabel;
}

- (UISegmentedControl *)scopeSegmentControl {
    if (!_scopeSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"检索基本信息",@"检索详细信息", nil];
        _scopeSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _scopeSegmentControl.frame = CGRectMake(20, 110, KScreenWidth - 40, 35);
        [_scopeSegmentControl setTitle:@"检索基本信息" forSegmentAtIndex:0];
        [_scopeSegmentControl setTitle:@"检索详细信息" forSegmentAtIndex:1];
        _scopeSegmentControl.selectedSegmentIndex = 0;
        [_scopeSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _scopeSegmentControl;
}

- (UITextField *)POIUIDsTextField {
    if (!_POIUIDsTextField) {
        _POIUIDsTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _POIUIDsTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _POIUIDsTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 175, 160, 35)];
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
