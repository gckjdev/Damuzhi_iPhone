//
//  PriceUtils.m
//  Travel
//
//  Created by haodong on 12-12-24.
//
//

#import "PriceUtils.h"

@implementation PriceUtils

+ (NSString *)priceToString:(double)price
{
    NSString *str = [NSString stringWithFormat:@"%.0f", price];
    return str;
}

+ (NSString *)priceToString:(double)price currency:(NSString *)currency
{
    NSString *str = [NSString stringWithFormat:@"%@%@",currency, [self priceToString:price] ];
    return str;
}

+ (NSString *)priceToStringCNY:(double)price
{
    return [self priceToString:price currency:@"¥"];
}

@end
