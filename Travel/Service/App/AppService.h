//
//  AppService.h
//  Travel
//
//  Created by 小涛 王 on 12-3-12.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonService.h"
#import "AppManager.h"
#import "ASINetworkQueue.h"
#import <CoreLocation/CoreLocation.h>

@interface AppService : CommonService

+ (AppService*)defaultService;

@property (retain, nonatomic) CLLocation *currentLocation;
@property (retain, nonatomic) NSString *currentCityChineseName;

- (void)loadAppData;
- (void)updateAppData;
- (void)updateHelpHtmlFile;

@end
