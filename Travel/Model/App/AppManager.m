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
#import "LocaleUtils.h"
#import "AppConstants.h"
#import "AppUtils.h"
#import "SelectedItemIdsManager.h"
#import "Item.h"
#import "PlaceUtils.h"
#import "RouteUtils.h"
#import "PlaceItemList.h"
#import "StringUtil.h"

#import "TouristRoute.pb.h"

//#define TEST_CITY

#ifdef TEST_CITY
#define CITY_LIST [self allCities]
#else
#define CITY_LIST _app.citiesList
#endif

@interface AppManager ()

@property (retain, nonatomic) NSArray *allCities;
@property (retain, nonatomic) NSMutableDictionary *placeItemDic;

@property (retain, nonatomic) TouristRoute *route;
@end

@implementation AppManager

static AppManager* _defaultAppManager = nil;

@synthesize app = _app;
@synthesize allCities = _allCities;
@synthesize placeItemDic = _placeItemDic;

@synthesize route = _route;
+ (id)defaultManager
{
    if (_defaultAppManager == nil){
        _defaultAppManager = [[AppManager alloc] init];
    }
    
    return _defaultAppManager;
}

- (id)init
{
    if (self = [super init]) {
        self.placeItemDic = [NSMutableDictionary dictionary];
        
        PlaceItemList *spotItemList = [[[PlaceItemList alloc] init] autorelease];
        [self.placeItemDic setObject:spotItemList forKey:[NSNumber numberWithInt:PlaceCategoryTypePlaceSpot]];
        
        PlaceItemList *hotelItemList = [[[PlaceItemList alloc] init] autorelease];
        [self.placeItemDic setObject:hotelItemList forKey:[NSNumber numberWithInt:PlaceCategoryTypePlaceHotel]];
        
        PlaceItemList *restaurantItemList = [[[PlaceItemList alloc] init] autorelease];
        [self.placeItemDic setObject:restaurantItemList forKey:[NSNumber numberWithInt:PlaceCategoryTypePlaceRestraurant]];
        
        PlaceItemList *shoppingItemList = [[[PlaceItemList alloc] init] autorelease];
        [self.placeItemDic setObject:shoppingItemList forKey:[NSNumber numberWithInt:PlaceCategoryTypePlaceShopping]];
        
        PlaceItemList *entertainmentItemList = [[[PlaceItemList alloc] init] autorelease];
        [self.placeItemDic setObject:entertainmentItemList forKey:[NSNumber numberWithInt:PlaceCategoryTypePlaceEntertainment]];
    }
    
    return self;
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
    [_placeItemDic release];
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
            
//            NSArray *cityList = [localApp citiesList];
//            for (City *city in cityList) {
//                PPDebug(@"city = %@", city.cityName);
//                PPDebug(@"city size = %d", city.dataSize);
//            }
//            
//            NSArray *testCityList = [localApp testCitiesList];
//            for (City *city in testCityList) {
//                PPDebug(@"testcity = %@", city.cityName);
//                PPDebug(@"city size = %d", city.dataSize);
//            }
//            
//            for (RecommendedApp *app in localApp.recommendedAppsList) {
//                PPDebug(@"app.name = %@", app.name);
//            }
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
    
    NSArray *cityList = [appData citiesList];
    for (City *city in cityList) {
        PPDebug(@"city = %@", city.cityName);
        PPDebug(@"city size = %d", city.dataSize);
    }
    
    NSArray *testCityList = [appData testCitiesList];
    for (City *city in testCityList) {
        PPDebug(@"testcity = %@", city.cityName);
        PPDebug(@"city size = %d", city.dataSize);
    }
    
    for (RecommendedApp *app in appData.recommendedAppsList) {
        PPDebug(@"app.name = %@", app.name);
    }
    
    for (NameIdPair *theme in appData.routeThemesList) {
        PPDebug(@"theme.name = %@", theme.name);
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

//- (void)setCurrentCityId:(int)newCityId 
//{
//    int currentCityId = [self getCurrentCityId];
//    if (newCityId == currentCityId) {
//        return;
//    }
//    
//    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults]; 
//    [userDefault setObject:[NSNumber numberWithInt:newCityId] forKey:KEY_CURRENT_CITY];
//    [userDefault synchronize];
//}

- (void)setCurrentCityId:(int)newCityId delegate:(id<AppManagerProtocol>)delegate
{
    int currentCityId = [self getCurrentCityId];
    if (newCityId == currentCityId) {
        return;
    }
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults]; 
    [userDefault setObject:[NSNumber numberWithInt:newCityId] forKey:KEY_CURRENT_CITY];
    [userDefault synchronize];
    
    if ([delegate respondsToSelector:@selector(currentCityDidChange:)]) {
        [delegate currentCityDidChange:newCityId];
    }
}

- (NSArray*)getSubCategoryItemList:(int)categoryId
{   
    return [[_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]] subCategoryItems];
}

- (NSArray *)getServiceItemList:(int)categoryId
{
    return [[_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]] serviceItems];
}

- (NSArray *)getAreaItemList:(int)categoryId
{
    return [[_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]] areaItems];
}

- (void)updateSubCategoryItemList:(int)categoryId placeList:(NSArray*)placeList
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
    
    PlaceItemList *itemList = [_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]];
    itemList.subCategoryItems = subCategoryItemList;
}

- (void)updateSubCategoryItemList:(int)categoryId staticticsList:(NSArray *)staticticsList
{        
    PlaceItemList *itemList = [_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]];
    itemList.subCategoryItems = [self statisticsList2ItemList:staticticsList];
}


- (void)updateServiceItemList:(int)categoryId placeList:(NSArray *)placeList
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
    
    PlaceItemList *itemList = [_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]];
    itemList.serviceItems = serviceItemList;
}

- (void)updateServiceItemList:(int)categoryId staticticsList:(NSArray *)staticticsList
{
    PlaceItemList *itemList = [_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]];
    itemList.serviceItems = [self statisticsList2ItemList:staticticsList];
}

- (void)updateAreaItemList:(int)categoryId cityId:(int)cityId placeList:(NSArray *)placeList
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
    
    PlaceItemList *itemList = [_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]];
    itemList.areaItems = areaList; 
}

- (void)updateAreaItemList:(int)categoryId cityId:(int)cityId staticticsList:(NSArray *)staticticsList
{
    PlaceItemList *itemList = [_placeItemDic objectForKey:[NSNumber numberWithInt:categoryId]];
    itemList.areaItems = [self statisticsList2ItemList:staticticsList];
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
    NSString *rankString = @"";
    
    for (int i = 0; i < priceRank; i ++) {
        rankString = [rankString stringByAppendingString:@"$"];
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
    
    [spotSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FROM_EXPENSIVE_TO_CHEAP
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
    
    [hotelSortItems addObject:[Item itemWithId:SORT_BY_HOTEL_STARTS
                                      itemName:NSLS(@"星级高至低") 
                                         count:0]];
    
    [hotelSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FROM_EXPENSIVE_TO_CHEAP
                                      itemName:NSLS(@"价格高至低") 
                                         count:0]];
    
    [hotelSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FROM_CHEAP_TO_EXPENSIVE
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
    
    [hestaurantSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FROM_EXPENSIVE_TO_CHEAP
                                           itemName:NSLS(@"价格高至低") 
                                              count:0]];
    
    [hestaurantSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FROM_CHEAP_TO_EXPENSIVE
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
    
    [entertainmentSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FROM_EXPENSIVE_TO_CHEAP
                                              itemName:NSLS(@"价格高至低") 
                                                 count:0]];
    
    [entertainmentSortItems addObject:[Item itemWithId:SORT_BY_PRICE_FROM_CHEAP_TO_EXPENSIVE
                                              itemName:NSLS(@"价格低至高") 
                                                 count:0]];
    
    [entertainmentSortItems addObject:[Item itemWithId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                              itemName:NSLS(@"距离近至远") 
                                                 count:0]];
    
    return entertainmentSortItems;
}


- (NSArray *)getRegions
{
    return _app.regionsList;
}

- (int)getRegionIdByCityId:(int)cityId
{
    int reId = ALL_CATEGORY;
    
    for (RouteCity *city in _app.destinationCitiesList) {
        if (city.routeCityId == cityId) {
            reId = city.regionId;
            break;
        }
    }
    
    return reId;
}


- (NSArray *)getDepartCityItemList:(NSArray *)staticticsList
{
    return [self statisticsList2ItemList:staticticsList];

}

- (NSArray *)getDestinationCityItemList
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    [retArray addObject:[Item itemWithId:ALL_CATEGORY 
                                itemName:NSLS(@"全部") 
                                   count:0]];
    
    for (RouteCity *city in _app.destinationCitiesList) {
        [retArray addObject:[Item itemWithId:city.routeCityId
                                    itemName:city.cityName 
                                       count:0]];
    }
    
    return retArray;
}

- (NSArray *)getRouteThemeItemList;
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    [retArray addObject:[Item itemWithId:ALL_CATEGORY 
                                itemName:NSLS(@"全部") 
                                   count:0]];
    
    for ( NameIdPair *theme in _app.routeThemesList) {
//        int count = [[RouteUtils getRouteList:routeList inTheme:theme.id] count];
//        if (count != 0) {
            [retArray addObject:[Item itemWithNameIdPair:theme count:0]];
//        }
    }
    
    return retArray; 
}

- (NSArray *)getRouteCategoryItemList:(NSArray *)routeList
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    [retArray addObject:[Item itemWithId:ALL_CATEGORY 
                                itemName:NSLS(@"全部") 
                                   count:0]];

    
    for ( NameIdPair *category in _app.routeCategorysList) {
//        int count = [[RouteUtils getRouteList:routeList inCategory:category.id] count];
//        if (count != 0) {
            [retArray addObject:[Item itemWithNameIdPair:category count:0]];
//        }
    }
    
    return retArray; 
}

- (NSArray *)getAgencyItemList:(NSArray *)staticticsList
{
    return [self statisticsList2ItemList:staticticsList];
}

- (NSArray *)statisticsList2ItemList:(NSArray *)staticticsList
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (Statistics *statistics in staticticsList) {
        [retArray addObject:[Item itemWithStatistics:statistics]];
        //PPDebug(@"name = %@ count = %d",statistics.name, statistics.count);
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

- (Agency*)getAgency:(int)agencyId
{
    for (Agency *agency in _app.agenciesList) {
        if (agency.agencyId == agencyId) {
            return agency;
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

- (NSString*)getAgencyShortName:(int)agencyId
{
    for (Agency *agency in _app.agenciesList) {
        if (agency.agencyId == agencyId) {
            return agency.shortName;
        }
    }
    
    return nil;
}

- (NSArray*)buildAdultItemList
{
    NSMutableArray *adultItems = [[[NSMutableArray alloc] init] autorelease];    
    
    [adultItems addObject:[Item itemWithId:1
                                  itemName:NSLS(@"成人1位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:2
                                  itemName:NSLS(@"成人2位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:3
                                  itemName:NSLS(@"成人3位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:4
                                  itemName:NSLS(@"成人4位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:5
                                  itemName:NSLS(@"成人5位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:6
                                  itemName:NSLS(@"成人6位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:7
                                  itemName:NSLS(@"成人7位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:8
                                  itemName:NSLS(@"成人8位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:9
                                  itemName:NSLS(@"成人9位") 
                                     count:0]];
    
    [adultItems addObject:[Item itemWithId:10
                                  itemName:NSLS(@"成人10位") 
                                     count:0]];
    
    return adultItems;
}







- (NSArray*)getSelectedPackageIdItemList:(TouristRoute *)aRoute
{
    NSMutableArray *packageIdItems = [[[NSMutableArray alloc] init] autorelease];    
        
    for (TravelPackage *package in aRoute.packagesList) {
        [packageIdItems addObject:[Item itemWithId:package.packageId 
                                          itemName:package.name 
                                             count:0]];
    }

    return packageIdItems;
}

//- (NSInteger)getTotalSelectedPackageIds:(TouristRoute *)aRoute
//{
//    return [aRoute.packagesList count];
//}





- (NSArray*)buildChildrenItemList
{
    NSMutableArray *childrenItems = [[[NSMutableArray alloc] init] autorelease]; 
    
    [childrenItems addObject:[Item itemWithId:0
                                     itemName:NSLS(@"儿童0位") 
                                        count:0]];
    
    [childrenItems addObject:[Item itemWithId:1
                                  itemName:NSLS(@"儿童1位") 
                                     count:0]];
    
    [childrenItems addObject:[Item itemWithId:2
                                  itemName:NSLS(@"儿童2位") 
                                     count:0]];
    
    [childrenItems addObject:[Item itemWithId:3
                                  itemName:NSLS(@"儿童3位") 
                                     count:0]];
    
    [childrenItems addObject:[Item itemWithId:4
                                  itemName:NSLS(@"儿童4位") 
                                     count:0]];
    
    [childrenItems addObject:[Item itemWithId:5
                                  itemName:NSLS(@"儿童5位") 
                                     count:0]];
    
    [childrenItems addObject:[Item itemWithId:6
                                  itemName:NSLS(@"儿童6位") 
                                     count:0]];
    
    [childrenItems addObject:[Item itemWithId:7
                                  itemName:NSLS(@"儿童7位") 
                                     count:0]];
    
    [childrenItems addObject:[Item itemWithId:8
                                     itemName:NSLS(@"儿童8位") 
                                        count:0]];
    
    [childrenItems addObject:[Item itemWithId:9
                                     itemName:NSLS(@"儿童9位") 
                                        count:0]];
    
    [childrenItems addObject:[Item itemWithId:10
                                     itemName:NSLS(@"儿童10位") 
                                        count:0]];
    
    return childrenItems;
}

- (NSArray *)buildRoutePriceRankItemList
{
    NSMutableArray *priceRankItemList = [[[NSMutableArray alloc] init] autorelease]; 
    
    [priceRankItemList addObject:[Item itemWithId:ALL_CATEGORY
                                         itemName:NSLS(@"全部") 
                                            count:0]];
    
    [priceRankItemList addObject:[Item itemWithId:PRICE_BELOW_1500
                                         itemName:NSLS(@"1500以下") 
                                        count:0]];
    
    [priceRankItemList addObject:[Item itemWithId:PRICE_1500_4000
                                     itemName:NSLS(@"1500-4000") 
                                        count:0]];
    
    [priceRankItemList addObject:[Item itemWithId:PRICE_MORE_THAN_4000
                                     itemName:NSLS(@"4000以上") 
                                        count:0]];
    
    return priceRankItemList;
}

- (NSArray *)buildDaysRangeItemList
{
    NSMutableArray *daysRangeItemList = [[[NSMutableArray alloc] init] autorelease]; 
    
    [daysRangeItemList addObject:[Item itemWithId:ALL_CATEGORY
                                         itemName:NSLS(@"全部") 
                                            count:0]];
    
    [daysRangeItemList addObject:[Item itemWithId:DAYS_1_3
                                         itemName:NSLS(@"1-3天") 
                                            count:0]];
    
    [daysRangeItemList addObject:[Item itemWithId:DAYS_3_8
                                         itemName:NSLS(@"4-8天") 
                                            count:0]];
    
    [daysRangeItemList addObject:[Item itemWithId:DAYS_MORE_THAN_8
                                         itemName:NSLS(@"8天以上") 
                                            count:0]];
    
    return daysRangeItemList;
}

- (NSArray *)buildRouteSortItemList
{
    NSMutableArray *routeSortItems = [[[NSMutableArray alloc] init] autorelease];    
    
    [routeSortItems addObject:[Item itemWithId:ROUTE_SORT_BY_DEFAULT
                                              itemName:NSLS(@"默认排序") 
                                                 count:0]];
    
    [routeSortItems addObject:[Item itemWithId:ROUTE_SORT_BY_FOLLOW_COUNT_FROM_MORE_TO_LESS
                                              itemName:NSLS(@"关注度从高到低") 
                                                 count:0]];
    
    [routeSortItems addObject:[Item itemWithId:ROUTE_SORT_BY_SORT_BY_RECOMMEND
                                      itemName:NSLS(@"大拇指评价从高到低") 
                                         count:0]];
    
    [routeSortItems addObject:[Item itemWithId:ROUTE_SORT_BY_PRICE_FROM_CHEAP_TO_EXPENSIVE
                                              itemName:NSLS(@"价格从低到高") 
                                                 count:0]];
    
    [routeSortItems addObject:[Item itemWithId:ROUTE_SORT_BY_PRICE_FROM_EXPENSIVE_TO_CHEAP
                                              itemName:NSLS(@"价格从高到低") 
                                                 count:0]];
    
    [routeSortItems addObject:[Item itemWithId:ROUTE_SORT_BY_DAYS_FROM_MORE_TO_LESS
                                      itemName:NSLS(@"出行天数从多到少") 
                                         count:0]];
    
    [routeSortItems addObject:[Item itemWithId:ROUTE_SORT_BY_DAYS_FROM_LESS_TO_MORE
                                      itemName:NSLS(@"出行天数从少到多") 
                                         count:0]];
    
    return routeSortItems;
}

- (NSArray *)getServicePhoneList
{
    return [NSArray arrayWithObjects:_app.serviceTelephone, nil];
}


- (NSString *)getCityGroupName:(int)groupId
{
    for (CityGroup *group in _app.cityGroupsList) {
        if (group.groupId == groupId) {
            return group.name;
        }
    }
    return nil;
}



- (NSArray *)getCityListInGroup:(int)groupId
{
    NSMutableArray *cityList = [NSMutableArray array];
    for (City *city in CITY_LIST) {
        if (city.groupId == groupId) {
            [cityList addObject:city];
        }
    } 
    
    return cityList;
}


- (NSDictionary *)getGroupCitysDicList
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSMutableArray *hotCities  = [NSMutableArray array];
    for (City *city in CITY_LIST) {
        if (city.hotCity) {
            [hotCities addObject:city];
        }
    }
    [dic setObject:hotCities forKey:NSLS(@"热门")];

    for (NSString *countryName in [self getCountryNameList]) {
        NSArray *cities = [self getCitiesOfCountry:countryName];
        [dic setObject:cities forKey:countryName];
    }
    
    return dic;
}

- (NSDictionary *)getNonRepeatedGroupCitysDicList
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *countryName in [self getCountryNameList]) {
        NSArray *cities = [self getCitiesOfCountry:countryName];
        [dic setObject:cities forKey:countryName];
    }
    
    return dic;
}

- (NSArray *)getGroupNameList
{
    NSMutableArray *groupName = [NSMutableArray array];
    [groupName addObject:NSLS(@"热门")];
    [groupName addObjectsFromArray:[self getCountryNameList]];
    
    return groupName;
}


- (NSArray *)getCitiesOfCountry:(NSString *)countryName
{
    NSMutableArray *cities = [NSMutableArray array];
    for (City *city in CITY_LIST) {
        if ([city.countryName isEqualToString:countryName]) {
            [cities addObject:city];
        }
    }
    
    return cities;
}

- (NSArray *)getCountryNameList
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    for (City *city in CITY_LIST) {
        [dic setObject:NSLS(@"") forKey:city.countryName];
    }
    
    NSArray *countryNameList =  [[dic allKeys] sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *countryName1 = (NSString *)obj1;
        NSString *countryName2 = (NSString *)obj2;
        
        return [[countryName1 pinyinFirstLetter] compare:[countryName2 pinyinFirstLetter] options:NSCaseInsensitiveSearch];
    }];
    
    return countryNameList;
}

- (NSArray *)getAgencyListFromLocalRouteList:(NSArray *)list
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (LocalRoute *route in list) {
        [array addObject:[self getAgency:route.agencyId]];
    }
    
    return [self deleteRepeatedObjectsFromArray:array];
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




- (NSDictionary *)getAgencyDicFromAgencyList:(NSArray *)agencyList
                              localRouteList:(NSArray *)routeList
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (Agency *agency in agencyList) {
        NSArray *array =  [self filterLocalRoutes:routeList agencyId:agency.agencyId];
        [dic setObject:array forKey:agency.name];
    }
    
    return dic;
}


- (NSArray *)filterLocalRoutes:(NSArray *)list agencyId:(int)agencyId 
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (LocalRoute *route in list) {
        if (route.agencyId == agencyId) {
            [array addObject:route];
        }
    }
    
    return array;
}

- (NSArray *)buildDepartPlaceItemList:(NSArray *)departPlaceList
{
    NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];    
    
    
    for (DepartPlace *departPlace in departPlaceList) {
        [items addObject:[Item itemWithId:departPlace.departPlaceId
                                 itemName:departPlace.departPlace
                                    count:0]];
    }
    
    return items;
}

@end
