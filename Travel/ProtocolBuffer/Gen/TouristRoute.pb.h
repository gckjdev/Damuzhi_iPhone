// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class Accommodation;
@class Accommodation_Builder;
@class Booking;
@class Booking_Builder;
@class DailySchedule;
@class DailySchedule_Builder;
@class Flight;
@class Flight_Builder;
@class Order;
@class OrderList;
@class OrderList_Builder;
@class Order_Builder;
@class PlaceTour;
@class PlaceTour_Builder;
@class TouristRoute;
@class TouristRouteList;
@class TouristRouteList_Builder;
@class TouristRoute_Builder;
@class TravelPackage;
@class TravelPackage_Builder;

@interface TouristRouteRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface TouristRouteList : PBGeneratedMessage {
@private
  NSMutableArray* mutableRoutesList;
}
- (NSArray*) routesList;
- (TouristRoute*) routesAtIndex:(int32_t) index;

+ (TouristRouteList*) defaultInstance;
- (TouristRouteList*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TouristRouteList_Builder*) builder;
+ (TouristRouteList_Builder*) builder;
+ (TouristRouteList_Builder*) builderWithPrototype:(TouristRouteList*) prototype;

+ (TouristRouteList*) parseFromData:(NSData*) data;
+ (TouristRouteList*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TouristRouteList*) parseFromInputStream:(NSInputStream*) input;
+ (TouristRouteList*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TouristRouteList*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TouristRouteList*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TouristRouteList_Builder : PBGeneratedMessage_Builder {
@private
  TouristRouteList* result;
}

- (TouristRouteList*) defaultInstance;

- (TouristRouteList_Builder*) clear;
- (TouristRouteList_Builder*) clone;

- (TouristRouteList*) build;
- (TouristRouteList*) buildPartial;

- (TouristRouteList_Builder*) mergeFrom:(TouristRouteList*) other;
- (TouristRouteList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TouristRouteList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) routesList;
- (TouristRoute*) routesAtIndex:(int32_t) index;
- (TouristRouteList_Builder*) replaceRoutesAtIndex:(int32_t) index with:(TouristRoute*) value;
- (TouristRouteList_Builder*) addRoutes:(TouristRoute*) value;
- (TouristRouteList_Builder*) addAllRoutes:(NSArray*) values;
- (TouristRouteList_Builder*) clearRoutesList;
@end

@interface TouristRoute : PBGeneratedMessage {
@private
  BOOL hasFollowUserCount_:1;
  BOOL hasCategoryId_:1;
  BOOL hasDays_:1;
  BOOL hasAverageRank_:1;
  BOOL hasAgencyId_:1;
  BOOL hasDepartCityId_:1;
  BOOL hasRouteId_:1;
  BOOL hasBookingNotice_:1;
  BOOL hasFee_:1;
  BOOL hasReference_:1;
  BOOL hasBookingNote_:1;
  BOOL hasCharacteristic_:1;
  BOOL hasCustomerServiceTelephone_:1;
  BOOL hasName_:1;
  BOOL hasTour_:1;
  BOOL hasThumbImage_:1;
  BOOL hasPrice_:1;
  int32_t followUserCount;
  int32_t categoryId;
  int32_t days;
  int32_t averageRank;
  int32_t agencyId;
  int32_t departCityId;
  int32_t routeId;
  NSString* bookingNotice;
  NSString* fee;
  NSString* reference;
  NSString* bookingNote;
  NSString* characteristic;
  NSString* customerServiceTelephone;
  NSString* name;
  NSString* tour;
  NSString* thumbImage;
  NSString* price;
  NSMutableArray* mutableThemeIdsList;
  NSMutableArray* mutableDestinationCityIdsList;
  NSMutableArray* mutableDetailImagesList;
  NSMutableArray* mutableDailySchedulesList;
  NSMutableArray* mutablePackagesList;
  NSMutableArray* mutableBookingsList;
  NSMutableArray* mutableRelatedplacesList;
}
- (BOOL) hasRouteId;
- (BOOL) hasName;
- (BOOL) hasDepartCityId;
- (BOOL) hasPrice;
- (BOOL) hasAgencyId;
- (BOOL) hasAverageRank;
- (BOOL) hasThumbImage;
- (BOOL) hasTour;
- (BOOL) hasDays;
- (BOOL) hasCategoryId;
- (BOOL) hasFollowUserCount;
- (BOOL) hasCustomerServiceTelephone;
- (BOOL) hasCharacteristic;
- (BOOL) hasBookingNote;
- (BOOL) hasReference;
- (BOOL) hasFee;
- (BOOL) hasBookingNotice;
@property (readonly) int32_t routeId;
@property (readonly, retain) NSString* name;
@property (readonly) int32_t departCityId;
@property (readonly, retain) NSString* price;
@property (readonly) int32_t agencyId;
@property (readonly) int32_t averageRank;
@property (readonly, retain) NSString* thumbImage;
@property (readonly, retain) NSString* tour;
@property (readonly) int32_t days;
@property (readonly) int32_t categoryId;
@property (readonly) int32_t followUserCount;
@property (readonly, retain) NSString* customerServiceTelephone;
@property (readonly, retain) NSString* characteristic;
@property (readonly, retain) NSString* bookingNote;
@property (readonly, retain) NSString* reference;
@property (readonly, retain) NSString* fee;
@property (readonly, retain) NSString* bookingNotice;
- (NSArray*) destinationCityIdsList;
- (int32_t) destinationCityIdsAtIndex:(int32_t) index;
- (NSArray*) themeIdsList;
- (int32_t) themeIdsAtIndex:(int32_t) index;
- (NSArray*) detailImagesList;
- (NSString*) detailImagesAtIndex:(int32_t) index;
- (NSArray*) dailySchedulesList;
- (DailySchedule*) dailySchedulesAtIndex:(int32_t) index;
- (NSArray*) packagesList;
- (TravelPackage*) packagesAtIndex:(int32_t) index;
- (NSArray*) bookingsList;
- (Booking*) bookingsAtIndex:(int32_t) index;
- (NSArray*) relatedplacesList;
- (PlaceTour*) relatedplacesAtIndex:(int32_t) index;

+ (TouristRoute*) defaultInstance;
- (TouristRoute*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TouristRoute_Builder*) builder;
+ (TouristRoute_Builder*) builder;
+ (TouristRoute_Builder*) builderWithPrototype:(TouristRoute*) prototype;

+ (TouristRoute*) parseFromData:(NSData*) data;
+ (TouristRoute*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TouristRoute*) parseFromInputStream:(NSInputStream*) input;
+ (TouristRoute*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TouristRoute*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TouristRoute*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TouristRoute_Builder : PBGeneratedMessage_Builder {
@private
  TouristRoute* result;
}

- (TouristRoute*) defaultInstance;

- (TouristRoute_Builder*) clear;
- (TouristRoute_Builder*) clone;

- (TouristRoute*) build;
- (TouristRoute*) buildPartial;

- (TouristRoute_Builder*) mergeFrom:(TouristRoute*) other;
- (TouristRoute_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TouristRoute_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasRouteId;
- (int32_t) routeId;
- (TouristRoute_Builder*) setRouteId:(int32_t) value;
- (TouristRoute_Builder*) clearRouteId;

- (BOOL) hasName;
- (NSString*) name;
- (TouristRoute_Builder*) setName:(NSString*) value;
- (TouristRoute_Builder*) clearName;

- (BOOL) hasDepartCityId;
- (int32_t) departCityId;
- (TouristRoute_Builder*) setDepartCityId:(int32_t) value;
- (TouristRoute_Builder*) clearDepartCityId;

- (NSArray*) destinationCityIdsList;
- (int32_t) destinationCityIdsAtIndex:(int32_t) index;
- (TouristRoute_Builder*) replaceDestinationCityIdsAtIndex:(int32_t) index with:(int32_t) value;
- (TouristRoute_Builder*) addDestinationCityIds:(int32_t) value;
- (TouristRoute_Builder*) addAllDestinationCityIds:(NSArray*) values;
- (TouristRoute_Builder*) clearDestinationCityIdsList;

- (BOOL) hasPrice;
- (NSString*) price;
- (TouristRoute_Builder*) setPrice:(NSString*) value;
- (TouristRoute_Builder*) clearPrice;

- (BOOL) hasAgencyId;
- (int32_t) agencyId;
- (TouristRoute_Builder*) setAgencyId:(int32_t) value;
- (TouristRoute_Builder*) clearAgencyId;

- (BOOL) hasAverageRank;
- (int32_t) averageRank;
- (TouristRoute_Builder*) setAverageRank:(int32_t) value;
- (TouristRoute_Builder*) clearAverageRank;

- (BOOL) hasThumbImage;
- (NSString*) thumbImage;
- (TouristRoute_Builder*) setThumbImage:(NSString*) value;
- (TouristRoute_Builder*) clearThumbImage;

- (BOOL) hasTour;
- (NSString*) tour;
- (TouristRoute_Builder*) setTour:(NSString*) value;
- (TouristRoute_Builder*) clearTour;

- (BOOL) hasDays;
- (int32_t) days;
- (TouristRoute_Builder*) setDays:(int32_t) value;
- (TouristRoute_Builder*) clearDays;

- (NSArray*) themeIdsList;
- (int32_t) themeIdsAtIndex:(int32_t) index;
- (TouristRoute_Builder*) replaceThemeIdsAtIndex:(int32_t) index with:(int32_t) value;
- (TouristRoute_Builder*) addThemeIds:(int32_t) value;
- (TouristRoute_Builder*) addAllThemeIds:(NSArray*) values;
- (TouristRoute_Builder*) clearThemeIdsList;

- (BOOL) hasCategoryId;
- (int32_t) categoryId;
- (TouristRoute_Builder*) setCategoryId:(int32_t) value;
- (TouristRoute_Builder*) clearCategoryId;

- (BOOL) hasFollowUserCount;
- (int32_t) followUserCount;
- (TouristRoute_Builder*) setFollowUserCount:(int32_t) value;
- (TouristRoute_Builder*) clearFollowUserCount;

- (BOOL) hasCustomerServiceTelephone;
- (NSString*) customerServiceTelephone;
- (TouristRoute_Builder*) setCustomerServiceTelephone:(NSString*) value;
- (TouristRoute_Builder*) clearCustomerServiceTelephone;

- (NSArray*) detailImagesList;
- (NSString*) detailImagesAtIndex:(int32_t) index;
- (TouristRoute_Builder*) replaceDetailImagesAtIndex:(int32_t) index with:(NSString*) value;
- (TouristRoute_Builder*) addDetailImages:(NSString*) value;
- (TouristRoute_Builder*) addAllDetailImages:(NSArray*) values;
- (TouristRoute_Builder*) clearDetailImagesList;

- (BOOL) hasCharacteristic;
- (NSString*) characteristic;
- (TouristRoute_Builder*) setCharacteristic:(NSString*) value;
- (TouristRoute_Builder*) clearCharacteristic;

- (NSArray*) dailySchedulesList;
- (DailySchedule*) dailySchedulesAtIndex:(int32_t) index;
- (TouristRoute_Builder*) replaceDailySchedulesAtIndex:(int32_t) index with:(DailySchedule*) value;
- (TouristRoute_Builder*) addDailySchedules:(DailySchedule*) value;
- (TouristRoute_Builder*) addAllDailySchedules:(NSArray*) values;
- (TouristRoute_Builder*) clearDailySchedulesList;

- (NSArray*) packagesList;
- (TravelPackage*) packagesAtIndex:(int32_t) index;
- (TouristRoute_Builder*) replacePackagesAtIndex:(int32_t) index with:(TravelPackage*) value;
- (TouristRoute_Builder*) addPackages:(TravelPackage*) value;
- (TouristRoute_Builder*) addAllPackages:(NSArray*) values;
- (TouristRoute_Builder*) clearPackagesList;

- (BOOL) hasBookingNote;
- (NSString*) bookingNote;
- (TouristRoute_Builder*) setBookingNote:(NSString*) value;
- (TouristRoute_Builder*) clearBookingNote;

- (NSArray*) bookingsList;
- (Booking*) bookingsAtIndex:(int32_t) index;
- (TouristRoute_Builder*) replaceBookingsAtIndex:(int32_t) index with:(Booking*) value;
- (TouristRoute_Builder*) addBookings:(Booking*) value;
- (TouristRoute_Builder*) addAllBookings:(NSArray*) values;
- (TouristRoute_Builder*) clearBookingsList;

- (BOOL) hasReference;
- (NSString*) reference;
- (TouristRoute_Builder*) setReference:(NSString*) value;
- (TouristRoute_Builder*) clearReference;

- (NSArray*) relatedplacesList;
- (PlaceTour*) relatedplacesAtIndex:(int32_t) index;
- (TouristRoute_Builder*) replaceRelatedplacesAtIndex:(int32_t) index with:(PlaceTour*) value;
- (TouristRoute_Builder*) addRelatedplaces:(PlaceTour*) value;
- (TouristRoute_Builder*) addAllRelatedplaces:(NSArray*) values;
- (TouristRoute_Builder*) clearRelatedplacesList;

- (BOOL) hasFee;
- (NSString*) fee;
- (TouristRoute_Builder*) setFee:(NSString*) value;
- (TouristRoute_Builder*) clearFee;

- (BOOL) hasBookingNotice;
- (NSString*) bookingNotice;
- (TouristRoute_Builder*) setBookingNotice:(NSString*) value;
- (TouristRoute_Builder*) clearBookingNotice;
@end

@interface DailySchedule : PBGeneratedMessage {
@private
  BOOL hasDay_:1;
  BOOL hasTitle_:1;
  BOOL hasBreakfast_:1;
  BOOL hasLunch_:1;
  BOOL hasDinner_:1;
  BOOL hasAccommodation_:1;
  int32_t day;
  NSString* title;
  NSString* breakfast;
  NSString* lunch;
  NSString* dinner;
  Accommodation* accommodation;
  NSMutableArray* mutablePlaceToursList;
}
- (BOOL) hasDay;
- (BOOL) hasTitle;
- (BOOL) hasBreakfast;
- (BOOL) hasLunch;
- (BOOL) hasDinner;
- (BOOL) hasAccommodation;
@property (readonly) int32_t day;
@property (readonly, retain) NSString* title;
@property (readonly, retain) NSString* breakfast;
@property (readonly, retain) NSString* lunch;
@property (readonly, retain) NSString* dinner;
@property (readonly, retain) Accommodation* accommodation;
- (NSArray*) placeToursList;
- (PlaceTour*) placeToursAtIndex:(int32_t) index;

+ (DailySchedule*) defaultInstance;
- (DailySchedule*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (DailySchedule_Builder*) builder;
+ (DailySchedule_Builder*) builder;
+ (DailySchedule_Builder*) builderWithPrototype:(DailySchedule*) prototype;

+ (DailySchedule*) parseFromData:(NSData*) data;
+ (DailySchedule*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (DailySchedule*) parseFromInputStream:(NSInputStream*) input;
+ (DailySchedule*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (DailySchedule*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (DailySchedule*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface DailySchedule_Builder : PBGeneratedMessage_Builder {
@private
  DailySchedule* result;
}

- (DailySchedule*) defaultInstance;

- (DailySchedule_Builder*) clear;
- (DailySchedule_Builder*) clone;

- (DailySchedule*) build;
- (DailySchedule*) buildPartial;

- (DailySchedule_Builder*) mergeFrom:(DailySchedule*) other;
- (DailySchedule_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (DailySchedule_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDay;
- (int32_t) day;
- (DailySchedule_Builder*) setDay:(int32_t) value;
- (DailySchedule_Builder*) clearDay;

- (BOOL) hasTitle;
- (NSString*) title;
- (DailySchedule_Builder*) setTitle:(NSString*) value;
- (DailySchedule_Builder*) clearTitle;

- (NSArray*) placeToursList;
- (PlaceTour*) placeToursAtIndex:(int32_t) index;
- (DailySchedule_Builder*) replacePlaceToursAtIndex:(int32_t) index with:(PlaceTour*) value;
- (DailySchedule_Builder*) addPlaceTours:(PlaceTour*) value;
- (DailySchedule_Builder*) addAllPlaceTours:(NSArray*) values;
- (DailySchedule_Builder*) clearPlaceToursList;

- (BOOL) hasBreakfast;
- (NSString*) breakfast;
- (DailySchedule_Builder*) setBreakfast:(NSString*) value;
- (DailySchedule_Builder*) clearBreakfast;

- (BOOL) hasLunch;
- (NSString*) lunch;
- (DailySchedule_Builder*) setLunch:(NSString*) value;
- (DailySchedule_Builder*) clearLunch;

- (BOOL) hasDinner;
- (NSString*) dinner;
- (DailySchedule_Builder*) setDinner:(NSString*) value;
- (DailySchedule_Builder*) clearDinner;

- (BOOL) hasAccommodation;
- (Accommodation*) accommodation;
- (DailySchedule_Builder*) setAccommodation:(Accommodation*) value;
- (DailySchedule_Builder*) setAccommodationBuilder:(Accommodation_Builder*) builderForValue;
- (DailySchedule_Builder*) mergeAccommodation:(Accommodation*) value;
- (DailySchedule_Builder*) clearAccommodation;
@end

@interface TravelPackage : PBGeneratedMessage {
@private
  BOOL hasPackageId_:1;
  BOOL hasName_:1;
  BOOL hasNote_:1;
  BOOL hasPrice_:1;
  BOOL hasDepartFlight_:1;
  BOOL hasReturnFlight_:1;
  int32_t packageId;
  NSString* name;
  NSString* note;
  NSString* price;
  Flight* departFlight;
  Flight* returnFlight;
  NSMutableArray* mutableAccommodationsList;
}
- (BOOL) hasPackageId;
- (BOOL) hasName;
- (BOOL) hasNote;
- (BOOL) hasPrice;
- (BOOL) hasDepartFlight;
- (BOOL) hasReturnFlight;
@property (readonly) int32_t packageId;
@property (readonly, retain) NSString* name;
@property (readonly, retain) NSString* note;
@property (readonly, retain) NSString* price;
@property (readonly, retain) Flight* departFlight;
@property (readonly, retain) Flight* returnFlight;
- (NSArray*) accommodationsList;
- (Accommodation*) accommodationsAtIndex:(int32_t) index;

+ (TravelPackage*) defaultInstance;
- (TravelPackage*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TravelPackage_Builder*) builder;
+ (TravelPackage_Builder*) builder;
+ (TravelPackage_Builder*) builderWithPrototype:(TravelPackage*) prototype;

+ (TravelPackage*) parseFromData:(NSData*) data;
+ (TravelPackage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TravelPackage*) parseFromInputStream:(NSInputStream*) input;
+ (TravelPackage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TravelPackage*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TravelPackage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TravelPackage_Builder : PBGeneratedMessage_Builder {
@private
  TravelPackage* result;
}

- (TravelPackage*) defaultInstance;

- (TravelPackage_Builder*) clear;
- (TravelPackage_Builder*) clone;

- (TravelPackage*) build;
- (TravelPackage*) buildPartial;

- (TravelPackage_Builder*) mergeFrom:(TravelPackage*) other;
- (TravelPackage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TravelPackage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasPackageId;
- (int32_t) packageId;
- (TravelPackage_Builder*) setPackageId:(int32_t) value;
- (TravelPackage_Builder*) clearPackageId;

- (BOOL) hasName;
- (NSString*) name;
- (TravelPackage_Builder*) setName:(NSString*) value;
- (TravelPackage_Builder*) clearName;

- (BOOL) hasNote;
- (NSString*) note;
- (TravelPackage_Builder*) setNote:(NSString*) value;
- (TravelPackage_Builder*) clearNote;

- (BOOL) hasPrice;
- (NSString*) price;
- (TravelPackage_Builder*) setPrice:(NSString*) value;
- (TravelPackage_Builder*) clearPrice;

- (BOOL) hasDepartFlight;
- (Flight*) departFlight;
- (TravelPackage_Builder*) setDepartFlight:(Flight*) value;
- (TravelPackage_Builder*) setDepartFlightBuilder:(Flight_Builder*) builderForValue;
- (TravelPackage_Builder*) mergeDepartFlight:(Flight*) value;
- (TravelPackage_Builder*) clearDepartFlight;

- (BOOL) hasReturnFlight;
- (Flight*) returnFlight;
- (TravelPackage_Builder*) setReturnFlight:(Flight*) value;
- (TravelPackage_Builder*) setReturnFlightBuilder:(Flight_Builder*) builderForValue;
- (TravelPackage_Builder*) mergeReturnFlight:(Flight*) value;
- (TravelPackage_Builder*) clearReturnFlight;

- (NSArray*) accommodationsList;
- (Accommodation*) accommodationsAtIndex:(int32_t) index;
- (TravelPackage_Builder*) replaceAccommodationsAtIndex:(int32_t) index with:(Accommodation*) value;
- (TravelPackage_Builder*) addAccommodations:(Accommodation*) value;
- (TravelPackage_Builder*) addAllAccommodations:(NSArray*) values;
- (TravelPackage_Builder*) clearAccommodationsList;
@end

@interface Booking : PBGeneratedMessage {
@private
  BOOL hasDate_:1;
  BOOL hasStatus_:1;
  BOOL hasRemainder_:1;
  BOOL hasAdultPrice_:1;
  BOOL hasChildrenPrice_:1;
  int32_t date;
  int32_t status;
  NSString* remainder;
  NSString* adultPrice;
  NSString* childrenPrice;
}
- (BOOL) hasDate;
- (BOOL) hasStatus;
- (BOOL) hasRemainder;
- (BOOL) hasAdultPrice;
- (BOOL) hasChildrenPrice;
@property (readonly) int32_t date;
@property (readonly) int32_t status;
@property (readonly, retain) NSString* remainder;
@property (readonly, retain) NSString* adultPrice;
@property (readonly, retain) NSString* childrenPrice;

+ (Booking*) defaultInstance;
- (Booking*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Booking_Builder*) builder;
+ (Booking_Builder*) builder;
+ (Booking_Builder*) builderWithPrototype:(Booking*) prototype;

+ (Booking*) parseFromData:(NSData*) data;
+ (Booking*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Booking*) parseFromInputStream:(NSInputStream*) input;
+ (Booking*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Booking*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Booking*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Booking_Builder : PBGeneratedMessage_Builder {
@private
  Booking* result;
}

- (Booking*) defaultInstance;

- (Booking_Builder*) clear;
- (Booking_Builder*) clone;

- (Booking*) build;
- (Booking*) buildPartial;

- (Booking_Builder*) mergeFrom:(Booking*) other;
- (Booking_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Booking_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDate;
- (int32_t) date;
- (Booking_Builder*) setDate:(int32_t) value;
- (Booking_Builder*) clearDate;

- (BOOL) hasStatus;
- (int32_t) status;
- (Booking_Builder*) setStatus:(int32_t) value;
- (Booking_Builder*) clearStatus;

- (BOOL) hasRemainder;
- (NSString*) remainder;
- (Booking_Builder*) setRemainder:(NSString*) value;
- (Booking_Builder*) clearRemainder;

- (BOOL) hasAdultPrice;
- (NSString*) adultPrice;
- (Booking_Builder*) setAdultPrice:(NSString*) value;
- (Booking_Builder*) clearAdultPrice;

- (BOOL) hasChildrenPrice;
- (NSString*) childrenPrice;
- (Booking_Builder*) setChildrenPrice:(NSString*) value;
- (Booking_Builder*) clearChildrenPrice;
@end

@interface Flight : PBGeneratedMessage {
@private
  BOOL hasFlightId_:1;
  BOOL hasCompany_:1;
  BOOL hasMode_:1;
  BOOL hasDepartCityName_:1;
  BOOL hasDepartTime_:1;
  BOOL hasDepartAirport_:1;
  BOOL hasArriveCityName_:1;
  BOOL hasArriveTime_:1;
  BOOL hasArriveAirport_:1;
  NSString* flightId;
  NSString* company;
  NSString* mode;
  NSString* departCityName;
  NSString* departTime;
  NSString* departAirport;
  NSString* arriveCityName;
  NSString* arriveTime;
  NSString* arriveAirport;
}
- (BOOL) hasFlightId;
- (BOOL) hasCompany;
- (BOOL) hasMode;
- (BOOL) hasDepartCityName;
- (BOOL) hasDepartTime;
- (BOOL) hasDepartAirport;
- (BOOL) hasArriveCityName;
- (BOOL) hasArriveTime;
- (BOOL) hasArriveAirport;
@property (readonly, retain) NSString* flightId;
@property (readonly, retain) NSString* company;
@property (readonly, retain) NSString* mode;
@property (readonly, retain) NSString* departCityName;
@property (readonly, retain) NSString* departTime;
@property (readonly, retain) NSString* departAirport;
@property (readonly, retain) NSString* arriveCityName;
@property (readonly, retain) NSString* arriveTime;
@property (readonly, retain) NSString* arriveAirport;

+ (Flight*) defaultInstance;
- (Flight*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Flight_Builder*) builder;
+ (Flight_Builder*) builder;
+ (Flight_Builder*) builderWithPrototype:(Flight*) prototype;

+ (Flight*) parseFromData:(NSData*) data;
+ (Flight*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Flight*) parseFromInputStream:(NSInputStream*) input;
+ (Flight*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Flight*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Flight*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Flight_Builder : PBGeneratedMessage_Builder {
@private
  Flight* result;
}

- (Flight*) defaultInstance;

- (Flight_Builder*) clear;
- (Flight_Builder*) clone;

- (Flight*) build;
- (Flight*) buildPartial;

- (Flight_Builder*) mergeFrom:(Flight*) other;
- (Flight_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Flight_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasFlightId;
- (NSString*) flightId;
- (Flight_Builder*) setFlightId:(NSString*) value;
- (Flight_Builder*) clearFlightId;

- (BOOL) hasCompany;
- (NSString*) company;
- (Flight_Builder*) setCompany:(NSString*) value;
- (Flight_Builder*) clearCompany;

- (BOOL) hasMode;
- (NSString*) mode;
- (Flight_Builder*) setMode:(NSString*) value;
- (Flight_Builder*) clearMode;

- (BOOL) hasDepartCityName;
- (NSString*) departCityName;
- (Flight_Builder*) setDepartCityName:(NSString*) value;
- (Flight_Builder*) clearDepartCityName;

- (BOOL) hasDepartTime;
- (NSString*) departTime;
- (Flight_Builder*) setDepartTime:(NSString*) value;
- (Flight_Builder*) clearDepartTime;

- (BOOL) hasDepartAirport;
- (NSString*) departAirport;
- (Flight_Builder*) setDepartAirport:(NSString*) value;
- (Flight_Builder*) clearDepartAirport;

- (BOOL) hasArriveCityName;
- (NSString*) arriveCityName;
- (Flight_Builder*) setArriveCityName:(NSString*) value;
- (Flight_Builder*) clearArriveCityName;

- (BOOL) hasArriveTime;
- (NSString*) arriveTime;
- (Flight_Builder*) setArriveTime:(NSString*) value;
- (Flight_Builder*) clearArriveTime;

- (BOOL) hasArriveAirport;
- (NSString*) arriveAirport;
- (Flight_Builder*) setArriveAirport:(NSString*) value;
- (Flight_Builder*) clearArriveAirport;
@end

@interface PlaceTour : PBGeneratedMessage {
@private
  BOOL hasPlaceId_:1;
  BOOL hasName_:1;
  BOOL hasDuration_:1;
  int32_t placeId;
  NSString* name;
  NSString* duration;
}
- (BOOL) hasName;
- (BOOL) hasPlaceId;
- (BOOL) hasDuration;
@property (readonly, retain) NSString* name;
@property (readonly) int32_t placeId;
@property (readonly, retain) NSString* duration;

+ (PlaceTour*) defaultInstance;
- (PlaceTour*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PlaceTour_Builder*) builder;
+ (PlaceTour_Builder*) builder;
+ (PlaceTour_Builder*) builderWithPrototype:(PlaceTour*) prototype;

+ (PlaceTour*) parseFromData:(NSData*) data;
+ (PlaceTour*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PlaceTour*) parseFromInputStream:(NSInputStream*) input;
+ (PlaceTour*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PlaceTour*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PlaceTour*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PlaceTour_Builder : PBGeneratedMessage_Builder {
@private
  PlaceTour* result;
}

- (PlaceTour*) defaultInstance;

- (PlaceTour_Builder*) clear;
- (PlaceTour_Builder*) clone;

- (PlaceTour*) build;
- (PlaceTour*) buildPartial;

- (PlaceTour_Builder*) mergeFrom:(PlaceTour*) other;
- (PlaceTour_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PlaceTour_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasName;
- (NSString*) name;
- (PlaceTour_Builder*) setName:(NSString*) value;
- (PlaceTour_Builder*) clearName;

- (BOOL) hasPlaceId;
- (int32_t) placeId;
- (PlaceTour_Builder*) setPlaceId:(int32_t) value;
- (PlaceTour_Builder*) clearPlaceId;

- (BOOL) hasDuration;
- (NSString*) duration;
- (PlaceTour_Builder*) setDuration:(NSString*) value;
- (PlaceTour_Builder*) clearDuration;
@end

@interface Accommodation : PBGeneratedMessage {
@private
  BOOL hasHotelId_:1;
  BOOL hasHotelName_:1;
  BOOL hasRoomType_:1;
  BOOL hasDuration_:1;
  int32_t hotelId;
  NSString* hotelName;
  NSString* roomType;
  NSString* duration;
}
- (BOOL) hasHotelName;
- (BOOL) hasRoomType;
- (BOOL) hasDuration;
- (BOOL) hasHotelId;
@property (readonly, retain) NSString* hotelName;
@property (readonly, retain) NSString* roomType;
@property (readonly, retain) NSString* duration;
@property (readonly) int32_t hotelId;

+ (Accommodation*) defaultInstance;
- (Accommodation*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Accommodation_Builder*) builder;
+ (Accommodation_Builder*) builder;
+ (Accommodation_Builder*) builderWithPrototype:(Accommodation*) prototype;

+ (Accommodation*) parseFromData:(NSData*) data;
+ (Accommodation*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Accommodation*) parseFromInputStream:(NSInputStream*) input;
+ (Accommodation*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Accommodation*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Accommodation*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Accommodation_Builder : PBGeneratedMessage_Builder {
@private
  Accommodation* result;
}

- (Accommodation*) defaultInstance;

- (Accommodation_Builder*) clear;
- (Accommodation_Builder*) clone;

- (Accommodation*) build;
- (Accommodation*) buildPartial;

- (Accommodation_Builder*) mergeFrom:(Accommodation*) other;
- (Accommodation_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Accommodation_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasHotelName;
- (NSString*) hotelName;
- (Accommodation_Builder*) setHotelName:(NSString*) value;
- (Accommodation_Builder*) clearHotelName;

- (BOOL) hasRoomType;
- (NSString*) roomType;
- (Accommodation_Builder*) setRoomType:(NSString*) value;
- (Accommodation_Builder*) clearRoomType;

- (BOOL) hasDuration;
- (NSString*) duration;
- (Accommodation_Builder*) setDuration:(NSString*) value;
- (Accommodation_Builder*) clearDuration;

- (BOOL) hasHotelId;
- (int32_t) hotelId;
- (Accommodation_Builder*) setHotelId:(int32_t) value;
- (Accommodation_Builder*) clearHotelId;
@end

@interface OrderList : PBGeneratedMessage {
@private
  NSMutableArray* mutableOrdersList;
}
- (NSArray*) ordersList;
- (Order*) ordersAtIndex:(int32_t) index;

+ (OrderList*) defaultInstance;
- (OrderList*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (OrderList_Builder*) builder;
+ (OrderList_Builder*) builder;
+ (OrderList_Builder*) builderWithPrototype:(OrderList*) prototype;

+ (OrderList*) parseFromData:(NSData*) data;
+ (OrderList*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (OrderList*) parseFromInputStream:(NSInputStream*) input;
+ (OrderList*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (OrderList*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (OrderList*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface OrderList_Builder : PBGeneratedMessage_Builder {
@private
  OrderList* result;
}

- (OrderList*) defaultInstance;

- (OrderList_Builder*) clear;
- (OrderList_Builder*) clone;

- (OrderList*) build;
- (OrderList*) buildPartial;

- (OrderList_Builder*) mergeFrom:(OrderList*) other;
- (OrderList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (OrderList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) ordersList;
- (Order*) ordersAtIndex:(int32_t) index;
- (OrderList_Builder*) replaceOrdersAtIndex:(int32_t) index with:(Order*) value;
- (OrderList_Builder*) addOrders:(Order*) value;
- (OrderList_Builder*) addAllOrders:(NSArray*) values;
- (OrderList_Builder*) clearOrdersList;
@end

@interface Order : PBGeneratedMessage {
@private
  BOOL hasOrderId_:1;
  BOOL hasBookDate_:1;
  BOOL hasRouteId_:1;
  BOOL hasAgencyId_:1;
  BOOL hasDepartDate_:1;
  BOOL hasAdult_:1;
  BOOL hasChildren_:1;
  BOOL hasStatus_:1;
  BOOL hasRouteName_:1;
  BOOL hasDepartCityName_:1;
  BOOL hasPrice_:1;
  BOOL hasPriceStatus_:1;
  int32_t orderId;
  int32_t bookDate;
  int32_t routeId;
  int32_t agencyId;
  int32_t departDate;
  int32_t adult;
  int32_t children;
  int32_t status;
  NSString* routeName;
  NSString* departCityName;
  NSString* price;
  NSString* priceStatus;
}
- (BOOL) hasOrderId;
- (BOOL) hasBookDate;
- (BOOL) hasRouteId;
- (BOOL) hasRouteName;
- (BOOL) hasAgencyId;
- (BOOL) hasDepartCityName;
- (BOOL) hasDepartDate;
- (BOOL) hasAdult;
- (BOOL) hasChildren;
- (BOOL) hasPrice;
- (BOOL) hasPriceStatus;
- (BOOL) hasStatus;
@property (readonly) int32_t orderId;
@property (readonly) int32_t bookDate;
@property (readonly) int32_t routeId;
@property (readonly, retain) NSString* routeName;
@property (readonly) int32_t agencyId;
@property (readonly, retain) NSString* departCityName;
@property (readonly) int32_t departDate;
@property (readonly) int32_t adult;
@property (readonly) int32_t children;
@property (readonly, retain) NSString* price;
@property (readonly, retain) NSString* priceStatus;
@property (readonly) int32_t status;

+ (Order*) defaultInstance;
- (Order*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Order_Builder*) builder;
+ (Order_Builder*) builder;
+ (Order_Builder*) builderWithPrototype:(Order*) prototype;

+ (Order*) parseFromData:(NSData*) data;
+ (Order*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Order*) parseFromInputStream:(NSInputStream*) input;
+ (Order*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Order*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Order*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Order_Builder : PBGeneratedMessage_Builder {
@private
  Order* result;
}

- (Order*) defaultInstance;

- (Order_Builder*) clear;
- (Order_Builder*) clone;

- (Order*) build;
- (Order*) buildPartial;

- (Order_Builder*) mergeFrom:(Order*) other;
- (Order_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Order_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasOrderId;
- (int32_t) orderId;
- (Order_Builder*) setOrderId:(int32_t) value;
- (Order_Builder*) clearOrderId;

- (BOOL) hasBookDate;
- (int32_t) bookDate;
- (Order_Builder*) setBookDate:(int32_t) value;
- (Order_Builder*) clearBookDate;

- (BOOL) hasRouteId;
- (int32_t) routeId;
- (Order_Builder*) setRouteId:(int32_t) value;
- (Order_Builder*) clearRouteId;

- (BOOL) hasRouteName;
- (NSString*) routeName;
- (Order_Builder*) setRouteName:(NSString*) value;
- (Order_Builder*) clearRouteName;

- (BOOL) hasAgencyId;
- (int32_t) agencyId;
- (Order_Builder*) setAgencyId:(int32_t) value;
- (Order_Builder*) clearAgencyId;

- (BOOL) hasDepartCityName;
- (NSString*) departCityName;
- (Order_Builder*) setDepartCityName:(NSString*) value;
- (Order_Builder*) clearDepartCityName;

- (BOOL) hasDepartDate;
- (int32_t) departDate;
- (Order_Builder*) setDepartDate:(int32_t) value;
- (Order_Builder*) clearDepartDate;

- (BOOL) hasAdult;
- (int32_t) adult;
- (Order_Builder*) setAdult:(int32_t) value;
- (Order_Builder*) clearAdult;

- (BOOL) hasChildren;
- (int32_t) children;
- (Order_Builder*) setChildren:(int32_t) value;
- (Order_Builder*) clearChildren;

- (BOOL) hasPrice;
- (NSString*) price;
- (Order_Builder*) setPrice:(NSString*) value;
- (Order_Builder*) clearPrice;

- (BOOL) hasPriceStatus;
- (NSString*) priceStatus;
- (Order_Builder*) setPriceStatus:(NSString*) value;
- (Order_Builder*) clearPriceStatus;

- (BOOL) hasStatus;
- (int32_t) status;
- (Order_Builder*) setStatus:(int32_t) value;
- (Order_Builder*) clearStatus;
@end

