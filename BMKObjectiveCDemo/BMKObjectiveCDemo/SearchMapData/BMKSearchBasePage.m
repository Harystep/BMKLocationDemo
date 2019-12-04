//
//  BMKSearchBasePage.m
//  BMKObjectiveCDemo
//
//  Created by zhaoxiangru on 2018/8/23.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKSearchBasePage.h"

@interface BMKSearchBasePage () <UITextFieldDelegate>
@end

@implementation BMKSearchBasePage

- (void)viewDidLoad {
    [super viewDidLoad];
}

//创建ToolView
- (void)createToolBarsWithItemArray:(NSArray *)itemArray {
    
    [_dataArray removeAllObjects];
    [_toolView removeFromSuperview];
    
    for (int i = 0; i<itemArray.count; i++) {
        NSDictionary *tempDic = itemArray[i];
        
        UILabel *leftTip = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth * 0.05, 0, KScreenWidth * 0.35, 33)];
        leftTip.textAlignment = NSTextAlignmentRight;
        leftTip.text = tempDic[@"leftItemTitle"];
        leftTip.textColor = self.view.tintColor;
        
        UITextField *leftText = [[UITextField alloc] initWithFrame:CGRectMake(KScreenWidth * 0.4, 0, KScreenWidth * 0.35, 33)];
        leftText.returnKeyType = UIReturnKeyDone;
        leftText.delegate = self;
        leftText.tag = 100 + i;
        [leftText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        leftText.text = tempDic[@"rightItemText"];
        leftText.placeholder = tempDic[@"rightItemPlaceholder"];
        [leftText setBorderStyle:UITextBorderStyleRoundedRect];
        //数据初始化并绑定
        [self.dataArray addObject:leftText.text];
        
        UIView *bar = [[UIView alloc] init];
        bar.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:247/255.0];
        bar.frame = CGRectMake(0, 35 * i, KScreenWidth * 0.75, 35);
        [bar addSubview:leftTip];
        [bar addSubview:leftText];
        
        [self.toolView addSubview:bar];
    }
    
    self.toolView.frame = CGRectMake(0, KScreenHeight - kViewTopHeight - 35 * itemArray.count - KiPhoneXSafeAreaDValue, KScreenWidth, 35 * itemArray.count);
    self.searchButton.frame = CGRectMake(KScreenWidth * 0.75, 0, KScreenWidth * 0.25, self.toolView.frame.size.height);
    [self.toolView addSubview:self.searchButton];
    [self.view addSubview:self.toolView];
    
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification {
    // 获取键盘的高度
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = [UIScreen mainScreen].bounds.size.height-self.toolView.frame.size.height-frame.size.height-KNavigationBarHeight - KStatuesBarHeight;
    self.toolView.frame = CGRectMake(self.toolView.frame.origin.x, y, self.toolView.frame.size.width, self.toolView.frame.size.height);
}

- (void)keyboardWillBeHiden:(NSNotification *)notification {
    if (KScreenHeight -  kViewTopHeight - KiPhoneXSafeAreaDValue - self.toolView.frame.size.height  == self.toolView.frame.origin.y)
        return;
    self.toolView.frame = CGRectMake(self.toolView.frame.origin.x, KScreenHeight -  kViewTopHeight - KiPhoneXSafeAreaDValue - self.toolView.frame.size.height, self.toolView.frame.size.width, self.toolView.frame.size.height);
}

- (void)searchData {
    if (![self isExistNullData]) {
        [self setupDefaultData];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"必选参数不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)setupDefaultData {
}

- (void)alertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检索结果" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL)isExistNullData {
    BOOL flag = NO;
    if (self.dataArray.count == 0) return NO;
    for (NSString *tempStr in self.dataArray) {
        if (tempStr.length == 0) {
            flag = YES;
            break;
        }
    }
    return flag;
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //数据更新
    [self.dataArray replaceObjectAtIndex:textField.tag - 100 withObject:textField.text];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField {
    //数据更新
    [self.dataArray replaceObjectAtIndex:textField.tag - 100 withObject:textField.text];
}

//根据polyline设置地图范围
- (void)mapViewFitPolyline:(BMKPolyline *)polyline withMapView:(BMKMapView *)mapView {
    double leftTop_x, leftTop_y, rightBottom_x, rightBottom_y;
    if (polyline.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyline.points[0];
    leftTop_x = pt.x;
    leftTop_y = pt.y;
    //左上方的点lefttop坐标（leftTop_x，leftTop_y）
    rightBottom_x = pt.x;
    rightBottom_y = pt.y;
    //右底部的点rightbottom坐标（rightBottom_x，rightBottom_y）
    for (int i = 1; i < polyline.pointCount; i++) {
        BMKMapPoint point = polyline.points[i];
        if (point.x < leftTop_x) {
            leftTop_x = point.x;
        }
        if (point.x > rightBottom_x) {
            rightBottom_x = point.x;
        }
        if (point.y < leftTop_y) {
            leftTop_y = point.y;
        }
        if (point.y > rightBottom_y) {
            rightBottom_y = point.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTop_x , leftTop_y);
    rect.size = BMKMapSizeMake(rightBottom_x - leftTop_x, rightBottom_y - leftTop_y);
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 10, 20, 10);
    [mapView fitVisibleMapRect:rect edgePadding:padding withAnimated:YES];
}

-(void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectZero;
        [_searchButton setTitle:@"搜 索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectZero];
        [_toolView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:247/255.0]];
    }
    return _toolView;
}

@end
