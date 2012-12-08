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
    PersonTypeCreditCard = 4
} PersonType;

@interface PersonManager : NSObject

+ (PersonManager *)defaultManager;

- (NSArray *)personList:(PersonType)personType;

@end
