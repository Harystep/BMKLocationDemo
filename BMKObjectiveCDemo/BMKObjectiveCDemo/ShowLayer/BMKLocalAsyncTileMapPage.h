//
//  BMKLocalAsyncTilePage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/19.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKLocalAsyncTileMapPage : UIViewController

@end

/**
 @brief 通过异步方法获取瓦片数据，是一个抽象类，需要通过继承该类，
 并重载loadTileForX:y:zoom:result:方法，瓦片图片是jpeg或者png格式，
 size为256x256
 */
@interface BMKLocalAsyncTileLayer: BMKAsyncTileLayer

@end
