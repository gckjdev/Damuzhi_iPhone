//
//  CommonRouteListFilter.m
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonRouteListFilter.h"
#import "TouristRoute.pb.h"
#import "ImageManager.h"

@implementation CommonRouteListFilter

+ (UIButton*)createFilterButton:(CGRect)frame title:(NSString*)title 
{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    UIImage *bgImageForNormal = [[ImageManager defaultManager] filgerBtnBgImage];   
    
    [button setBackgroundImage:bgImageForNormal forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize: 12]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    return button;
}

//+ (NSArray *)filterRouteList:(NSArray *)routeList byAgencyIdList:(NSArray *)agencyIdList
//{
//    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
//    for (TouristRoute *route in routeList) {
//        NSNumber *agencyId = [NSNumber numberWithInt:route.agencyId];
//        if (NSNotFound != [agencyIdList indexOfObject:agencyId]) {
//            [retArray addObject:route];
//        }
//    }
//    
//    return retArray;
//}
//
//
//
//+ (NSArray *)filterRouteList:(NSArray *)routeList byThemeIdList:(NSArray *)themeIdList
//{
//    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
//    for (TouristRoute *route in routeList) {
//        for (NSNumber *themeId in route.themeIdsList) {
//            if (NSNotFound != [themeIdList indexOfObject:themeId]) {
//                [retArray addObject:route];
//            }
//        }
//    }
//    
//    return retArray;
//}
//
//+ (NSArray *)filterRouteList:(NSArray *)routeList byCategoryIdList:(NSArray *)categoryIdList
//{
//    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
//    for (TouristRoute *route in routeList) {
//        NSNumber *categoryId = [NSNumber numberWithInt:route.categoryId];
//        if (NSNotFound != [categoryIdList indexOfObject:categoryId]) {
//            [retArray addObject:route];
//        }
//    }
//    
//    return retArray;
//}
//
//+ (NSArray *)filterRouteList:(NSArray *)routeList byDepartCityId:(int)departCityId
//{    
//    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
//    
//    for (TouristRoute *route in routeList) {
//        if (route.departCityId == departCityId) {
//            [retArray addObject:route];
//        }
//    }
//    
//    return retArray;
//}
//
//+ (NSArray *)filterRouteList:(NSArray *)routeList byDestinationCityId:(int)destinationCityId
//{
//    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
//    
//    for (TouristRoute *route in routeList) {
////        if (route.destinationCityId == destinationCityId) {
////            [retArray addObject:route];
////        }
//        for (NSNumber *cityId in route.destinationCityIdsList) {
//            if ([cityId intValue] == destinationCityId) {
//                [retArray addObject:route];
//            }
//        }
//    }
//    
//    return retArray;
//}



@end
