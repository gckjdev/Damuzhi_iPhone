//
//  PersonManager.h
//  Travel
//
//  Created by haodong on 12-12-6.
//
//

#import <Foundation/Foundation.h>

typedef enum{
    PersonTypePassenger = 1,
    PersonTypeCheckIn = 2,
    PersonTypeContact = 3,
} PersonType;

@class Person;

@interface PersonManager : NSObject

+ (PersonManager *)defaultManager:(PersonType)personType;

- (NSArray*)findAllPersons;
- (void)deletePerson:(Person *)person;
- (void)savePerson:(Person *)person;

@end
