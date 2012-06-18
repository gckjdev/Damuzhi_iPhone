//
//  PlaceExtend.m
//  Travel
//
//  Created by 小涛 王 on 12-6-5.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceExtend.h"
#import "CommonPlace.h"

@implementation Place (PlaceExtend)

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
    NSNumber *providedServceId = [NSNumber numberWithInt:serviceId_];
    if (serviceId_ == ALL_CATEGORY || NSNotFound != [self.providedServiceIdList indexOfObject:providedServceId]) {
        return YES;
    }
    
    return NO ;
}

@end
