//
//  PriceUtils.h
//  Travel
//
//  Created by haodong on 12-12-24.
//
//

#import <Foundation/Foundation.h>

@interface PriceUtils : NSObject

+ (NSString *)priceToString:(double)price;
+ (NSString *)priceToString:(double)price currency:(NSString *)currency;
+ (NSString *)priceToStringCNY:(double)price;

@end
