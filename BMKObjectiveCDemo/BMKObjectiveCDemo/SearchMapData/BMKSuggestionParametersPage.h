//
//  BMKSuggestionParametersPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKSuggestionParametersPage : UIViewController
@property (nonatomic, copy) void (^searchDataBlock)(BMKSuggestionSearchOption *option);
@end
