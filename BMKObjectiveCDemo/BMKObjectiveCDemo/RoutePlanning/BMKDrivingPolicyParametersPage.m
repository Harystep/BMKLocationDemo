//
//  BMKDrivingPolicyParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/16.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKDrivingPolicyParametersPage.h"

@interface BMKDrivingPolicyParametersPage ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UISegmentedControl *trafficSegmentControl;
@property (nonatomic, strong) UIPickerView *policyPickerView;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, copy) NSArray *drivingPolicyData;
@property (nonatomic, strong) BMKDrivingRoutePlanOption *drivingOption;
@end

@implementation BMKDrivingPolicyParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化请求参数类BMKDrivingRoutePlanOption的实例
        _drivingOption = [[BMKDrivingRoutePlanOption alloc] init];
        /*
         驾车策略，默认使用BMK_DRIVING_TIME_FIRST
         BMK_DRIVING_BLK_FIRST：躲避拥堵
         BMK_DRIVING_TIME_FIRST：最短时间
         BMK_DRIVING_DIS_FIRST：最短路程
         BMK_DRIVING_FEE_FIRST：少走高速
         */
        _drivingOption.drivingPolicy = BMK_DRIVING_TIME_FIRST;
        /*
         路线中每一个step的路况，默认使用BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE
         BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE：不带路况
         BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE：道路和路况
         */
        _drivingOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;
        _drivingPolicyData = [NSArray arrayWithObjects:@"躲避拥堵", @"最短时间", @"最短路程", @"少走高速", nil];
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setupPickerDelegate];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"驾车策略";
    [self.view addSubview:self.trafficSegmentControl];
    [self.view addSubview:self.policyPickerView];
    [self.view addSubview:self.finishButton];
}

- (void)setupPickerDelegate {
    _policyPickerView.delegate = self;
    _policyPickerView.dataSource = self;
}

#pragma mark - Responding events
- (void)trafficSegmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_trafficSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            //不带路况
             _drivingOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;
            break;
        default:
            //道路和路况
             _drivingOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;
            break;
    }
}

- (void)clickFinishButton {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.policyDataBlock) {
        self.policyDataBlock(_drivingOption);
    }
}

#pragma mark - UIPickerViewDataSource && UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _drivingPolicyData.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _drivingOption.drivingPolicy = (BMKDrivingPolicy)(row - 1);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200 * heightScale)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [dataLabel setFont:[UIFont systemFontOfSize:20]];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.text = _drivingPolicyData[row];
    return dataLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _drivingPolicyData[row];
}

#pragma mark - Lazy loading
- (UISegmentedControl *)trafficSegmentControl {
    if (!_trafficSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"不带路况", @"道路和路况", nil];
        _trafficSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _trafficSegmentControl.frame = CGRectMake(10 * widthScale, 12.5, 355 * widthScale, 35);
        [_trafficSegmentControl setTitle:@"不带路况" forSegmentAtIndex:0];
        [_trafficSegmentControl setTitle:@"道路和路况" forSegmentAtIndex:1];
        _trafficSegmentControl.selectedSegmentIndex = 0;
        [_trafficSegmentControl addTarget:self action:@selector(trafficSegmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _trafficSegmentControl;
}

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
