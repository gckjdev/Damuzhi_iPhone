//
//  TravelTipsService.m
//  Travel
//
//  Created by 小涛 王 on 12-4-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "TravelTipsService.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "PPDebug.h"
#import "CommonNetworkClient.h"
#import "TravelNetworkRequest.h"
#import "Package.pb.h"

@implementation TravelTipsService

@synthesize localTravelTipsManager = _localTravelTipsManager;
@synthesize onlineTravelTipsManager = _onlineTravelTipsManager;

static TravelTipsService *_instance = nil;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
    [_localTravelTipsManager release];
    [_onlineTravelTipsManager release];
    [super dealloc];
}

+ (TravelTipsService*)defaultService
{
    if (_instance == nil){
        _instance = [[TravelTipsService alloc] init];   
        
    }
    
    return _instance;
}

- (id)init
{
    self = [super init];
    _localTravelTipsManager = [[TravelTipsManager alloc] init];
    _onlineTravelTipsManager = [[TravelTipsManager alloc] init];
    return self;
}

#pragma mark - 
#pragma mark Share Methods

typedef NSArray* (^LocalRequestHandler)(int* resultCode);
typedef NSArray* (^RemoteRequestHandler)(int* resultCode);

- (void)processLocalRemoteQuery:(PPViewController<TravelTipsServiceDelegate>*)viewController
                   localHandler:(LocalRequestHandler)localHandler
                  remoteHandler:(RemoteRequestHandler)remoteHandler
                         cityId:(int)cityId
{
    [viewController showActivityWithText:NSLS(@"数据加载中......")];
    
    NSOperationQueue* queue = [self getOperationQueue:@"SERACH_WORKING_QUEUE"];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        NSArray* list = nil;
        int resultCode = 0;
        if ([AppUtils hasLocalCityData:cityId] == YES){
            // read local data firstly               
            PPDebug(@"Has Local Data For City %@, Read Data Locally", [[AppManager defaultManager] getCityName:cityId]);
            if (localHandler != NULL){
                list = localHandler(&resultCode);
            }
        }
        else{
            // if local data no exist, try to read data from remote            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", [[AppManager defaultManager] getCityName:cityId]);            
            if (remoteHandler != NULL){
                list = remoteHandler(&resultCode);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];           
            if (viewController && [viewController respondsToSelector:@selector(findRequestDone:tipList:)]) {
                [viewController findRequestDone:resultCode tipList:list];
            }
        });
    }];
}

- (void)findTravelTipList:(int)cityId type:(TravelTipType)type viewController:(PPViewController<TravelTipsServiceDelegate>*)viewController
{
    LocalRequestHandler localHandler = ^NSArray *(int* resultCode) {
        [_localTravelTipsManager switchCity:cityId];
        NSArray* list = [_localTravelTipsManager getTravelTipList:type];   
        *resultCode = 0;
        return list;
    };
    
    LocalRequestHandler remoteHandler = ^NSArray *(int* resultCode) {
        // TODO, send network request here
        int listType = [self getListTypeByTravelTipType:type];
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:listType                                                               
                                                               cityId:cityId
                                                                 lang:LanguageTypeZhHans]; 
        
        NSArray* list = nil;
        
        *resultCode = output.resultCode;
        if (output.resultCode == ERROR_SUCCESS) {
            @try {
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];                
                list = [[travelResponse travelTipList] tipListList];
            }
            @catch (NSException *exception) {
                PPDebug(@"<findTravelTipList: %d> Caught %@%@", type, [exception name], [exception reason]);
            }
        }
        
        return list;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler
                           cityId:cityId];
}

- (int)getListTypeByTravelTipType:(TravelTipType)type
{
    int listType = 0;
    switch (type) {
        case TravelTipTypeGuide:
            listType = OBJECT_LIST_TYPE_TRAVEL_GUIDE;
            break;
            
        case TravelTipTypeRoute:
            listType = OBJECT_LIST_TYPE_TRAVEL_ROUTE;
            break;
            
        default:
            break;
    }
    
    return listType;
}

@end
