//
//  BMKMassTransitParametersPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKMassTransitParametersPage : UIViewController
@property (nonatomic, copy) void (^searchDataBlock)(BMKMassTransitRoutePlanOption *option);
@end
