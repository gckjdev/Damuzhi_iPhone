//
//  GoogleAddressComponent.h
//  Travel
//
//  Created by haodong on 13-1-3.
//
//

#import <Foundation/Foundation.h>

@interface GoogleAddressComponent : NSObject

@property (retain, nonatomic) NSString *longName;
@property (retain, nonatomic) NSString *shortName;
@property (retain, nonatomic) NSArray *types;

- (id)initWithLongName:(NSString *)longName
             shortName:(NSString *)shortName
                 types:(NSArray *)types;
@end



@interface GACManager : NSObject

+ (GACManager *)defaultManager;
- (NSString *)countryCode:(NSString *)geocodeJson;
- (NSString *)cityName:(NSString *)geocodeJson;

@end

