// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "TouristRoute.pb.h"

@class Accommodation;
@class Accommodation_Builder;
@class Agency;
@class Agency_Builder;
@class App;
@class App_Builder;
@class Booking;
@class Booking_Builder;
@class City;
@class CityArea;
@class CityArea_Builder;
@class CityGroup;
@class CityGroup_Builder;
@class CityList;
@class CityList_Builder;
@class City_Builder;
@class DailySchedule;
@class DailySchedule_Builder;
@class Flight;
@class Flight_Builder;
@class HelpInfo;
@class HelpInfo_Builder;
@class NameIdPair;
@class NameIdPair_Builder;
@class Order;
@class OrderList;
@class OrderList_Builder;
@class Order_Builder;
@class PlaceMeta;
@class PlaceMeta_Builder;
@class PlaceTour;
@class PlaceTour_Builder;
@class RecommendedApp;
@class RecommendedApp_Builder;
@class Region;
@class Region_Builder;
@class RouteCity;
@class RouteCity_Builder;
@class TouristRoute;
@class TouristRouteList;
@class TouristRouteList_Builder;
@class TouristRoute_Builder;
@class TravelPackage;
@class TravelPackage_Builder;
typedef enum {
  PlaceCategoryTypePlaceAll = 9999,
  PlaceCategoryTypePlaceSpot = 1,
  PlaceCategoryTypePlaceHotel = 2,
  PlaceCategoryTypePlaceRestraurant = 3,
  PlaceCategoryTypePlaceShopping = 4,
  PlaceCategoryTypePlaceEntertainment = 5,
} PlaceCategoryType;

BOOL PlaceCategoryTypeIsValidValue(PlaceCategoryType value);


@interface AppRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface NameIdPair : PBGeneratedMessage {
@private
  BOOL hasId_:1;
  BOOL hasName_:1;
  BOOL hasImage_:1;
  int32_t id;
  NSString* name;
  NSString* image;
}
- (BOOL) hasName;
- (BOOL) hasId;
- (BOOL) hasImage;
@property (readonly, retain) NSString* name;
@property (readonly) int32_t id;
@property (readonly, retain) NSString* image;

+ (NameIdPair*) defaultInstance;
- (NameIdPair*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (NameIdPair_Builder*) builder;
+ (NameIdPair_Builder*) builder;
+ (NameIdPair_Builder*) builderWithPrototype:(NameIdPair*) prototype;

+ (NameIdPair*) parseFromData:(NSData*) data;
+ (NameIdPair*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (NameIdPair*) parseFromInputStream:(NSInputStream*) input;
+ (NameIdPair*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (NameIdPair*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (NameIdPair*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface NameIdPair_Builder : PBGeneratedMessage_Builder {
@private
  NameIdPair* result;
}

- (NameIdPair*) defaultInstance;

- (NameIdPair_Builder*) clear;
- (NameIdPair_Builder*) clone;

- (NameIdPair*) build;
- (NameIdPair*) buildPartial;

- (NameIdPair_Builder*) mergeFrom:(NameIdPair*) other;
- (NameIdPair_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (NameIdPair_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasName;
- (NSString*) name;
- (NameIdPair_Builder*) setName:(NSString*) value;
- (NameIdPair_Builder*) clearName;

- (BOOL) hasId;
- (int32_t) id;
- (NameIdPair_Builder*) setId:(int32_t) value;
- (NameIdPair_Builder*) clearId;

- (BOOL) hasImage;
- (NSString*) image;
- (NameIdPair_Builder*) setImage:(NSString*) value;
- (NameIdPair_Builder*) clearImage;
@end

@interface PlaceMeta : PBGeneratedMessage {
@private
  BOOL hasName_:1;
  BOOL hasCategoryId_:1;
  NSString* name;
  PlaceCategoryType categoryId;
  NSMutableArray* mutableSubCategoryListList;
  NSMutableArray* mutableProvidedServiceListList;
}
- (BOOL) hasCategoryId;
- (BOOL) hasName;
@property (readonly) PlaceCategoryType categoryId;
@property (readonly, retain) NSString* name;
- (NSArray*) subCategoryListList;
- (NameIdPair*) subCategoryListAtIndex:(int32_t) index;
- (NSArray*) providedServiceListList;
- (NameIdPair*) providedServiceListAtIndex:(int32_t) index;

+ (PlaceMeta*) defaultInstance;
- (PlaceMeta*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PlaceMeta_Builder*) builder;
+ (PlaceMeta_Builder*) builder;
+ (PlaceMeta_Builder*) builderWithPrototype:(PlaceMeta*) prototype;

+ (PlaceMeta*) parseFromData:(NSData*) data;
+ (PlaceMeta*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PlaceMeta*) parseFromInputStream:(NSInputStream*) input;
+ (PlaceMeta*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PlaceMeta*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PlaceMeta*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PlaceMeta_Builder : PBGeneratedMessage_Builder {
@private
  PlaceMeta* result;
}

- (PlaceMeta*) defaultInstance;

- (PlaceMeta_Builder*) clear;
- (PlaceMeta_Builder*) clone;

- (PlaceMeta*) build;
- (PlaceMeta*) buildPartial;

- (PlaceMeta_Builder*) mergeFrom:(PlaceMeta*) other;
- (PlaceMeta_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PlaceMeta_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCategoryId;
- (PlaceCategoryType) categoryId;
- (PlaceMeta_Builder*) setCategoryId:(PlaceCategoryType) value;
- (PlaceMeta_Builder*) clearCategoryId;

- (BOOL) hasName;
- (NSString*) name;
- (PlaceMeta_Builder*) setName:(NSString*) value;
- (PlaceMeta_Builder*) clearName;

- (NSArray*) subCategoryListList;
- (NameIdPair*) subCategoryListAtIndex:(int32_t) index;
- (PlaceMeta_Builder*) replaceSubCategoryListAtIndex:(int32_t) index with:(NameIdPair*) value;
- (PlaceMeta_Builder*) addSubCategoryList:(NameIdPair*) value;
- (PlaceMeta_Builder*) addAllSubCategoryList:(NSArray*) values;
- (PlaceMeta_Builder*) clearSubCategoryListList;

- (NSArray*) providedServiceListList;
- (NameIdPair*) providedServiceListAtIndex:(int32_t) index;
- (PlaceMeta_Builder*) replaceProvidedServiceListAtIndex:(int32_t) index with:(NameIdPair*) value;
- (PlaceMeta_Builder*) addProvidedServiceList:(NameIdPair*) value;
- (PlaceMeta_Builder*) addAllProvidedServiceList:(NSArray*) values;
- (PlaceMeta_Builder*) clearProvidedServiceListList;
@end

@interface CityArea : PBGeneratedMessage {
@private
  BOOL hasAreaId_:1;
  BOOL hasAreaName_:1;
  int32_t areaId;
  NSString* areaName;
}
- (BOOL) hasAreaId;
- (BOOL) hasAreaName;
@property (readonly) int32_t areaId;
@property (readonly, retain) NSString* areaName;

+ (CityArea*) defaultInstance;
- (CityArea*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CityArea_Builder*) builder;
+ (CityArea_Builder*) builder;
+ (CityArea_Builder*) builderWithPrototype:(CityArea*) prototype;

+ (CityArea*) parseFromData:(NSData*) data;
+ (CityArea*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityArea*) parseFromInputStream:(NSInputStream*) input;
+ (CityArea*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityArea*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CityArea*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CityArea_Builder : PBGeneratedMessage_Builder {
@private
  CityArea* result;
}

- (CityArea*) defaultInstance;

- (CityArea_Builder*) clear;
- (CityArea_Builder*) clone;

- (CityArea*) build;
- (CityArea*) buildPartial;

- (CityArea_Builder*) mergeFrom:(CityArea*) other;
- (CityArea_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CityArea_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasAreaId;
- (int32_t) areaId;
- (CityArea_Builder*) setAreaId:(int32_t) value;
- (CityArea_Builder*) clearAreaId;

- (BOOL) hasAreaName;
- (NSString*) areaName;
- (CityArea_Builder*) setAreaName:(NSString*) value;
- (CityArea_Builder*) clearAreaName;
@end

@interface City : PBGeneratedMessage {
@private
  BOOL hasHotCity_:1;
  BOOL hasCityId_:1;
  BOOL hasDataSize_:1;
  BOOL hasPriceRank_:1;
  BOOL hasGroupId_:1;
  BOOL hasCityName_:1;
  BOOL hasLatestVersion_:1;
  BOOL hasCountryName_:1;
  BOOL hasDownloadUrl_:1;
  BOOL hasCurrencySymbol_:1;
  BOOL hasCurrencyId_:1;
  BOOL hasCurrencyName_:1;
  BOOL hotCity_:1;
  int32_t cityId;
  int32_t dataSize;
  int32_t priceRank;
  int32_t groupId;
  NSString* cityName;
  NSString* latestVersion;
  NSString* countryName;
  NSString* downloadUrl;
  NSString* currencySymbol;
  NSString* currencyId;
  NSString* currencyName;
  NSMutableArray* mutableAreaListList;
}
- (BOOL) hasCityId;
- (BOOL) hasCityName;
- (BOOL) hasLatestVersion;
- (BOOL) hasCountryName;
- (BOOL) hasDataSize;
- (BOOL) hasDownloadUrl;
- (BOOL) hasCurrencySymbol;
- (BOOL) hasCurrencyId;
- (BOOL) hasCurrencyName;
- (BOOL) hasPriceRank;
- (BOOL) hasGroupId;
- (BOOL) hasHotCity;
@property (readonly) int32_t cityId;
@property (readonly, retain) NSString* cityName;
@property (readonly, retain) NSString* latestVersion;
@property (readonly, retain) NSString* countryName;
@property (readonly) int32_t dataSize;
@property (readonly, retain) NSString* downloadUrl;
@property (readonly, retain) NSString* currencySymbol;
@property (readonly, retain) NSString* currencyId;
@property (readonly, retain) NSString* currencyName;
@property (readonly) int32_t priceRank;
@property (readonly) int32_t groupId;
- (BOOL) hotCity;
- (NSArray*) areaListList;
- (CityArea*) areaListAtIndex:(int32_t) index;

+ (City*) defaultInstance;
- (City*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (City_Builder*) builder;
+ (City_Builder*) builder;
+ (City_Builder*) builderWithPrototype:(City*) prototype;

+ (City*) parseFromData:(NSData*) data;
+ (City*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (City*) parseFromInputStream:(NSInputStream*) input;
+ (City*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (City*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (City*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface City_Builder : PBGeneratedMessage_Builder {
@private
  City* result;
}

- (City*) defaultInstance;

- (City_Builder*) clear;
- (City_Builder*) clone;

- (City*) build;
- (City*) buildPartial;

- (City_Builder*) mergeFrom:(City*) other;
- (City_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (City_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCityId;
- (int32_t) cityId;
- (City_Builder*) setCityId:(int32_t) value;
- (City_Builder*) clearCityId;

- (BOOL) hasCityName;
- (NSString*) cityName;
- (City_Builder*) setCityName:(NSString*) value;
- (City_Builder*) clearCityName;

- (BOOL) hasLatestVersion;
- (NSString*) latestVersion;
- (City_Builder*) setLatestVersion:(NSString*) value;
- (City_Builder*) clearLatestVersion;

- (BOOL) hasCountryName;
- (NSString*) countryName;
- (City_Builder*) setCountryName:(NSString*) value;
- (City_Builder*) clearCountryName;

- (BOOL) hasDataSize;
- (int32_t) dataSize;
- (City_Builder*) setDataSize:(int32_t) value;
- (City_Builder*) clearDataSize;

- (BOOL) hasDownloadUrl;
- (NSString*) downloadUrl;
- (City_Builder*) setDownloadUrl:(NSString*) value;
- (City_Builder*) clearDownloadUrl;

- (NSArray*) areaListList;
- (CityArea*) areaListAtIndex:(int32_t) index;
- (City_Builder*) replaceAreaListAtIndex:(int32_t) index with:(CityArea*) value;
- (City_Builder*) addAreaList:(CityArea*) value;
- (City_Builder*) addAllAreaList:(NSArray*) values;
- (City_Builder*) clearAreaListList;

- (BOOL) hasCurrencySymbol;
- (NSString*) currencySymbol;
- (City_Builder*) setCurrencySymbol:(NSString*) value;
- (City_Builder*) clearCurrencySymbol;

- (BOOL) hasCurrencyId;
- (NSString*) currencyId;
- (City_Builder*) setCurrencyId:(NSString*) value;
- (City_Builder*) clearCurrencyId;

- (BOOL) hasCurrencyName;
- (NSString*) currencyName;
- (City_Builder*) setCurrencyName:(NSString*) value;
- (City_Builder*) clearCurrencyName;

- (BOOL) hasPriceRank;
- (int32_t) priceRank;
- (City_Builder*) setPriceRank:(int32_t) value;
- (City_Builder*) clearPriceRank;

- (BOOL) hasGroupId;
- (int32_t) groupId;
- (City_Builder*) setGroupId:(int32_t) value;
- (City_Builder*) clearGroupId;

- (BOOL) hasHotCity;
- (BOOL) hotCity;
- (City_Builder*) setHotCity:(BOOL) value;
- (City_Builder*) clearHotCity;
@end

@interface CityList : PBGeneratedMessage {
@private
  NSMutableArray* mutableCitiesList;
}
- (NSArray*) citiesList;
- (City*) citiesAtIndex:(int32_t) index;

+ (CityList*) defaultInstance;
- (CityList*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CityList_Builder*) builder;
+ (CityList_Builder*) builder;
+ (CityList_Builder*) builderWithPrototype:(CityList*) prototype;

+ (CityList*) parseFromData:(NSData*) data;
+ (CityList*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityList*) parseFromInputStream:(NSInputStream*) input;
+ (CityList*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityList*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CityList*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CityList_Builder : PBGeneratedMessage_Builder {
@private
  CityList* result;
}

- (CityList*) defaultInstance;

- (CityList_Builder*) clear;
- (CityList_Builder*) clone;

- (CityList*) build;
- (CityList*) buildPartial;

- (CityList_Builder*) mergeFrom:(CityList*) other;
- (CityList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CityList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) citiesList;
- (City*) citiesAtIndex:(int32_t) index;
- (CityList_Builder*) replaceCitiesAtIndex:(int32_t) index with:(City*) value;
- (CityList_Builder*) addCities:(City*) value;
- (CityList_Builder*) addAllCities:(NSArray*) values;
- (CityList_Builder*) clearCitiesList;
@end

@interface HelpInfo : PBGeneratedMessage {
@private
  BOOL hasVersion_:1;
  BOOL hasHelpHtml_:1;
  NSString* version;
  NSString* helpHtml;
}
- (BOOL) hasVersion;
- (BOOL) hasHelpHtml;
@property (readonly, retain) NSString* version;
@property (readonly, retain) NSString* helpHtml;

+ (HelpInfo*) defaultInstance;
- (HelpInfo*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (HelpInfo_Builder*) builder;
+ (HelpInfo_Builder*) builder;
+ (HelpInfo_Builder*) builderWithPrototype:(HelpInfo*) prototype;

+ (HelpInfo*) parseFromData:(NSData*) data;
+ (HelpInfo*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (HelpInfo*) parseFromInputStream:(NSInputStream*) input;
+ (HelpInfo*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (HelpInfo*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (HelpInfo*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface HelpInfo_Builder : PBGeneratedMessage_Builder {
@private
  HelpInfo* result;
}

- (HelpInfo*) defaultInstance;

- (HelpInfo_Builder*) clear;
- (HelpInfo_Builder*) clone;

- (HelpInfo*) build;
- (HelpInfo*) buildPartial;

- (HelpInfo_Builder*) mergeFrom:(HelpInfo*) other;
- (HelpInfo_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (HelpInfo_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasVersion;
- (NSString*) version;
- (HelpInfo_Builder*) setVersion:(NSString*) value;
- (HelpInfo_Builder*) clearVersion;

- (BOOL) hasHelpHtml;
- (NSString*) helpHtml;
- (HelpInfo_Builder*) setHelpHtml:(NSString*) value;
- (HelpInfo_Builder*) clearHelpHtml;
@end

@interface RecommendedApp : PBGeneratedMessage {
@private
  BOOL hasId_:1;
  BOOL hasName_:1;
  BOOL hasAppId_:1;
  BOOL hasDescription_:1;
  BOOL hasIcon_:1;
  BOOL hasUrl_:1;
  int32_t id;
  NSString* name;
  NSString* appId;
  NSString* description;
  NSString* icon;
  NSString* url;
}
- (BOOL) hasName;
- (BOOL) hasId;
- (BOOL) hasAppId;
- (BOOL) hasDescription;
- (BOOL) hasIcon;
- (BOOL) hasUrl;
@property (readonly, retain) NSString* name;
@property (readonly) int32_t id;
@property (readonly, retain) NSString* appId;
@property (readonly, retain) NSString* description;
@property (readonly, retain) NSString* icon;
@property (readonly, retain) NSString* url;

+ (RecommendedApp*) defaultInstance;
- (RecommendedApp*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (RecommendedApp_Builder*) builder;
+ (RecommendedApp_Builder*) builder;
+ (RecommendedApp_Builder*) builderWithPrototype:(RecommendedApp*) prototype;

+ (RecommendedApp*) parseFromData:(NSData*) data;
+ (RecommendedApp*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (RecommendedApp*) parseFromInputStream:(NSInputStream*) input;
+ (RecommendedApp*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (RecommendedApp*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (RecommendedApp*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface RecommendedApp_Builder : PBGeneratedMessage_Builder {
@private
  RecommendedApp* result;
}

- (RecommendedApp*) defaultInstance;

- (RecommendedApp_Builder*) clear;
- (RecommendedApp_Builder*) clone;

- (RecommendedApp*) build;
- (RecommendedApp*) buildPartial;

- (RecommendedApp_Builder*) mergeFrom:(RecommendedApp*) other;
- (RecommendedApp_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (RecommendedApp_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasName;
- (NSString*) name;
- (RecommendedApp_Builder*) setName:(NSString*) value;
- (RecommendedApp_Builder*) clearName;

- (BOOL) hasId;
- (int32_t) id;
- (RecommendedApp_Builder*) setId:(int32_t) value;
- (RecommendedApp_Builder*) clearId;

- (BOOL) hasAppId;
- (NSString*) appId;
- (RecommendedApp_Builder*) setAppId:(NSString*) value;
- (RecommendedApp_Builder*) clearAppId;

- (BOOL) hasDescription;
- (NSString*) description;
- (RecommendedApp_Builder*) setDescription:(NSString*) value;
- (RecommendedApp_Builder*) clearDescription;

- (BOOL) hasIcon;
- (NSString*) icon;
- (RecommendedApp_Builder*) setIcon:(NSString*) value;
- (RecommendedApp_Builder*) clearIcon;

- (BOOL) hasUrl;
- (NSString*) url;
- (RecommendedApp_Builder*) setUrl:(NSString*) value;
- (RecommendedApp_Builder*) clearUrl;
@end

@interface Agency : PBGeneratedMessage {
@private
  BOOL hasAgencyId_:1;
  BOOL hasName_:1;
  BOOL hasShortName_:1;
  int32_t agencyId;
  NSString* name;
  NSString* shortName;
}
- (BOOL) hasAgencyId;
- (BOOL) hasName;
- (BOOL) hasShortName;
@property (readonly) int32_t agencyId;
@property (readonly, retain) NSString* name;
@property (readonly, retain) NSString* shortName;

+ (Agency*) defaultInstance;
- (Agency*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Agency_Builder*) builder;
+ (Agency_Builder*) builder;
+ (Agency_Builder*) builderWithPrototype:(Agency*) prototype;

+ (Agency*) parseFromData:(NSData*) data;
+ (Agency*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Agency*) parseFromInputStream:(NSInputStream*) input;
+ (Agency*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Agency*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Agency*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Agency_Builder : PBGeneratedMessage_Builder {
@private
  Agency* result;
}

- (Agency*) defaultInstance;

- (Agency_Builder*) clear;
- (Agency_Builder*) clone;

- (Agency*) build;
- (Agency*) buildPartial;

- (Agency_Builder*) mergeFrom:(Agency*) other;
- (Agency_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Agency_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasAgencyId;
- (int32_t) agencyId;
- (Agency_Builder*) setAgencyId:(int32_t) value;
- (Agency_Builder*) clearAgencyId;

- (BOOL) hasName;
- (NSString*) name;
- (Agency_Builder*) setName:(NSString*) value;
- (Agency_Builder*) clearName;

- (BOOL) hasShortName;
- (NSString*) shortName;
- (Agency_Builder*) setShortName:(NSString*) value;
- (Agency_Builder*) clearShortName;
@end

@interface RouteCity : PBGeneratedMessage {
@private
  BOOL hasRouteCityId_:1;
  BOOL hasRegionId_:1;
  BOOL hasCityName_:1;
  BOOL hasCountryName_:1;
  int32_t routeCityId;
  int32_t regionId;
  NSString* cityName;
  NSString* countryName;
}
- (BOOL) hasRouteCityId;
- (BOOL) hasCityName;
- (BOOL) hasCountryName;
- (BOOL) hasRegionId;
@property (readonly) int32_t routeCityId;
@property (readonly, retain) NSString* cityName;
@property (readonly, retain) NSString* countryName;
@property (readonly) int32_t regionId;

+ (RouteCity*) defaultInstance;
- (RouteCity*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (RouteCity_Builder*) builder;
+ (RouteCity_Builder*) builder;
+ (RouteCity_Builder*) builderWithPrototype:(RouteCity*) prototype;

+ (RouteCity*) parseFromData:(NSData*) data;
+ (RouteCity*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (RouteCity*) parseFromInputStream:(NSInputStream*) input;
+ (RouteCity*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (RouteCity*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (RouteCity*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface RouteCity_Builder : PBGeneratedMessage_Builder {
@private
  RouteCity* result;
}

- (RouteCity*) defaultInstance;

- (RouteCity_Builder*) clear;
- (RouteCity_Builder*) clone;

- (RouteCity*) build;
- (RouteCity*) buildPartial;

- (RouteCity_Builder*) mergeFrom:(RouteCity*) other;
- (RouteCity_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (RouteCity_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasRouteCityId;
- (int32_t) routeCityId;
- (RouteCity_Builder*) setRouteCityId:(int32_t) value;
- (RouteCity_Builder*) clearRouteCityId;

- (BOOL) hasCityName;
- (NSString*) cityName;
- (RouteCity_Builder*) setCityName:(NSString*) value;
- (RouteCity_Builder*) clearCityName;

- (BOOL) hasCountryName;
- (NSString*) countryName;
- (RouteCity_Builder*) setCountryName:(NSString*) value;
- (RouteCity_Builder*) clearCountryName;

- (BOOL) hasRegionId;
- (int32_t) regionId;
- (RouteCity_Builder*) setRegionId:(int32_t) value;
- (RouteCity_Builder*) clearRegionId;
@end

@interface Region : PBGeneratedMessage {
@private
  BOOL hasRegionId_:1;
  BOOL hasRegionName_:1;
  int32_t regionId;
  NSString* regionName;
}
- (BOOL) hasRegionId;
- (BOOL) hasRegionName;
@property (readonly) int32_t regionId;
@property (readonly, retain) NSString* regionName;

+ (Region*) defaultInstance;
- (Region*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Region_Builder*) builder;
+ (Region_Builder*) builder;
+ (Region_Builder*) builderWithPrototype:(Region*) prototype;

+ (Region*) parseFromData:(NSData*) data;
+ (Region*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Region*) parseFromInputStream:(NSInputStream*) input;
+ (Region*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Region*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Region*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Region_Builder : PBGeneratedMessage_Builder {
@private
  Region* result;
}

- (Region*) defaultInstance;

- (Region_Builder*) clear;
- (Region_Builder*) clone;

- (Region*) build;
- (Region*) buildPartial;

- (Region_Builder*) mergeFrom:(Region*) other;
- (Region_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Region_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasRegionId;
- (int32_t) regionId;
- (Region_Builder*) setRegionId:(int32_t) value;
- (Region_Builder*) clearRegionId;

- (BOOL) hasRegionName;
- (NSString*) regionName;
- (Region_Builder*) setRegionName:(NSString*) value;
- (Region_Builder*) clearRegionName;
@end

@interface CityGroup : PBGeneratedMessage {
@private
  BOOL hasGroupId_:1;
  BOOL hasName_:1;
  int32_t groupId;
  NSString* name;
}
- (BOOL) hasGroupId;
- (BOOL) hasName;
@property (readonly) int32_t groupId;
@property (readonly, retain) NSString* name;

+ (CityGroup*) defaultInstance;
- (CityGroup*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CityGroup_Builder*) builder;
+ (CityGroup_Builder*) builder;
+ (CityGroup_Builder*) builderWithPrototype:(CityGroup*) prototype;

+ (CityGroup*) parseFromData:(NSData*) data;
+ (CityGroup*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityGroup*) parseFromInputStream:(NSInputStream*) input;
+ (CityGroup*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityGroup*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CityGroup*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CityGroup_Builder : PBGeneratedMessage_Builder {
@private
  CityGroup* result;
}

- (CityGroup*) defaultInstance;

- (CityGroup_Builder*) clear;
- (CityGroup_Builder*) clone;

- (CityGroup*) build;
- (CityGroup*) buildPartial;

- (CityGroup_Builder*) mergeFrom:(CityGroup*) other;
- (CityGroup_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CityGroup_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasGroupId;
- (int32_t) groupId;
- (CityGroup_Builder*) setGroupId:(int32_t) value;
- (CityGroup_Builder*) clearGroupId;

- (BOOL) hasName;
- (NSString*) name;
- (CityGroup_Builder*) setName:(NSString*) value;
- (CityGroup_Builder*) clearName;
@end

@interface App : PBGeneratedMessage {
@private
  BOOL hasDataVersion_:1;
  BOOL hasServiceTelephone_:1;
  NSString* dataVersion;
  NSString* serviceTelephone;
  NSMutableArray* mutableCitiesList;
  NSMutableArray* mutableTestCitiesList;
  NSMutableArray* mutablePlaceMetaDataListList;
  NSMutableArray* mutableRecommendedAppsList;
  NSMutableArray* mutableRegionsList;
  NSMutableArray* mutableDepartCitiesList;
  NSMutableArray* mutableDestinationCitiesList;
  NSMutableArray* mutableRouteThemesList;
  NSMutableArray* mutableRouteCategorysList;
  NSMutableArray* mutableAgenciesList;
  NSMutableArray* mutableCityGroupsList;
}
- (BOOL) hasDataVersion;
- (BOOL) hasServiceTelephone;
@property (readonly, retain) NSString* dataVersion;
@property (readonly, retain) NSString* serviceTelephone;
- (NSArray*) citiesList;
- (City*) citiesAtIndex:(int32_t) index;
- (NSArray*) testCitiesList;
- (City*) testCitiesAtIndex:(int32_t) index;
- (NSArray*) placeMetaDataListList;
- (PlaceMeta*) placeMetaDataListAtIndex:(int32_t) index;
- (NSArray*) recommendedAppsList;
- (RecommendedApp*) recommendedAppsAtIndex:(int32_t) index;
- (NSArray*) regionsList;
- (Region*) regionsAtIndex:(int32_t) index;
- (NSArray*) departCitiesList;
- (RouteCity*) departCitiesAtIndex:(int32_t) index;
- (NSArray*) destinationCitiesList;
- (RouteCity*) destinationCitiesAtIndex:(int32_t) index;
- (NSArray*) routeThemesList;
- (NameIdPair*) routeThemesAtIndex:(int32_t) index;
- (NSArray*) routeCategorysList;
- (NameIdPair*) routeCategorysAtIndex:(int32_t) index;
- (NSArray*) agenciesList;
- (Agency*) agenciesAtIndex:(int32_t) index;
- (NSArray*) cityGroupsList;
- (CityGroup*) cityGroupsAtIndex:(int32_t) index;

+ (App*) defaultInstance;
- (App*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (App_Builder*) builder;
+ (App_Builder*) builder;
+ (App_Builder*) builderWithPrototype:(App*) prototype;

+ (App*) parseFromData:(NSData*) data;
+ (App*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (App*) parseFromInputStream:(NSInputStream*) input;
+ (App*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (App*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (App*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface App_Builder : PBGeneratedMessage_Builder {
@private
  App* result;
}

- (App*) defaultInstance;

- (App_Builder*) clear;
- (App_Builder*) clone;

- (App*) build;
- (App*) buildPartial;

- (App_Builder*) mergeFrom:(App*) other;
- (App_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (App_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDataVersion;
- (NSString*) dataVersion;
- (App_Builder*) setDataVersion:(NSString*) value;
- (App_Builder*) clearDataVersion;

- (NSArray*) citiesList;
- (City*) citiesAtIndex:(int32_t) index;
- (App_Builder*) replaceCitiesAtIndex:(int32_t) index with:(City*) value;
- (App_Builder*) addCities:(City*) value;
- (App_Builder*) addAllCities:(NSArray*) values;
- (App_Builder*) clearCitiesList;

- (NSArray*) testCitiesList;
- (City*) testCitiesAtIndex:(int32_t) index;
- (App_Builder*) replaceTestCitiesAtIndex:(int32_t) index with:(City*) value;
- (App_Builder*) addTestCities:(City*) value;
- (App_Builder*) addAllTestCities:(NSArray*) values;
- (App_Builder*) clearTestCitiesList;

- (NSArray*) placeMetaDataListList;
- (PlaceMeta*) placeMetaDataListAtIndex:(int32_t) index;
- (App_Builder*) replacePlaceMetaDataListAtIndex:(int32_t) index with:(PlaceMeta*) value;
- (App_Builder*) addPlaceMetaDataList:(PlaceMeta*) value;
- (App_Builder*) addAllPlaceMetaDataList:(NSArray*) values;
- (App_Builder*) clearPlaceMetaDataListList;

- (NSArray*) recommendedAppsList;
- (RecommendedApp*) recommendedAppsAtIndex:(int32_t) index;
- (App_Builder*) replaceRecommendedAppsAtIndex:(int32_t) index with:(RecommendedApp*) value;
- (App_Builder*) addRecommendedApps:(RecommendedApp*) value;
- (App_Builder*) addAllRecommendedApps:(NSArray*) values;
- (App_Builder*) clearRecommendedAppsList;

- (NSArray*) regionsList;
- (Region*) regionsAtIndex:(int32_t) index;
- (App_Builder*) replaceRegionsAtIndex:(int32_t) index with:(Region*) value;
- (App_Builder*) addRegions:(Region*) value;
- (App_Builder*) addAllRegions:(NSArray*) values;
- (App_Builder*) clearRegionsList;

- (NSArray*) departCitiesList;
- (RouteCity*) departCitiesAtIndex:(int32_t) index;
- (App_Builder*) replaceDepartCitiesAtIndex:(int32_t) index with:(RouteCity*) value;
- (App_Builder*) addDepartCities:(RouteCity*) value;
- (App_Builder*) addAllDepartCities:(NSArray*) values;
- (App_Builder*) clearDepartCitiesList;

- (NSArray*) destinationCitiesList;
- (RouteCity*) destinationCitiesAtIndex:(int32_t) index;
- (App_Builder*) replaceDestinationCitiesAtIndex:(int32_t) index with:(RouteCity*) value;
- (App_Builder*) addDestinationCities:(RouteCity*) value;
- (App_Builder*) addAllDestinationCities:(NSArray*) values;
- (App_Builder*) clearDestinationCitiesList;

- (NSArray*) routeThemesList;
- (NameIdPair*) routeThemesAtIndex:(int32_t) index;
- (App_Builder*) replaceRouteThemesAtIndex:(int32_t) index with:(NameIdPair*) value;
- (App_Builder*) addRouteThemes:(NameIdPair*) value;
- (App_Builder*) addAllRouteThemes:(NSArray*) values;
- (App_Builder*) clearRouteThemesList;

- (NSArray*) routeCategorysList;
- (NameIdPair*) routeCategorysAtIndex:(int32_t) index;
- (App_Builder*) replaceRouteCategorysAtIndex:(int32_t) index with:(NameIdPair*) value;
- (App_Builder*) addRouteCategorys:(NameIdPair*) value;
- (App_Builder*) addAllRouteCategorys:(NSArray*) values;
- (App_Builder*) clearRouteCategorysList;

- (NSArray*) agenciesList;
- (Agency*) agenciesAtIndex:(int32_t) index;
- (App_Builder*) replaceAgenciesAtIndex:(int32_t) index with:(Agency*) value;
- (App_Builder*) addAgencies:(Agency*) value;
- (App_Builder*) addAllAgencies:(NSArray*) values;
- (App_Builder*) clearAgenciesList;

- (BOOL) hasServiceTelephone;
- (NSString*) serviceTelephone;
- (App_Builder*) setServiceTelephone:(NSString*) value;
- (App_Builder*) clearServiceTelephone;

- (NSArray*) cityGroupsList;
- (CityGroup*) cityGroupsAtIndex:(int32_t) index;
- (App_Builder*) replaceCityGroupsAtIndex:(int32_t) index with:(CityGroup*) value;
- (App_Builder*) addCityGroups:(CityGroup*) value;
- (App_Builder*) addAllCityGroups:(NSArray*) values;
- (App_Builder*) clearCityGroupsList;
@end

