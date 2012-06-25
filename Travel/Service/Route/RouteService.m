//
//  RouteService.m
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteService.h"
#import "TravelNetworkRequest.h"
#import "LocaleUtils.h"
#import "PPViewController.h"

@interface RouteService ()

@property (retain, nonatomic) NSArray *routeList;

@end

static RouteService *_defaultRouteService = nil;

@implementation RouteService

@synthesize routeList = _routeList;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
    [_routeList release];
    [super dealloc];
}

+ (RouteService*)defaultService
{
    if (_defaultRouteService == nil){
        _defaultRouteService = [[RouteService alloc] init];                
    }
    
    return _defaultRouteService;
}

- (void)findRoutesWithType:(int)routeType
              departCityId:(int)departCityId
         destinationCityId:(int)destinationCityId
                     start:(int)start
                     count:(int)count
            viewController:(PPViewController<RouteServiceDelegate>*)viewController
{
    [viewController showActivityWithText:NSLS(@"数据加载中......")];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:routeType 
                                                         departCityId:departCityId 
                                                    destinationCityId:destinationCityId 
                                                                start:start 
                                                                count:count 
                                                                 lang:LanguageTypeZhHans];
        int totalCount;
        NSArray *routeList;
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
            
                totalCount = [travelResponse totalCount];
                routeList = [[travelResponse routeList] routesList];
                

            }
            @catch (NSException *exception){
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];   
            
            if ([viewController respondsToSelector:@selector(findRequestDone:totalCount:routeList:)]) {
                [viewController findRequestDone:output.resultCode 
                                     totalCount:totalCount
                                      routeList:routeList];
            }
        });
    });    
}

- (void)findRouteWithRouteId:(int)routeId viewController:(PPViewController<RouteServiceDelegate>*)viewController

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:OBJECT_TYPE_ROUTE_DETAIL
                                                                  objId:routeId  
                                                                 lang:LanguageTypeZhHans];
        
        TravelResponse *travelResponse = nil;
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
                TouristRoute *route = [travelResponse route];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([viewController respondsToSelector:@selector(findRequestDone:route:)]) {
                        [viewController findRequestDone:travelResponse.resultCode 
                                                  route:route];
                    }
                });
            }
            @catch (NSException *exception){
            }
        }
    }); 
}


@end
