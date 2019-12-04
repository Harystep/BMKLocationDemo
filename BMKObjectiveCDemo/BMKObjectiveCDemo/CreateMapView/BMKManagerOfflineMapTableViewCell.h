//
//  BMKManagerOfflineMapTableViewCell.h
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kBMKOfflineDownloadNotification;

@interface BMKManagerOfflineMapTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^deleteOfflineMapBlock)();
- (void)refreshUIWithData:(NSString *)cityName packetSize:(NSString *)packetSize cityID:(NSUInteger)cityID;
@end
