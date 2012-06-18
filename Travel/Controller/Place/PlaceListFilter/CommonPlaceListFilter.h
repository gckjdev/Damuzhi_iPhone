//
//  CommonPlaceListFilter.h
//  Travel
//
//  Created by haodong qiu on 12年3月30日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonPlaceListController.h"

@interface CommonPlaceListFilter : NSObject

+ (UIButton*)createFilterButton:(CGRect)frame title:(NSString*)title;

+ (NSArray*)filterPlaceList:(NSArray*)placeList bySubCategoryIdList:(NSArray*)subCategoryIdList;
+ (NSArray*)filterPlaceList:(NSArray*)placeList byPriceIdList:(NSArray*)priceIdList;
+ (NSArray*)filterPlaceList:(NSArray*)placeList byAreaIdList:(NSArray*)areaIdList;
+ (NSArray*)filterPlaceList:(NSArray*)placeList byServiceIdList:(NSArray*)serviceIdList;
+ (NSArray*)sortPlaceList:(NSArray*)placeList bySortId:(NSNumber*)sortId currentLocation:(CLLocation*)currentLocation;

@end
