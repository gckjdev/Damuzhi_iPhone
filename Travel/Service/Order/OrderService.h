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
- (void)placeOrderDone:(int)result;

@end

@interface OrderService : CommonService

+ (OrderService*)defaultService;

- (void)placeOrderUsingUserId:(NSString *)userId 
                      routeId:(int)routeId
                       packId:(int)packId
                   departDate:(int)departDate
                        adult:(int)adult
                     children:(int)children
                contactPerson:(NSString *)contactPersion
                    telephone:(NSString *)telephone;

- (void)placeOrderUsingLoginId:(NSString *)LoginId 
                         token:(NSString *)token
                      routeId:(int)routeId
                       packId:(int)packId
                   departDate:(int)departDate
                        adult:(int)adult
                     children:(int)children
                contactPerson:(NSString *)contactPersion
                    telephone:(NSString *)telephone;

@end
