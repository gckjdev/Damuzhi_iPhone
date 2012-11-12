//
//  AppUtils.h
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

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface AppUtils : NSObject

+ (BOOL)createAllNeededDir;

// For getting app dir.
+ (NSString*)getDownloadDir;
+ (NSString*)getZipDir;
+ (NSString*)getCitiesDir;
+ (NSString*)getAppDir;
+ (NSString*)getHelpDir;
+ (NSString*)getUserDir;

// For getting icons dir
+ (NSString*)getProvidedServiceIconsDir;
+ (NSString*)getRecommendedAppIconsDir;
+ (NSString*)getCategoryIconsDir;

// For favorate data dir
+ (NSString*)getFavoriteDir;

// For history data dir
+ (NSString*)getHistoryDir;

// For follow routes data dir
+ (NSString*)getFollowRoutesDir;

//For follow local routes data dir
+ (NSString*)getFollowLocalRoutesDir;

// Interface for app data file.
+ (NSString*)getAppFilePath;

// For getting city download path.
+ (NSString*)getDownloadPath:(int)cityId;
+ (NSString*)getZipFilePath:(int)cityId;

// Interface to determine if there has local city data.
+ (BOOL)hasLocalCityData:(int)cityId;

// For unzip city data.
+ (BOOL)unzipCityZip:(int)cityId;

// For delete city data.
+ (void)deleteCityData:(int)cityId;

// Interface for unzip flag
+ (NSString*)getUnzipFlag:(int)cityId;

// For getting city data dir.
+ (NSString*)getCityDir:(int)cityId;

// For getting city data file path
+ (NSString*)getCityoverViewFilePath:(int)cityId;
+ (NSString*)getPackageFilePath:(int)cityId;
+ (NSArray*)getPlaceFilePathList:(int)cityId;
+ (NSArray*)getGuideFilePathList:(int)cityId;
+ (NSArray*)getRouteFilePathList:(int)cityId;

// Interface for help file
+ (BOOL)hasLocalHelpHtml;
+ (NSString*)getHelpZipFilePath;
+ (NSString*)getHelpHtmlFilePath;

// For getting icon file path.
+ (NSString*)getProvidedServiceIconPath:(int)providedServiceId;
+ (NSString*)getCategoryIcon:(int)categoryId;
//+ (NSString*)getCategoryIndicatorIcon:(int)categoryId;
+ (NSString*)getCategoryPinIcon:(int)categoryId;
+ (NSString*)getRecommendedAppIconPath:(int)appId;

// For getting favorite file path
+ (NSString*)getFavoriteFilePath:(int)cityId;

// For getting history file path
+ (NSString*)getHistoryFilePath:(int)cityId;
+ (NSString*)getDefaultHistoryFilePath;

// For getting follow routes file path 
+ (NSString *)getFollowRoutesFilePath:(int)type;

// For getting follow local routes file path 
+ (NSString *)getFollowLocalRoutesFilePath;

// For place image showable.
+ (BOOL)isShowImage;
+ (void)enableImageShow:(BOOL)isShow;

// For showing Alert message.
+ (UIAlertView*)showAlertViewWhenUsingCellNetworkForDownloadWithTag:(int)tag delegate:(id)delegate;
+ (UIAlertView*)showDeleteCityDataAlertViewWithTag:(int)tag delegate:(id)delegate;

+ (UIAlertView*)showAlertViewWhenLookingMapWithoutNetwork;

+ (UIAlertView*)showAlertViewWhenUserDenyLocatedServiceWithTag:(int)tag delegate:(id)delegate;
+ (UIAlertView*)showAlertViewWhenUserDenyLocatedService;
+ (UIAlertView*)showAlertViewWhenCannotLocateUserLocation;
+ (void)enableShowUserLocateDenyAlert:(BOOL)isShow;

// for other ...
+ (NSString*)getAbsolutePath:(NSString*)absoluteDir string:(NSString*)string;
+ (NSURL*)getNSURLFromHtmlFileOrURL:(NSString*)fileOrURL;

@end
