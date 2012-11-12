//
//  SinaweiboManager
//  TestWeibo2.0
//
//  Created by haodong on 12-11-6.
//  Copyright (c) 2012年 haodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface SinaweiboManager : NSObject

@property (retain, nonatomic) SinaWeibo *sinaweibo;

+ (SinaweiboManager *)defaultManager;

//此方法在AppDelegate中调用
- (void)createSinaweiboWithAppKey:(NSString *)appKey
                        appSecret:(NSString *)appSecret
                   appRedirectURI:(NSString *)appRedirectURI
                         delegate:(id<SinaWeiboDelegate>)delegate;

- (void)setDelegate:(id<SinaWeiboDelegate>)delegate;

- (void)storeAuthData;
- (void)removeAuthData;

@end
