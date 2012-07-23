//
//  RouteExtend.m
//  Travel
//
//  Created by 小涛 王 on 12-6-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteExtend.h"
#import "AppConstants.h"

@implementation TouristRoute (RouteExtend)

- (BOOL)isProvidedByAngency:(int)angencyId_
{    
    if (angencyId_ == ALL_CATEGORY || self.agencyId == angencyId_) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isKindOfTheme:(int)themeId_
{
    if (themeId_ == ALL_CATEGORY) {
        return YES;
    }
    
    for (NSNumber *themeId in self.themeIdsList) {
        if ([themeId intValue] == themeId_) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isKindOfCategory:(int)categoryId_
{
    if (categoryId_ == ALL_CATEGORY || self.categoryId == categoryId_) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isDepartFromCity:(int)departCityId_
{
    if (departCityId_ == ALL_CATEGORY || self.departCityId == departCityId_) {
        return YES;
    }
    
    return NO;
}


- (BOOL)isHeadForCity:(int)destinationCityId_
{
//    if (destinationCityId_ == ALL_CATEGORY || self.destinationCityId == destinationCityId_) {
//        return YES;
//    }
//    
//    return NO;
    
    if (destinationCityId_ == ALL_CATEGORY) {
        return YES;
    }
    
    for (NSNumber *cityId in self.destinationCityIdsList) {
        if ([cityId intValue] == destinationCityId_) {
            return YES;
        }
    }
    
    return NO;
}

@end
