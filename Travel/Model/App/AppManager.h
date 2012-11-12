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
#import "Package.pb.h"

@protocol AppManagerProtocol <NSObject>

@optional 
- (void)currentCityDidChange:(int)newCityId;

@end

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
- (void)setCurrentCityId:(int)newCityId delegate:(id<AppManagerProtocol>)delegate;

// Get item list for select controller.
//- (NSArray *)getSubCategoryItemList:(int)categoryId placeList:(NSArray *)placeList;
//- (NSArray *)getServiceItemList:(int)categoryId placeList:(NSArray *)placeList;
//- (NSArray *)getAreaItemList:(int)cityId placeList:(NSArray *)placeList;
- (NSArray *)getPriceRankItemList:(int)cityId;
- (NSArray *)getSortItemList:(int)categoryId;

- (NSArray *)getSubCategoryItemList:(int)categoryId;
- (NSArray *)getServiceItemList:(int)categoryId;
- (NSArray *)getAreaItemList:(int)categoryId;

- (void)updateSubCategoryItemList:(int)categoryId placeList:(NSArray*)placeList;
- (void)updateSubCategoryItemList:(int)categoryId staticticsList:(NSArray *)staticticsList;
- (void)updateServiceItemList:(int)categoryId placeList:(NSArray *)placeList;
- (void)updateServiceItemList:(int)categoryId staticticsList:(NSArray *)staticticsList;
- (void)updateAreaItemList:(int)categoryId cityId:(int)cityId placeList:(NSArray *)placeList;
- (void)updateAreaItemList:(int)categoryId cityId:(int)cityId staticticsList:(NSArray *)staticticsList;


// Get angency list 
- (NSArray *)getRegions;
- (int)getRegionIdByCityId:(int)cityId;
- (NSArray *)getDepartCityItemList:(NSArray *)staticticsList;
- (NSArray *)getDestinationCityItemList;
- (NSArray *)getRouteThemeItemList;
//- (NSArray *)getRouteCategoryItemList:(NSArray *)routeList;
- (NSArray *)getAgencyItemList:(NSArray *)staticticsList;

- (NSString*)getDepartCityName:(int)routeCityId;
- (Agency*)getAgency:(int)agencyId;

- (NSString*)getAgencyName:(int)agencyId;
- (NSString*)getAgencyShortName:(int)agencyId;

- (NSArray*)buildAdultItemList;
- (NSArray*)buildChildrenItemList;

- (NSArray*)getSelectedPackageIdItemList:(TouristRoute *)aRoute;



- (NSArray *)buildRoutePriceRankItemList;
- (NSArray *)buildDaysRangeItemList;
- (NSArray *)buildRouteSortItemList;

- (NSArray *)getServicePhoneList;

- (NSArray *)getCityListInGroup:(int)groupId;
- (NSDictionary *)getGroupCitysDicList;
- (NSArray *)getGroupNameList;
- (NSDictionary *)getNonRepeatedGroupCitysDicList;

- (NSArray *)getAgencyListFromLocalRouteList:(NSArray *)list;
- (NSDictionary *)getAgencyDicFromAgencyList:(NSArray *)agencyList
                              localRouteList:(NSArray *)routeList;

- (NSArray *)buildDepartPlaceItemList:(NSArray *)departPlaceList;

@end
