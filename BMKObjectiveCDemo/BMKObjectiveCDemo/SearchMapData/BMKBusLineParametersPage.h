//
//  BMKBusLineParametersPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKBusLineParametersPage : UIViewController
@property (nonatomic, copy) void (^searchDataBlock)(BMKBusLineSearchOption *option);
@end
