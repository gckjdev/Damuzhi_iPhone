//
//  GoogleAddressComponent.m
//  Travel
//
//  Created by haodong on 13-1-3.
//
//

#import "GoogleAddressComponent.h"
#import "JSON.h"

@implementation GoogleAddressComponent
- (void)dealloc
{
    [_longName release];
    [_shortName release];
    [_types release];
    [super dealloc];
}

- (id)initWithLongName:(NSString *)longName
             shortName:(NSString *)shortName
                 types:(NSArray *)types
{
    self = [super init];
    if (self) {
        self.longName = longName;
        self.shortName = shortName;
        self.types = types;
    }
    return self;
}

@end



static GACManager *_gACManager = nil;
@implementation GACManager

+ (GACManager *)defaultManager
{
    if (_gACManager == nil) {
        _gACManager = [[GACManager alloc] init];
    }
    return _gACManager;
}

- (NSArray *)componentList:(NSString *)geocodeJson
{
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSDictionary *dataDic = [geocodeJson JSONValue];
    NSArray *results  = [dataDic objectForKey:@"results"];
    if ([results count] > 0) {
        NSDictionary *resultDic = [results objectAtIndex:0];
        NSArray *components = [resultDic objectForKey:@"address_components"];
        for (NSDictionary *componentDic in components) {
            NSString *longName = [componentDic objectForKey:@"long_name"];
            NSString *shortName = [componentDic objectForKey:@"short_name"];
            NSArray *types = [componentDic objectForKey:@"types"];
            
            GoogleAddressComponent *component = [[[GoogleAddressComponent alloc] initWithLongName:longName shortName:shortName types:types] autorelease];
            [mutableArray addObject:component];
        }
    }
    
    return mutableArray;
}

- (NSString *)shortNameWithComponentList:(NSArray *)componentList type:(NSString *)type
{
    NSString *countryCode = nil;
    for (GoogleAddressComponent *component in componentList) {
        BOOL found = NO;
        for (NSString *oneType in component.types) {
            if ([oneType isEqualToString:type]) {
                found = YES;
                break;
            }
        }
        if (found) {
            countryCode = component.shortName;
            break;
        }
    }
    
    return countryCode;
}

- (NSString *)countryCode:(NSString *)geocodeJson
{
    NSArray *list = [self componentList:geocodeJson];
    
    NSString *countryCode = [self shortNameWithComponentList:list type:@"country"];
    
    return countryCode;
}

- (NSString *)cityName:(NSString *)geocodeJson
{
    NSArray *list = [self componentList:geocodeJson];
    
    NSString *cityPinyin = [self shortNameWithComponentList:list type:@"locality"];
    
    return cityPinyin;
}

@end
