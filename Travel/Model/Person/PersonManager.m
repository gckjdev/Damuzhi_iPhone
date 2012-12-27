//
//  PersonManager.m
//  Travel
//
//  Created by haodong on 12-12-6.
//
//

#import "PersonManager.h"
#import "AirHotel.pb.h"
#import "AppUtils.h"
#import "LogUtil.h"

@interface PersonManager()
@property (assign, nonatomic) PersonType personType;
@end


static PersonManager *_personManager = nil;

@implementation PersonManager

+ (PersonManager *)defaultManager:(PersonType)personType
{
    if (_personManager == nil) {
        _personManager = [[PersonManager alloc] init];
    }
    
    _personManager.personType = personType;
    return _personManager;
}

- (NSString*)getFilePath
{
    return [AppUtils getPersonFilePath:_personType];
}

- (NSArray*)findAllPersons
{
    NSData* data = [NSData dataWithContentsOfFile:[self getFilePath]];
    PersonList *list = nil;
    if (data != nil) {
        @try {
            list = [PersonList parseFromData:data];
        }
        @catch (NSException *exception) {
            PPDebug(@"<PersonManager> findAllPersons Caught %@%@", [exception name], [exception reason]);
        }
    }
    
    return [list personsList];
}

- (void)writeToFileWithList:(NSArray*)newList
{
    PersonList_Builder* builder = [[PersonList_Builder alloc] init];
    [builder addAllPersons:newList];
    PersonList *newPersonList = [builder build];
    
    PPDebug(@"<PersonManager> %@",[self getFilePath]);
    if (![[newPersonList data] writeToFile:[self getFilePath]  atomically:YES]) {
        PPDebug(@"<PersonManager> error");
    }
    [builder release];
}

- (BOOL)isEqual:(Person *)person anotherPerson:(Person *)anotherPerson
{
    if ([person.name isEqual:anotherPerson.name]
        && [person.nameEnglish isEqualToString:anotherPerson.nameEnglish]
        && person.ageType == anotherPerson.ageType
        && person.gender == anotherPerson.gender
        && person.nationalityId == anotherPerson.nationalityId
        && person.cardTypeId == anotherPerson.cardTypeId
        && [person.cardNumber isEqualToString:anotherPerson.cardNumber]
        && person.cardValidDate == anotherPerson.cardValidDate
        && person.birthday == anotherPerson.birthday
        && [person.phone isEqualToString:anotherPerson.phone]) {
        return YES;
    }
    
    return NO;
}

- (void)deletePerson:(Person *)person
{
    BOOL found = NO;
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllPersons]];
    for (Person *personTemp in mutableArray) {
        if ([self isEqual:personTemp anotherPerson:person]) {
            [mutableArray removeObject:personTemp];
            found = YES;
            break;
        }
    }
    
    if (found) {
        [self writeToFileWithList:mutableArray];
    }
}

- (void)savePerson:(Person *)person
{
    [self deletePerson:person];
    
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllPersons]];
    [mutableArray addObject:person];
    [self writeToFileWithList:mutableArray];
}



//+ (PersonManager *)defaultManager
//{
//    if (_personManager == nil) {
//        _personManager = [[PersonManager alloc] init];
//    }
//    return _personManager;
//}


//- (NSArray *)personList:(PersonType)personType
//{
//    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
//    
//    //test data
//    NSArray *nameArray = [NSArray arrayWithObjects:@"李一", @"李二", @"李三", @"李四", @"李五", nil];
//    if (personType != PersonTypeCreditCard) {
//        for (int i= 0; i < 5; i ++) {
//            Person_Builder *builder = [[[Person_Builder alloc] init] autorelease];
//            [builder setName:[nameArray objectAtIndex:i]];
//            [builder setNameEnglish:@"Yi/Lee"];
//            [builder setAgeType:PersonAgeTypePersonAgeAdult];
//            [builder setGender:PersonGenderPersonGenderMale];
//            [builder setNationalityId:1];
//            [builder setCardTypeId:1];
//            [builder setCardNumber:@"123456789"];
//            [builder setCardValidDate:9999999];
//            [builder setBirthday:9999999];
//            [builder setPhone:@"13900000000"];
//            
//            Person *person = [builder build];
//            [reArray addObject:person];
//        }
//        return reArray;
//    } else {
//        
//        for (int i= 0; i < 5; i ++) {
//            CreditCard_Builder *builder = [[[CreditCard_Builder alloc] init] autorelease];
//            [builder setBankId:1];
//            [builder setName:[nameArray objectAtIndex:i]];
//            [builder setNumber:@"987654321"];
//            
//            CreditCard *cc = [builder build];
//            [reArray addObject:cc];
//        }
//        return reArray;
//    }
//}

@end
