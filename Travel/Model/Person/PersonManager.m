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
@property (assign, nonatomic) BOOL isMemeber;

//用于非会员保存
@property (retain, nonatomic) NSMutableArray *passengers;
@property (retain, nonatomic) NSMutableArray *checkInPersons;
@property (retain, nonatomic) NSMutableArray *contactPersons;
@end


static PersonManager *_personManager = nil;

@implementation PersonManager

- (void)dealloc
{
    [_passengers release];
    [_checkInPersons release];
    [_contactPersons release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.passengers = [[[NSMutableArray alloc] init] autorelease];
        self.checkInPersons = [[[NSMutableArray alloc] init] autorelease];
        self.contactPersons = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}


+ (PersonManager *)defaultManager:(PersonType)personType isMember:(BOOL)isMember
{
    if (_personManager == nil) {
        _personManager = [[PersonManager alloc] init];
    }
    
    _personManager.personType = personType;
    _personManager.isMemeber = isMember;
    return _personManager;
}

- (NSString*)getFilePath
{
    return [AppUtils getPersonFilePath:_personType];
}

- (NSArray*)findAllPersons
{
    if (_isMemeber) {
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
    
    //非会员
    else {
         return [self getTempArray];
    }
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
    NSMutableArray* mutableArray = nil;
    if (_isMemeber) {
        mutableArray = [NSMutableArray arrayWithArray:[self findAllPersons]];
    } else {
        mutableArray = [self getTempArray];
    }
    
    for (Person *personTemp in mutableArray) {
        if ([self isEqual:personTemp anotherPerson:person]) {
            [mutableArray removeObject:personTemp];
            found = YES;
            break;
        }
    }
    
    if (_isMemeber) {
        if (found) {
            [self writeToFileWithList:mutableArray];
        }
    }
}

- (void)savePerson:(Person *)person
{
    [self deletePerson:person];
    
    if (_isMemeber) {
        NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllPersons]];
        [mutableArray addObject:person];
        [self writeToFileWithList:mutableArray];
    }
    
    else {
        NSMutableArray *list = [self getTempArray];
        [list addObject:person];
    }
}

- (void)deleteAllPersons
{
    if (_isMemeber) {
        [self writeToFileWithList:nil];
    }
    
    else {
        NSMutableArray *list = [self getTempArray];
        [list removeAllObjects];
    }
}

- (BOOL)isExistName:(NSString *)name
{
    NSArray *list = [self findAllPersons];
    for (Person *person in list) {
        if ([person.name isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isExistCardTypeId:(int)cardTypeId cardNumber:(NSString *)cardNumber
{
    NSArray *list = [self findAllPersons];
    for (Person *person in list) {
        if (person.cardTypeId == cardTypeId && [person.cardNumber isEqualToString:cardNumber] ) {
            return YES;
        }
    }
    return NO;
}

/************非会员*************/
- (NSMutableArray *)getTempArray
{
    switch (_personType) {
        case PersonTypePassenger:
            return _passengers;
        case PersonTypeCheckIn:
            return _checkInPersons;
            break;
        case PersonTypeContact:
            return _contactPersons;
            break;
        default:
            return nil;
            break;
    }
}

@end
