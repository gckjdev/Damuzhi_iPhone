//
//  CityManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityOverViewManager.h"
#import "AppUtils.h"
#import "PPDebug.h"
#import "AppManager.h"
#import "PPDebug.h"
#import "LocaleUtils.h"
#import "AppConstants.h"

@implementation CityOverViewManager

@synthesize cityId = _cityId;
@synthesize cityBasic = _cityBasic;
@synthesize travelPrepration = _travelPrepration;
@synthesize travelUtility = _travelUtility;
@synthesize travelTransportation = _travelTransportation;

static CityOverViewManager *_defaultInstance = nil;

+ (id)defaultManager
{
    if (_defaultInstance == nil){
        _defaultInstance = [[CityOverViewManager alloc] init];
    }
    
    return _defaultInstance;
}

- (void)dealloc
{
    [_cityBasic release];
    [_travelPrepration release];
    [_travelUtility release];
    [_travelTransportation release];
    [super dealloc];
}

- (CityOverview*)readCityOverviewData:(int)cityId
{
    // if there has no local city data
    if (![AppUtils hasLocalCityData:cityId]) {
        return nil;
    }
    
    NSString *filePath = [AppUtils getCityoverViewFilePath:cityId];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    CityOverview *cityOveriew = nil;
    
    if (data != nil) {
        @try {
            cityOveriew = [CityOverview parseFromData:data];
        }
        @catch (NSException *exception) {
            PPDebug(@"<readCityOverviewData> Caught %@%@", [exception name], [exception reason]);
        }
    }
    
    return cityOveriew;
}

- (void)switchCity:(int)newCityId
{
    if (_cityId == newCityId){
        return;
    }
    
    self.cityId = newCityId;

    CityOverview *cityOverView = [self readCityOverviewData:newCityId];
    
    self.cityBasic = cityOverView.cityBasic; 
    self.travelPrepration = cityOverView.travelPrepration;          
    self.travelUtility = cityOverView.travelUtility;              
    self.travelTransportation = cityOverView.travelTransportation;       
}

- (CommonOverview*)getCommonOverview:(CommonOverviewType)type
{
    CommonOverview *overview = nil;
    
    switch (type) {
        case CommonOverviewTypeCityBasic:
            overview = _cityBasic;
            break;
            
        case CommonOverviewTypeTravelPrepration:
            overview = _travelPrepration;
            break;
            
        case CommonOverviewTypeTravelUtility:
            overview = _travelUtility;
            break;
            
        case CommonOverviewTypeTravelTransportation:
            overview = _travelTransportation;
            break;
            
        default:
            break;
    }
    
    return overview;
}

@end

