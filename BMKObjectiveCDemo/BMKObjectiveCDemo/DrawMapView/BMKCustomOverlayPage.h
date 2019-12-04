//
//  BMKCustomOverlayPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKCustomOverlayPage : UIViewController

@end

@interface CustomOverlay : BMKShape<BMKOverlay>
@property (nonatomic, assign) BMKMapRect boundingMapRect;
@property (nonatomic, assign) BMKMapPoint *points;
@property (nonatomic, assign) NSUInteger pointCount;
/*
 填充颜色
 注：请使用 - (UIColor *)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha; 初始化UIColor，使用[UIColor ***Color]初始化时，个别case转换成RGB后会有问题
 */
@property (strong, nonatomic) UIColor *fillColor;

/*
 画笔颜色
 注：请使用 - (UIColor *)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha; 初始化UIColor，使用[UIColor ***Color]初始化时，个别case转换成RGB后会有问题
 */
@property (strong, nonatomic) UIColor *strokeColor;

-(id)initWithPoints:(BMKMapPoint *)points count:(NSUInteger)count;
+ (CustomOverlay *)customWithPoints:(BMKMapPoint *)points count:(NSUInteger)count;
@end

@interface CustomOverlayView : BMKOverlayGLBasicView
@property (nonatomic, strong) CustomOverlay *customOverlay;
@end




