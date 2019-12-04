//
//  BMKDownloadOfflineMapPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKDownloadOfflineMapPage.h"
#import "BMKDownloadOfflineMapTableViewCell.h"
#import "BMKManagerOfflineMapTableViewCell.h"

static NSString *downloadCellIdentifier = @"com.Baidu.BMKDownloadOfflineMap";
static NSString *manangerCellIdentifier = @"com.Baidu.BMKManagerOfflineMap";
static const NSInteger kilobyte = 1024;
static const NSInteger megabyte = 1048576;
static const NSInteger gigabyte = 1073741824;

//离线地图代理，用于获取离线地图事件
@interface BMKDownloadOfflineMapPage ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, BMKOfflineMapDelegate>
@property (nonatomic, strong) UISegmentedControl *offlineMapSegmentControl;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UITableView *downloadOfflineView;
@property (nonatomic, strong) UITableView *managerOfflineView;
@property (nonatomic, strong) BMKOfflineMap *offlineMap; //离线地图类的实例
@property (nonatomic, copy) NSArray *hotCitys; //热门城市
@property (nonatomic, copy) NSArray *offlineCitys; //全部离线地图城市
@property (nonatomic, strong) BMKOLUpdateElement *updateElement; //离线地图更新信息
@property (nonatomic, copy) NSMutableArray *managerCitys;  //下载管理页管理的城市
@end

@implementation BMKDownloadOfflineMapPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createTableView];
    [self createOfflineMap];
}

#pragma mark - Config UI
- (void)createTableView {
    _downloadOfflineView.dataSource = self;
    _downloadOfflineView.delegate = self;
    [_downloadOfflineView registerClass:[BMKDownloadOfflineMapTableViewCell class] forCellReuseIdentifier:downloadCellIdentifier];
    _managerOfflineView.dataSource = self;
    _managerOfflineView.delegate = self;
    [_managerOfflineView registerClass:[BMKManagerOfflineMapTableViewCell class] forCellReuseIdentifier:manangerCellIdentifier];
}

- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"下载地图";
    [self.view addSubview:self.backgroundScrollView];
    [self.view addSubview:self.offlineMapSegmentControl];
    [self.backgroundScrollView addSubview:self.downloadOfflineView];
    [self.backgroundScrollView addSubview:self.managerOfflineView];
}

- (void)createOfflineMap {
    //实例化离线地图类BMKOfflineMap对象
    _offlineMap = [[BMKOfflineMap alloc] init];
    //返回热门城市列表，数组元素为BMKOLSearchRecord
    _hotCitys = [_offlineMap getHotCityList];
    //返回所有支持离线地图的城市列表，数组元素为BMKOLSearchRecord
    _offlineCitys = [_offlineMap getOfflineCityList];
    //设置离线地图类的代理
    _offlineMap.delegate = self;
    //下载管理cities
    _managerCitys = [NSMutableArray array];
}

#pragma mark - BMKOfflineMapDelegate
/**
 返回通知结果
 
 @param type 事件类型
 @param state 事件状态
 type为TYPE_OFFLINE_UPDATE，表示正在下载或更新城市id为state的离线包，
 type为TYPE_OFFLINE_ZIPCNT，表示检测到state个离线压缩包，
 type为TYPE_OFFLINE_ADD，表示新安装的离线地图数目，
 type为TYPE_OFFLINE_UNZIP，表示正在解压第state个离线包，
 type为TYPE_OFFLINE_ERRZIP，表示有state个错误包，
 type为TYPE_VER_NEWVER，表示id为state的城市离线包有新版本，
 type为TYPE_OFFLINE_UNZIPFINISH时，表示扫瞄完成，成功导入state个离线包
 */
- (void)onGetOfflineMapState:(int)type withState:(int)state {
    switch (type) {
        case TYPE_OFFLINE_UPDATE:
        {
            /**
             返回指定城市id离线地图更新信息
             @param cityID 指定的城市id
             @return 指定城市id离线地图更新信息
             */
            _updateElement = [_offlineMap getUpdateInfo:state];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[@"ratio"] = @(_updateElement.ratio);
            userInfo[@"cityID"] = @(state);
            [[NSNotificationCenter defaultCenter] postNotificationName:kBMKOfflineDownloadNotification object:nil userInfo:userInfo];
            break;
        }
        case TYPE_OFFLINE_NEWVER:
            break;
        case TYPE_OFFLINE_ZIPCNT:
            break;
        case TYPE_OFFLINE_ERRZIP:
            break;
        case TYPE_OFFLINE_UNZIPFINISH:
            break;
        default:
            NSLog(@"default");
            break;
    }
}

#pragma mark - Private
/**
 离线地图数据包大小单位转换
 
 @param packetSize 离线地图数据包总大小，单位是bytes
 @return 转换单位后的离线地图数据包大小
 */
- (NSString *)getDataSizeString:(NSInteger)packetSize {
    NSString *packetSizeString = @"";
    if (packetSize < kilobyte) {
        packetSizeString = [NSString stringWithFormat:@"%ldB", (long)packetSize];
    } else if (packetSize < megabyte) {
        packetSizeString = [NSString stringWithFormat:@"%ldK", (long)(packetSize / kilobyte)];
    } else if (packetSize < gigabyte) {
        if ((packetSize % megabyte) == 0 ) {
            packetSizeString = [NSString stringWithFormat:@"%ldM", (long)megabyte];
        } else {
            NSInteger decimal = 0;
            NSString *decimalString = nil;
            decimal = (packetSize % megabyte);
            decimal /= kilobyte;
            if (decimal < 10) {
                decimalString = [NSString stringWithFormat:@"%d", 0];
            } else if (decimal >= 10 && decimal < 100) {
                NSInteger temp = decimal / 10;
                if (temp >= 5) {
                    decimalString = [NSString stringWithFormat:@"%d", 1];
                } else {
                    decimalString = [NSString stringWithFormat:@"%d", 0];
                }
            } else if (decimal >= 100 && decimal < kilobyte) {
                NSInteger temp = decimal / 100;
                if (temp >= 5) {
                    decimal = temp + 1;
                    if (decimal >= 10) {
                        decimal = 9;
                    }
                    decimalString = [NSString stringWithFormat:@"%ld", (long)decimal];
                } else {
                    decimalString = [NSString stringWithFormat:@"%ld", (long)temp];
                }
            }
            if (decimalString == nil || [decimalString isEqualToString:@""]) {
                packetSizeString = [NSString stringWithFormat:@"%ld Mss", (long)packetSize / megabyte];
            } else {
                packetSizeString = [NSString stringWithFormat:@"%ld.%@M", (long)packetSize / megabyte, decimalString];
            }
        }
    } else {
        packetSizeString = [NSString stringWithFormat:@"%ld G", (long)packetSize / gigabyte];
    }
    return packetSizeString;
}
#pragma mark - Responding events
- (void)segmentControlDidChangeValue:(id)sender {
    NSUInteger selectIndex = [_offlineMapSegmentControl selectedSegmentIndex];
    switch (selectIndex) {
        case 0:
            _backgroundScrollView.contentOffset = CGPointMake(0, 0);
            break;
        default:
            _backgroundScrollView.contentOffset = CGPointMake(KScreenWidth, 0);
            break;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_downloadOfflineView]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_downloadOfflineView]) {
        if (section == 0) {
            return  _hotCitys.count;
        } else {
            return _offlineCitys.count;
        }
    } else {
        return _managerCitys.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual: _downloadOfflineView]) {
        BMKDownloadOfflineMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadCellIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            /**
             BMKOLSearchRecord为离线地图搜索城市记录信息类：
             cityName：城市名
             size：数据包总大小
             cityID：城市ID
             cityType：城市类型 0：全国；1：省份；2：城市；如果是省份，可以通过childCities得到子城市列表
             childCities：子城市列表
             */
            BMKOLSearchRecord *hotCityRecord = _hotCitys[indexPath.row];
            [cell refreshUIWithData:hotCityRecord.cityName packetSize:[self getDataSizeString:(long)hotCityRecord.size] cityID:hotCityRecord.cityID];
            cell.downloadOfflineMapBlock = ^{
                [_offlineMap start:hotCityRecord.cityID];
                if (![_managerCitys containsObject:hotCityRecord]) {
                    [_managerCitys addObject:hotCityRecord];
                    [_managerOfflineView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                }
            };
            cell.pauseOfflineMapBlock = ^{
                [_offlineMap pause:hotCityRecord.cityID];
            };
        } else if(indexPath.section == 1) {
            BMKOLSearchRecord *offlineCityRecord = _offlineCitys[indexPath.row];
            [cell refreshUIWithData:offlineCityRecord.cityName packetSize:[self getDataSizeString:(long)offlineCityRecord.size] cityID:offlineCityRecord.cityID];
            cell.downloadOfflineMapBlock = ^{
                [_offlineMap start:offlineCityRecord.cityID];
                if (![_managerCitys containsObject:offlineCityRecord]) {
                    [_managerCitys addObject:offlineCityRecord];
                    [_managerOfflineView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                }
            };
            cell.pauseOfflineMapBlock = ^{
                /**
                  暂停下载指定城市id的离线地图
                  @param cityID 指定的城市ID
                  @return 成功返回YES，否则返回NO
                 */
                [_offlineMap pause:offlineCityRecord.cityID];
            };
        }
        [_downloadOfflineView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        return cell;
    } else {
        BMKManagerOfflineMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:manangerCellIdentifier forIndexPath:indexPath];
        BMKOLSearchRecord *cityRecord = _managerCitys[indexPath.row];
        [cell refreshUIWithData:cityRecord.cityName packetSize:[self getDataSizeString:(long)cityRecord.size] cityID:cityRecord.cityID];
        cell.deleteOfflineMapBlock = ^{
            /**
              删除下载指定城市id的离线地图
              @param cityID 指定的城市ID
              @return 成功返回YES，否则返回NO
             */
            [_offlineMap remove:cityRecord.cityID];
            [_managerCitys removeObject:cityRecord];
            [_managerOfflineView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:_downloadOfflineView]) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * widthScale, 0, KScreenWidth - 20 * widthScale, 45 * heightScale)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = COLOR(0x6B6B6B);
        if (section == 0) {
            titleLabel.text = @"热门城市";
        } else {
            titleLabel.text = @"全国城市";
        }
        [titleView addSubview:titleLabel];
        return titleView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 * heightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:_downloadOfflineView] && !(section == 2)) {
      return 60 * heightScale;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_downloadOfflineView]) {
        if (indexPath.section == 0) {
            BMKOLSearchRecord *hotCityRecord = _hotCitys[indexPath.row];
            [_offlineMap start:hotCityRecord.cityID];
            if (![_managerCitys containsObject:hotCityRecord]) {
                [_managerCitys addObject:hotCityRecord];
                [_managerOfflineView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        } else {
            BMKOLSearchRecord *offlineCityRecord = _offlineCitys[indexPath.row];
            [_offlineMap start:offlineCityRecord.cityID];
            if (![_managerCitys containsObject:offlineCityRecord]) {
                [_managerCitys addObject:offlineCityRecord];
                [_managerOfflineView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
        _offlineMapSegmentControl.selectedSegmentIndex = 1;
        [self segmentControlDidChangeValue:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_managerOfflineView]) {
        return YES;
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_managerOfflineView]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            BMKOLSearchRecord *cityRecord = _managerCitys[indexPath.row];
            [_offlineMap remove:cityRecord.cityID];
            [_managerCitys removeObject:cityRecord];
            [_managerOfflineView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark -lazy loading
- (UISegmentedControl *)offlineMapSegmentControl {
    if (!_offlineMapSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"城市列表",@"下载管理",nil];
        _offlineMapSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _offlineMapSegmentControl.frame = CGRectMake(10 * widthScale, 12.5, 355 * widthScale, 35);
        [_offlineMapSegmentControl setTitle:@"城市列表" forSegmentAtIndex:0];
        [_offlineMapSegmentControl setTitle:@"下载管理" forSegmentAtIndex:1];
        _offlineMapSegmentControl.selectedSegmentIndex = 0;
        [_offlineMapSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _offlineMapSegmentControl;
}

- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 72.5, KScreenWidth * 2, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue - 120)];
    }
    return _backgroundScrollView;
}

- (UITableView *)downloadOfflineView {
    if (!_downloadOfflineView) {
        _downloadOfflineView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue) style:UITableViewStyleGrouped];
    }
    return _downloadOfflineView;
}

- (UITableView *)managerOfflineView {
    if (!_managerOfflineView) {
        _managerOfflineView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue) style:UITableViewStyleGrouped];
    }
    return _managerOfflineView;
}

@end
