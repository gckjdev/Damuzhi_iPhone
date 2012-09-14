//
//  OrderService.h
//  Travel
//
//  Created by 小涛 王 on 12-6-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@protocol OrderServiceDelegate <NSObject>

@optional
- (void)placeOrderDone:(int)resultCode
                result:(int)result
           reusultInfo:(NSString *)resultInfo;

- (void)findRequestDone:(int)resultCode
                   list:(NSArray *)list;

@end

@interface OrderService : CommonService

+ (OrderService*)defaultService;

// 下面接口中departDate参数的格式是：yyyyMMdd

- (void)placeOrderUsingUserId:(NSString *)userId 
                      routeId:(int)routeId
                    packageId:(int)packageId
                   departDate:(NSDate *)departDate
                        adult:(int)adult
                     children:(int)children
                contactPerson:(NSString *)contactPersion
                    telephone:(NSString *)telephone
                     delegate:(id<OrderServiceDelegate>)delegate;

- (void)placeOrderUsingLoginId:(NSString *)LoginId 
                         token:(NSString *)token
                      routeId:(int)routeId
                    packageId:(int)packageId
                   departDate:(NSDate *)departDate
                        adult:(int)adult
                     children:(int)children
                contactPerson:(NSString *)contactPersion
                    telephone:(NSString *)telephone
                      delegate:(id<OrderServiceDelegate>)delegate;

- (void)findOrderUsingUserId:(NSString *)userId
                   orderType:(int)orderType
                    delegate:(id<OrderServiceDelegate>)delegate;


- (void)findOrderUsingLoginId:(NSString *)loginId
                        token:(NSString *)token
                    orderType:(int)orderType
                     delegate:(id<OrderServiceDelegate>)delegate;



- (void)localRouteOrderUsingUserId:(NSString *)userId 
                           routeId:(int)routeId 
                     departPlaceId:(int)departPlaceId
                        departDate:(NSDate *)departDate
                             adult:(int)adult
                          children:(int)children
                     contactPerson:(NSString *)contactPersion
                         telephone:(NSString *)telephone
                          delegate:(id<OrderServiceDelegate>)delegate;

- (void)localRouteOrderUsingLoginId:(NSString *)loginId 
                              token:(NSString *)token
                            routeId:(int)routeId
                      departPlaceId:(int)departPlaceId
                         departDate:(NSDate *)departDate
                              adult:(int)adult
                           children:(int)children
                      contactPerson:(NSString *)contactPersion
                          telephone:(NSString *)telephone
                           delegate:(id<OrderServiceDelegate>)delegate;

@end
