//
//  BMKIndoorRouteParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKIndoorRouteParametersPage.h"

@interface BMKIndoorRouteParametersPage ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *fromFloorLabel;
@property (nonatomic, strong) UILabel *fromLatitudeLabel;
@property (nonatomic, strong) UILabel *fromLongitudeLabel;
@property (nonatomic, strong) UILabel *toFloorLabel;
@property (nonatomic, strong) UILabel *toLatitudeLabel;
@property (nonatomic, strong) UILabel *toLongitudeLabel;
@property (nonatomic, strong) UITextField *fromFloorTextField;
@property (nonatomic, strong) UITextField *fromLatitudeTextField;
@property (nonatomic, strong) UITextField *fromLongitudeTextField;
@property (nonatomic, strong) UITextField *toFloorTextField;
@property (nonatomic, strong) UITextField *toLatitudeTextField;
@property (nonatomic, strong) UITextField *toLongitudeTextField;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation BMKIndoorRouteParametersPage

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
    [self.backgroundScrollView addSubview:self.fromFloorLabel];
    [self.backgroundScrollView addSubview:self.fromLatitudeLabel];
    [self.backgroundScrollView addSubview:self.fromLongitudeLabel];
    [self.backgroundScrollView addSubview:self.toFloorLabel];
    [self.backgroundScrollView addSubview:self.toLongitudeLabel];
    [self.backgroundScrollView addSubview:self.toLatitudeLabel];
    [self.backgroundScrollView addSubview:self.fromFloorTextField];
    [self.backgroundScrollView addSubview:self.fromLatitudeTextField];
    [self.backgroundScrollView addSubview:self.fromLongitudeTextField];
    [self.backgroundScrollView addSubview:self.toFloorTextField];
    [self.backgroundScrollView addSubview:self.toLatitudeTextField];
    [self.backgroundScrollView addSubview:self.toLongitudeTextField];
    [self.backgroundScrollView addSubview:self.searchButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _fromFloorTextField.delegate = self;
    _fromLatitudeTextField.delegate = self;
    _fromLongitudeTextField.delegate = self;
    _toFloorTextField.delegate = self;
    _toLongitudeTextField.delegate = self;
    _toLatitudeTextField.delegate = self;
    _backgroundScrollView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        if ([textField isEqual:_toFloorTextField] || [textField isEqual:_toLatitudeTextField] || [textField isEqual:_toLongitudeTextField]) {
            [UIView animateWithDuration:0.5 animations:^{
                _backgroundScrollView.contentOffset = CGPointMake(0, 270);
            }];
        }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    BMKIndoorRoutePlanOption *indoorRoutePlanOption = [self setupIndoorRoutePlanOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(indoorRoutePlanOption);
    }
}

- (BMKIndoorRoutePlanOption *)setupIndoorRoutePlanOption {
    BMKIndoorPlanNode *fromNode = [[BMKIndoorPlanNode alloc] init];
    //起点所在楼层
    fromNode.floor = _fromFloorTextField.text;
    //起点坐标
    fromNode.pt = CLLocationCoordinate2DMake([_fromLatitudeTextField.text floatValue], [_fromLongitudeTextField.text floatValue]);
   
    BMKIndoorPlanNode *toNode = [[BMKIndoorPlanNode alloc] init];
    //终点所在楼层
    toNode.floor = _toFloorTextField.text;
    //终点坐标
    toNode.pt = CLLocationCoordinate2DMake([_toLatitudeTextField.text floatValue], [_toLongitudeTextField.text floatValue]);
    
    BMKIndoorRoutePlanOption *indoorRoutePlanOption = [[BMKIndoorRoutePlanOption alloc] init];
    //检索的起点
    indoorRoutePlanOption.from = fromNode;
    //检索的终点
    indoorRoutePlanOption.to = toNode;
    return indoorRoutePlanOption;
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 540 + 100);
    }
    return _backgroundScrollView;
}

- (UILabel *)fromFloorLabel {
    if (!_fromFloorLabel) {
        _fromFloorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _fromFloorLabel.font = [UIFont systemFontOfSize:17];
        _fromFloorLabel.text = @"起点楼层（必选）";
    }
    return _fromFloorLabel;
}

- (UILabel *)fromLatitudeLabel {
    if (!_fromLatitudeLabel) {
        _fromLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _fromLatitudeLabel.font = [UIFont systemFontOfSize:17];
        _fromLatitudeLabel.text = @"起点纬度（必选）";
    }
    return _fromLatitudeLabel;
}

- (UILabel *)fromLongitudeLabel {
    if (!_fromLongitudeLabel) {
        _fromLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _fromLongitudeLabel.font = [UIFont systemFontOfSize:17];
        _fromLongitudeLabel.text = @"起点经度（必选）";
    }
    return _fromLongitudeLabel;
}

- (UILabel *)toFloorLabel {
    if (!_toFloorLabel) {
        _toFloorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _toFloorLabel.font = [UIFont systemFontOfSize:17];
        _toFloorLabel.text = @"终点楼层（必选）";
    }
    return _toFloorLabel;
}

- (UILabel *)toLatitudeLabel {
    if (!_toLatitudeLabel) {
        _toLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _toLatitudeLabel.font = [UIFont systemFontOfSize:17];
        _toLatitudeLabel.text = @"终点纬度（必选）";
    }
    return _toLatitudeLabel;
}

- (UILabel *)toLongitudeLabel {
    if (!_toLongitudeLabel) {
        _toLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 470, KScreenWidth - 20, 30)];
        _toLongitudeLabel.font = [UIFont systemFontOfSize:17];
        _toLongitudeLabel.text = @"终点经度（必选）";
    }
    return _toLongitudeLabel;
}

- (UITextField *)fromFloorTextField {
    if (!_fromFloorTextField) {
        _fromFloorTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _fromFloorTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromFloorTextField;
}

- (UITextField *)fromLatitudeTextField {
    if (!_fromLatitudeTextField) {
        _fromLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _fromLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromLatitudeTextField;
}

- (UITextField *)fromLongitudeTextField {
    if (!_fromLongitudeTextField) {
        _fromLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _fromLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromLongitudeTextField;
}

- (UITextField *)toFloorTextField {
    if (!_toFloorTextField) {
        _toFloorTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _toFloorTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toFloorTextField;
}

- (UITextField *)toLatitudeTextField {
    if (!_toLatitudeTextField) {
        _toLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _toLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toLatitudeTextField;
}

- (UITextField *)toLongitudeTextField {
    if (!_toLongitudeTextField) {
        _toLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 505, KScreenWidth - 40, 35)];
        _toLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toLongitudeTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 570, 160, 35)];
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
