//
//  BMKWalkingRouteParametersPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKWalkingRouteParametersPage : UIViewController
@property (nonatomic, copy) void (^searchDataBlock)(BMKWalkingRoutePlanOption *option);
@end
