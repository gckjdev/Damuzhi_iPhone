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

@implementation AppManager

static AppManager* _defaultAppManager = nil;
@synthesize app = _app;

+ (id)defaultManager
{
    if (_defaultAppManager == nil){
        _defaultAppManager = [[AppManager alloc] init];
    }
    
    return _defaultAppManager;
}

-(void)dealloc
{
    [_app release];
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
    [[appData data] writeToFile:[AppUtils getAppFilePath] atomically:YES];
}

- (City*)getCity:(int)cityId
{
    for (City *city in _app.citiesList) {
        if(city.cityId == cityId)
        {
            return city;
        }
    }
    
    return nil;
}

- (City*)getTestCity:(int)cityId
{
    for (City *testCity in _app.testCitiesList) {
        if(testCity.cityId == cityId)
        {
            return testCity;
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
    return _app.citiesList;
}

- (NSArray*)getCityIdList
{
    NSMutableArray *cityIdList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in _app.citiesList) {
        NSNumber *cityId = [[[NSNumber alloc] initWithInt:city.cityId] autorelease];
        [cityIdList addObject:cityId]; 
    }
    
    return cityIdList;
}

- (NSArray*)getCityNameList
{
    NSMutableArray *cityNameList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in _app.citiesList) {
        [cityNameList addObject:city.cityName]; 
    }
    
    return cityNameList;
}

- (NSArray*)getTestCityNameList
{
    NSMutableArray *cityNameList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in _app.testCitiesList) {
        [cityNameList addObject:city.cityName]; 
    }
    
    return cityNameList;
}

- (NSString*)getCityName:(int)cityId
{
    NSString *cityName = NSLS(@"");;
    for (City *city in _app.citiesList) {
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
    for (City *city in _app.citiesList) {
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
    for (City *city in _app.citiesList) {
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
    for (City *city in _app.citiesList) {
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
    for (City *city in _app.citiesList) {
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
    [[SelectedItemIdsManager defaultManager] resetAllSelectedItems];
}


- (NSArray*)getSubCategoryItemList:(int)categoryId placeList:(NSArray*)placeList
{
    NSMutableArray *subCategoryItemList = [[[NSMutableArray alloc] init] autorelease];    
    
    [subCategoryItemList addObject:[[[Item alloc] initWithItemId:ALL_CATEGORY itemName:NSLS(@"全部") count:[placeList count]] autorelease]];
    
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *subCategory in [placeMeta subCategoryListList]) {
            int count = [[PlaceUtils getPlaceList:placeList inSameSubcategory:subCategory.id] count];
            if (count != 0) {
                [subCategoryItemList addObject:[[[Item alloc] initWithNameIdPair:subCategory count:count] autorelease]];
            }
        }
    }
    
    return subCategoryItemList;
}

- (NSArray*)getServiceItemList:(int)categoryId placeList:(NSArray *)placeList
{
    NSMutableArray *serviceList = [[[NSMutableArray alloc] init] autorelease];
    
    [serviceList addObject:[[[Item alloc] initWithItemId:ALL_CATEGORY 
                                                itemName:NSLS(@"全部") 
                                                   count:[placeList count]] autorelease]];
        
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *providedService in [placeMeta providedServiceListList]) {
            int count = [[PlaceUtils getPlaceList:placeList hasSameService:providedService.id] count];
            if (count != 0) {
                [serviceList addObject:[[[Item alloc] initWithNameIdPair:providedService
                                                                   count:count] autorelease]];
            }
        }
    }
    
    return serviceList;
}

- (NSArray *)getAreaItemList:(int)cityId placeList:(NSArray *)placeList
{
    NSMutableArray *areaList = [[[NSMutableArray alloc] init] autorelease];
    
    [areaList addObject:[[[Item alloc] initWithItemId:ALL_CATEGORY itemName:NSLS(@"全部")
                                                count:[placeList count]] autorelease]];
    
    
    for (CityArea* area in [[self getCity:cityId] areaListList]) {
        int count = [[PlaceUtils getPlaceList:placeList inSameArea:area.areaId] count];
        if (count != 0) {
            [areaList addObject:[[[Item alloc] initWithItemId:area.areaId itemName:area.areaName count:count] autorelease]];
        }
    }
    
    return areaList;
}

- (NSArray *)getPriceRankItemList:(int)cityId
{
    NSMutableArray *priceList = [[[NSMutableArray alloc] init] autorelease];
    
    [priceList addObject:[[[Item alloc] initWithItemId:ALL_CATEGORY 
                                              itemName:NSLS(@"全部")
                                                count:0] autorelease]];
    
    
    
    for (int rank = 1; rank <= [self getPriceRank:cityId]; rank ++) {
        NSString *priceRankString = [self getPriceRankString:rank];
        [priceList addObject:[[[Item alloc] initWithItemId:rank 
                                                  itemName:priceRankString 
                                                     count:0] autorelease]];
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
    
    [spotSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_RECOMMEND
                                                  itemName:NSLS(@"大拇指推荐高至低") 
                                                     count:0] autorelease]];
    
    [spotSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                                  itemName:NSLS(@"距离近至远") 
                                                     count:0] autorelease]];
    
    [spotSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP
                                                  itemName:NSLS(@"门票价格高到低") 
                                                     count:0] autorelease]];
    
    return spotSortItems;
}

- (NSArray*)buildHotelSortItemList
{
    NSMutableArray *hotelSortItems = [[[NSMutableArray alloc] init] autorelease];    
    
    [hotelSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_RECOMMEND
                                                   itemName:NSLS(@"大拇指推荐高至低") 
                                                      count:0] autorelease]];
    
    [hotelSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_STARTS
                                                   itemName:NSLS(@"星级高至低") 
                                                      count:0] autorelease]];
    
    [hotelSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP
                                                   itemName:NSLS(@"价格高至低") 
                                                      count:0] autorelease]];
    
    [hotelSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE
                                                   itemName:NSLS(@"价格低至高") 
                                                      count:0] autorelease]];
    
    [hotelSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                                   itemName:NSLS(@"距离近至远") 
                                                      count:0] autorelease]];
    
    return hotelSortItems;
}

- (NSArray*)buildRestaurantSortItemList
{
    NSMutableArray *hestaurantSortItems = [[[NSMutableArray alloc] init] autorelease];  
    
    [hestaurantSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_RECOMMEND
                                                        itemName:NSLS(@"大拇指推荐高至低") 
                                                           count:0] autorelease]];
    
    [hestaurantSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP
                                                        itemName:NSLS(@"价格高至低") 
                                                           count:0] autorelease]];
    
    [hestaurantSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE
                                                        itemName:NSLS(@"价格低至高") 
                                                           count:0] autorelease]];
    
    [hestaurantSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                                        itemName:NSLS(@"距离近至远") 
                                                           count:0] autorelease]];
    
    return hestaurantSortItems;
}

- (NSArray*)buildShoppingSortItemList
{
    NSMutableArray *shoppingtSortItems = [[[NSMutableArray alloc] init] autorelease];
    
    [shoppingtSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_RECOMMEND
                                                       itemName:NSLS(@"大拇指推荐高至低") 
                                                          count:0] autorelease]];
    
    [shoppingtSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                                       itemName:NSLS(@"距离近至远") 
                                                          count:0] autorelease]];
    
    return shoppingtSortItems;
}

- (NSArray*)buildEntertainmentSortItemList
{
    NSMutableArray *entertainmentSortItems = [[[NSMutableArray alloc] init] autorelease];    
    
    [entertainmentSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_RECOMMEND
                                                           itemName:NSLS(@"大拇指推荐高至低") 
                                                              count:0] autorelease]];
    
    [entertainmentSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP
                                                           itemName:NSLS(@"价格高至低") 
                                                              count:0] autorelease]];
    
    [entertainmentSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE
                                                           itemName:NSLS(@"价格低至高") 
                                                              count:0] autorelease]];
    
    [entertainmentSortItems addObject:[[[Item alloc] initWithItemId:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR
                                                           itemName:NSLS(@"距离近至远") 
                                                              count:0] autorelease]];
    
    return entertainmentSortItems;
}


- (NSString*)getRouteCityName:(int)routeCityId
{
    return nil;
}


@end
