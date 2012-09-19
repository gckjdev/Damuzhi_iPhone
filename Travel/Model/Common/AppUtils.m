//
//  AppUtils.m
//  Travel
//
//  Created by 小涛 王 on 12-3-19.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "AppUtils.h"
#import "AppConstants.h"
#import "FileUtil.h"
#import "SSZipArchive.h"
#import "PPDebug.h"
#import "LocaleUtils.h"
#import "AppConstants.h"
#import "App.pb.h"

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

@implementation AppUtils

static BOOL _showUserLocateDenyAlert = YES;

+ (BOOL)createAllNeededDir
{
    BOOL success = [FileUtil createDir:[self getDownloadDir]]
    && [FileUtil createDir:[self getZipDir]]
    && [FileUtil createDir:[self getCitiesDir]]
    && [FileUtil createDir:[self getAppDir]]
    && [FileUtil createDir:[self getHelpDir]]
    && [FileUtil createDir:[self getUserDir]]
    && [FileUtil createDir:[self getProvidedServiceIconsDir]]
    && [FileUtil createDir:[self getRecommendedAppIconsDir]]
    && [FileUtil createDir:[self getCategoryIconsDir]]
    && [FileUtil createDir:[self getFavoriteDir]]
    && [FileUtil createDir:[self getHistoryDir]] 
    && [FileUtil createDir:[self getFollowRoutesDir]]
    && [FileUtil createDir:[self getFollowLocalRoutesDir]];
    
    return success;
}

+ (NSString*)getDownloadDir
{
    return [FileUtil getFileFullPath:DIR_OF_DOWNLOAD];
}

+ (NSString*)getZipDir
{
    return [FileUtil getFileFullPath:DIR_OF_ZIP];
}

+ (NSString*)getCitiesDir
{
    return [FileUtil getFileFullPath:DIR_OF_CITIES];
}

+ (NSString*)getAppDir
{
    return [FileUtil getFileFullPath:DIR_OF_APP];
}

+ (NSString*)getHelpDir
{
    return [FileUtil getFileFullPath:DIR_OF_HELP];
}

+ (NSString*)getUserDir
{
    return [FileUtil getFileFullPath:DIR_OF_USER];
}

+ (NSString*)getProvidedServiceIconsDir
{
    return [FileUtil getFileFullPath:DIR_OF_PROVIDED_SERVICE_ICON];
}

+ (NSString*)getRecommendedAppIconsDir
{
    return [FileUtil getFileFullPath:DIR_OF_RECOMMENDED_APP_ICON];
}

+ (NSString*)getCategoryIconsDir
{
    return [FileUtil getFileFullPath:DIR_OF_CATEGORY_ICON];
}

+ (NSString*)getFavoriteDir
{
    return [FileUtil getFileFullPath:DIR_OF_FAVORITE];
}

+ (NSString*)getHistoryDir
{
    return [FileUtil getFileFullPath:DIR_OF_HISTORY];
}

+ (NSString*)getFollowRoutesDir
{
    return [FileUtil getFileFullPath:DIR_OF_FOLLOW_ROUTES];
}

+ (NSString*)getFollowLocalRoutesDir
{
    return [FileUtil getFileFullPath:DIR_OF_FOLLOW_LOCAL_ROUTES];
}

+ (NSString*)getDownloadPath:(int)cityId
{
    return [[AppUtils getDownloadDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.zip", cityId]];
}

+ (NSString*)getCityDir:(int)cityId
{
    return [[FileUtil getFileFullPath:DIR_OF_CITIES] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d", cityId]];
}

+ (NSString*)getCityoverViewFilePath:(int)cityId
{
    return [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:FILENAME_OF_CITY_OVERVIEW_DATA]; 
}

+ (NSString*)getPackageFilePath:(int)cityId
{
    return [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:FILENAME_OF_PACKAGE_DATA];
}

+ (NSArray*)getPlaceFilePathList:(int)cityId
{
    NSString *palceFileDir = [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:DIR_OF_PLACE_DATA];
    
    return [self getFilePathList:palceFileDir];
}

+ (NSArray*)getGuideFilePathList:(int)cityId
{
    NSString *guideDir = [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:DIR_OF_GUIDE_DATA];
    
    return [self getFilePathList:guideDir];
}

+ (NSArray*)getRouteFilePathList:(int)cityId
{
    NSString *routeDir = [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:DIR_OF_ROUTE_DATA];
    
    return [self getFilePathList:routeDir];
}

+ (NSArray*)getFilePathList:(NSString*)fileDir
{
    NSArray *filenameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fileDir error:nil];
    NSMutableArray *filePathList = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSString *filename in filenameList) {
        BOOL flag = YES;
        NSString *fullPath = [fileDir stringByAppendingPathComponent:filename];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [filePathList addObject:fullPath];
            }
        }
    }
    
    return filePathList;
}
            
+ (NSString*)getUnzipFlag:(int)cityId
{
    return [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:FLAG_OF_UNZIP_SUCCESS];
}

+ (NSString*)getZipFilePath:(int)cityId
{
    //TODO, consturct a zip file path and return 
    NSString *zipName = [NSString stringWithFormat:@"%d.zip", cityId];
    return [[AppUtils getZipDir] stringByAppendingPathComponent:zipName];
}

+ (NSString*)getAppFilePath
{
    return [[AppUtils getAppDir] stringByAppendingPathComponent:FILENAME_OF_APP_DATA];
}

+ (NSString*)getHelpHtmlFilePath
{
    return [[AppUtils getHelpDir] stringByAppendingPathComponent:FILENAME_OF_HELP_HTML];
}

+ (BOOL)hasLocalCityData:(int)cityId
{
    BOOL hasData = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AppUtils getUnzipFlag:cityId]]) {
        hasData = YES;
    }
    
    return hasData;
}

+ (BOOL)hasLocalHelpHtml
{
    BOOL hasData = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AppUtils getHelpHtmlFilePath]]) {
        hasData = YES;
    }
    
    return hasData;
} 

+ (BOOL)unzipCityZip:(int)cityId
{
    [FileUtil createDir:[AppUtils getCityDir:cityId]];

    return [SSZipArchive unzipFileAtPath:[AppUtils getZipFilePath:cityId]
                           toDestination:[AppUtils getCityDir:cityId]];;
}

+ (NSString*)getHelpZipFilePath
{
    return [[AppUtils getZipDir] stringByAppendingPathComponent:FILENAME_OF_HELP_ZIP];
}

+ (void)deleteCityData:(int)cityId
{
    NSString *path = [AppUtils getCityDir:cityId];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    return;
}

+ (NSString*)getAbsolutePath:(NSString*)absoluteDir string:(NSString*)string
{
    if ([string hasPrefix:@"http:"]) {
        return string;
    }else{
        return [absoluteDir stringByAppendingPathComponent:string];
    }
}

+ (NSURL*)getNSURLFromHtmlFileOrURL:(NSString*)fileOrURL
{
    NSURL* url = nil;
    if ([fileOrURL hasPrefix:@"http:"]){
        url = [NSURL URLWithString:fileOrURL];           
    }
    else{
        NSString *htmlPath = fileOrURL;        
        url = [NSURL fileURLWithPath:htmlPath];
    }
    
    return url;
}

+ (NSString*)getProvidedServiceIconPath:(int)providedServiceId
{
    NSString *destinationDir = [AppUtils getProvidedServiceIconsDir];
    NSString *fileName = [NSString stringWithFormat:@"%d.png", providedServiceId];
    return [destinationDir stringByAppendingPathComponent:fileName];
}

+ (NSString*)getRecommendedAppIconPath:(int)appId
{
    NSString *destinationDir = [AppUtils getRecommendedAppIconsDir];
    NSString *fileName = [NSString stringWithFormat:@"%d.png", appId];
    return [destinationDir stringByAppendingPathComponent:fileName];
}

+ (NSString*)getFavoriteFilePath:(int)cityId
{
    return [[AppUtils getFavoriteDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.dat",cityId]];
}

+ (NSString*)getHistoryFilePath:(int)cityId
{
    return [[AppUtils getHistoryDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.dat",cityId]];
}

+ (NSString*)getDefaultHistoryFilePath
{
    return [[AppUtils getHistoryDir] stringByAppendingPathComponent:@"history.dat"];
}

+ (NSString *)getFollowRoutesFilePath:(int)type
{
    return [[AppUtils getFollowRoutesDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.dat",type]];
}

+ (NSString *)getFollowLocalRoutesFilePath
{
    return [[AppUtils getFollowLocalRoutesDir] stringByAppendingPathComponent:@"localRoute.dat"];
}

+ (BOOL)isShowImage
{
    //default return YES
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:KEY_IS_SHOW_IMAGE]) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_SHOW_IMAGE];
}

+ (void)enableImageShow:(BOOL)isShow
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isShow forKey:KEY_IS_SHOW_IMAGE];
    [userDefaults synchronize];
}

+ (NSString*)getCategoryIcon:(int)categoryId
{
    switch (categoryId) {
        case PlaceCategoryTypePlaceSpot:
            return @"jd";
            break;
        case PlaceCategoryTypePlaceHotel:
            return @"ht";
            break;
        case PlaceCategoryTypePlaceRestraurant:
            return @"cg";
            break;
        case PlaceCategoryTypePlaceShopping:
            return @"gw";
            break;
        case PlaceCategoryTypePlaceEntertainment:
            return @"yl";
            break;
        default:
            break;
    }
    return nil;
}

//+ (NSString*)getCategoryIndicatorIcon:(int)categoryId
//{
//    switch (categoryId) {
//        case PlaceCategoryTypePlaceSpot:
//            return @"pin_jd2";
//            break;
//        case PlaceCategoryTypePlaceHotel:
//            return @"pin_ht2";
//            break;
//        case PlaceCategoryTypePlaceRestraurant:
//            return @"pin_cg2";
//            break;
//        case PlaceCategoryTypePlaceShopping:
//            return @"pin_gw2";
//            break;
//        case PlaceCategoryTypePlaceEntertainment:
//            return @"pin_yl2";
//            break;
//        default:
//            break;
//    }
//    return nil;
//
//}

+ (NSString*)getCategoryPinIcon:(int)categoryId
{
    switch (categoryId) {
        case PlaceCategoryTypePlaceSpot:
            return @"pin_jd";
            break;
        case PlaceCategoryTypePlaceHotel:
            return @"pin_ht";
            break;
        case PlaceCategoryTypePlaceRestraurant:
            return @"pin_cg";
            break;
        case PlaceCategoryTypePlaceShopping:
            return @"pin_gw";
            break;
        case PlaceCategoryTypePlaceEntertainment:
            return @"pin_yl";
            break;
        default:
            break;
    }
    return nil;
    
}

+ (UIAlertView*)showAlertViewWhenUsingCellNetworkForDownloadWithTag:(int)tag delegate:(id)delegate
{
    NSString *message = NSLS(@"您现在使用非WIFI网络下载，将会占用大量流量，是否继续下载?");
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:message delegate:delegate cancelButtonTitle:NSLS(@"取消") otherButtonTitles:NSLS(@"确定"),nil] autorelease];
    alert.tag = tag;
    [alert show];
    
    return alert;
}

+ (UIAlertView*)showDeleteCityDataAlertViewWithTag:(int)tag delegate:(id)delegate
{
    NSString *message = NSLS(@"是否确认删除?");
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:message delegate:delegate cancelButtonTitle:NSLS(@"取消") otherButtonTitles:NSLS(@"确定"),nil] autorelease];
    alert.tag = tag;
    [alert show];
    
    return alert;
}

+ (UIAlertView*)showAlertViewWhenLookingMapWithoutNetwork
{
    NSString *message = NSLS(@"网络弱，地图模式暂无法使用");
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:message delegate:nil cancelButtonTitle:NSLS(@"我知道了") otherButtonTitles:nil,nil] autorelease];
    [alert show];
    
    return alert;
}

// alert when user denies your application’s use of the location service.

+ (UIAlertView*)showAlertViewWhenUserDenyLocatedServiceWithTag:(int)tag delegate:(id)delegate
{
    if (!_showUserLocateDenyAlert) {
        return nil;
    }
    
    NSString *message = NSLS(@"您没有开启定位功能，请到手机设置里开启");
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:message delegate:delegate cancelButtonTitle:NSLS(@"我知道了") otherButtonTitles:NSLS(@"不再提醒"),nil] autorelease];
    alert.tag = tag;
    [alert show];
    
    return alert;
}

+ (UIAlertView*)showAlertViewWhenUserDenyLocatedService
{
    NSString *message = NSLS(@"您没有开启定位功能，请到手机设置里开启");
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:message delegate:nil cancelButtonTitle:NSLS(@"我知道了") otherButtonTitles:nil,nil] autorelease];
    [alert show];
    
    return alert;
}

+ (UIAlertView*)showAlertViewWhenCannotLocateUserLocation
{
    NSString *message = NSLS(@"未能获取您的位置");
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:message delegate:nil cancelButtonTitle:NSLS(@"我知道了") otherButtonTitles:nil,nil] autorelease];
    [alert show];
    
    return alert;
}
 
+ (void)enableShowUserLocateDenyAlert:(BOOL)isShow
{
    _showUserLocateDenyAlert = isShow;
}


@end
