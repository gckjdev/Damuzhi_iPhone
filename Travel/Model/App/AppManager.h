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

@property (retain, nonatomic) App *app;

- (void)loadAppData;
- (void)updateAppData:(App*)appData;

- (City*)getCity:(int)cityId;

- (NSString*)getAppDataVersion;

- (NSString*)getCategoryName:(int)categoryId;
- (NSArray*)getCityList;
- (NSArray*)getCityIdList;
- (NSArray*)getCityNameList;

- (NSString*)getCityName:(int)cityId;
- (NSString*)getCityLatestVersion:(int)cityId;
- (NSString*)getCountryName:(int)cityId;
- (int)getCityDataSize:(int)cityId;
- (NSString*)getCityDownloadUrl:(int)cityId;

- (NSString*)getAreaName:(int)cityId areaId:(int)areaId;
- (NSString*)getCurrencySymbol:(int)cityId;
- (NSString*)getCurrencyName:(int)cityId;

- (NSArray*)getProvidedServiceIconList:(int)categoryId;
- (NSString*)getSubCategotyName:(int)categoryId subCategoryId:(int)subCategoryId;
- (NSString*)getProvidedServiceIcon:(int)categoryId providedServiceId:(int)providedServiceId;
- (NSArray *)getProvidedServiceList:(int)categoryId;

- (int)getCurrentCityId;
- (NSString*)getCurrentCityName;
- (void)setCurrentCityId:(int)newCity;

// Get item list for select controller.
- (NSArray *)getSubCategoryItemList:(int)categoryId placeList:(NSArray *)placeList;
- (NSArray *)getServiceItemList:(int)categoryId placeList:(NSArray *)placeList;
- (NSArray *)getAreaItemList:(int)cityId placeList:(NSArray *)placeList;
- (NSArray *)getPriceRankItemList:(int)cityId;
- (NSArray *)getSortItemList:(int)categoryId;

// Get angency list 
- (NSArray *)getDepartCityItemList:(NSArray *)routeList;
- (NSArray *)getDestinationCityItemList:(NSArray *)routeList;
- (NSArray *)getRouteThemeItemList:(NSArray *)routeList;
- (NSArray *)getRouteCategoryItemList:(NSArray *)routeList;
- (NSArray *)getAgencyItemList:(NSArray *)routeList;

- (NSString*)getDepartCityName:(int)routeCityId;
- (NSString*)getAgencyName:(int)agencyId;

- (NSArray*)buildAdultItemList;
- (NSArray*)buildChildrenItemList;

@end
