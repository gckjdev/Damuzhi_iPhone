//
//  CreditCardManager.m
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import "CreditCardManager.h"
#import "AppUtils.h"
#import "AirHotel.pb.h"
#import "LogUtil.h"

@interface CreditCardManager()
@property (retain, nonatomic) NSMutableArray *creditCards;
@end


static CreditCardManager *_creditCardManager = nil;

@implementation CreditCardManager

- (void)dealloc
{
    [_creditCards release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.creditCards = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

+ (CreditCardManager *)defaultManager
{
    if (_creditCardManager == nil) {
        _creditCardManager = [[CreditCardManager alloc] init];
    }
    
    return _creditCardManager;
}

- (NSString*)getFilePath
{
    return [AppUtils getCreditCardFilePath];
}

- (NSArray*)findAllCreditCards
{
    NSData* data = [NSData dataWithContentsOfFile:[self getFilePath]];
    CreditCardList *list = nil;
    if (data != nil) {
        @try {
            list = [CreditCardList parseFromData:data];
        }
        @catch (NSException *exception) {
            PPDebug(@"<CreditCardManager> findAllCreditCards Caught %@%@", [exception name], [exception reason]);
        }
    }
    
    return [list creditCardsList];
}

- (void)writeToFileWithList:(NSArray*)newList
{
    CreditCardList_Builder* builder = [[CreditCardList_Builder alloc] init];
    [builder addAllCreditCards:newList];
    CreditCardList *newCreditCardList = [builder build];
    
    PPDebug(@"<CreditCardManager> %@",[self getFilePath]);
    if (![[newCreditCardList data] writeToFile:[self getFilePath]  atomically:YES]) {
        PPDebug(@"<CreditCardManager> error");
    }
    [builder release];
}

- (BOOL)isEqual:(CreditCard *)creditCard anotherCreditCard:(CreditCard *)anotherCreditCard
{
    if (creditCard.bankId == anotherCreditCard.bankId
        && [creditCard.number isEqualToString:anotherCreditCard.number]
        && [creditCard.name isEqualToString:anotherCreditCard.name]
        && [creditCard.ccv isEqualToString:anotherCreditCard.ccv]
        && creditCard.validDateYear == anotherCreditCard.validDateYear
        && creditCard.validDateMonth == anotherCreditCard.validDateMonth
        && creditCard.idCardTypeId == anotherCreditCard.idCardTypeId
        && [creditCard.idCardNumber isEqualToString:anotherCreditCard.idCardNumber])
    {
        return YES;
    }
    
    return NO;
}

- (void)deleteCreditCard:(CreditCard *)creditCard
{
    BOOL found = NO;
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllCreditCards]];
    for (CreditCard *creditCardTemp in mutableArray) {
        if ([self isEqual:creditCardTemp anotherCreditCard:creditCard]) {
            [mutableArray removeObject:creditCardTemp];
            found = YES;
            break;
        }
    }
    
    if (found) {
        [self writeToFileWithList:mutableArray];
    }
}

- (void)saveCreditCard:(CreditCard *)creditCard
{
    [self deleteCreditCard:creditCard];
    
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllCreditCards]];
    [mutableArray addObject:creditCard];
    [self writeToFileWithList:mutableArray];
}

/************非会员*************/
- (NSArray *)findAllTempCreditCards
{
    return _creditCards;
}

- (void)deleteTempCreditCard:(CreditCard *)creditCard
{
    for (CreditCard *oneCreditCard in _creditCards) {
        if ([self isEqual:oneCreditCard anotherCreditCard:creditCard]) {
            [_creditCards removeObject:oneCreditCard];
            break;
        }
    }
}

- (void)addTempCreditCard:(CreditCard *)creditCard
{
    [self deleteTempCreditCard:creditCard];
    [_creditCards addObject:creditCard];
}

- (void)deleteAllTempCreditCards
{
    [_creditCards removeAllObjects];
}

@end
