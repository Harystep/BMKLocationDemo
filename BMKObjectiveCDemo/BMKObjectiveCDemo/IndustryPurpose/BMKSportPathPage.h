//
//  BMKSportPathPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKSportPathPage : UIViewController

@end

@interface BMKSportNode : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat speed;
@end

