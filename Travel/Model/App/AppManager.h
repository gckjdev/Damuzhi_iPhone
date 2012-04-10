//
//  AppManager.h
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "App.pb.h"
#import "LocalCity.h"

@interface AppManager : NSObject<CommonManagerProtocol>
{
    App* _app;    
}

@property (retain, nonatomic) App *app;

- (void)loadAppData;
- (void)updateAppData:(App*)appData;

- (City*)getCity:(int)cityId;
- (City*)getTestCity:(int)cityId;

- (NSString*)getAppDataVersion;
- (NSString*)getHelpHtml;

- (NSString*)getCategoryName:(int)categoryId;
- (NSArray*)getCityList;
- (NSArray*)getCityIdList;
- (NSArray*)getCityNameList;
- (NSArray*)getTestCityNameList;

- (NSString*)getCityName:(int)cityId;
- (NSString*)getCityLatestVersion:(int)cityId;
- (NSString*)getCountryName:(int)cityId;
- (int)getCityDataSize:(int)cityId;
- (NSString*)getCityDownloadUrl:(int)cityId;

//- (NSArray*)getAreaList:(int)cityId;
- (NSString*)getAreaName:(int)cityId areaId:(int)areaId;
- (NSString*)getCurrencySymbol:(int)cityId;
- (NSString*)getCurrencyId:(int)cityId;
- (NSString*)getCurrencyName:(int)cityId;
//- (int)getPriceRank:(int)cityId;

- (NSArray*)getSubCategoryList:(int)categoryId;
- (NSArray*)getProvidedServiceList:(int)categoryId;

- (NSArray*)getProvidedServiceNameList:(int)categoryId;
- (NSArray*)getProvidedServiceIconList:(int)categoryId;

- (NSString*)getSubCategotyName:(int)categoryId subCategoryId:(int)subCategoryId;
- (NSString*)getProvidedServiceName:(int)categoryId providedServiceId:(int)providedServiceId;
- (NSString*)getProvidedServiceIcon:(int)categoryId providedServiceId:(int)providedServiceId;

- (int)getCurrentCityId;
- (NSString*)getCurrentCityName;
- (void)setCurrentCityId:(int)newCity;

- (NSArray*)getSortOptionList:(int)categoryId;

- (NSArray *)getAreaNameList:(int)cityId;
- (NSArray *)getPriceList:(int)cityId;

@end
