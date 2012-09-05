//
//  TravelNetworkConstants.h
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Travel_TravelNetworkConstants_h
#define Travel_TravelNetworkConstants_h

#define OS_IOS 1

// for test service
//#define URL_SERVICE                 @"http://59.34.17.68:8012/service/"

// for formal service
#define URL_SERVICE                 @"http://api.trip8888.com/service/"
//#define URL_SERVICE                 @"http://61.143.225.198:8012/Service/"

// URL
#define URL_TRAVEL_REGISTER_USER    (URL_SERVICE@"RegisterUser.aspx?")

//query place list
#define URL_TRAVEL_QUERY_LIST       (URL_SERVICE@"queryList.aspx?")
#define URL_TRAVEL_QUERY_OBJECT     (URL_SERVICE@"queryObject.aspx?")

#define URL_TRAVEL_ADD_FAVORITE     (URL_SERVICE@"addFavorite.aspx?")

#define URL_TRAVEL_DELETE_FAVORITE  (URL_SERVICE@"deleteFavorite.aspx?") 
#define URL_TRAVEL_QUERY_PLACE      (URL_SERVICE@"queryPlace.aspx?") 

#define URL_TRAVEL_QUERY_VERSION    (URL_SERVICE@"iphoneVersion.txt")
#define URL_TRAVEL_SUBMIT_FEEKBACK  (URL_SERVICE@"feedback.aspx?")

#define URL_TRAVEL_MEMBER_REGISTER      (URL_SERVICE@"memberRegister.aspx?")
#define URL_TRAVEL_MEMBER_VERIFICATION  (URL_SERVICE@"memberVerification.aspx?")
#define URL_TRAVEL_RETRIEVE_PASSWORD  (URL_SERVICE@"retrievePassword.aspx?")
#define URL_TRAVEL_PLACE_ORDER  (URL_SERVICE@"placeOrder.aspx?")


// Output Format
#define FORMAT_TRAVEL_JSON          1
#define FORMAT_TRAVEL_PB            2   // protocol buffer

// request & reponse parameters (HTTP / JSON)
#define PARA_TRAVEL_USER_ID         @"userId"
#define PARA_TRAVEL_LOGIN_ID        @"loginId"
#define PARA_TRAVEL_PASSWORD        @"password"
#define PARA_TRAVEL_TOKEN           @"token"
#define PARA_TRAVEL_TYPE            @"type"
#define PARA_TRAVEL_DEVICE_TOKEN    @"deviceToken"
#define PARA_TRAVEL_RESULT          @"result"
#define PARA_TRAVEL_DEVICE_ID       @"deviceId"
#define PARA_TRAVEL_MAC_ADRESS      @"macAdress"
#define PARA_TRAVEL_ID              @"id"

#define PARA_TRAVEL_CONTACT         @"contact"
#define PARA_TRAVEL_CONTENT         @"content"

#define PARA_TRAVEL_CITY_ID         @"cityId"
#define PARA_TRAVEL_ID              @"id"
#define PARA_TRAVEL_LANG            @"lang"
#define PARA_TRAVEL_OS              @"os"

#define PARA_TRAVEL_PLACE_ID        @"placeId"
#define PARA_TRAVEL_LONGITUDE       @"longitude"
#define PARA_TRAVEL_LATITUDE        @"latitude"

#define PARA_TRAVEL_NUM             @"num"
#define PARA_TRAVEL_DISTANCE        @"distance"

#define PARA_TRAVEL_DEPART_CITY_ID          @"departCityId"
#define PARA_TRAVEL_DESTINATION_CITY_ID     @"destinationCityId"
#define PARA_TRAVEL_START                   @"start"
#define PARA_TRAVEL_COUNT                   @"count"


#define PARA_TRAVEL_PLACE_FAVORITE_COUNT    @"placeFavoriteCount"
#define PARA_TRAVEL_APP_VERSION             @"app_version"
#define PARA_TRAVEL_APP_DATA_VERSION        @"app_data_version"

#define PARA_TRAVEL_TELEPHONE               @"telephone"
#define PARA_TRAVEL_CODE                    @"code"

#define PARA_TRAVEL_RESULT                  @"result"
#define PARA_TRAVEL_RESULT_INFO             @"resultInfo"

#define PARA_TRAVEL_ROUTE_ID                @"routeId"
#define PARA_TRAVEL_PACKAGE_ID              @"packageId"
#define PARA_TRAVEL_DEPART_DATE             @"departDate"
#define PARA_TRAVEL_ADULT                   @"adult"
#define PARA_TRAVEL_CHILDREN                @"children"
#define PARA_TRAVEL_CONTACT_PERSION         @"contactPersion"

// For object list
#define OBJECT_LIST_TYPE_ALL_PLACE       1
#define OBJECT_LIST_TYPE_SPOT            21
#define OBJECT_LIST_TYPE_HOTEL           22
#define OBJECT_LIST_TYPE_RESTAURANT      23
#define OBJECT_LIST_TYPE_SHOPPING        24
#define OBJECT_LIST_TYPE_ENTERTAINMENT   25

#define OBJECT_LIST_TYPE_ALL_NEARBY_PLACE       50
#define OBJECT_LIST_TYPE_NEARBY_SPOT            51
#define OBJECT_LIST_TYPE_NEARBY_HOTEL           52
#define OBJECT_LIST_TYPE_NEARBY_RESTAURANT      53
#define OBJECT_LIST_TYPE_NEARBY_SHOPPING        54
#define OBJECT_LIST_TYPE_NEARBY_ENTERTAINMENT   55

#define OBJECT_LIST_TYPE_ALL_NEARBY_10KM_PLACE       60
#define OBJECT_LIST_TYPE_NEARBY_10KM_SPOT            61
#define OBJECT_LIST_TYPE_NEARBY_10KM_HOTEL           62
#define OBJECT_LIST_TYPE_NEARBY_10KM_RESTAURANT      63
#define OBJECT_LIST_TYPE_NEARBY_10KM_SHOPPING        64
#define OBJECT_LIST_TYPE_NEARBY_10KM_ENTERTAINMENT   65

#define OBJECT_LIST_TYPE_TRAVEL_GUIDE    5
#define OBJECT_LIST_TYPE_TRAVEL_ROUTE    6

#define OBJECT_LIST_TOP_FAVORITE_ALL                40
#define OBJECT_LIST_TOP_FAVORITE_SPOT               41
#define OBJECT_LIST_TOP_FAVORITE_HOTEL              42
#define OBJECT_LIST_TOP_FAVORITE_RESTAURANT         43
#define OBJECT_LIST_TOP_FAVORITE_SHOPPING           44
#define OBJECT_LIST_TOP_FAVORITE_ENTERTAINMENT      45

#define OBJECT_LIST_ROUTE_PACKAGE_TOUR              70
#define OBJECT_LIST_ROUTE_UNPACKAGE_TOUR            71
#define OBJECT_LIST_ROUTE_SELF_GUIDE_TOUR           72

#define OBJECT_LIST_ROUTE_FEEKBACK                  75


#define OBJECT_LIST_PACKAGE_TOUR_ORDER              80
#define OBJECT_LIST_UNPACKAGE_TOUR_ORDER            81
#define OBJECT_LIST_SELF_GUIDE_TOUR_ORDER           82


#define OBJECT_LIST_CITY_IMAGE                      90

// For object type
#define OBJECT_TYPE_USER_RIGISTER               1
#define OBJECT_TYPE_CITY_BASIC                  2
#define OBJECT_TYPE_TRAVEL_PREPARATION          3
#define OBJECT_TYPE_TRAVEL_TRANSPORTATION       4     
#define OBJECT_TYPE_TRAVEL_UTILITY              5
#define OBJECT_TYPE_HELP_INOF                   8
#define OBJECT_TYPE_APP_DATA                    10
#define OBJECT_TYPE_ROUTE_DETAIL                50

#endif
