//
//  BMKDownloadOfflineMapTableViewCell.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/4/16.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKDownloadOfflineMapTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^downloadOfflineMapBlock)();
@property (nonatomic, copy) void (^pauseOfflineMapBlock)();
@property (nonatomic, copy) void (^deleteOfflineMapBlock)();
/**
 刷新单元格的内容

 @param cityName 城市名称
 @param packetSize 包大小
 @param cityID 城市标识符
 */
- (void)refreshUIWithData:(NSString *)cityName packetSize:(NSString *)packetSize cityID:(CGFloat)cityID;
@end
