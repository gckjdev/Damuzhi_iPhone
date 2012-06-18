//
//  PlaceExtend.h
//  Travel
//
//  Created by 小涛 王 on 12-6-5.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.pb.h"

@interface Place (PlaceExtend)
- (BOOL)isKindOfCategory:(int)categoryId;
- (BOOL)isKindOfSubCategory:(int)subcategoryId;
- (BOOL)isInPriceRank:(int)priceRank;
- (BOOL)isInArea:(int)areaId;
- (BOOL)hasService:(int)serviceId;

@end
