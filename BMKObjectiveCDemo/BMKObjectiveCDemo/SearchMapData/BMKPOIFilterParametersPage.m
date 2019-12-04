//
//  BMKPOIFilterParametersPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKPOIFilterParametersPage.h"

@interface BMKPOIFilterParametersPage ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UISegmentedControl *industryTypeSegmentControl;
@property (nonatomic, strong) UISegmentedControl *sortRuleSegmentControl;
@property (nonatomic, strong) UIPickerView *sortBasisPickerView;
@property (nonatomic, copy) NSArray *hotelSortBasisTypeData;
@property (nonatomic, copy) NSArray *caterSortBasisTypeData;
@property (nonatomic, copy) NSArray *lifeSortBasisTypeData;
@property (nonatomic, strong) UILabel *isGrouponLabel;
@property (nonatomic, strong) UILabel *isDiscountLabel;
@property (nonatomic, strong) UISwitch *isGrouponSwitch;
@property (nonatomic, strong) UISwitch *isDiscountSwitch;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) BMKPOISearchFilter *filter; //POI检索过滤条件
@end

@implementation BMKPOIFilterParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //实例化POI检索过滤条件类对象
        _filter = [[BMKPOISearchFilter alloc] init];
        /**
         POI检索排序规则
         
         - BMK_POI_SORT_RULE_DESCENDING: 从高到底，降序排列
         - BMK_POI_SORT_RULE_ASCENDING: 从低到高，升序排列
         */
        _filter.sortRule = BMK_POI_SORT_RULE_DESCENDING;
        /**
         POI所属行业类型，设置该字段可提高检索速度和过滤经度
         
         - BMK_POI_INDUSTRY_TYPE_HOTEL: 宾馆
         - BMK_POI_INDUSTRY_TYPE_CATER: 餐饮
         - BMK_POI_INDUSTRY_TYPE_LIFE: 生活娱乐
         */
        _filter.industryType = BMK_POI_INDUSTRY_TYPE_HOTEL;
        //是否有团购
        _filter.isGroupon = NO;
        //是否有折扣
        _filter.isDiscount = NO;
        _hotelSortBasisTypeData = [NSArray arrayWithObjects:@"默认排序", @"按价格排序", @"按距离排序（只对周边有效）", @"按好评排序", @"按星级排序", @"按卫生排序", nil];
        _caterSortBasisTypeData = [NSArray arrayWithObjects:@"默认排序", @"按价格排序", @"按距离排序（只对周边有效）", @"按口味排序", @"按好评排序", @"按服务排序", nil];
        _lifeSortBasisTypeData = [NSArray arrayWithObjects:@"默认排序", @"按价格排序", @"按距离排序（只对周边有效）", @"按好评排序", @"按服务排序", nil];
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
    self.title = @"过滤条件";
    [self.view addSubview:self.industryTypeSegmentControl];
    [self.view addSubview:self.sortRuleSegmentControl];
    [self.view addSubview:self.sortBasisPickerView];
    [self.view addSubview:self.isGrouponLabel];
    [self.view addSubview:self.isGrouponSwitch];
    [self.view addSubview:self.isDiscountLabel];
    [self.view addSubview:self.isDiscountSwitch];
    [self.view addSubview:self.finishButton];
}

- (void)setupPickerDelegate {
    _sortBasisPickerView.delegate = self;
    _sortBasisPickerView.dataSource = self;
}

#pragma mark - Responding events
- (void)industryTypeSegmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_industryTypeSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            //过滤条件的行业类型为酒店
            _filter.industryType = BMK_POI_INDUSTRY_TYPE_HOTEL;
            break;
        case 1:
            //过滤条件的行业类型为餐饮
            _filter.industryType = BMK_POI_INDUSTRY_TYPE_CATER;
            break;
        default:
            //过滤条件的行业类型为生活娱乐
            _filter.industryType =  BMK_POI_INDUSTRY_TYPE_LIFE;
            break;
    }
    [_sortBasisPickerView reloadAllComponents];
}

- (void)sortRuleSegmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_sortRuleSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            //排序规则为降序排列
            _filter.sortRule = BMK_POI_SORT_RULE_DESCENDING;
            break;
        default:
            //排序规则为升序排列
            _filter.sortRule = BMK_POI_SORT_RULE_ASCENDING;
            break;
    }
}

- (void)grouponSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //有打折
        _filter.isGroupon = YES;
    } else {
        //无打折
       _filter.isGroupon = NO;
    }
}

- (void)discountSwitchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //有折扣
       _filter.isDiscount = YES;
    } else {
        //无折扣
        _filter.isDiscount = NO;
    }
}

- (void)clickFinishButton {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.filterDataBlock) {
        self.filterDataBlock(_filter);
    }
}

#pragma mark - UIPickerViewDataSource && UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_filter.industryType == BMK_POI_INDUSTRY_TYPE_HOTEL) {
        return _hotelSortBasisTypeData.count;
    } else if (_filter.industryType == BMK_POI_INDUSTRY_TYPE_CATER) {
        return _caterSortBasisTypeData.count;
    } else {
        return _lifeSortBasisTypeData.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_filter.industryType == BMK_POI_INDUSTRY_TYPE_HOTEL) {
        /**
         排序依据，根据industryType字段指定的行业类型不同，此字段应设置为对应行业的依据值
         比如industryType字段的值为BMK_POI_INDUSTRY_TYPE_CATER，则此字段应选择BMK_POI_SORT_BASIS_TYPE_CATER_XXX对应的枚举值
         */
        /**
         检索过滤条件中的排序依据类型
         类型整体分为宾馆行业、餐饮行业、生活娱乐行业3大类
         
         - BMK_POI_SORTNAME_TYPE_HOTEL_DEFAULT: 宾馆行业，默认排序
         - BMK_POI_SORTNAME_TYPE_HOTEL_PRICE: 宾馆行业，按价格排序
         - BMK_POI_SORTNAME_TYPE_HOTEL_DISTANCE: 宾馆行业，按距离排序（只对周边检索有效）
         - BMK_POI_SORTNAME_TYPE_HOTEL_TOTAL_SCORE: 宾馆行业，按好评排序
         - BMK_POI_SORTNAME_TYPE_HOTEL_LEVEL: 宾馆行业，按星级排序
         - BMK_POI_SORTNAME_TYPE_HOTEL_HEALTH_SCORE: 宾馆行业，按卫生排序
         - BMK_POI_SORTNAME_TYPE_CATER_DEFAULT: 餐饮行业，默认排序
         - BMK_POI_SORTNAME_TYPE_CATER_PRICE: 餐饮行业，按价格排序
         - BMK_POI_SORTNAME_TYPE_CATER_DISTANCE: 餐饮行业，按距离排序（只对周边检索有效）
         - BMK_POI_SORTNAME_TYPE_CATER_TASTE_RATING: 餐饮行业，按口味排序
         - BMK_POI_SORTNAME_TYPE_CATER_OVERALL_RATING: 餐饮行业，按好评排序
         - BMK_POI_SORTNAME_TYPE_CATER_SERVICE_RATING: 餐饮行业，按服务排序
         - BMK_POI_SORTNAME_TYPE_LIFE_DEFAULT: 生活娱乐行业，默认排序
         - BMK_POI_SORTNAME_TYPE_LIFE_PRICE: 生活娱乐行业，按价格排序
         - BMK_POI_SORTNAME_TYPE_LIFE_DISTANCE: 生活娱乐行业，按距离排序（只对周边检索有效）
         - BMK_POI_SORTNAME_TYPE_LIFE_OVERALL_RATING: 生活娱乐行业，按好评排序
         - BMK_POI_SORTNAME_TYPE_LIFE_COMMENT_NUMBER: 生活娱乐行业，按服务排序
         */
       _filter.sortBasis = (BMKPOISortBasisType)(row + 1);
    } else if (_filter.industryType == BMK_POI_INDUSTRY_TYPE_CATER) {
        _filter.sortBasis = (BMKPOISortBasisType)(row + 10);
    } else {
        _filter.sortBasis = (BMKPOISortBasisType)(row + 20);
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200 * heightScale)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [dataLabel setFont:[UIFont systemFontOfSize:20]];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_filter.industryType == BMK_POI_INDUSTRY_TYPE_HOTEL) {
        dataLabel.text = _hotelSortBasisTypeData[row];
    } else if (_filter.industryType == BMK_POI_INDUSTRY_TYPE_CATER) {
        dataLabel.text = _caterSortBasisTypeData[row];
    } else {
        dataLabel.text = _lifeSortBasisTypeData[row];
    }
    return dataLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_filter.industryType == BMK_POI_INDUSTRY_TYPE_HOTEL) {
        return _hotelSortBasisTypeData[row];
    } else if (_filter.industryType == BMK_POI_INDUSTRY_TYPE_CATER) {
        return _caterSortBasisTypeData[row];
    } else {
        return _lifeSortBasisTypeData[row];
    }
}

#pragma mark - Lazy loading
- (UISegmentedControl *)industryTypeSegmentControl {
    if (!_industryTypeSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"宾馆", @"餐饮", @"生活娱乐", nil];
        _industryTypeSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _industryTypeSegmentControl.frame =  CGRectMake(10 * widthScale, 12.5, 355 * widthScale, 35);
        [_industryTypeSegmentControl setTitle:@"宾馆" forSegmentAtIndex:0];
        [_industryTypeSegmentControl setTitle:@"餐饮" forSegmentAtIndex:1];
        [_industryTypeSegmentControl setTitle:@"生活娱乐" forSegmentAtIndex:2];
        _industryTypeSegmentControl.selectedSegmentIndex = 0;
        [_industryTypeSegmentControl addTarget:self action:@selector(industryTypeSegmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _industryTypeSegmentControl;
}

- (UISegmentedControl *)sortRuleSegmentControl {
    if (!_sortRuleSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"降序排列", @"升序排列", nil];
        _sortRuleSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _sortRuleSegmentControl.frame = CGRectMake(10 * widthScale, 230, 355 * widthScale, 35);
        [_sortRuleSegmentControl setTitle:@"降序排列" forSegmentAtIndex:0];
        [_sortRuleSegmentControl setTitle:@"升序排列" forSegmentAtIndex:1];
        _sortRuleSegmentControl.selectedSegmentIndex = 0;
        [_sortRuleSegmentControl addTarget:self action:@selector(sortRuleSegmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _sortRuleSegmentControl;
}

- (UIPickerView *)sortBasisPickerView {
    if (!_sortBasisPickerView) {
        _sortBasisPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, 120)];
        [_sortBasisPickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _sortBasisPickerView;
}

- (UILabel *)isGrouponLabel {
    if (!_isGrouponLabel) {
        _isGrouponLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 285, KScreenWidth - 20, 30)];
        _isGrouponLabel.text = @"是否有团购";
        _isGrouponLabel.font = [UIFont systemFontOfSize:17];
    }
    return _isGrouponLabel;
}

- (UILabel *)isDiscountLabel {
    if (!_isDiscountLabel) {
        _isDiscountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 375, KScreenWidth - 20, 30)];
        _isDiscountLabel.text = @"是否有打折";
        _isDiscountLabel.font = [UIFont systemFontOfSize:17];
    }
    return _isDiscountLabel;
}

- (UISwitch *)isGrouponSwitch {
    if (!_isGrouponSwitch) {
        _isGrouponSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 320, 120, 35)];
        [_isGrouponSwitch addTarget:self action:@selector(grouponSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _isGrouponSwitch;
}

- (UISwitch *)isDiscountSwitch {
    if (!_isDiscountSwitch) {
        _isDiscountSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 410, 120, 35)];
        [_isDiscountSwitch addTarget:self action:@selector(discountSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _isDiscountSwitch;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 160)/2, 475, 160, 35)];
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
