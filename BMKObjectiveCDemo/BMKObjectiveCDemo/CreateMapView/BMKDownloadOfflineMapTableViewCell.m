//
//  BMKDownloadOfflineMapTableViewCell.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/4/16.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKDownloadOfflineMapTableViewCell.h"

@interface BMKDownloadOfflineMapTableViewCell ()
@property (nonatomic, strong) UILabel *cityNameLabel;
@property (nonatomic, strong) UILabel *cityPackageSize;
@end

@implementation BMKDownloadOfflineMapTableViewCell

#pragma mark - Initialization method
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark - Config UI
- (void)configUI {
    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [self.contentView addSubview:self.cityNameLabel];
    [self.contentView addSubview:self.cityPackageSize];
}

#pragma mark - Config data
- (void)refreshUIWithData:(NSString *)cityName packetSize:(NSString *)packetSize cityID:(CGFloat)cityID {
    _cityNameLabel.text = [NSString stringWithFormat:@"%@（cityID:%@）", cityName, @(cityID)];
    _cityPackageSize.text = [NSString stringWithFormat:@"%@", packetSize];
}

#pragma mark -lazy loading
- (UILabel *)cityNameLabel {
    if (!_cityNameLabel) {
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * widthScale, 15 * heightScale, 250 * widthScale, 30 * heightScale)];
        _cityNameLabel.textColor = [UIColor blackColor];
        _cityNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _cityNameLabel;
}

- (UILabel *)cityPackageSize {
    if (!_cityPackageSize) {
        _cityPackageSize = [[UILabel alloc] initWithFrame:CGRectMake(300 * widthScale, 15 * heightScale, 60 * widthScale, 30 * heightScale)];
        _cityPackageSize.textColor = [UIColor blackColor];
        _cityPackageSize.font = [UIFont systemFontOfSize:16];
    }
    return _cityPackageSize;
}

@end
