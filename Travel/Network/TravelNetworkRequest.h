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
                           cityId:(int)cityId 
                            start:(int)start
                            count:(int)count
                   subCategoryIds:(NSArray *)subCategoryIds
                          areaIds:(NSArray *)areaIds
                       serviceIds:(NSArray *)serviceIds
                     priceRankIds:(NSArray *)priceRankIds
                      sortTypeIds:(NSArray *)sortTypeIds
                   needStatistics:(BOOL)needStatistics
                             lang:(int)lang;

+ (CommonNetworkOutput*)queryList:(int)type 
                           cityId:(int)cityId
                            start:(int)start
                            count:(int)count
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
                            start:(int)start
                            count:(int)count
                 departCityIdList:(NSArray *)departCityIdList 
            destinationCityIdList:(NSArray *)destinationCityIdList 
                     agencyIdList:(NSArray *)agencyIdList 
                  priceRankIdList:(NSArray *)priceRankIdList
                  daysRangeIdList:(NSArray *)daysRangeIdList 
                      themeIdList:(NSArray *)themeIdList 
                     sortTypeList:(NSArray *)sortTypeList 
                   needStatistics:(BOOL)needStatistics
                             lang:(int)lang 
                             test:(BOOL)test;

+ (CommonNetworkOutput*)login:(NSString *)loginId 
                     password:(NSString *)password;

+ (CommonNetworkOutput*)logout:(NSString *)loginId
                         token:(NSString *)token;

+ (CommonNetworkOutput*)signUp:(NSString *)loginId
                      password:(NSString *)password;

+ (CommonNetworkOutput*)verificate:(NSString *)loginId 
                         telephone:(NSString *)telephone;

+ (CommonNetworkOutput*)verificate:(NSString *)loginId
                              code:(NSString *)code;

+ (CommonNetworkOutput*)retrievePassword:(NSString *)telephone;

+ (CommonNetworkOutput*)modifyPassword:(NSString *)loginId
                                 token:(NSString *)token 
                           oldPassword:(NSString *)oldPassword
                           newPassword:(NSString *)newPassword;

+ (CommonNetworkOutput*)retrieveUserInfo:(NSString *)loginId
                                   token:(NSString *)token;

+ (CommonNetworkOutput*)modifyUserInfo:(NSString *)loginId
                                 token:(NSString *)token 
                              fullName:(NSString *)fullName
                              nickName:(NSString *)nickName
                                gender:(int)gender
                             telephone:(NSString *)telephone
                                 email:(NSString *)email
                               address:(NSString *)address;

+ (CommonNetworkOutput*)placeOrderWithUserId:(NSString *)userId 
                                     routeId:(int)routeId
                                   packageId:(int)packageId
                                  departDate:(NSString *)departDate
                                       adult:(int)adult
                                    children:(int)children
                               contactPerson:(NSString *)contactPersion
                                   telephone:(NSString *)telephone;

+ (CommonNetworkOutput*)placeOrderWithLoginId:(NSString *)loginId 
                                        token:(NSString *)token
                                      routeId:(int)routeId
                                    packageId:(int)packageId
                                   departDate:(NSString *)departDate
                                        adult:(int)adult
                                     children:(int)children
                                contactPerson:(NSString *)contactPersion
                                    telephone:(NSString *)telephone;

+ (CommonNetworkOutput*)queryList:(int)type
                           userId:(NSString *)userId
                             lang:(int)lang;

+ (CommonNetworkOutput*)queryList:(int)type
                          loginId:(NSString *)loginId
                            token:(NSString *)token
                             lang:(int)lang;

+ (CommonNetworkOutput*)queryList:(int)type
                          routeId:(int)routeId
                            start:(int)start
                            count:(int)count
                             lang:(int)lang;

+ (CommonNetworkOutput*)followRoute:(NSString *)userId 
                            loginId:(NSString *)loginId 
                              token:(NSString *)token 
                            routeId:(int)routeId;

+ (CommonNetworkOutput*)routeFeedback:(NSString *)loginId 
                                token:(NSString *)token 
                              routeId:(int)routeId 
                              orderId:(int)orderId
                                 rank:(int)rank 
                              content:(NSString *)content;

+ (CommonNetworkOutput*)localRouteOrderWithUserId:(NSString *)userId 
                                          routeId:(int)routeId
                                    departPlaceId:(int)departPlaceId
                                       departDate:(NSString *)departDate
                                            adult:(int)adult
                                         children:(int)children
                                    contactPerson:(NSString *)contactPersion
                                        telephone:(NSString *)telephone;

+ (CommonNetworkOutput*)localRouteOrderWithLoginId:(NSString *)loginId 
                                             token:(NSString *)token
                                           routeId:(int)routeId
                                     departPlaceId:(int)departPlaceId
                                        departDate:(NSString *)departDate
                                             adult:(int)adult
                                          children:(int)children
                                     contactPerson:(NSString *)contactPersion
                                         telephone:(NSString *)telephone;

+ (CommonNetworkOutput*)queryNearbyList:(int)type
                                 cityId:(int)cityId
                               latitude:(double)latitude
                              longitude:(double)longitude
                               distance:(double)distance
                                  start:(int)start
                                  count:(int)count
                                   lang:(int)lang;

+ (CommonNetworkOutput*)queryList:(int)type
                           cityId:(int)cityId
                      checkInDate:(NSString *)checkInDate
                     checkOutDate:(NSString *)checkOutDate
                            start:(int)start
                            count:(int)count
                             lang:(int)lang;

+ (CommonNetworkOutput*)orderAirHotel:(NSData *)data;

+ (CommonNetworkOutput*)queryList:(int)type
                     departCityId:(int)departCityId
                destinationCityId:(int)destinationCityId
                       departDate:(NSString *)departDate
                       flightType:(int)flightType
                     flightNumber:(NSString *)flightNumber
                             lang:(int)lang;

@end
