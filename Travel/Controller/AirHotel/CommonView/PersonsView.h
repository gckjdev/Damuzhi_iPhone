//
//  PersonsView.h
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import <UIKit/UIKit.h>

typedef enum{
    PersonListTypePassenger = 1,
    PersonListTypeCheckIn = 2,
} PersonListType;

@interface PersonsView : UIView

+ (CGFloat)getHeight:(NSArray *)personList;
+ (PersonsView *)createCheckInPersonLabels:(NSArray *)personList type:(PersonListType)type;

@end
