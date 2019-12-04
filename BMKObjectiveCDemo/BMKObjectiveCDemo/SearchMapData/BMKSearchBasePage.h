//  BMKSearchBasePage.h
//  BMKObjectiveCDemo
//  Created by zhaoxiangru on 2018/8/23.
//  Copyright © 2018年 Baidu. All rights reserved.   

#import <UIKit/UIKit.h>

@interface BMKSearchBasePage : UIViewController
//搜索按钮
@property (nonatomic, strong) UIButton *searchButton;
//搜索数据
@property (nonatomic, strong) NSMutableArray *dataArray;
//搜索工具视图
@property (nonatomic, strong) UIView *toolView;
- (void)createToolBarsWithItemArray:(NSArray *)itemArray;
//搜索工具简单搜索事件，子类重写覆盖
- (void)setupDefaultData;
//判断必传数据是否有空的
- (BOOL)isExistNullData;
- (void)alertMessage:(NSString *)message;
//根据polyline设置地图范围
- (void)mapViewFitPolyline:(BMKPolyline *)polyline withMapView:(BMKMapView *)mapView;
@end


