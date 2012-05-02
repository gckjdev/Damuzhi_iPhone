//
//  PlaceUtils.m
//  Travel
//
//  Created by haodong qiu on 12年4月11日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PlaceUtils.h"
#import "LocaleUtils.h"
#import "AppManager.h"

@implementation PlaceUtils

+ (NSString*)hotelStarToString:(int32_t)hotelStar
{
    switch (hotelStar) {
        case 1:
            return NSLS(@"一星级");
            break;
        case 2:
            return NSLS(@"二星级");
            break;
        case 3:
            return NSLS(@"三星级");
            break;
        case 4:
            return NSLS(@"四星级");
            break;
        case 5:
            return NSLS(@"五星级");
            break;
            
        default:
            break;
    }
    return nil;
}

+ (NSString*)getPriceString:(Place*)place
{
    if ([place.price intValue] > 0) {
        return [NSString stringWithFormat:@"%@%@",
                [[AppManager defaultManager] getCurrencySymbol:place.cityId],
                [place price]];
    }else {
        return NSLS(@"免费");
    }
}


+ (NSString*)getDistanceString:(Place*)place currentLocation:(CLLocation*)currentLocation
{
    if (currentLocation == nil) {
        return @"";
    }
    
    CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:[place latitude] longitude:[place longitude]];
    CLLocationDistance distance = [placeLocation distanceFromLocation:currentLocation];
    [placeLocation release];
    
    return[PlaceUtils getDistanceStringFrom:distance];
}

+ (NSString*)getDistanceStringFrom:(float)distance
{    
    // 单位统一为KM，大于1KM的，采用四舍五入，不用小数点; 小于1KM的，以小数点后一位为标准，如:0.9KM，小于0.1KM的，用“<0.1KM”
    double distanceInKM = distance/1000.0;
    
    if (distance >1000.0) {
        long long temp = distanceInKM + 0.5;
        return [NSString stringWithFormat:NSLS(@"%lldKM"), temp];
    }
    else if (distance > 100.0){ 
        return [NSString stringWithFormat:NSLS(@"%.1fKM"), distanceInKM];
    }
    else {
        return [NSString stringWithFormat:NSLS(@"<0.1KM")];
    }
}


@end
