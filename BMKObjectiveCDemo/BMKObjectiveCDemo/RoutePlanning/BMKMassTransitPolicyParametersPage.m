//
//  BMKMassTransitPolicyParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/16.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKMassTransitPolicyParametersPage.h"

@interface BMKMassTransitPolicyParametersPage ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *incityPolicyPickerView;
@property (nonatomic, strong) UIPickerView *intercityPolicyPickerView;
@property (nonatomic, strong) UIPickerView *intercityTransPolicyPickerView;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, copy) NSArray *incityPolicyData;
@property (nonatomic, copy) NSArray *intercityPolicyData;
@property (nonatomic, copy) NSArray *intercityTransPolicyData;
@property (nonatomic, strong) BMKMassTransitRoutePlanOption *massTransitOption;
@end

@implementation BMKMassTransitPolicyParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化公共交通路线查询基础信息类的实例
        _massTransitOption = [[BMKMassTransitRoutePlanOption alloc] init];
        /*
         市内公交换乘策略策略，默认使用BMK_MASS_TRANSIT_INCITY_RECOMMEND
         BMK_MASS_TRANSIT_INCITY_RECOMMEND：推荐
         BMK_MASS_TRANSIT_INCITY_TRANSFER_FIRST：少换乘
         BMK_MASS_TRANSIT_INCITY_WALK_FIRST：少步行
         BMK_MASS_TRANSIT_INCITY_NO_SUBWAY：不坐地铁
         BMK_MASS_TRANSIT_INCITY_TIME_FIRST：较快捷
         BMK_MASS_TRANSIT_INCITY_SUBWAY_FIRST：地铁优先
         */
        _massTransitOption.incityPolicy = BMK_MASS_TRANSIT_INCITY_RECOMMEND;
        /*
         跨城公交换乘策略，默认使用BMK_MASS_TRANSIT_INTERCITY_TIME_FIRST
         BMK_MASS_TRANSIT_INTERCITY_TIME_FIRST：较快捷
         BMK_MASS_TRANSIT_INTERCITY_START_EARLY：出发早
         BMK_MASS_TRANSIT_INTERCITY_PRICE_FIRST：价格低
         */
        _massTransitOption.intercityPolicy = BMK_MASS_TRANSIT_INTERCITY_TIME_FIRST;
        /*
         跨城交通方式策略，默认使用BMK_MASS_TRANSIT_INTERCITY_TRANS_TRAIN_FIRST
         BMK_MASS_TRANSIT_INTERCITY_TRANS_TRAIN_FIRST：火车优先
         BMK_MASS_TRANSIT_INTERCITY_TRANS_PLANE_FIRST：飞机优先
         BMK_MASS_TRANSIT_INTERCITY_TRANS_BUS_FIRST：大巴优先
         */
        _massTransitOption.intercityTransPolicy = BMK_MASS_TRANSIT_INTERCITY_TRANS_TRAIN_FIRST;
        _incityPolicyData = [NSArray arrayWithObjects:@"推荐", @"少换乘", @"少步行", @"不坐地铁", @"较快捷", @"地铁优先", nil];
        _intercityPolicyData = [NSArray arrayWithObjects:@"较快捷", @"出发早", @"价格低", nil];
        _intercityTransPolicyData = [NSArray arrayWithObjects:@"火车优先", @"飞机优先", @"大巴优先", nil];
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
    self.title = @"跨城公交策略";
    [self.view addSubview:self.incityPolicyPickerView];
    [self.view addSubview:self.intercityPolicyPickerView];
    [self.view addSubview:self.intercityTransPolicyPickerView];
    [self.view addSubview:self.finishButton];
}

- (void)setupPickerViewDelegate {
    _incityPolicyPickerView.delegate = self;
    _intercityPolicyPickerView.delegate = self;
    _intercityTransPolicyPickerView.delegate = self;
}

#pragma mark - Responding events
- (void)clickFinishButton {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.policyDataBlock) {
        self.policyDataBlock(_massTransitOption);
    };
}

#pragma mark - UIPickerViewDataSource && UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:_incityPolicyPickerView]) {
        return _incityPolicyData.count;
    } else if ([pickerView isEqual:_intercityPolicyPickerView]) {
        return _intercityPolicyData.count;
    } else {
        return _intercityTransPolicyData.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:_incityPolicyPickerView]) {
        //市内公交换乘策略策略
       _massTransitOption.incityPolicy = (BMKMassTransitIncityPolicy)row;
    } else if ([pickerView isEqual:_intercityPolicyPickerView]) {
        //跨城公交换乘策略
        _massTransitOption.intercityPolicy = (BMKMassTransitIntercityPolicy)row;
    } else {
        //跨城交通方式策略
        _massTransitOption.intercityTransPolicy = (BMKMassTransitIntercityTransPolicy)row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200 * heightScale)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [dataLabel setFont:[UIFont systemFontOfSize:20]];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([pickerView isEqual:_incityPolicyPickerView]) {
        dataLabel.text = _incityPolicyData[row];
    } else if ([pickerView isEqual:_intercityPolicyPickerView]) {
        dataLabel.text = _intercityPolicyData[row];
    } else {
        dataLabel.text = _intercityTransPolicyData[row];
    }
    return dataLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:_incityPolicyPickerView]) {
        return _incityPolicyData[row];
    } else if ([pickerView isEqual:_intercityPolicyData]) {
        return _intercityPolicyData[row];
    } else {
        return _intercityTransPolicyData[row];
    }
}

#pragma mark - Lazy loading
- (UIPickerView *)incityPolicyPickerView {
    if (!_incityPolicyPickerView) {
        _incityPolicyPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, 120)];
        [_incityPolicyPickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _incityPolicyPickerView;
}

- (UIPickerView *)intercityPolicyPickerView {
    if (!_intercityPolicyPickerView) {
        _intercityPolicyPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 230, KScreenWidth, 120)];
        [_intercityPolicyPickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _intercityPolicyPickerView;
}

- (UIPickerView *)intercityTransPolicyPickerView {
    if (!_intercityTransPolicyPickerView) {
        _intercityTransPolicyPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 380, KScreenWidth, 120)];
        [_intercityTransPolicyPickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _intercityTransPolicyPickerView;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 530, 160, 35)];
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
