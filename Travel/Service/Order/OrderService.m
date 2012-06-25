//
//  OrderService.m
//  Travel
//
//  Created by 小涛 王 on 12-6-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "OrderService.h"
#import "TravelNetworkRequest.h"

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
                   departDate:(int)departDate
                        adult:(int)adult
                     children:(int)children
                contactPerson:(NSString *)contactPersion
                    telephone:(NSString *)telephone
                     delegate:(id<OrderServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest placeOrderWithUserId:userId 
                                                                         routeId:routeId
                                                                       packageId:packageId 
                                                                      departDate:departDate
                                                                           adult:adult 
                                                                        children:children 
                                                                   contactPerson:contactPersion 
                                                                       telephone:telephone];   

        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(placeOrderDone:)]) {
                [delegate placeOrderDone:output.resultCode];
            }
        });                        
    });
}

- (void)placeOrderUsingLoginId:(NSString *)loginId 
                         token:(NSString *)token
                       routeId:(int)routeId
                     packageId:(int)packageId
                    departDate:(int)departDate
                         adult:(int)adult
                      children:(int)children
                 contactPerson:(NSString *)contactPersion
                     telephone:(NSString *)telephone
                      delegate:(id<OrderServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest placeOrderWithLoginId:loginId
                                                                            token:token 
                                                                          routeId:routeId
                                                                        packageId:packageId 
                                                                       departDate:departDate 
                                                                            adult:adult 
                                                                         children:children 
                                                                    contactPerson:contactPersion 
                                                                        telephone:telephone];   
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(placeOrderDone:)]) {
                [delegate placeOrderDone:output.resultCode];
            }
        });                        
    });
}

@end
