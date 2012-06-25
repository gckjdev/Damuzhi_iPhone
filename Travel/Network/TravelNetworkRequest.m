//
//  TravelNetworkRequest.m
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TravelNetworkRequest.h"
#import "StringUtil.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "UIDevice+IdentifierAddition.h"
#import "UserManager.h"
#import "PPDebug.h"
#import "UIDevice+IdentifierAddition.h"

@implementation TravelNetworkRequest

+ (CommonNetworkOutput*)sendRequest:(NSString*)baseURL
                constructURLHandler:(ConstructURLBlock)constructURLHandler
                    responseHandler:(TravelNetworkResponseBlock)responseHandler
                       outputFormat:(int)outputFormat
                             output:(CommonNetworkOutput*)output
{  
    NSURL* url = nil;    
    if (constructURLHandler != NULL)
        url = [NSURL URLWithString:[constructURLHandler(baseURL) stringByURLEncode]];
    else
        url = [NSURL URLWithString:baseURL];        
    
    if (url == nil){
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setAllowCompressedResponse:YES];
    [request setTimeOutSeconds:NETWORK_TIMEOUT];
    
#ifdef DEBUG    
    int startTime = time(0);
    PPDebug(@"[SEND] URL=%@", [url description]);    
#endif
    
    [request startSynchronous];
    //    BOOL *dataWasCompressed = [request isResponseCompressed]; // Was the response gzip compressed?
    //    NSData *compressedResponse = [request rawResponseData]; // Compressed data    
    //    NSData *uncompressedData = [request responseData]; // Uncompressed data
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
#ifdef DEBUG    
    PPDebug(@"[RECV] : status=%d, error=%@", [request responseStatusCode], [error description]);
#endif    
    
    if (error != nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (statusCode != 200){
        output.resultCode = statusCode;
    }
    else{

#ifdef DEBUG
        int endTime = time(0);
        PPDebug(@"[RECV] data (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)", 
              [[request responseData] length], (endTime - startTime),
              [[request rawResponseData] length], [[request responseData] length]);
#endif         

        if (outputFormat == FORMAT_TRAVEL_PB){
            responseHandler(nil, [request responseData], output.resultCode);               
            output.responseData = [request responseData];
        }
        else{
            NSString *text = [request responseString];
            NSDictionary *jsonDictionary = nil;
            output.textData = text;
            if ([text length] > 0){   
                jsonDictionary = [text JSONValue];
            }
#ifdef DEBUG
            PPDebug(@"[RECV] JSON string data : %@", text);
#endif            

            responseHandler(jsonDictionary, nil, output.resultCode);       
        }

        return output;
    }
    
    return output;
}

+ (CommonNetworkOutput*)submitFeekback:(NSString*)feekback
                               contact:(NSString*)contact
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_USER_ID value:[[UserManager defaultManager] getUserId]];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CONTACT 
                                       value:[contact stringByURLEncode]];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CONTENT 
                                       value:[feekback stringByURLEncode]];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_SUBMIT_FEEKBACK
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

+ (CommonNetworkOutput*)registerUser:(int)type
                               token:(NSString*)deviceToken
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        NSString* deviceId = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
        NSString *macAdress = [[UIDevice currentDevice] performSelector:@selector(macAdress)];
        NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DEVICE_TOKEN value:deviceToken];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DEVICE_ID value:deviceId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_MAC_ADRESS value:macAdress];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_APP_VERSION value:appVersion];

        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_REGISTER_USER
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

+ (CommonNetworkOutput*)queryList:(int)type 
                           cityId:(int)cityId 
                             lang:(int)lang
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CITY_ID intValue:cityId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_LIST
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}

+ (CommonNetworkOutput*)queryList:(int)type 
                           cityId:(int)cityId
                            start:(int)start
                            count:(int)count
                             lang:(int)lang 
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CITY_ID intValue:cityId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_START intValue:start];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_COUNT intValue:count];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];

        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_LIST
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}

+ (CommonNetworkOutput*)queryList:(int)type
                             lang:(int)lang
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_LIST
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}

+ (CommonNetworkOutput*)queryList:(int)type 
                             lang:(int)lang
                               os:(int)os
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_OS intValue:os];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode){  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_LIST
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}

+ (CommonNetworkOutput*)queryList:(int)type
                          placeId:(int)placeId
                              num:(int)num 
                             lang:(int)lang
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_PLACE_ID intValue:placeId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_NUM intValue:num];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_LIST
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}

+ (CommonNetworkOutput*)queryList:(int)type
                          placeId:(int)placeId 
                         distance:(double)distance
                             lang:(int)lang
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_PLACE_ID intValue:placeId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DISTANCE doubleValue:distance];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_LIST
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}

+ (CommonNetworkOutput*)queryObject:(int)type 
                              objId:(int)objId 
                               lang:(int)lang
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_ID intValue:objId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_OBJECT
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}


+ (CommonNetworkOutput*)queryObject:(int)type
                               lang:(int)lang
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_OBJECT
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}



+ (CommonNetworkOutput*)addFavoriteByUserId:(NSString *)userId
                                    placeId:(NSString *)placeId 
                                  longitude:(NSString *)longitude
                                   latitude:(NSString *)latitude
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_USER_ID value:userId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_PLACE_ID value:placeId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LONGITUDE value:longitude];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LATITUDE value:latitude];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_ADD_FAVORITE
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

+ (CommonNetworkOutput*)deleteFavoriteByUserId:(NSString *)userId 
                                       placeId:(NSString *)placeId
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_USER_ID value:userId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_PLACE_ID value:placeId];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_DELETE_FAVORITE
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

+ (CommonNetworkOutput*)queryVersion
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        NSString* str = [NSString stringWithString:baseURL];        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_VERSION
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

+ (CommonNetworkOutput*)queryPlace:(NSString*)userId
                           placeId:(NSString*)placeId;
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_USER_ID value:userId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_PLACE_ID value:placeId];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_PLACE
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}


+ (CommonNetworkOutput*)queryList:(int)type 
                     departCityId:(int)departCityId 
                destinationCityId:(int)destinationCityId
                            start:(int)start
                            count:(int)count
                             lang:(int)lang
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
    
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DEPART_CITY_ID intValue:departCityId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DESTINATION_CITY_ID intValue:destinationCityId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_START intValue:start];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_COUNT intValue:count];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LANG intValue:lang];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_QUERY_LIST
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_PB
                                      output:output];
}


+ (CommonNetworkOutput*)login:(NSString *)loginId
                     password:(NSString *)password
{
    return nil;
}

+ (CommonNetworkOutput*)logout:(NSString *)loginId 
                         token:(NSString *)token
{
    return nil;
}

+ (CommonNetworkOutput*)signUp:(NSString *)loginId
                      password:(NSString *)password 
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LOGIN_ID value:loginId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_PASSWORD value:password];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_OS intValue:OS_IOS];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_MEMBER_REGISTER
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

+ (CommonNetworkOutput*)verificate:(NSString *)loginId
                         telephone:(NSString *)telephone 
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LOGIN_ID value:loginId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TELEPHONE value:telephone];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_MEMBER_VERIFICATION
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}


+ (CommonNetworkOutput*)verificate:(NSString *)loginId 
                              code:(NSString *)code
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LOGIN_ID value:loginId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CODE value:code];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_MEMBER_VERIFICATION
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}


+ (CommonNetworkOutput*)retrievePassword:(NSString *)loginId
                               telephone:(NSString *)telephone
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LOGIN_ID value:loginId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TELEPHONE value:telephone];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_RETRIEVE_PASSWORD
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

+ (CommonNetworkOutput*)modifyUserInfo:(NSString *)loginId
                            token:(NSString *)token 
                         fullName:(NSString *)fullName
                         nickName:(NSString *)nickName
                           gender:(int)gender
                        telephone:(NSString *)telephone
                            email:(NSString *)email
                          address:(NSString *)address
{
    return nil;
}

+ (CommonNetworkOutput*)modifyPassword:(NSString *)loginId
                            token:(NSString *)token 
                      oldPassword:(NSString *)oldPassword
                      newPassword:(NSString *)newPassword
{
    return nil;
}

+ (CommonNetworkOutput*)retrieveUserInfo:(NSString *)loginId
                          token:(NSString *)token
{
    return nil;
}

+ (CommonNetworkOutput*)placeOrderWithUserId:(NSString *)userId 
                                     routeId:(int)routeId
                                   packageId:(int)packageId
                                  departDate:(int)departDate
                                       adult:(int)adult
                                    children:(int)children
                               contactPerson:(NSString *)contactPersion
                                   telephone:(NSString *)telephone
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_USER_ID value:userId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_ROUTE_ID intValue:routeId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_PACKAGE_ID intValue:packageId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DEPART_DATE intValue:departDate];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CHILDREN intValue:children];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CONTACT_PERSION value:contactPersion];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TELEPHONE value:telephone];

        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_MEMBER_REGISTER
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}


+ (CommonNetworkOutput*)placeOrderWithLoginId:(NSString *)loginId 
                                        token:(NSString *)token
                                      routeId:(int)routeId
                                    packageId:(int)packageId
                                   departDate:(int)departDate
                                        adult:(int)adult
                                     children:(int)children
                                contactPerson:(NSString *)contactPersion
                                    telephone:(NSString *)telephone
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_LOGIN_ID value:loginId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TOKEN value:token];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_ROUTE_ID intValue:routeId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_PACKAGE_ID intValue:packageId];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DEPART_DATE intValue:departDate];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CHILDREN intValue:children];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_CONTACT_PERSION value:contactPersion];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TELEPHONE value:telephone];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_MEMBER_REGISTER
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

@end
