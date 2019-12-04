//
//  BMKAnimationAnnotationView.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/22.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKAnimationAnnotationView.h"

@implementation BMKAnimationAnnotationView

/**
 初始化并返回一个annotationView
 
 @param annotation 关联的annotation对象
 @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
 @return 初始化成功则返回annotation view，否则返回nil
 */
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 32, 32);
        UIImageView *annotationImage = [[UIImageView alloc] initWithFrame:self.frame];
        annotationImage.animationImages = @[[UIImage imageNamed:@"greenAnimationIcon"], [UIImage imageNamed:@"blackAnimationIcon"], [UIImage imageNamed:@"redAnimationIcon"]];
        annotationImage.animationDuration = 0.5 * 3;
        annotationImage.animationRepeatCount = 0;
        [annotationImage startAnimating];
        [self addSubview:annotationImage];
    }
    return self;
}

@end
