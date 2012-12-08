//
//  PersonManager.m
//  Travel
//
//  Created by haodong on 12-12-6.
//
//

#import "PersonManager.h"
#import "AirHotel.pb.h"

static PersonManager *_personManager = nil;

@implementation PersonManager

+ (PersonManager *)defaultManager
{
    if (_personManager == nil) {
        _personManager = [[PersonManager alloc] init];
    }
    return _personManager;
}


- (NSArray *)personList:(PersonType)personType
{
    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
    
    //test data
    NSArray *nameArray = [NSArray arrayWithObjects:@"李一", @"李二", @"李三", @"李四", @"李五", nil];
    if (personType != PersonTypeCreditCard) {
        for (int i= 0; i < 5; i ++) {
            Person_Builder *builder = [[[Person_Builder alloc] init] autorelease];
            [builder setName:[nameArray objectAtIndex:i]];
            [builder setNameEnglish:@"Yi Lee"];
            [builder setAgeType:PersonAgeTypePersonAgeAdult];
            [builder setGender:PersonGenderPersonGenderMale];
            [builder setNationalityId:1];
            [builder setCardTypeId:1];
            [builder setCardNumber:@"123456789"];
            [builder setCardValidDate:9999999];
            [builder setBirthday:9999999];
            [builder setPhone:@"13900000000"];
            
            Person *person = [builder build];
            [reArray addObject:person];
        }
        return reArray;
    } else {
        
        for (int i= 0; i < 5; i ++) {
            CreditCard_Builder *builder = [[[CreditCard_Builder alloc] init] autorelease];
            [builder setBankId:1];
            [builder setName:[nameArray objectAtIndex:i]];
            [builder setNumber:@"987654321"];
            
            CreditCard *cc = [builder build];
            [reArray addObject:cc];
        }
        return reArray;
    }
}

@end
