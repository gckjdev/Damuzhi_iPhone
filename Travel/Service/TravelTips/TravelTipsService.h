//
//  TravelTipsService.h
//  Travel
//
//  Created by 小涛 王 on 12-4-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TravelTipsManager.h"
#import "PPTableViewController.h"

@protocol TravelTipsServiceDelegate <NSObject>
        
@optional
- (void)findRequestDone:(int)resulteCode tipList:(NSArray*)tipList;

@end

@interface TravelTipsService : CommonService

@property (retain, nonatomic) TravelTipsManager *localTravelTipsManager;
@property (retain, nonatomic) TravelTipsManager *onlineTravelTipsManager;

+ (TravelTipsService*)defaultService;

- (void)findTravelTipList:(int)cityId type:(TravelTipType)type viewController:(PPViewController<TravelTipsServiceDelegate>*)viewController;

@end
