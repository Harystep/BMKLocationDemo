//
//  BMKSearchBaseViewController.m
//  BMKObjectiveCDemo
//
//  Created by zhaoxiangru on 2018/8/23.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKSearchBaseViewController.h"

@interface BMKSearchBaseViewController ()<UITextFieldDelegate>

@end

@implementation BMKSearchBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//创建ToolView
-(void)createToolBarsWithItemArray:(NSArray *)itemArray{
    _toolView = [[UIView alloc] init];
    _toolView.frame = CGRectMake(0, self.view.frame.size.height-35*itemArray.count-KNavigationBarHeight - KStatuesBarHeight - KiPhoneXSafeAreaDValue, self.view.frame.size.width, 35*itemArray.count);
    for (int i = 0; i<itemArray.count; i++) {
        NSDictionary *tempDic = itemArray[i];
        UIView *bar = [[UIView alloc] init];
//        bar.clipsToBounds = YES;
//        bar.barTintColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:247/255.0];
        bar.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:247/255.0];
        UILabel *leftTip = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.05, 0, [UIScreen mainScreen].bounds.size.width * 0.3, 33)];
        leftTip.textAlignment = NSTextAlignmentRight;
        leftTip.text = tempDic[@"leftItemTitle"];
        leftTip.textColor = self.view.tintColor;
//        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftTip];
        UITextField *leftText = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.35, 0, [UIScreen mainScreen].bounds.size.width * 0.35, 33)];
        leftText.returnKeyType = UIReturnKeyDone;//变为完成按钮
        leftText.delegate = self;
        leftText.tag = 100 + i;
        [leftText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        leftText.text = tempDic[@"rightItemText"];
        //数据初始化并绑定
        [self.dataArray addObject:leftText.text];
        leftText.placeholder = tempDic[@"rightItemPlaceholder"];
        [leftText setBorderStyle:UITextBorderStyleRoundedRect];
        [bar addSubview:leftTip];
        [bar addSubview:leftText];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:leftText];
        
//        UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        bar.frame = CGRectMake(0, 35*i, [UIScreen mainScreen].bounds.size.width * 0.7, 35);
        [_toolView addSubview:bar];
//        bar.items =  [[NSArray alloc]initWithObjects:leftItem,rightItem,nil];
    }
   
    _searchButton = [[UIButton alloc] init];
    _searchButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*0.7, 0, [UIScreen mainScreen].bounds.size.width*0.3, _toolView.frame.size.height);
    [_searchButton setTitle:@"搜 索" forState:UIControlStateNormal];
    [_searchButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(setupDefaultData) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_searchButton];
    [_toolView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:247/255.0]];
    
    [self.view addSubview:_toolView];
    #pragma mark -键盘弹出添加监听事件
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    // 获取键盘的高度
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = [UIScreen mainScreen].bounds.size.height-self.toolView.frame.size.height-frame.size.height-KNavigationBarHeight - KStatuesBarHeight;
    self.toolView.frame = CGRectMake(self.toolView.frame.origin.x, y, self.toolView.frame.size.width, self.toolView.frame.size.height);
}

- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    if ([UIScreen mainScreen].bounds.size.height-self.toolView.frame.size.height-KNavigationBarHeight - KStatuesBarHeight  == self.toolView.frame.origin.y)
        return;
    self.toolView.frame = CGRectMake(self.toolView.frame.origin.x,[UIScreen mainScreen].bounds.size.height-self.toolView.frame.size.height -KNavigationBarHeight - KStatuesBarHeight - KiPhoneXSafeAreaDValue, self.toolView.frame.size.width, self.toolView.frame.size.height);
}

-(void)setupDefaultData{

}

#pragma mark -懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(BOOL)isExistNullData{
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
    [self.dataArray replaceObjectAtIndex:textField.tag-100 withObject:textField.text];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField {
    //数据更新
    [self.dataArray replaceObjectAtIndex:textField.tag-100 withObject:textField.text];
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine withMapView:(BMKMapView *)mapView {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    //左上方的点lefttop坐标（ltX，ltY）
    rbX = pt.x, rbY = pt.y;
    //右底部的点rightbottom坐标（rbX，rbY）
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y < ltY) {
            ltY = pt.y;
        }
        if (pt.y > rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
//    [mapView setVisibleMapRect:rect];
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 10, 20, 10);
    [mapView fitVisibleMapRect:rect edgePadding:padding withAnimated:YES];
}

-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
