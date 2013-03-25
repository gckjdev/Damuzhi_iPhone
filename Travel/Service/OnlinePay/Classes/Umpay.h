//
//  Umpay.h
//  UmpaySDK
//
//  Created by Wang Haijun on 12-1-19.
//  Copyright (c) 2012年 Umpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UmpayDelegate <NSObject>

@required

- (void)onPayResult:(NSString*)orderId resultCode:(NSString*)resultCode resultMessage:(NSString*)resultMessage;

@end

@interface Umpay : NSObject

+ (BOOL)pay:(NSString *)tradeNo payType:(NSString*)payType  window:(UIWindow *)window delegate:(id <UmpayDelegate>)delegate;
 
@end
