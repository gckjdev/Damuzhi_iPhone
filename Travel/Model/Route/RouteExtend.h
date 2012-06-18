//
//  RouteExtend.h
//  Travel
//
//  Created by 小涛 王 on 12-6-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouristRoute.pb.h"

@interface TouristRoute (RouteExtend)

- (BOOL)isProvidedByAngency:(int)angencyId;
- (BOOL)isKindOfTheme:(int)themeId;
- (BOOL)isKindOfCategory:(int)typeId;
- (BOOL)isDepartFromCity:(int)departCityId;
- (BOOL)isHeadForCity:(int)destinationCityId;

@end
