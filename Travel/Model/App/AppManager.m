//
//  AppManager.m
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppManager.h"
#import "App.pb.h"
#import "ImageName.h"
#import "LogUtil.h"
#import "CommonPlace.h"
#import "LocaleUtils.h"
#import "AppConstants.h"
#import "AppUtils.h"
#import "SelectedItemIdsManager.h"
#import "Item.h"
#import "PlaceUtils.h"
#import "RouteUtils.h"

//#define TEST_CITY

#ifdef TEST_CITY
#define CITY_LIST [self allCities]
#else
#define CITY_LIST _app.citiesList
#endif

@interface AppManager ()

@property (retain, nonatomic) NSArray *allCities;

@end

@implementation AppManager

static AppManager* _defaultAppManager = nil;

@synthesize app = _app;
@synthesize allCities = _allCities;

+ (id)defaultManager
{
    if (_defaultAppManager == nil){
        _defaultAppManager = [[AppManager alloc] init];
    }
    
    return _defaultAppManager;
}

- (NSArray *)allCities
{
//    if (_allCities == nil) {
        self.allCities = [self mergeAllCities];
//    }
    
    return _allCities;
}

- (NSArray *)mergeAllCities
{
    NSMutableArray *allCity = [[[NSMutableArray alloc] init] autorelease];
    
    [allCity addObjectsFromArray: _app.citiesList];
    [allCity addObjectsFromArray:_app.testCitiesList];
    
//    for (City *city in _app.citiesList) {
//        [allCity addObject:city];
////        PPDebug(@"city_ = %@", city.cityName);
//    }
//    
//    for (City *city in _app.testCitiesList) {
//        [allCity addObject:city];
////        PPDebug(@"testCity_ = %@", city.cityName);
//
//    }
    
    return allCity;
}

-(void)dealloc
{
    [_app release];
    [_allCities release];
    [super dealloc];
}

- (void)loadAppData
{
    // TODO: load app data
    NSData *localAppData = [NSData dataWithContentsOfFile:[AppUtils getAppFilePath]];
    if(localAppData != nil)
    {
        @try {
            App *localApp = [App parseFromData:localAppData];
            self.app = localApp;
            PPDebug(@"loading local app data %@...... done!", [AppUtils getAppFilePath]);
        }
        @catch (NSException *exception) {
            PPDebug (@"<loadAppData> Caught %@%@", [exception name], [exception reason]);
        }
    }
}

- (void)updateAppData:(App*)appData
{
    PPDebug(@"Updating app data and save!");
    
    self.app = appData;    
    
    NSArray *cityList = [self.app citiesList];
    for (City *city in cityList) {
        PPDebug(@"city = %@", city.cityName);
    }
    
    NSArray *testCityList = [self.app testCitiesList];
    for (City *city in testCityList) {
        PPDebug(@"testcity = %@", city.cityName);
    }
    
    for (RecommendedApp *app in self.app.recommendedAppsList) {
        PPDebug(@"app.name = %@", app.name);
    }
    
    [[appData data] writeToFile:[AppUtils getAppFilePath] atomically:YES];
}

- (City*)getCity:(int)cityId
{
    for (City *city in CITY_LIST) {
        if(city.cityId == cityId)
        {
            return city;
        }
    }
    
    return nil;
}

-(NSString*)getAppDataVersion
{
    return _app.dataVersion;
}

- (NSArray*)getCityList
{
    return CITY_LIST;
}

- (NSArray*)getCityIdList
{
    NSMutableArray *cityIdList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in CITY_LIST) {
        NSNumber *cityId = [[[NSNumber alloc] initWithInt:city.cityId] autorelease];
        [cityIdList addObject:cityId]; 
    }
    
    return cityIdList;
}

- (NSArray*)getCityNameList
{
    NSMutableArray *cityNameList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in CITY_LIST) {
        [cityNameList addObject:city.cityName]; 
    }
    
    return cityNameList;
}

- (NSString*)getCityName:(int)cityId
{
    NSString *cityName = NSLS(@"");;
    for (City *city in CITY_LIST) {
        if (city.cityId == cityId) {
            cityName = city.cityName;
            break;
        }   
    }
    
    return cityName;
}

- (NSString*)getCityLatestVersion:(int)cityId
{
    NSString *cityName = NSLS(@"");;
    for (City *city in CITY_LIST) {
        if (city.cityId == cityId) {
            cityName = city.cityName;
            break;
        }   
    }
    
    return cityName;
}

- (NSString*)getCountryName:(int)cityId
{
    NSString *countryName = NSLS(@"");;
    for (City *city in CITY_LIST) {
        if (city.cityId == cityId) {
            countryName = city.countryName;
            break;
        }   
    }
    
    return countryName;
}

- (int)getCityDataSize:(int)cityId
{
    int dataSize = 0;
    for (City *city in CITY_LIST) {
        if (city.cityId == cityId) {
            dataSize = city.dataSize;
            break;
        }   
    }
    
    return dataSize;
}

- (NSString*)getCityDownloadUrl:(int)cityId
{
    NSString *url = NSLS(@"");;
    for (City *city in CITY_LIST) {
        if (city.cityId == cityId) {
            url = city.downloadUrl;
            break;
        }   
    }
    
    return url;
}

- (NSArray*)getAreaList:(int)cityId
{
    City *city = [self getCity:cityId];
    return city.areaListList;
}

- (NSString*)getAreaName:(int)cityId areaId:(int)areaId
{
    NSString *areaName = @"";
    for (CityArea *area in [self getAreaList:cityId]) {
        if (areaId == area.areaId) {
            areaName = area.areaName;
            break;
        }
    }
    
    return areaName;
}

- (NSString*)getCurrencySymbol:(int)cityId
{
    City *city = [self getCity:cityId];
    return city.currencySymbol;
}

//- (NSString*)getCurrencyId:(int)cityId
//{
//    City *city = [self getCity:cityId];
//    return city.currencyId;
//}

- (NSString*)getCurrencyName:(int)cityId
{
    City *city = [self getCity:cityId];
    return city.currencyName;
}

- (int)getPriceRank:(int)cityId
{
    City *city = [self getCity:cityId];
    return city.priceRank;
}

- (PlaceMeta*)getPlaceMeta:(int)categoryId
{
    for (PlaceMeta *placeMeta in _app.placeMetaDataListList) {
        if (placeMeta.categoryId == categoryId) {
            return placeMeta;
        }
    }
    
    return nil;
}

- (NSString*)getCategoryName:(int)categoryId
{
    NSString *categoryName = NSLS(@"");
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if(placeMeta != nil)
    {
        categoryName = placeMeta.name;
    }
    
    return categoryName;
}


- (NSArray*)getSubCategoryNameList:(int)categoryId
{
    NSMutableArray *subCategoryNameList = [[[NSMutableArray alloc] init] autorelease];
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *subCategory in placeMeta.subCategoryListList) {
            [subCategoryNameList addObject:subCategory.name];
        }
    }

    return subCategoryNameList;
}

//- (NSArray*)getProvidedServiceNameList:(int)categoryId
//{
//    NSMutableArray *providedServiceNameList = [[[NSMutableArray alloc] init] autorelease];
//    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
//    if (placeMeta !=nil) {
//        for (NameIdPair *providedServiceName in placeMeta.subCategoryListList) {
//            [providedServiceNameList addObject:providedServiceName.name];
//        }
//    }
//    
//    return providedServiceNameList;
//}

- (NSArray*)getProvidedServiceIconList:(int)categoryId
{
    NSMutableArray *providedServiceIconList = [[[NSMutableArray alloc] init] autorelease];
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *providedServiceIcon in placeMeta.subCategoryListList) {
            [providedServiceIconList addObject:providedServiceIcon.name];
        }
    }
    
    return providedServiceIconList;
}

- (NSString*)getSubCategotyName:(int)categoryId subCategoryId:(int)subCategoryId;
{
    NSString *subCategoryName = NSLS(@"");
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *subCategory in placeMeta.subCategoryListList) {
            if (subCategory.id == subCategoryId) {
                subCategoryName = subCategory.name;
            }
        }
    }
    
    return subCategoryName;
}

//- (NSString*)getProvidedServiceName:(int)categoryId providedServiceId:(int)providedServiceId;
//{
//    NSString *providedServiceName = NSLS(@"");
//    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
//    if (placeMeta !=nil) {
//        for (NameIdPair *providedService in placeMeta.providedServiceListList) {
//            if (providedService.id == providedServiceId) {
//                providedServiceName = providedService.name;
//            }
//        }
//    }
//    
//    return providedServiceName;
//}

- (NSString*)getProvidedServiceIcon:(int)categoryId providedServiceId:(int)providedServiceId;
{
    NSString *providedServiceIcon = NSLS(@"");
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *providedService in placeMeta.providedServiceListList) {
            if (providedService.id == providedServiceId) {
                providedServiceIcon = providedService.image;
            }
        }
    }
    
    return providedServiceIcon;
}

- (NSArray *)getProvidedServiceList:(int)categoryId
{
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        return placeMeta.providedServiceListList;
    }
    
    return nil;
}

- (int)getCurrentCityId
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber* city = [userDefault objectForKey:KEY_CURRENT_CITY];
    if (city == nil){
        return DEFAULT_CITY_ID;
    }
    else {
        return [city intValue];
    }
}

- (NSString*)getCurrentCityName
{
    int cityId = [self getCurrentCityId];
    return [self getCityName:cityId];
}

- (void)setCurrentCityId:(int)newCityId
{
    int currentCityId = [self getCurrentCityId];
    if (newCityId == currentCityId) {
        return;
    }
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults]; 
    [userDefault setObject:[NSNumber numberWithInt:newCityId] forKey:KEY_CURRENT_CITY];
    [userDefault synchronize];
//    [[SelectedItemIdsManager defaultManager] resetAllSelectedItems];
}


- (NSArray*)getSubCategoryItemList:(int)categoryId placeList:(NSArray*)placeList
{
    NSMutableArray *subCategoryItemList = [[[NSMutableArray alloc] init] autorelease];    
    
    [subCategoryItemList addObject:[Item itemWithId:ALL_CATEGORY
                                           itemName:NSLS(@"全部")
                                              count:[placeList count]]];
    
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *subCategory in [placeMeta subCategoryListList]) {
            int count = [[PlaceUtils getPlaceList:placeList inSameSubcategory:subCategory.id] count];
            if (count != 0) {
                [subCategoryItemList addObject:[Item itemWithNameIdPair:subCategory count:count]];
            }
        }
    }
    
    return subCategoryItemList;
}

- (NSArray*)getServiceItemList:(int)categoryId placeList:(NSArray *)placeList
{
    NSMutableArray *serviceItemList = [[[NSMutableArray alloc] init] autorelease];
    
    [serviceItemList addObject:[Item itemWithId:ALL_CATEGORY 
                                       itemName:NSLS(@"全部") 
                                          count:[placeList count]]];

    
    NSArray *serviceList = [self getProvidedServiceList:categoryId];
    for (NameIdPair *service in serviceList) {
        int count = [[PlaceUtils getPlaceList:placeList hasSameService:service.id] count];
        if (count != 0) {
            [serviceItemList addObject:[Item itemWithNameIdPair:service count:count]];
        }
    }    
    
    return serviceItemList;
}

- (NSArray *)getAreaItemList:(int)cityId placeList:(NSArray *)placeList
{
    NSMutableArray *areaList = [[[NSMutableArray alloc] init] autorelease];
    
    [areaList addObject:[Item itemWithId:ALL_CATEGORY 
                                itemName:NSLS(@"全部") 
                                   count:[placeList count]]];
    
    
    for (CityArea* area in [[self getCity:cityId] areaListList]) {
        int count = [[PlaceUtils getPlaceList:placeList inSameArea:area.areaId] count];
        if (count != 0) {
            [areaList addObject:[Item itemWithId:area.areaId itemName:area.areaName count:count]];
        }
    }
    
    return areaList;
}

- (NSArray *)getPriceRankItemList:(int)cityId
{
    NSMutableArray *priceList = [[[NSMutableArray alloc] init] autorelease];
        
    [priceList addObject:[Item itemWithId:ALL_CATEGORY 
                                 itemName:NSLS(@"全部") 
                                    count:0]];

    
    for (int rank = 1; rank <= [self getPriceRank:cityId]; rank ++) {
        NSString *priceRankString = [self getPriceRankString:rank];        
        [priceList addObject:[Item itemWithId:rank itemName:priceRankString count:0]];
    }
    
    return priceList;
}

- (NSArray*)getSortItemList:(int32_t)categoryId
{
    NSArray *array = nil;
    switch (categoryId) {
        case PlaceCategoryTypePlaceSpot:            
            array = [self buildSpotSortItemList];
            break;
            
        case PlaceCategoryTypePlaceHotel:
            array = [self buildHotelSortItemList];
            break;
            
        case PlaceCategoryTypePlaceRestraurant:
            array = [self buildRestaurantSortItemList];
            break;
            
        case PlaceCategoryTypePlaceShopping:
            array = [self buildShoppingSortItemList];
            break;
            
        case PlaceCategoryTypePlaceEntertainment:
            array = [self buildEntertainmentSortItemList];
            break;
            
        default:
            break;
    }
    
    return array;
}

- (NSString *)getPriceRankString:(int)priceRank
{
    NSString *rankString = nil;
    switch (priceRank) {
        case 1:
            rankString = @"$";
            break;
        case 2:
            rankString = @"$$";
            break;
        case 3:
            rankString = @"$$$";
            break;
        case 4:
            rankString = @"$$$$";
            break;
            
        default:
            break;
    }
    
    return rankString;
}

- (NSArray*)buildSpotSortItemList
{
    NSMutableArray *spotSortItems = [[[NSMutableArray alloc] init] autorelease];    
    
    [spotSortItems addObject:[Item itemWithId:SORT_BY_RECOMMEND
                                      itemName:NSLS(@"大拇指推荐高至低") 
                                        count:0]];
    
    [spotSortItems addObject:[Item itemWithId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                      itemName:NSLS(@"距离近至远") 
                                         count:0]];
    
    [spotSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP
                                      itemName:NSLS(@"门票价格高到低") 
                                         count:0]];
    
    return spotSortItems;
}

- (NSArray*)buildHotelSortItemList
{
    NSMutableArray *hotelSortItems = [[[NSMutableArray alloc] init] autorelease];    
    
    [hotelSortItems addObject:[Item itemWithId:SORT_BY_RECOMMEND
                                      itemName:NSLS(@"大拇指推荐高至低") 
                                         count:0]];
    
    [hotelSortItems addObject:[Item itemWithId:SORT_BY_STARTS
                                      itemName:NSLS(@"星级高至低") 
                                         count:0]];
    
    [hotelSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP
                                      itemName:NSLS(@"价格高至低") 
                                         count:0]];
    
    [hotelSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE
                                      itemName:NSLS(@"价格低至高") 
                                         count:0]];
    
    [hotelSortItems addObject:[Item itemWithId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                      itemName:NSLS(@"距离近至远") 
                                         count:0]];
    
    return hotelSortItems;
}

- (NSArray*)buildRestaurantSortItemList
{
    NSMutableArray *hestaurantSortItems = [[[NSMutableArray alloc] init] autorelease];  
    
    [hestaurantSortItems addObject:[Item itemWithId:SORT_BY_RECOMMEND
                                           itemName:NSLS(@"大拇指推荐高至低") 
                                              count:0]];
    
    [hestaurantSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP
                                           itemName:NSLS(@"价格高至低") 
                                              count:0]];
    
    [hestaurantSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE
                                           itemName:NSLS(@"价格低至高") 
                                              count:0]];
    
    [hestaurantSortItems addObject:[Item itemWithId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                           itemName:NSLS(@"距离近至远") 
                                              count:0]];
    
    return hestaurantSortItems;
}

- (NSArray*)buildShoppingSortItemList
{
    NSMutableArray *shoppingtSortItems = [[[NSMutableArray alloc] init] autorelease];
    
    [shoppingtSortItems addObject:[Item itemWithId:SORT_BY_RECOMMEND
                                            itemName:NSLS(@"大拇指推荐高至低") 
                                               count:0]];
    
    [shoppingtSortItems addObject:[Item itemWithId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                          itemName:NSLS(@"距离近至远") 
                                             count:0]];
    
    return shoppingtSortItems;
}

- (NSArray*)buildEntertainmentSortItemList
{
    NSMutableArray *entertainmentSortItems = [[[NSMutableArray alloc] init] autorelease];    
    
    [entertainmentSortItems addObject:[Item itemWithId:SORT_BY_RECOMMEND
                                              itemName:NSLS(@"大拇指推荐高至低") 
                                                 count:0]];
    
    [entertainmentSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP
                                              itemName:NSLS(@"价格高至低") 
                                                 count:0]];
    
    [entertainmentSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE
                                              itemName:NSLS(@"价格低至高") 
                                                 count:0]];
    
    [entertainmentSortItems addObject:[Item itemWithId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                              itemName:NSLS(@"距离近至远") 
                                                 count:0]];
    
    return entertainmentSortItems;
}

// Get angency list 
- (NSArray *)getDepartCityItemList:(NSArray *)routeList
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (RouteCity *city in _app.departCitiesList) {
        int count = [[RouteUtils getRouteList:routeList departFromCity:city.routeCityId] count];
        if (count != 0) {
            [retArray addObject:[Item itemWithId:city.routeCityId
                                        itemName:city.cityName 
                                           count:count]];
        }
    }
    
    return retArray;
}

- (NSArray *)getDestinationCityItemList:(NSArray *)routeList
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (RouteCity *city in _app.destinationCitiesList) {
        int count = [[RouteUtils getRouteList:routeList headForCity:city.routeCityId] count];
        if (count != 0) {
            [retArray addObject:[Item itemWithId:city.routeCityId 
                                        itemName:city.cityName
                                           count:count]];
        }
    }
    
    return retArray; 
}

- (NSArray *)getRouteThemeItemList:(NSArray *)routeList;
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    [retArray addObject:[Item itemWithId:ALL_CATEGORY 
                                itemName:NSLS(@"全部") 
                                   count:[routeList count]]];
    
    for ( NameIdPair *theme in _app.routeThemesList) {
        int count = [[RouteUtils getRouteList:routeList inTheme:theme.id] count];
//        if (count != 0) {
            [retArray addObject:[Item itemWithNameIdPair:theme count:count]];
//        }
    }
    
    return retArray; 
}

- (NSArray *)getRouteCategoryItemList:(NSArray *)routeList
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    [retArray addObject:[Item itemWithId:ALL_CATEGORY 
                                itemName:NSLS(@"全部") 
                                   count:[routeList count]]];

    
    for ( NameIdPair *category in _app.routeCategorysList) {
        int count = [[RouteUtils getRouteList:routeList inCategory:category.id] count];
//        if (count != 0) {
            [retArray addObject:[Item itemWithNameIdPair:category count:count]];
//        }
    }
    
    return retArray; 
}

- (NSArray *)getAgencyItemList:(NSArray *)routeList
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    [retArray addObject:[Item itemWithId:ALL_CATEGORY 
                                itemName:NSLS(@"全部") 
                                   count:[routeList count]]];
    
    for (Agency *agency in _app.agenciesList) {
        int count = [[RouteUtils getRouteList:routeList providedByAngency:agency.agencyId] count];
        if (count != 0) {
            [retArray addObject:[Item itemWithId:agency.agencyId
                                        itemName:agency.name
                                           count:count]];
        }
    }
    
    return retArray;
}


- (NSString*)getDepartCityName:(int)routeCityId
{
    for (RouteCity *city in _app.departCitiesList) {
        if (city.routeCityId == routeCityId) {
            return city.cityName;
        }
    }
    
    return nil;
}

- (NSString*)getAgencyName:(int)agencyId
{
    for (Agency *agency in _app.agenciesList) {
        if (agency.agencyId == agencyId) {
            return agency.name;
        }
    }
    
    return nil;
}


@end
