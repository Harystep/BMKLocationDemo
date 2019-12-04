//
//  BMKMassTransitParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKMassTransitParametersPage.h"
#import "BMKMassTransitPolicyParametersPage.h"

@interface BMKMassTransitParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *fromCityNameLabel;
@property (nonatomic, strong) UILabel *fromCityIDLabel;
@property (nonatomic, strong) UILabel *fromLatitudeLabel;
@property (nonatomic, strong) UILabel *fromLongitudeLabel;
@property (nonatomic, strong) UILabel *fromNameLabel;
@property (nonatomic, strong) UILabel *toCityNameLabel;
@property (nonatomic, strong) UILabel *toCityIDLabel;
@property (nonatomic, strong) UILabel *toLatitudeLabel;
@property (nonatomic, strong) UILabel *toLongitudeLabel;
@property (nonatomic,strong) UILabel *toNameLabel;
@property (nonatomic, strong) UILabel *pageIndexLabel;
@property (nonatomic, strong) UILabel *pageSizeLabel;
@property (nonatomic, strong) UILabel *cityNameLabel;
@property (nonatomic, strong) UITextField *cityNameTextField;
@property (nonatomic, strong) UITextField *fromCityNameTextField;
@property (nonatomic, strong) UITextField *fromCityIDTextField;
@property (nonatomic, strong) UITextField *fromLatitudeTextField;
@property (nonatomic, strong) UITextField *fromLongitudeTextField;
@property (nonatomic, strong) UITextField *fromNameTextField;
@property (nonatomic, strong) UITextField *toCityNameTextField;
@property (nonatomic, strong) UITextField *toCityIDTextField;
@property (nonatomic, strong) UITextField *toLatitudeTextField;
@property (nonatomic, strong) UITextField *toLongitudeTextField;
@property (nonatomic, strong) UITextField *toNameTextField;
@property (nonatomic, strong) UITextField *pageIndexTextField;
@property (nonatomic, strong) UITextField *pageSizeTextField;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *massTransitpolicyButton;
@property (nonatomic, strong) BMKMassTransitRoutePlanOption *massTransitOption;
@end

@implementation BMKMassTransitParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化请求参数类BMKMassTransitRoutePlanOption的实例
        _massTransitOption = [[BMKMassTransitRoutePlanOption alloc] init];
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
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.fromCityNameLabel];
    [self.backgroundScrollView addSubview:self.fromCityIDLabel];
    [self.backgroundScrollView addSubview:self.fromLatitudeLabel];
    [self.backgroundScrollView addSubview:self.fromLongitudeLabel];
    [self.backgroundScrollView addSubview:self.toCityNameLabel];
    [self.backgroundScrollView addSubview:self.toCityIDLabel];
    [self.backgroundScrollView addSubview:self.toLatitudeLabel];
    [self.backgroundScrollView addSubview:self.toLongitudeLabel];
    [self.backgroundScrollView addSubview:self.pageSizeLabel];
    [self.backgroundScrollView addSubview:self.pageIndexLabel];
    [self.backgroundScrollView addSubview:self.fromCityNameTextField];
    [self.backgroundScrollView addSubview:self.fromCityIDTextField];
    [self.backgroundScrollView addSubview:self.fromLatitudeTextField];
    [self.backgroundScrollView addSubview:self.fromLongitudeTextField];
    [self.backgroundScrollView addSubview:self.toCityIDTextField];
    [self.backgroundScrollView addSubview:self.toCityNameTextField];
    [self.backgroundScrollView addSubview:self.toLatitudeTextField];
    [self.backgroundScrollView addSubview:self.toLongitudeTextField];
    [self.backgroundScrollView addSubview:self.pageIndexTextField];
    [self.backgroundScrollView addSubview:self.pageSizeTextField];
    [self.backgroundScrollView addSubview:self.fromNameLabel];
    [self.backgroundScrollView addSubview:self.toNameLabel];
    [self.backgroundScrollView addSubview:self.fromNameTextField];
    [self.backgroundScrollView addSubview:self.toNameTextField];
    [self.backgroundScrollView addSubview:self.cityNameLabel];
    [self.backgroundScrollView addSubview:self.cityNameTextField];
    [self.backgroundScrollView addSubview:self.searchButton];
    [self.backgroundScrollView addSubview:self.massTransitpolicyButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _fromCityIDTextField.delegate = self;
    _fromCityNameTextField.delegate = self;
    _fromLatitudeTextField.delegate = self;
    _fromLongitudeTextField.delegate = self;
    _toCityNameTextField.delegate = self;
    _toCityIDTextField.delegate = self;
    _toLatitudeTextField.delegate = self;
    _toLongitudeTextField.delegate = self;
    _fromNameTextField.delegate = self;
    _toNameTextField.delegate = self;
    _pageSizeTextField.delegate = self;
    _pageIndexTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        if ([textField isEqual:_toCityIDTextField] || [textField isEqual:_pageIndexTextField] || [textField isEqual:_pageSizeTextField]) {
            [UIView animateWithDuration:0.5 animations:^{
                _backgroundScrollView.contentOffset = CGPointMake(0, 630);
            }];
        }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    [self setupMassTransitRoutePlanOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(_massTransitOption);
    }
}

- (void)clickMassTransitpolicyButton {
    BMKMassTransitPolicyParametersPage *page = [[BMKMassTransitPolicyParametersPage alloc] init];
    page.policyDataBlock = ^(BMKMassTransitRoutePlanOption *option) {
        /*
         跨城公交换乘策略，默认使用BMK_MASS_TRANSIT_INTERCITY_TIME_FIRST
         BMK_MASS_TRANSIT_INTERCITY_TIME_FIRST：较快捷
         BMK_MASS_TRANSIT_INTERCITY_START_EARLY：出发早
         BMK_MASS_TRANSIT_INTERCITY_PRICE_FIRST：价格低
         */
        _massTransitOption.intercityPolicy = option.intercityPolicy;
        /*
         跨城交通方式策略，默认使用BMK_MASS_TRANSIT_INTERCITY_TRANS_TRAIN_FIRST
         BMK_MASS_TRANSIT_INTERCITY_TRANS_TRAIN_FIRST：火车优先
         BMK_MASS_TRANSIT_INTERCITY_TRANS_PLANE_FIRST：飞机优先
         BMK_MASS_TRANSIT_INTERCITY_TRANS_BUS_FIRST：大巴优先
         */
        _massTransitOption.intercityTransPolicy = option.intercityTransPolicy;
        /*
         市内公交换乘策略策略，默认使用BMK_MASS_TRANSIT_INCITY_RECOMMEND
         BMK_MASS_TRANSIT_INCITY_RECOMMEND：推荐
         BMK_MASS_TRANSIT_INCITY_TRANSFER_FIRST：少换乘
         BMK_MASS_TRANSIT_INCITY_WALK_FIRST：少步行
         BMK_MASS_TRANSIT_INCITY_NO_SUBWAY：不坐地铁
         BMK_MASS_TRANSIT_INCITY_TIME_FIRST：较快捷
         BMK_MASS_TRANSIT_INCITY_SUBWAY_FIRST：地铁优先
         */
        _massTransitOption.incityPolicy = option.incityPolicy;
    };
    page.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.navigationController pushViewController:page animated:YES];
}

- (void)setupMassTransitRoutePlanOption {
    BMKPlanNode *fromNode = [[BMKPlanNode alloc] init];
    //起点名称
    fromNode.name = _fromNameTextField.text;
    //起点所在城市，注：cityName和cityID同时指定时，优先使用cityID
    fromNode.cityName = _fromCityNameTextField.text;
    //起点所在城市ID，注：cityName和cityID同时指定时，优先使用cityID
    fromNode.cityID = [_fromCityIDTextField.text integerValue];
    //起点坐标
    fromNode.pt = CLLocationCoordinate2DMake([_fromLatitudeTextField.text floatValue], [_fromLongitudeTextField.text floatValue]);
    
    BMKPlanNode *toNode = [[BMKPlanNode alloc] init];
    //终点名称
    toNode.name = _toNameTextField.text;
    //终点所在城市，注：cityName和cityID同时指定时，优先使用cityID
    toNode.cityName = _toCityNameTextField.text;
    //终点所在城市ID，注：cityName和cityID同时指定时，优先使用cityID
    toNode.cityID = [_toCityIDTextField.text floatValue];
    //终点坐标
    toNode.pt = CLLocationCoordinate2DMake([_toLatitudeTextField.text floatValue], [_toLongitudeTextField.text floatValue]);
    //检索的起点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
    _massTransitOption.from = fromNode;
    //检索的终点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
    _massTransitOption.to = toNode;
    //分页索引，默认值为0，可选
    _massTransitOption.pageIndex = [_pageIndexTextField.text integerValue];
    //分页数量，默认值为10，取值范围[1,10]，可选
    _massTransitOption.pageCapacity = [_pageSizeTextField.text integerValue];
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 1080 + 100);
    }
    return _backgroundScrollView;
}

- (UILabel *)cityNameLabel {
    if (!_cityNameLabel) {
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _cityNameLabel.text = @"城市名称";
        _cityNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _cityNameLabel;
}

- (UITextField *)cityNameTextField {
    if (!_cityNameTextField) {
        _cityNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _cityNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _cityNameTextField;
}

- (UILabel *)fromNameLabel {
    if (!_fromNameLabel) {
        _fromNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _fromNameLabel.text = @"起点关键字（必选，关键字和坐标二选一）";
        _fromNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _fromNameLabel;
}

- (UILabel *)fromCityNameLabel {
    if (!_fromCityNameLabel) {
        _fromCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _fromCityNameLabel.font = [UIFont systemFontOfSize:17];
        _fromCityNameLabel.text = @"起点城市名称（必选）";
    }
    return _fromCityNameLabel;
}

- (UILabel *)fromLatitudeLabel {
    if (!_fromLatitudeLabel) {
        _fromLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _fromLatitudeLabel.font = [UIFont systemFontOfSize:17];
        _fromLatitudeLabel.text = @"起点纬度";
    }
    return _fromLatitudeLabel;
}

- (UILabel *)fromLongitudeLabel {
    if (!_fromLongitudeLabel) {
        _fromLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _fromLongitudeLabel.font = [UIFont systemFontOfSize:17];
        _fromLongitudeLabel.text = @"起点经度";
    }
    return _fromLongitudeLabel;
}

- (UILabel *)fromCityIDLabel {
    if (!_fromCityIDLabel) {
        _fromCityIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _fromCityIDLabel.font = [UIFont systemFontOfSize:17];
        _fromCityIDLabel.text = @"起点城市ID";
    }
    return _fromCityIDLabel;
}

- (UILabel *)toNameLabel {
    if (!_toNameLabel) {
        _toNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 470, KScreenWidth - 20, 30)];
        _toNameLabel.text = @"终点关键字（必选，关键字和坐标二选一）";
        _toNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _toNameLabel;
}

- (UILabel *)toCityNameLabel {
    if (!_toCityNameLabel) {
        _toCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 560, KScreenWidth - 20, 30)];
        _toCityNameLabel.font = [UIFont systemFontOfSize:17];
        _toCityNameLabel.text = @"终点城市名称";
    }
    return _toCityNameLabel;
}

- (UILabel *)toLatitudeLabel {
    if (!_toLatitudeLabel) {
        _toLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 650, KScreenWidth - 20, 30)];
        _toLatitudeLabel.font = [UIFont systemFontOfSize:17];
        _toLatitudeLabel.text = @"终点纬度";
    }
    return _toLatitudeLabel;
}

- (UILabel *)toLongitudeLabel {
    if (!_toLongitudeLabel) {
        _toLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 740, KScreenWidth - 20, 30)];
        _toLongitudeLabel.font = [UIFont systemFontOfSize:17];
        _toLongitudeLabel.text = @"终点经度";
    }
    return _toLongitudeLabel;
}

- (UILabel *)toCityIDLabel {
    if (!_toCityIDLabel) {
        _toCityIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 830, KScreenWidth - 20, 30)];
        _toCityIDLabel.font = [UIFont systemFontOfSize:17];
        _toCityIDLabel.text = @"终点城市ID";
    }
    return _toCityIDLabel;
}

- (UILabel *)pageIndexLabel {
    if (!_pageIndexLabel) {
        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 920, KScreenWidth - 20, 30)];
        _pageIndexLabel.font = [UIFont systemFontOfSize:17];
        _pageIndexLabel.text = @"分页";
    }
    return _pageIndexLabel;
}

- (UILabel *)pageSizeLabel {
    if (!_pageSizeLabel) {
        _pageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 1010, KScreenWidth - 20, 30)];
        _pageSizeLabel.font = [UIFont systemFontOfSize:17];
        _pageSizeLabel.text = @"召回数量";
    }
    return _pageSizeLabel;
}

- (UITextField *)fromNameTextField {
    if (!_fromNameTextField) {
        _fromNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _fromNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromNameTextField;
}

- (UITextField *)fromCityNameTextField {
    if (!_fromCityNameTextField) {
        _fromCityNameTextField  = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _fromCityNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromCityNameTextField;
}

- (UITextField *)fromLatitudeTextField {
    if (!_fromLatitudeTextField) {
        _fromLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _fromLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromLatitudeTextField;
}

- (UITextField *)fromLongitudeTextField {
    if (!_fromLongitudeTextField) {
        _fromLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _fromLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromLongitudeTextField;
}

- (UITextField *)fromCityIDTextField {
    if (!_fromCityIDTextField) {
        _fromCityIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _fromCityIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromCityIDTextField;
}

- (UITextField *)toNameTextField {
    if (!_toNameTextField) {
        _toNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 505, KScreenWidth - 40, 35)];
        _toNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toNameTextField;
}

- (UITextField *)toCityNameTextField {
    if (!_toCityNameTextField) {
        _toCityNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 595, KScreenWidth - 40, 35)];
        _toCityNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toCityNameTextField;
}

- (UITextField *)toLatitudeTextField {
    if (!_toLatitudeTextField) {
        _toLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 685, KScreenWidth - 40, 35)];
        _toLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toLatitudeTextField;
}

- (UITextField *)toLongitudeTextField {
    if (!_toLongitudeTextField) {
        _toLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 775, KScreenWidth - 40, 35)];
        _toLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toLongitudeTextField;
}

- (UITextField *)toCityIDTextField {
    if (!_toCityIDTextField) {
        _toCityIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 865, KScreenWidth - 40, 35)];
        _toCityIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toCityIDTextField;
}

- (UITextField *)pageIndexTextField {
    if (!_pageIndexTextField) {
        _pageIndexTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 955, KScreenWidth - 40, 35)];
        _pageIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageIndexTextField;
}

- (UITextField *)pageSizeTextField {
    if (!_pageSizeTextField) {
        _pageSizeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 1045, KScreenWidth - 40, 35)];
        _pageSizeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _pageSizeTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(197 * widthScale, 1100, 159 * widthScale, 35)];
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

- (UIButton *)massTransitpolicyButton {
    if (!_massTransitpolicyButton) {
        _massTransitpolicyButton = [[UIButton alloc] initWithFrame:CGRectMake(19 * widthScale, 1100, 159 * widthScale, 35)];
        [_massTransitpolicyButton addTarget:self action:@selector(clickMassTransitpolicyButton) forControlEvents:UIControlEventTouchUpInside];
        _massTransitpolicyButton.clipsToBounds = YES;
        _massTransitpolicyButton.layer.cornerRadius = 16;
        [_massTransitpolicyButton setTitle:@"设置驾车策略参数" forState:UIControlStateNormal];
        _massTransitpolicyButton.titleLabel.textColor = [UIColor whiteColor];
        _massTransitpolicyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _massTransitpolicyButton.backgroundColor = COLOR(0x3385FF);
    }
    return _massTransitpolicyButton;
}

@end

