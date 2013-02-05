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

+ (PersonManager *)defaultManager:(PersonType)personType isMember:(BOOL)isMember;

- (NSArray*)findAllPersons;
- (void)deletePerson:(Person *)person;
- (void)savePerson:(Person *)person;
- (void)deleteAllPersons;
- (BOOL)isExistName:(NSString *)name;
- (BOOL)isExistCardTypeId:(int)cardTypeId cardNumber:(NSString *)cardNumber;

@end
