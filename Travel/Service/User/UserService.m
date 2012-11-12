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
#import "LocaleUtils.h"

#define SERVICE_ERROR_NO_INFO NSLS(@"服务器响应失败,未返回错误信息")

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
//    // if user exists locally then return, else send a registration to server
//    if ([[UserManager defaultManager] getUserId]) {
//        return;
//    }
//    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            CommonNetworkOutput *output = [TravelNetworkRequest registerUser:1 token:deviceToken];
            
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
//    }
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
                
                NSString *app_update_title = (NSString *)[jsonDict objectForKey:PARA_TRAVEL_APP_UPDATE_TITLE];
                NSString *app_update_content = (NSString *)[jsonDict objectForKey:PARA_TRAVEL_APP_UPDATE_CONTENT];
                
                if (delegate && [delegate respondsToSelector:@selector(queryVersionFinish:dataVersion:title:content:)]) {
                    [delegate queryVersionFinish:app_version dataVersion:app_data_version title:app_update_title content:app_update_content];
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
        
        int result = -1;
        NSString *resultInfo;
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
            NSString *token = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_TOKEN];
            if (resultInfo == nil) {
                resultInfo = SERVICE_ERROR_NO_INFO;
            }
            
            if (result == 0) {
                [[UserManager defaultManager] loginWithLoginId:loginId password:password token:token];
            }
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(loginDidFinish:result:resultInfo:)]) {
                [delegate loginDidFinish:output.resultCode result:result resultInfo:resultInfo];
            }
        });                        
    });
}

- (void)logout:(id<UserServiceDelegate>)delegate
 
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *loginId = [[UserManager defaultManager] loginId];
        NSString *token = [[UserManager defaultManager] token];
        
        [TravelNetworkRequest logout:loginId token:token];
                
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(loginoutDidFinish:result:resultInfo:)]) {
                [[UserManager defaultManager] logout];
                [delegate loginoutDidFinish:0 result:0 resultInfo:nil];
            }
        });  
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
        if (resultInfo == nil) {
            resultInfo = SERVICE_ERROR_NO_INFO;
        }

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
        
        NSDictionary* jsonDict = [output.textData JSONValue];
        int result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
        NSString *resultInfo = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        if (resultInfo == nil) {
            resultInfo = SERVICE_ERROR_NO_INFO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(verificationDidSend:result:resultInfo:)]) {
                [delegate verificationDidSend:output.resultCode result:result resultInfo:resultInfo];
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
        
        NSDictionary* jsonDict = [output.textData JSONValue];
        int result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
        NSString *resultInfo = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        if (resultInfo == nil) {
            resultInfo = SERVICE_ERROR_NO_INFO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(verificationDidFinish:result:resultInfo:)]) {
                [delegate verificationDidFinish:output.resultCode result:result resultInfo:resultInfo];
            }
        });
    });
}

- (void)retrievePassword:(NSString *)telephone 
                delegate:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest retrievePassword:telephone];   
        
        NSDictionary* jsonDict = [output.textData JSONValue];
        int result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
        NSString *resultInfo = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        if (resultInfo == nil) {
            resultInfo = SERVICE_ERROR_NO_INFO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(retrievePasswordDidSend:result:resultInfo:)]) {
                [delegate retrievePasswordDidSend:output.resultCode result:result resultInfo:resultInfo];
            }
        });
    });
}

- (void)modifyUserFullName:(NSString *)fullName
                  nickName:(NSString *)nickName
                    gender:(int)gender
                 telephone:(NSString *)telephone
                     email:(NSString *)email
                   address:(NSString *)address
                  delegate:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *loginId = [[UserManager defaultManager] loginId];
        NSString *token = [[UserManager defaultManager] token];
        CommonNetworkOutput *output = [TravelNetworkRequest modifyUserInfo:loginId
                                                                     token:token
                                                                  fullName:fullName
                                                                  nickName:nickName
                                                                    gender:gender
                                                                 telephone:telephone
                                                                     email:email
                                                                   address:address];   
        
        NSDictionary* jsonDict = [output.textData JSONValue];
        int result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
        NSString *resultInfo = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        if (resultInfo == nil) {
            resultInfo = SERVICE_ERROR_NO_INFO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(modifyPasswordDidDone:result:resultInfo:)]) {
                [delegate modifyPasswordDidDone:output.resultCode result:result resultInfo:resultInfo];
            }
        });
    });
}

- (void)modifyPassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
              delegate:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *loginId = [[UserManager defaultManager] loginId];
        NSString *token = [[UserManager defaultManager] token];
        CommonNetworkOutput *output = [TravelNetworkRequest modifyPassword:loginId 
                                                                     token:token 
                                                               oldPassword:oldPassword 
                                                               newPassword:newPassword];   
        
        NSDictionary* jsonDict = [output.textData JSONValue];
        int result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
        NSString *resultInfo = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        if (resultInfo == nil) {
            resultInfo = SERVICE_ERROR_NO_INFO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(modifyPasswordDidDone:result:resultInfo:)]) {
                [delegate modifyPasswordDidDone:output.resultCode result:result resultInfo:resultInfo];
            }
        });
    });
}

- (void)retrieveUserInfo:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *loginId = [[UserManager defaultManager] loginId];
        NSString *token = [[UserManager defaultManager] token];
        CommonNetworkOutput *output = [TravelNetworkRequest retrieveUserInfo:loginId token:token];   
        
        TravelResponse *travelResponse = nil;
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
                UserInfo *userInfo = [travelResponse userInfo];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([delegate respondsToSelector:@selector(retrieveUserInfoDidDone:userInfo:)]) {
                        [delegate retrieveUserInfoDidDone:output.resultCode userInfo:userInfo];
                    }
                });
            }
            @catch (NSException *exception){
                PPDebug(@"<atch exception in retrieveUserInfo>");
            }
        }
    }); 

}

@end
