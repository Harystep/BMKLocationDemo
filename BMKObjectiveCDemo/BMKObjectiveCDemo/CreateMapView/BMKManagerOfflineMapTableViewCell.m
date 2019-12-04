//
//  BMKManagerOfflineMapTableViewCell.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKManagerOfflineMapTableViewCell.h"

NSString *kBMKOfflineDownloadNotification = @"kBMKOfflineDownloadNotification";

@interface BMKManagerOfflineMapTableViewCell()
@property (nonatomic, strong) UILabel *cityNameLabel;
@property (nonatomic, strong) UILabel *deleteOfflineMap;
@property (nonatomic, assign) NSInteger cityID;
@property (nonatomic, assign) NSNumber *ratio; //下载百分比
@end

@implementation BMKManagerOfflineMapTableViewCell

#pragma mark - Initialization method
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _ratio = [NSNumber numberWithInt:0];
    [self configUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRatio:) name:kBMKOfflineDownloadNotification object:nil];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Config UI
- (void)configUI {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.cityNameLabel];
    [self.contentView addSubview:self.deleteOfflineMap];
}

#pragma mark - Config data
- (void)refreshUIWithData:(NSString *)cityName packetSize:(NSString *)packetSize cityID:(NSUInteger)cityID {
    _cityNameLabel.text = [NSString stringWithFormat:@"%@（%@）", cityName, packetSize];
    self.cityID = cityID;
    if ([self.ratio isEqualToNumber:@(100)]) {
        _deleteOfflineMap.text = @"完成";
    } else {
        _deleteOfflineMap.text = [NSString stringWithFormat:@"%@ %%",self.ratio];
    }
}

#pragma mark - Responding events
- (void)clickDeleteOfflineMap {
    if (self.deleteOfflineMapBlock) {
        self.deleteOfflineMapBlock();
    }
}

- (void)updateRatio:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSNumber *ratio = userInfo[@"ratio"];
    NSNumber *cityID = userInfo[@"cityID"];
    
    if ([cityID isEqualToNumber:@(self.cityID)]) {
        self.ratio = ratio;
        if ([ratio isEqualToNumber:@(100)]) {
            _deleteOfflineMap.text = @"完成";
        } else {
            _deleteOfflineMap.text = [NSString stringWithFormat:@"%@ %%",ratio];
        }
    }
}

#pragma mark -lazy loading
- (UILabel *)deleteOfflineMap {
    if (!_deleteOfflineMap) {
        _deleteOfflineMap = [[UILabel alloc] initWithFrame:CGRectMake(300 * widthScale, 15 * heightScale, 60 * widthScale, 30 * heightScale)];
        _deleteOfflineMap.text = @"0 %";
        _deleteOfflineMap.textColor = [UIColor blackColor];
        _deleteOfflineMap.font = [UIFont systemFontOfSize:17.0f];
    }
    return _deleteOfflineMap;
}

- (UILabel *)cityNameLabel {
    if (!_cityNameLabel) {
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * widthScale, 15 * heightScale, 200 * widthScale, 30 * heightScale)];
        _cityNameLabel.textColor = [UIColor blackColor];
        _cityNameLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _cityNameLabel;
}

@end
