//
//  CityOverViewCity.h
//  Travel
//
//  Created by 小涛 王 on 12-3-17.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonService.h"
#import "CityOverViewManager.h"
#import "PPViewController.h"
#import "CityOverview.pb.h"

@protocol CityOverviewServiceDelegate <NSObject>

@optional
- (void)findRequestDone:(int)result overview:(CommonOverview*)overView;

- (void)findRequestDone:(int)result 
             totalCount:(int)totalCount
             cityImages:(NSArray *)cityImages;

@end

@interface CityOverviewService : CommonService
{
    CityOverViewManager *_localCityOverViewManager;
    CityOverViewManager *_onlineCityOverViewManager;
}

+ (CityOverviewService*)defaultService;

- (void)findCommonOverView:(int)cityId
                      type:(CommonOverviewType)type
                  delegate:(PPViewController<CityOverviewServiceDelegate>*)viewController;

@end
