//
//  RestaurantDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"
#import "AppManager.h"
#import "PlaceUtils.h"

@implementation RestaurantViewHandler

- (void)addDetailViewsToController:(CommonPlaceDetailController*)controller WithPlace:(Place*)place
{
    [controller addIntroductionViewWith: NSLS(@"餐馆介绍") description:[place introduction]];
    
    NSString *str = [[AppManager defaultManager] getSubCategotyName:[place categoryId] subCategoryId:[place subCategoryId]];
    [controller addSegmentViewWith: NSLS(@"菜式类型") description: str];
    
    [controller addSegmentViewWith: NSLS(@"营业时间") description:[place openTime]];
    
    [controller addSegmentViewWith:NSLS(@"人均消费") description:[PlaceUtils getDetailPrice:place]];
    
    //[controller addSegmentViewWith: NSLS(@"推荐理由") description:[[place keywordsList] componentsJoinedByString:@"、"]];
    
    [controller addSegmentViewWith: NSLS(@"特色菜式") description:[[place typicalDishesList] componentsJoinedByString:@" "]];
    
    NSMutableString * transportation = [NSMutableString stringWithString:[place transportation]];
    NSRange range = NSMakeRange(0, [transportation length]); 
    [transportation replaceOccurrencesOfString:@";" withString:@"\n" options:NSCaseInsensitiveSearch range:range];
    [controller addSegmentViewWith: NSLS(@"交通信息") description:transportation];
}

@end
