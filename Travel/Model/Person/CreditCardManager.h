//
//  CreditCardManager.h
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import <Foundation/Foundation.h>

enum{
    PaymentTypeCreditCard = 1
};

@class CreditCard;

@interface CreditCardManager : NSObject

+ (CreditCardManager *)defaultManager;

- (NSArray*)findAllCreditCards;
- (void)deleteCreditCard:(CreditCard *)creditCard;
- (void)saveCreditCard:(CreditCard *)creditCard;
 
@end
