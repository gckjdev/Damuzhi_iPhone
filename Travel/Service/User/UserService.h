//
//  UserService.h
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "Package.pb.h"

@protocol UserServiceDelegate <NSObject>

@optional

- (void)queryVersionFinish:(NSString*)version
               dataVersion:(NSString*)dataVersion
                     title:(NSString *)title
                   content:(NSString *)content;

- (void)submitFeekbackDidFinish:(int)resultCode;

- (void)signUpDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo;
- (void)verificationDidSend:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo;
- (void)verificationDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo;
- (void)loginDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo;
- (void)loginoutDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo;

- (void)retrievePasswordDidSend:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo;

- (void)modifyPasswordDidDone:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo;
- (void)retrieveUserInfoDidDone:(int)resultCode userInfo:(UserInfo *)userInfo;

@end

@interface UserService : CommonService

+ (UserService*)defaultService;

- (void)autoRegisterUser:(NSString*)deviceToken;

- (void)queryVersion:(id<UserServiceDelegate>)delegate;

- (void)submitFeekback:(id<UserServiceDelegate>)delegate
              feekback:(NSString*)feekback
               contact:(NSString*)contact;

// 用户自动登录接口，启动时调用
- (void)autoLogin:(id<UserServiceDelegate>)delegate;

// 用户登录接口
- (void)login:(NSString *)loginId
     password:(NSString *)password
     delegate:(id<UserServiceDelegate>)delegate;

// 用户登出接口
- (void)logout:(id<UserServiceDelegate>)delegate;

// 注册接口
- (void)signUp:(NSString *)loginId 
      password:(NSString *)password
      delegate:(id<UserServiceDelegate>)delegate;

// 验证接口
- (void)verificate:(NSString *)loginId 
         telephone:(NSString *)telephone 
          delegate:(id<UserServiceDelegate>)delegate;

// 验证接口
- (void)verificate:(NSString *)loginId 
              code:(NSString *)code 
          delegate:(id<UserServiceDelegate>)delegate;


// 找回密码接口
- (void)retrievePassword:(NSString *)telephone
                delegate:(id<UserServiceDelegate>)delegate;

- (void)modifyUserFullName:(NSString *)fullName
                  nickName:(NSString *)nickName
                    gender:(int)gender
                 telephone:(NSString *)telephone
                     email:(NSString *)email
                   address:(NSString *)address
                  delegate:(id<UserServiceDelegate>)delegate;
    
- (void)modifyPassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
              delegate:(id<UserServiceDelegate>)delegate;

- (void)retrieveUserInfo:(id<UserServiceDelegate>)delegate;

@end
