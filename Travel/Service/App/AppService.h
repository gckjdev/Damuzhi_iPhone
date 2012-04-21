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

@protocol UnzipDelegate <NSObject>

@optional
- (void)didFinishUnzip:(City*)city;
- (void)didFailUnzip:(City*)city;

@end

@interface AppService : CommonService

@property (retain, nonatomic) NSMutableArray *downloadRequestList;
@property (retain, nonatomic) NSOperationQueue *queue;
+ (AppService*)defaultService;

- (void)loadAppData;
- (void)updateAppData;
- (void)updateHelpHtmlFile;

- (void)UnzipCityDataAsynchronous:(int)cityId unzipDelegate:(id<UnzipDelegate>)unzipDelegate;

@end
