//
//  AppConstants.h
//  Travel
//
//  Created by 小涛 王 on 12-3-19.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//
//
// App dir struct 
// -----document--------download--------001_ZhHans_1.0.zip
//                |
//                |
//                 -----zip--------001_ZhHans_1.0.zip 
//                |
//                |
//                 -----cities--------1--------xxxx(这里的目录结构参考接口文档)
//                |           |
//                |           |
//                |            -------2--------xxxx
//                |  
//                 -----app---------app.dat
//                |           |
//                |           |
//                |            -----icon-------providedService-------xxx.icon
//                |                        |
//                |                        |
//                |                         ---recommendApp----------xxx.icon
//                |                        |
//                |                        |
//                |                         ---category--------------xxx.icon
//                |   
//                 -----help---------helpinfo.html
//                |   
//                 -----user---------favorite--------xxx.dat
//                            |
//                            |
//                             ------history---------xxx.dat


#ifndef Travel_AppConstants_h
#define Travel_AppConstants_h

#define FILENAME_OF_APP_DATA                @"app.dat"          // in bundle
#define FILENAME_OF_HELP_ZIP                @"help.zip"
//#define DEFAULT_CITY_ZIP                    @"1.zip"            //in bundle

#define DIR_OF_DOWNLOAD                     @"download"
#define DIR_OF_ZIP                          @"zip"   
#define DIR_OF_CITIES                       @"cities"
#define DIR_OF_APP                          @"app"
#define DIR_OF_HELP                         @"help"
#define DIR_OF_USER                         @"user"

#define DIR_OF_PROVIDED_SERVICE_ICON        @"app/icons/providedService"
#define DIR_OF_RECOMMENDED_APP_ICON         @"app/icons/recommendedApp/"
#define DIR_OF_CATEGORY_ICON                @"app/icons/category"

#define DIR_OF_FAVORITE                     @"app/user/favorite/"
#define DIR_OF_HISTORY                      @"app/user/history/"
#define DIR_OF_FOLLOW_ROUTES                @"app/user/followRoutes/"
#define DIR_OF_FOLLOW_LOCAL_ROUTES          @"app/user/followLocalRoutes/"

// Under city dir, relative.
#define FLAG_OF_UNZIP_SUCCESS               @"unzip_success" 
#define FILENAME_OF_CITY_OVERVIEW_DATA      @"overview.dat"
#define FILENAME_OF_PACKAGE_DATA            @"package.dat"
#define DIR_OF_PLACE_DATA                   @"place/"
#define DIR_OF_GUIDE_DATA                   @"tips/guides/"
#define DIR_OF_ROUTE_DATA                   @"tips/routes/"

//
#define FAVORITE_PLACE_FILE         @"favorite_place.dat"
#define HISTORY_PLACE_FILE          @"history_place.dat"
#define PLACE_STORAGE_DEFAULT_DIR   @"save_place_data"

// Under help dir.
#define FILENAME_OF_HELP_HTML               @"helpinfo.html"

#define DEFAULT_CITY_ID                     1   // 1 for @"香港"
#define KEY_CURRENT_CITY                    @"current_city"

#define KEY_IS_SHOW_IMAGE                   @"KEY_IS_SHOW_IMAGE"

#define ALERT_USING_CELL_NEWORK 1
#define ALERT_DELETE_CITY 2
#define ALERT_CANCEL_UPDATE_CITT 3

#define ALL_CATEGORY   (-1)

// 地点排序方式
enum{
    SORT_BY_RECOMMEND = 1,
    SORT_BY_DESTANCE_FROM_NEAR_TO_FAR = 2,
    SORT_BY_DESTANCE_FROM_FAR_TO_NEAR = 3,
    SORT_BY_PRICE_FROM_EXPENSIVE_TO_CHEAP = 4,
    SORT_BY_PRICE_FROM_CHEAP_TO_EXPENSIVE = 5,
    SORT_BY_HOTEL_STARTS = 6
};

// 线路排序方式
enum{
    ROUTE_SORT_BY_DEFAULT = 1,
    ROUTE_SORT_BY_FOLLOW_COUNT_FROM_MORE_TO_LESS = 2,
    ROUTE_SORT_BY_SORT_BY_RECOMMEND = 3,
    ROUTE_SORT_BY_PRICE_FROM_CHEAP_TO_EXPENSIVE = 4,
    ROUTE_SORT_BY_PRICE_FROM_EXPENSIVE_TO_CHEAP = 5,    
    ROUTE_SORT_BY_DAYS_FROM_MORE_TO_LESS = 6,
    ROUTE_SORT_BY_DAYS_FROM_LESS_TO_MORE = 7
};

enum{
    PRICE_BELOW_1500 = 1,
    PRICE_1500_4000 = 2,
    PRICE_MORE_THAN_4000 = 3
};

enum{
    DAYS_1_3 = 1,
    DAYS_3_8 = 2,
    DAYS_MORE_THAN_8 = 3
};


#endif
