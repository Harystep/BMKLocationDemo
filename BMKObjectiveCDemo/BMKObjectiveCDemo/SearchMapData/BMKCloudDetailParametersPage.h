//
//  BMKCloudDetailParametersPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKCloudDetailParametersPage : UIViewController
@property (nonatomic, copy) void (^searchDataBlock)(BMKCloudDetailSearchInfo *info);
@end