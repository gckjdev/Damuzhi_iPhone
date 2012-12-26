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

static CreditCardManager *_creditCardManager = nil;

@implementation CreditCardManager

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

- (void)deleteCreditCard:(CreditCard *)creditCard
{
    BOOL found = NO;
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllCreditCards]];
    for (CreditCard *creditCardTemp in mutableArray) {
        if ([creditCardTemp isEqual:creditCard]) {
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

@end
