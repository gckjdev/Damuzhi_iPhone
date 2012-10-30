//
//  PackageManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PackageManager.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "PPDebug.h"
#import "StringUtil.h"

@implementation PackageManager

@synthesize packageList = _packageList;

static PackageManager *_instance = nil;

+ (id)defaultManager
{
    if (_instance == nil) {
        _instance = [[PackageManager alloc] init];
    }
    
    _instance.packageList = [_instance readAllPackages];
    return _instance;
}

- (void)dealloc
{
    [_packageList release];
    [super dealloc];
}

- (NSString*)getCityVersion:(int)cityId
{
    NSString *cityVersion = @"";
    for (Package *package in _packageList) {
        if (cityId == package.cityId) {
            cityVersion = package.version;
        }
    }
    
    return cityVersion;
}

- (LanguageType)getLanguageType:(int)cityId
{
    for (Package *package in _packageList) {
        if (cityId == package.cityId) {
            return package.language;
        }
    }
    
    return 0;
}

- (NSArray*)readAllPackages
{
    NSMutableArray * packageList = [[[NSMutableArray alloc] init] autorelease];
    NSArray *cityIdList = [[AppManager defaultManager] getCityIdList];
    
    for (NSNumber *cityId in cityIdList) {
        //a city is exist when a unzip flag and the city packagefile both exist;
        if ([AppUtils hasLocalCityData:[cityId intValue]]) {
            NSString *filePath = [AppUtils getPackageFilePath:[cityId intValue]];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            if (data != nil) {
                @try {
                    Package *package = [Package parseFromData:data]; 
                    [packageList addObject:package];
                }
                @catch (NSException *exception) {
                    PPDebug (@"<readAllPackages:%@> Caught %@%@", filePath, [exception name], [exception reason]);
                }
            }
        }
    }
    
    return packageList;
}

- (NSArray*)getDownLoadLocalCityList
{
    NSMutableArray *cityList = [[[NSMutableArray alloc] init] autorelease];
    for (Package *package in _packageList) {
        City *city = [[AppManager defaultManager] getCity:package.cityId];
        if (city != nil) {
            [cityList addObject:city];
        }
    }
    return cityList;
}



- (NSArray*)getDownLoadCountryGroupList
{
    NSMutableArray *countryNameList = [[[NSMutableArray alloc] init] autorelease];
    for (Package *package in _packageList) {
        City *city = [[AppManager defaultManager] getCity:package.cityId];
        if (city != nil) {
            [countryNameList addObject:city.countryName];
        }
    }

    countryNameList = [self deleteRepeatedObjectsFromArray:countryNameList];
    
    NSArray *sortedArray = [countryNameList sortedArrayUsingComparator: ^(id obj1, id obj2) {
        NSString *countryName1 = (NSString *)obj1;
        NSString *countryName2 = (NSString *)obj2;
        return [[countryName1 pinyinFirstLetter] compare:[countryName2 pinyinFirstLetter] options:NSCaseInsensitiveSearch];
    }];
    
    return sortedArray;
}


- (NSMutableArray *)getdownLoadCityListFromCountry:(NSString *) countryName
{

    NSMutableArray *localCityListFromCountry = [NSMutableArray array];
    NSArray *localCityList = [self getDownLoadLocalCityList];
    for (City *city in localCityList) 
    {
        if ([city.countryName isEqualToString:countryName])
        {
            [localCityListFromCountry addObject:city];
        }
    }
    return localCityListFromCountry;
}


-(NSMutableArray *)deleteRepeatedObjectsFromArray:(NSArray *) originalArray
{
    NSMutableArray *deletedArray = [[[NSMutableArray alloc] init] autorelease];
    for (unsigned i = 0; i < [originalArray count]; i++){  
        if ([deletedArray containsObject:[originalArray objectAtIndex:i]] == NO){  
            [deletedArray addObject:[originalArray objectAtIndex:i]];  
        }  
    }  
    return deletedArray;
}

@end
