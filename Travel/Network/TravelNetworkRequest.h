//
//  TravelNetworkRequest.h
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPNetworkRequest.h"
#import "TravelNetworkConstants.h"

typedef void (^TravelNetworkResponseBlock)(NSDictionary* jsonDictionary, NSData* data, int resultCode);

@interface TravelNetworkRequest : NSObject

+ (CommonNetworkOutput*)submitFeekback:(NSString*)feekback 
                               contact:(NSString*)contact;

+ (CommonNetworkOutput*)registerUser:(int)type 
                               token:(NSString*)deviceToken;

+ (CommonNetworkOutput*)queryList:(int)type 
                           cityId:(int)cityId 
                             lang:(int)lang;

+ (CommonNetworkOutput*)queryList:(int)type 
                             lang:(int)lang;

+ (CommonNetworkOutput*)queryList:(int)type 
                             lang:(int)lang 
                               os:(int)os;

+ (CommonNetworkOutput*)queryList:(int)type 
                          placeId:(int)placeId 
                              num:(int)num 
                             lang:(int)lang;

+ (CommonNetworkOutput*)queryList:(int)type 
                          placeId:(int)placeId
                         distance:(double)distance
                             lang:(int)lang;

+ (CommonNetworkOutput*)queryObject:(int)type 
                              objId:(int)objId 
                               lang:(int)lang;

+ (CommonNetworkOutput*)queryObject:(int)type lang:(int)lang;
+ (CommonNetworkOutput*)addFavoriteByUserId:(NSString *)userId 
                                    placeId:(NSString *)placeId 
                                  longitude:(NSString *)longitude 
                                   latitude:(NSString *)latitude;

+ (CommonNetworkOutput*)deleteFavoriteByUserId:(NSString *)userId 
                                       placeId:(NSString *)placeId;
+ (CommonNetworkOutput*)queryVersion;

+ (CommonNetworkOutput*)queryPlace:(NSString*)userId
                           placeId:(NSString*)placeId;

+ (CommonNetworkOutput*)queryList:(int)type 
                     departCityId:(int)departCityId 
                destinationCityId:(int)destinationCityId
                            start:(int)start
                            count:(int)count
                             lang:(int)lang;

@end
