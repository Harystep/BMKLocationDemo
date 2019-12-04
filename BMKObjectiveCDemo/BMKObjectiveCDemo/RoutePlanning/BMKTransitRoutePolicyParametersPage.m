//
//  BMKTransitRoutePolicyParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/16.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKTransitRoutePolicyParametersPage.h"

@interface BMKTransitRoutePolicyParametersPage ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *policyPickerView;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, copy) NSArray *transitPolicyData;
@property (nonatomic, strong) BMKTransitRoutePlanOption *transitOption;
@end

@implementation BMKTransitRoutePolicyParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化请求参数类BMKTransitRoutePlanOption的实例
        _transitOption = [[BMKTransitRoutePlanOption alloc] init];
        /*
         公交检索策略，默认使用BMK_TRANSIT_TIME_FIRST
         BMK_TRANSIT_TIME_FIRST：较快捷(公交)
         BMK_TRANSIT_TRANSFER_FIRST：换乘(公交)
         BMK_TRANSIT_WALK_FIRST：少步行(公交)
         BMK_TRANSIT_NO_SUBWAY：不坐地铁
         */
        _transitOption.transitPolicy = BMK_TRANSIT_TIME_FIRST;
        _transitPolicyData = [NSArray arrayWithObjects:@"较快捷", @"少换乘", @"少步行", @"不坐地铁", nil];
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setupPickerViewDelegate];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"市内公交策略";
    [self.view addSubview:self.policyPickerView];
    [self.view addSubview:self.finishButton];
}

- (void)setupPickerViewDelegate {
    _policyPickerView.delegate = self;
}

#pragma mark - Responding events
- (void)clickFinishButton {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.policyDataBlock) {
        self.policyDataBlock(_transitOption);
    }
}

#pragma mark - UIPickerViewDataSource && UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _transitPolicyData.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _transitOption.transitPolicy = (BMKTransitPolicy)(row + 3);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200 * heightScale)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [dataLabel setFont:[UIFont systemFontOfSize:20]];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.text = _transitPolicyData[row];
    return dataLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _transitPolicyData[row];
}

#pragma mark - Lazy loading
- (UIPickerView *)policyPickerView {
    if (!_policyPickerView) {
        _policyPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, 120)];
        [_policyPickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _policyPickerView;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 230, 160, 35)];
        [_finishButton addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.clipsToBounds = YES;
        _finishButton.layer.cornerRadius = 16;
        [_finishButton setTitle:@"OK" forState:UIControlStateNormal];
        _finishButton.titleLabel.textColor = [UIColor whiteColor];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _finishButton.backgroundColor = COLOR(0x3385FF);
    }
    return _finishButton;
}

@end
