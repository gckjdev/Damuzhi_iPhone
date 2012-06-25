//
//  UserService.m
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserService.h"
#import "UserManager.h"
#import "TravelNetworkRequest.h"
#import "JSON.h"
#import "LogUtil.h"

@implementation UserService

static UserService* _defaultUserService = nil;

+ (UserService*)defaultService
{
    if (_defaultUserService == nil) {
        _defaultUserService = [[UserService alloc] init];
    }
    return _defaultUserService;
}

- (void)autoRegisterUser:(NSString*)deviceToken
{
    // if user exists locally then return, else send a registration to server
    if ([[UserManager defaultManager] getUserId]) {
        return;
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            CommonNetworkOutput *output = [TravelNetworkRequest registerUser:OBJECT_TYPE_USER_RIGISTER token:deviceToken];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (output.textData != nil) {
                    NSDictionary* jsonDict = [output.textData JSONValue];
                    NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
                    
                    if (0 == result.intValue){
                        NSString *userId = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_USER_ID];
                        [[UserManager defaultManager] saveUserId:userId];
                    }else {
                        PPDebug(@"<UserService> autoRegisterUser faild,result:%d", result.intValue);
                    }
                }else {
                    PPDebug(@"<UserService>autoRegisterUser:　Get User ID faild");
                }
            });                        
        });
    }
}


- (void)queryVersion:(id<UserServiceDelegate>)delegate;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CommonNetworkOutput *output = [TravelNetworkRequest queryVersion];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS) {
                NSDictionary* jsonDict = [output.textData JSONValue];
                NSString *app_version = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_APP_VERSION];
                NSString *app_data_version = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_APP_DATA_VERSION];
                
                if (delegate && [delegate respondsToSelector:@selector(queryVersionFinish:dataVersion:)]) {
                    [delegate queryVersionFinish:app_version dataVersion:app_data_version];
                }
            }
        });                        
    });

}

- (void)submitFeekback:(id<UserServiceDelegate>)delegate
              feekback:(NSString*)feekback
               contact:(NSString*)contact
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest submitFeekback:feekback contact:contact];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(submitFeekbackDidFinish:)]) {
                 [delegate submitFeekbackDidFinish:(output.resultCode)];
            }
        });                        
    });
}

- (void)autoLogin:(id<UserServiceDelegate>)delegate
{
    if ([[UserManager defaultManager] isAutoLogin]) {
            [self login:[[UserManager defaultManager] loginId] password:[[UserManager defaultManager] password] delegate:delegate];
    }
}

- (void)login:(NSString *)loginId
     password:(NSString *)password
     delegate:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest login:loginId password:password];   
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            NSString *token = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_TOKEN];
            [[UserManager defaultManager] loginWithLoginId:loginId password:password token:token];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(loginDidFinish:)]) {
                [delegate loginDidFinish:output.resultCode];
            }
        });                        
    });
}

- (void)logout:(NSString *)loginId 
         token:(NSString *)token
{
    [[UserManager defaultManager] logout];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        CommonNetworkOutput *output = [TravelNetworkRequest logout:loginId token:token];   
        [TravelNetworkRequest logout:loginId token:token];   
    });
}

- (void)signUp:(NSString *)loginId 
      password:(NSString *)password 
      delegate:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest signUp:loginId password:password];
        
        NSDictionary* jsonDict = [output.textData JSONValue];
        int result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
        NSString *resultInfo = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(signUpDidFinish:result:resultInfo:)]) {
                [delegate signUpDidFinish:output.resultCode result:result resultInfo:resultInfo];
            }
        });                        
    });
}

- (void)verificate:(NSString *)loginId
         telephone:(NSString *)telephone
          delegate:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest verificate:loginId telephone:telephone];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(verificationDidSend:)]) {
                [delegate verificationDidSend:output.resultCode];
            }
        });
    });
}

- (void)verificate:(NSString *)loginId 
              code:(NSString *)code 
          delegate:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest verificate:loginId code:code];   
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(verificationDidFinish:)]) {
                [delegate verificationDidFinish:output.resultCode];
            }
        });
    });
}

- (void)retrievePassword:(NSString *)loginId 
               telephone:(NSString *)telephone 
                delegate:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest retrievePassword:loginId telephone:telephone];   
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(retrievePasswordDidSend:)]) {
                [delegate retrievePasswordDidSend:output.resultCode];
            }
        });
    });
}

- (void)modifyUserInfo:(NSString *)loginId
                 token:(NSString *)token 
              fullName:(NSString *)fullName
              nickName:(NSString *)nickName
                gender:(int)gender
             telephone:(NSString *)telephone
                 email:(NSString *)email
               address:(NSString *)address
{
    

}

- (void)modifyPassword:(NSString *)loginId
                 token:(NSString *)token 
           oldPassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
{
    
}

- (void)retrieveUserInfo:(NSString *)loginId
                   token:(NSString *)token
{
    
}

@end
