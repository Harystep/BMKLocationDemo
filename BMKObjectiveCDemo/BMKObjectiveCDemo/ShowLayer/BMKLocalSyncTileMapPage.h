//
//  BMKTileMapPage.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @brief 通过同步方法获取瓦片数据，是一个抽象类，需要通过继承该类，并重载 tileForX:y:zoom: 方法
 瓦片图片是jpeg或者png格式，size为256x256
 */
@interface BMKLocalSyncTileLayer: BMKSyncTileLayer

@end

@interface BMKLocalSyncTileMapPage : UIViewController

@end

