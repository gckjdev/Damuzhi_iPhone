//
//  OrderService.m
//  Travel
//
//  Created by 小涛 王 on 12-6-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "OrderService.h"
#import "TravelNetworkRequest.h"
#import "JSON.h"
#import "Package.pb.h"
#import "PPDebug.h"
#import "TimeUtils.h"

@implementation OrderService

static OrderService *_instance = nil;

+ (OrderService*)defaultService
{
    if (_instance == nil){
        _instance = [[OrderService alloc] init];                
    }
    
    return _instance;
}

- (void)placeOrderUsingUserId:(NSString *)userId 
                      routeId:(int)routeId
                    packageId:(int)packageId
                   departDate:(NSDate *)departDate
                        adult:(int)adult
                     children:(int)children
                contactPerson:(NSString *)contactPersion
                    telephone:(NSString *)telephone
                     delegate:(id<OrderServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *departDateStr = dateToStringByFormat(departDate, @"yyyyMMdd");
        CommonNetworkOutput *output = [TravelNetworkRequest placeOrderWithUserId:userId 
                                                                         routeId:routeId
                                                                       packageId:packageId 
                                                                      departDate:departDateStr
                                                                           adult:adult 
                                                                        children:children 
                                                                   contactPerson:contactPersion 
                                                                       telephone:telephone];   

        int result = -1;
        NSString *resultInfo = nil;
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(placeOrderDone:result:reusultInfo:)]) {
                [delegate placeOrderDone:output.resultCode result:result reusultInfo:resultInfo];
            }
        });                        
    });
}

- (void)placeOrderUsingLoginId:(NSString *)loginId 
                         token:(NSString *)token
                       routeId:(int)routeId
                     packageId:(int)packageId
                    departDate:(NSDate *)departDate
                         adult:(int)adult
                      children:(int)children
                 contactPerson:(NSString *)contactPersion
                     telephone:(NSString *)telephone
                      delegate:(id<OrderServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *departDateStr = dateToStringByFormat(departDate, @"yyyyMMdd");
        CommonNetworkOutput *output = [TravelNetworkRequest placeOrderWithLoginId:loginId
                                                                            token:token 
                                                                          routeId:routeId
                                                                        packageId:packageId 
                                                                       departDate:departDateStr 
                                                                            adult:adult 
                                                                         children:children 
                                                                    contactPerson:contactPersion 
                                                                        telephone:telephone];   
        int result = -1;
        NSString *resultInfo = nil;
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(placeOrderDone:result:reusultInfo:)]) {
                [delegate placeOrderDone:output.resultCode result:result reusultInfo:resultInfo];
            }
        });                        
    });
}


- (void)findOrderUsingUserId:(NSString *)userId
                    orderType:(int)orderType
                    delegate:(id<OrderServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest queryList:orderType userId:userId lang:LanguageTypeZhHans];   
        int result = -1;
        NSString *resultInfo;
        TravelResponse *travelResponse = nil;

        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
            } @catch (NSException *exception){
                PPDebug (@"<findOrderUsingUserId> Caught %@%@", [exception name], [exception reason]);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(findRequestDone:list:)]) {
                [delegate findRequestDone:output.resultCode
                                     list:[travelResponse.orderList ordersList]];
            }
        });                        
    });
}


- (void)findOrderUsingLoginId:(NSString *)loginId
                        token:(NSString *)token
                    orderType:(int)orderType
                     delegate:(id<OrderServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest queryList:orderType loginId:loginId token:token lang:LanguageTypeZhHans];   
        int result = -1;
        NSString *resultInfo;
        TravelResponse *travelResponse = nil;
        
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
            } @catch (NSException *exception){
                PPDebug (@"<findOrderUsingUserId> Caught %@%@", [exception name], [exception reason]);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(findRequestDone:list:)]) {
                [delegate findRequestDone:output.resultCode
                                     list:[travelResponse.orderList ordersList]];
            }
        });                        
    });
}

- (void)localRouteOrderUsingUserId:(NSString *)userId 
                           routeId:(int)routeId 
                     departPlaceId:(int)departPlaceId
                        departDate:(NSDate *)departDate
                             adult:(int)adult
                          children:(int)children
                     contactPerson:(NSString *)contactPersion
                         telephone:(NSString *)telephone
                          delegate:(id<OrderServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *departDateStr = dateToStringByFormat(departDate, @"yyyyMMdd");
        CommonNetworkOutput *output = [TravelNetworkRequest localRouteOrderWithUserId:userId 
                                                                              routeId:routeId 
                                                                        departPlaceId:departPlaceId 
                                                                           departDate:departDateStr 
                                                                                adult:adult 
                                                                             children:children 
                                                                        contactPerson:contactPersion 
                                                                            telephone:telephone]; 
        
        int result = -1;
        NSString *resultInfo = nil;
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(placeOrderDone:result:reusultInfo:)]) {
                [delegate placeOrderDone:output.resultCode result:result reusultInfo:resultInfo];
            }
        });                        
    });
}

- (void)localRouteOrderUsingLoginId:(NSString *)loginId 
                              token:(NSString *)token
                            routeId:(int)routeId
                      departPlaceId:(int)departPlaceId
                         departDate:(NSDate *)departDate
                              adult:(int)adult
                           children:(int)children
                      contactPerson:(NSString *)contactPersion
                          telephone:(NSString *)telephone
                           delegate:(id<OrderServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *departDateStr = dateToStringByFormat(departDate, @"yyyyMMdd");
        
        CommonNetworkOutput *output = [TravelNetworkRequest localRouteOrderWithLoginId:loginId 
                                                                                 token:token 
                                                                               routeId:routeId 
                                                                         departPlaceId:departPlaceId 
                                                                            departDate:departDateStr 
                                                                                 adult:adult 
                                                                              children:children 
                                                                         contactPerson:contactPersion 
                                                                             telephone:telephone];  
        int result = -1;
        NSString *resultInfo = nil;
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(placeOrderDone:result:reusultInfo:)]) {
                [delegate placeOrderDone:output.resultCode result:result reusultInfo:resultInfo];
            }
        });                        
    });
}

@end
