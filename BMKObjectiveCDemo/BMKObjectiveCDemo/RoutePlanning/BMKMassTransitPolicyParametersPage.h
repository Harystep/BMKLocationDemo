//
//  BMKMassTransitPolicyParametersPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/16.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKMassTransitPolicyParametersPage : UIViewController
@property (nonatomic, copy) void (^policyDataBlock)(BMKMassTransitRoutePlanOption *option);
@end
