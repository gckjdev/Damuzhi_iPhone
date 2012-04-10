// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class App;
@class App_Builder;
@class City;
@class CityArea;
@class CityArea_Builder;
@class CityList;
@class CityList_Builder;
@class City_Builder;
@class HelpInfo;
@class HelpInfo_Builder;
@class NameIdPair;
@class NameIdPair_Builder;
@class PlaceMeta;
@class PlaceMeta_Builder;
typedef enum {
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
  BOOL hasCityId_:1;
  BOOL hasDataSize_:1;
  BOOL hasPriceRank_:1;
  BOOL hasCityName_:1;
  BOOL hasLatestVersion_:1;
  BOOL hasCountryName_:1;
  BOOL hasDownloadUrl_:1;
  BOOL hasCurrencySymbol_:1;
  BOOL hasCurrencyId_:1;
  BOOL hasCurrencyName_:1;
  int32_t cityId;
  int32_t dataSize;
  int32_t priceRank;
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
  BOOL hasHelpHtml_:1;
  NSString* helpHtml;
}
- (BOOL) hasHelpHtml;
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

- (BOOL) hasHelpHtml;
- (NSString*) helpHtml;
- (HelpInfo_Builder*) setHelpHtml:(NSString*) value;
- (HelpInfo_Builder*) clearHelpHtml;
@end

@interface App : PBGeneratedMessage {
@private
  BOOL hasDataVersion_:1;
  BOOL hasHelpHtml_:1;
  NSString* dataVersion;
  NSString* helpHtml;
  NSMutableArray* mutableCitiesList;
  NSMutableArray* mutableTestCitiesList;
  NSMutableArray* mutablePlaceMetaDataListList;
}
- (BOOL) hasDataVersion;
- (BOOL) hasHelpHtml;
@property (readonly, retain) NSString* dataVersion;
@property (readonly, retain) NSString* helpHtml;
- (NSArray*) citiesList;
- (City*) citiesAtIndex:(int32_t) index;
- (NSArray*) testCitiesList;
- (City*) testCitiesAtIndex:(int32_t) index;
- (NSArray*) placeMetaDataListList;
- (PlaceMeta*) placeMetaDataListAtIndex:(int32_t) index;

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

- (BOOL) hasHelpHtml;
- (NSString*) helpHtml;
- (App_Builder*) setHelpHtml:(NSString*) value;
- (App_Builder*) clearHelpHtml;
@end

