//
//  UserManager.m
//  Travel
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

#define KEY_USER_ID   @"KEY_USER_ID"
#define KEY_LOGIN_ID   @"KEY_LOGIN_ID"
#define KEY_PASSWORD   @"KEY_PASSWORD"
#define KEY_AUTO_LOGIN   @"KEY_AUTO_LOGIN"
#define KEY_REMEMBER_LOGIN_ID   @"KEY_REMEMBER_LOGIN_ID"
#define KEY_REMEMBER_PASSWORD   @"KEY_REMEMBER_PASSWORD"




@interface UserManager ()

@property (assign, nonatomic) BOOL isLogin;
@property (copy, nonatomic) NSString *loginId;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *token;

@property (assign, nonatomic) BOOL isAutoLogin;
@property (assign, nonatomic) BOOL isRememberLoginId;
@property (assign, nonatomic) BOOL isRememberPassword;

@end

@implementation UserManager

static UserManager* _defaultUserManager = nil;

@synthesize isLogin = _isLogin;
@synthesize loginId = _loginId;
@synthesize password = _password;
@synthesize token = _token;

@synthesize isAutoLogin = _isAutoLogin;
@synthesize isRememberLoginId = _isRememberLoginId;
@synthesize isRememberPassword = _isRememberPassword;

+ (id)defaultManager
{
    if (_defaultUserManager == nil){
        _defaultUserManager = [[UserManager alloc] init];
    }
    
    return _defaultUserManager;
}

- (id)init
{
    if (self = [super init]) {
        self.isAutoLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTO_LOGIN] boolValue];
        self.isRememberLoginId = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_REMEMBER_LOGIN_ID] boolValue];
        self.isRememberPassword = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_REMEMBER_PASSWORD] boolValue];
        
        if (_isAutoLogin) {
            self.loginId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LOGIN_ID];
            self.password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
        }
        
        if (_isRememberLoginId) {
            self.loginId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LOGIN_ID];
        }
        
        if (_isRememberPassword) {
            self.password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
        }
    }
    
    return self;    
}

- (void)dealloc
{
    [_loginId release];
    [_password release];
    [_token release];
    [super dealloc];
}

- (NSString*)getUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_ID];
}

- (void)saveUserId:(NSString*)userId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:KEY_USER_ID];
}

- (void)loginWithLoginId:(NSString *)loginId
                password:(NSString *)password
                   token:(NSString *)token
{
    self.isLogin = YES;
    self.loginId = loginId;
    self.password = password;
    self.token = token;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSNumber numberWithBool:_isAutoLogin]  forKey:KEY_AUTO_LOGIN];
    [userDefaults setObject:[NSNumber numberWithBool:_isRememberLoginId]  forKey:KEY_REMEMBER_LOGIN_ID];
    [userDefaults setObject:[NSNumber numberWithBool:_isRememberPassword]  forKey:KEY_REMEMBER_PASSWORD];

    if (_isAutoLogin) {
        [userDefaults setObject:loginId forKey:KEY_LOGIN_ID];
        [userDefaults setObject:password forKey:KEY_PASSWORD];
    }
    
    if (_isRememberLoginId) {
        [userDefaults setObject:_loginId forKey:KEY_LOGIN_ID];
    }
        
    if (_isRememberPassword) {
        [userDefaults setObject:password forKey:KEY_PASSWORD];
    }
}

- (void)logout
{
    self.isLogin = NO;
    self.loginId = nil;
    self.password = nil;
    self.token = nil;
}


- (BOOL)isLogin
{
    return _isLogin;
}

- (NSString *)loginId;
{
    return _loginId;
}

- (NSString *)password;
{
    return _password;
}

- (NSString *)token
{
    return _token;
}

- (void)setAutoLogin:(BOOL)autoLogin
{
    self.isAutoLogin = autoLogin;
}

- (void)rememberLoginId:(BOOL)remember
{
    self.isRememberLoginId = remember;
}

- (void)rememberPassword:(BOOL)remember
{
    self.isRememberPassword = remember;
}

- (BOOL)isAutoLogin
{
    return _isAutoLogin;
}

- (BOOL)isRememberLoginId
{
    return _isRememberLoginId;
}


- (BOOL)isRememberPassword
{
    return _isRememberPassword;
}




@end
