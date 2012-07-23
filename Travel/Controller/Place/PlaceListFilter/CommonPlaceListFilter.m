//
//  CommonPlaceListFilter.m
//  Travel
//
//  Created by haodong qiu on 12年3月30日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "CommonPlaceListFilter.h"
#import "Place.pb.h"
#import "AppManager.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "LocaleUtils.h"
#import "ImageName.h"
#import "PlaceUtils.h"
#import "ImageManager.h"
#import "AppConstants.h"

@implementation CommonPlaceListFilter

+ (UIButton*)createFilterButton:(CGRect)frame title:(NSString*)title
{
    UIImage *bgImageForNormal = [[ImageManager defaultManager] filgerBtnBgImage];
    UIImage *bgImageForHeightlight = [[ImageManager defaultManager] filgerBtnBgImage];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:bgImageForNormal forState:UIControlStateNormal];
    [button setBackgroundImage:bgImageForHeightlight forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize: 12]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    return button;
}

+ (NSArray*)filterPlaceList:(NSArray*)placeList bySubCategoryIdList:(NSArray*)subCategoryIdList
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];    
    
    //filter by selectedCategoryId
    for (NSNumber *selectedSubCategoryId in subCategoryIdList) {
        if ([selectedSubCategoryId intValue] == ALL_CATEGORY) {
            return placeList;
        }
        
        for (Place *place in placeList) {
            if ([selectedSubCategoryId intValue] == [place subCategoryId])
            {
                [array addObject:place];
            }
        }
    }
    
    return array;
}

+ (NSArray*)filterPlaceList:(NSArray*)placeList byPriceIdList:(NSArray*)priceIdList
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];    
    
    for (NSNumber *selectedPriceId in priceIdList)
    {
        PPDebug(@"selectedPriceList:%d",[selectedPriceId intValue]);
        if ([selectedPriceId intValue] == ALL_CATEGORY) {
            return placeList;
        }
    }
    
    for (Place *place in placeList) {
        PPDebug(@"place priceRank:%d",place.priceRank);
        for (NSNumber *number in priceIdList) {
            if (place.priceRank == number.intValue) {
                [array addObject:place];
                break;
            }
        }
    }

    return array;
}

+ (NSArray*)filterPlaceList:(NSArray*)placeList byAreaIdList:(NSArray*)areaIdList;
{
    for (NSNumber *selectedAreaId in areaIdList)
    {
        if ([selectedAreaId intValue] == ALL_CATEGORY) {
            return placeList;
        }
    }
    
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (Place *place in placeList) {
        for (NSNumber *number in areaIdList) {
            if (number.intValue == place.areaId) {
                [array addObject:place];
                break;
            }
        }
    }
    return array;
}

+ (NSArray*)filterPlaceList:(NSArray*)placeList byServiceIdList:(NSArray*)serviceIdList
{
    for (NSNumber *selectedServiceId in serviceIdList)
    {
        if ([selectedServiceId intValue] == ALL_CATEGORY) {
            return placeList;
        }
    }
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    BOOL found = NO;
    for (Place *place in placeList) {
        for (NSNumber *selectedNumber in serviceIdList) {
            for (NSNumber *placeServiceId in place.providedServiceIdList) {
                if (selectedNumber.intValue == placeServiceId.intValue) {
                    [array addObject:place];
                    found = YES;
                    break;
                }
            }
            if (found) {
                break;
            }
        }
    }
    
    return array;
}

+ (NSArray*)sortPlaceList:(NSArray*)placeList bySortId:(NSNumber*)sortId currentLocation:(CLLocation*)currentLocation
{
    NSArray *array = nil;
    switch ([sortId intValue]) {
        case SORT_BY_RECOMMEND:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                int rank1 = [place1 rank];
                int rank2 = [place2 rank];
                
                if (rank1 < rank2)
                    return NSOrderedDescending;
                else  if (rank1 > rank2)
                    return NSOrderedAscending;
                else return NSOrderedSame;
            }];
            break;
            
        case SORT_BY_PRICE_FROM_EXPENSIVE_TO_CHEAP:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                float price1 = [[place1 price] floatValue];
                float price2 = [[place2 price] floatValue] ;
                
                if (price1 < price2)
                    return NSOrderedDescending;
                else  if (price1 > price2)
                    return NSOrderedAscending;
                else return NSOrderedSame;
            }];
            break;
            
        case SORT_BY_PRICE_FROM_CHEAP_TO_EXPENSIVE:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                float price1 = [[place1 price] floatValue];
                float price2 = [[place2 price] floatValue] ;
                
                if (price1 < price2)
                    return NSOrderedAscending;
                else  if (price1 > price2)
                    return NSOrderedDescending;
                else return NSOrderedSame;
            }];
            break;
            
        case SORT_BY_DESTANCE_FROM_NEAR_TO_FAR:
            array = [PlaceUtils sortedByDistance:currentLocation array:placeList type:[sortId intValue]];
            break;
            
        case SORT_BY_HOTEL_STARTS:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                int rank1 = [place1 hotelStar];
                int rank2 = [place2 hotelStar];
                
                if (rank1 < rank2)
                    return NSOrderedDescending;
                else  if (rank1 > rank2)
                    return NSOrderedAscending;
                else return NSOrderedSame;
            }];
            break;
            
        default:
            break;
    }
    
    return array;
}

@end
