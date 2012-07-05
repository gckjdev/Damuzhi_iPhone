//
//  AppService.m
//  Travel
//
//  Created by 小涛 王 on 12-3-12.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "AppService.h"
#import "PPViewController.h"
#import "LogUtil.h"
#import "TravelNetworkRequest.h"
#import "Package.pb.h"
#import "FileUtil.h"
#import "TravelNetworkConstants.h"
#import "SSZipArchive.h"
#import "AppUtils.h"
#import "AppConstants.h"
#import "ASIHTTPRequest.h"
#import "LocalCityManager.h"


#define SERACH_WORKING_QUEUE    @"SERACH_WORKING_QUEUE"

@implementation AppService

@synthesize currentLocation = _currentLocation;
static AppService* _defaultAppService = nil;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
    [_currentLocation release];
    [super dealloc];
}

+ (AppService*)defaultService
{
    if (_defaultAppService == nil){
        _defaultAppService = [[AppService alloc] init];
    }
    
    return _defaultAppService;
}

- (id)init
{
    self = [super init];
    if (self) {
//        [self setCurrentLocation:[[[CLLocation alloc] initWithLatitude:0.0 longitude:0.0] autorelease]];
    }
    
    return self;
}

#pragma mark - 
#pragma mark App Life Cycle Management

- (NSString*)getAppVersion
{
    // TODO later
    return @"";
}

- (void)copyDefaultAppDataFormBundle
{        
    // copy file from bundle to zip dir
    PPDebug(@"copy defalut app.dat from bundle to app dir");
    [FileUtil copyFileFromBundleToAppDir:FILENAME_OF_APP_DATA
                                  appDir:[AppUtils getAppDir] 
                               overwrite:NO];
}

- (void)copyBuildinHelpHtmlFileFormBundleAndRelease
{    
     if ([AppUtils hasLocalHelpHtml]) {
         return;
     }

    // copy file from bundle to zip dir
    PPDebug(@"copy defalut help.html from bundle to app dir");
    [FileUtil copyFileFromBundleToAppDir:FILENAME_OF_HELP_ZIP
                                  appDir:[AppUtils getZipDir]
                               overwrite:NO];
    
    // unzip
    [SSZipArchive unzipFileAtPath:[AppUtils getHelpZipFilePath]
                    toDestination:[AppUtils getHelpDir]];
}

//- (void)copyBuildinCityZipFromBundleAndRelease
//{       
//    if ([AppUtils hasLocalCityData:DEFAULT_CITY_ID]) { 
//        return;
//    }
//    
//    // create City Dir
//    [FileUtil createDir:[AppUtils getZipDir]];
//    
//    // copy file from bundle to zip dir
//    PPDebug(@"copy defalut zip from bundle to zip dir");
//    [FileUtil copyFileFromBundleToAppDir:DEFAULT_CITY_ZIP
//                                  appDir:[AppUtils getZipDir] 
//                               overwrite:NO];
//    
//    // if there has no unzip city data, unzip
//    [self UnzipDefaultCity];
//}

- (void)loadAppData
{
    [AppUtils createAllNeededDir];

    [self copyDefaultAppDataFormBundle];
    [[AppManager defaultManager] loadAppData];

//    [self copyBuildinCityZipFromBundleAndRelease];
    [self copyBuildinHelpHtmlFileFormBundleAndRelease];
}

- (void)updateHelpHtmlFile
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:OBJECT_TYPE_HELP_INOF lang:LanguageTypeZhHans];
        HelpInfo *helpInfo = nil;
        
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                helpInfo = [[TravelResponse parseFromData:output.responseData] helpInfo];
                if (![helpInfo.version isEqualToString:[self getHelpHtmlFileVersion]]) {
                    NSURL *url = [NSURL URLWithString:helpInfo.helpHtml];
                    [self downloadResource:url destinationPath:[AppUtils getHelpZipFilePath]];
                    [SSZipArchive unzipFileAtPath:[AppUtils getHelpZipFilePath] 
                                    toDestination:[AppUtils getHelpDir]];
                    [self setHelpHtmlFileVersion:helpInfo.version];
                }
            }
            @catch (NSException *exception){
                PPDebug (@"<updateHelpHtmlFile> Caught %@%@", [exception name], [exception reason]);
            }
        }
    });    
}

#define KEY_HELP_HTML_FILE_VERSION @"KEY_HELP_HTML_FILE_VERSION"
- (NSString*)getHelpHtmlFileVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HELP_HTML_FILE_VERSION];
}

- (void)setHelpHtmlFileVersion:(NSString*)version
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:version forKey:KEY_HELP_HTML_FILE_VERSION];
    [userDefaults synchronize];
}

- (void)updateAppData
{        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:OBJECT_TYPE_APP_DATA lang:LanguageTypeZhHans os:OS_IOS];
        TravelResponse *travelResponse = nil;

        if (output.resultCode == ERROR_SUCCESS){
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [[AppManager defaultManager] updateAppData:[travelResponse appInfo]];
                });
                
                // TODO , performance can be improved by add sperate working queue for download
                NSArray *placeMetas = [[travelResponse appInfo] placeMetaDataListList];
                [self downloadProvidedServiceIcons:placeMetas];
                NSArray *recommendApps = [[travelResponse appInfo] recommendedAppsList];
                [self downloadRecommendedAppIcons:recommendApps];
            }
            @catch (NSException *exception){
                PPDebug (@"<updateAppData> Caught %@%@", [exception name], [exception reason]);
            }
        }
    });    
}

- (void)downloadProvidedServiceIcons:(NSArray*)placeMetas
{
    for (PlaceMeta *placeMeta in placeMetas) {
        for (NameIdPair *providedService in [placeMeta providedServiceListList]) {
            // download icons of each provide service icon
            NSURL *url = [NSURL URLWithString:providedService.image];
            NSString *destinationPath = [AppUtils getProvidedServiceIconPath:providedService.id];
            [self downloadResource:url destinationPath:destinationPath];
        }
    }
}

- (void)downloadRecommendedAppIcons:(NSArray*)appRecommendList
{
    for (RecommendedApp *app in appRecommendList) {
        // download icons of each provide service icon
        NSURL *url = [NSURL URLWithString:app.icon];
        NSString *destinationPath = [AppUtils getRecommendedAppIconPath:app.id];
        [self downloadResource:url destinationPath:destinationPath];
    }
}

- (void)downloadResource:(NSURL*)url destinationPath:(NSString*)destinationPath
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
//    PPDebug(@"download request = %@", url.description);
    [request setDownloadDestinationPath:destinationPath];
    
    [request startSynchronous];
}  

@end
