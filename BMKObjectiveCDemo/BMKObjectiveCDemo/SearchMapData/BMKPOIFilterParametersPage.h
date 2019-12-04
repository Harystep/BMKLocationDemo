//
//  BMKPOIFilterParametersPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKPOIFilterParametersPage : UIViewController
@property (nonatomic, copy) void (^filterDataBlock)(BMKPOISearchFilter *filter);
@end
