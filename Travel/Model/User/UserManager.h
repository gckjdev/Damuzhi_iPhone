//
//  UserManager.h
//  Travel
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@interface UserManager : NSObject<CommonManagerProtocol>

- (NSString*)getUserId;
- (void)saveUserId:(NSString*)userId;

// 是否自动登录，由UserService调用。
- (BOOL)isAutoLogin;

// 设置login信息，由UserService调用。
- (void)loginWithLoginId:(NSString *)loginId
                password:(NSString *)password
                   token:(NSString *)token;

// 设置logout信息，由UserService调用。
- (void)logout;

// 返回登录信息。
- (BOOL)isLogin;
- (NSString *)loginId;
- (NSString *)password;
- (NSString *)token;

// 设置登录信息，用于用户登录界面。
- (void)setAutoLogin:(BOOL)autoLogin;
- (void)rememberLoginId:(BOOL)remember;
- (void)rememberPassword:(BOOL)remember;

// 是否记住用户名(loginId)，调用用登录界面时判断，若是，则设置界面的用户名。
- (BOOL)isRememberLoginId;

// 是否记住密码(password)，调用用户登录界面时判断，若是，则设置界面上的密码。
- (BOOL)isRememberPassword;

@end
