//
//  PlaceExtend.m
//  Travel
//
//  Created by 小涛 王 on 12-6-5.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceExtend.h"
#import "Place.pb.h"
#import "App.pb.h"
#import "AppConstants.h"

@implementation Place (PlaceExtend)

- (BOOL)isKindOfCategory:(int)categoryId_
{
    if (categoryId_ == PlaceCategoryTypePlaceAll || self.categoryId == categoryId_) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isKindOfSubCategory:(int)subCategoryId_
{    
    if (subCategoryId_ == ALL_CATEGORY || self.subCategoryId == subCategoryId_) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isInPriceRank:(int)priceRank_
{
    if (priceRank_ == ALL_CATEGORY || self.priceRank == priceRank_) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isInArea:(int)areaId_
{
    if (areaId_ == ALL_CATEGORY || self.areaId == areaId_) {
        return YES;
    }
    
    return NO;
}

- (BOOL)hasService:(int)serviceId_
{    
    if (serviceId_ == ALL_CATEGORY) {
        return YES;
    }
    
    for (NSNumber *servicId in self.providedServiceIdList) {
        if ([servicId intValue] == serviceId_) {
            return YES;
        }
    }
    
    return NO;
}

@end
