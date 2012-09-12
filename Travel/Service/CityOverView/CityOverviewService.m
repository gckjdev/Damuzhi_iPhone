//
//  CityOverViewCity.m
//  Travel
//
//  Created by 小涛 王 on 12-3-17.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityOverviewService.h"
#import "PPViewController.h"
#import "LogUtil.h"
#import "TravelNetworkRequest.h"
#import "CityOverview.pb.h"
#import "Package.pb.h"
#import "CityOverViewManager.h"
#import "TravelNetworkConstants.h"
#import "AppManager.h"
#import "AppUtils.h"
#import "PPNetworkConstants.h"

#define SERACH_WORKING_QUEUE1    @"SERACH_WORKING_QUEUE1"

@implementation CityOverviewService

static CityOverviewService *_cityOverViewService = nil;

+ (CityOverviewService*)defaultService
{
    if (_cityOverViewService == nil) {
        _cityOverViewService = [[CityOverviewService alloc] init];
    }
    
    return _cityOverViewService;
}

- (id)init
{
    self = [super init];
    _localCityOverViewManager = [[CityOverViewManager alloc] init];
    _onlineCityOverViewManager = [[CityOverViewManager alloc] init];
    return self;
}

- (void)dealloc
{
    [_localCityOverViewManager release];
    [_onlineCityOverViewManager release];
    [super dealloc];
}

typedef CommonOverview* (^LocalRequestHandler)(int* resultCode);
typedef CommonOverview* (^RemoteRequestHandler)(int* resultCode);

- (void)processLocalRemoteQuery:(PPViewController<CityOverviewServiceDelegate>*)viewController
                   localHandler:(LocalRequestHandler)localHandler
                  remoteHandler:(RemoteRequestHandler)remoteHandler
{
    [viewController showActivityWithText:NSLS(@"数据加载中......")];
    
    NSOperationQueue* queue = [self getOperationQueue:SERACH_WORKING_QUEUE1];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        CommonOverview* overview = nil;
        int resultCode = 0;
        if ([AppUtils hasLocalCityData:[[AppManager defaultManager] getCurrentCityId]] == YES){
            // read local data firstly               
            PPDebug(@"Has Local Data For City %@, Read Data Locally", [[AppManager defaultManager] getCurrentCityName]);
            if (localHandler != NULL){
                overview = localHandler(&resultCode);
            }
        }
        else{
            // if local data no exist, try to read data from remote            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", [[AppManager defaultManager] getCurrentCityName]);            
            if (remoteHandler != NULL){
                overview = remoteHandler(&resultCode);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];   
            if (viewController && [viewController respondsToSelector:@selector(findRequestDone:overview:)]) {
                [viewController findRequestDone:resultCode overview:overview];
            }
        });
    }];
}

- (void)findCommonOverView:(int)cityId
                      type:(CommonOverviewType)type
                  delegate:(PPViewController<CityOverviewServiceDelegate>*)viewController
{
    LocalRequestHandler localHandler = ^CommonOverview *(int* resultCode) {
        [_localCityOverViewManager switchCity:cityId];
        *resultCode = 0;
        return [_localCityOverViewManager getCommonOverview:type];
    };
    
    RemoteRequestHandler remoteHandler = ^CommonOverview *(int* resultCode) {
        int objectType = [self getObjectTypeByCommonOverviewType:type];
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:objectType
                                                                  objId:cityId
                                                                   lang:LanguageTypeZhHans]; 
        
        // TODO check output result code
        CommonOverview *commonOverView = nil;
        
        *resultCode = output.resultCode;
        if (output.resultCode == ERROR_SUCCESS) {
            @try {
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                commonOverView = [travelResponse overview];
            }
            @catch (NSException *exception) {
                PPDebug(@"<findCommonOverView:%d> Caught %@%@", objectType, [exception name], [exception reason]);
            }
        }
        
        return commonOverView;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
}



- (int)getObjectTypeByCommonOverviewType:(CommonOverviewType)type
{
    int objectType = 0;
    
    switch (type) {
        case CommonOverviewTypeCityBasic:
            objectType = OBJECT_TYPE_CITY_BASIC;
            break;
            
        case CommonOverviewTypeTravelPrepration:
            objectType = OBJECT_TYPE_TRAVEL_PREPARATION;
            break;

        case CommonOverviewTypeTravelUtility:
            objectType = OBJECT_TYPE_TRAVEL_UTILITY;
            break;

        case CommonOverviewTypeTravelTransportation:
            objectType = OBJECT_TYPE_TRAVEL_TRANSPORTATION;
            break;
            
        default:
            break;
    }
    
    return objectType;
}

@end
