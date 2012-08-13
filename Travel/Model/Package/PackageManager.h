//
//  PackageManager.h
//  Travel
//
//  Created by 小涛 王 on 12-3-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "Package.pb.h"

@interface PackageManager : NSObject <CommonManagerProtocol>
{
    NSArray     *_packageList;
}

@property (retain, nonatomic)   NSArray     *packageList;

- (NSString*)getCityVersion:(int)cityId;
- (LanguageType)getLanguageType:(int)cityId;
- (NSArray*)getDownLoadLocalCityList;
- (NSArray*)getDownLoadCountryGroupList;
- (NSMutableArray *)getdownLoadCityListFromCountry:(NSString *) countryName;

@end
