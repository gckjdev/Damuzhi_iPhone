//
//  PersonsView.m
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import "PersonsView.h"
#import "AirHotel.pb.h"
#import "LocaleUtils.h"

@implementation PersonsView

#define WIDTH_PERSONSVIEW       300
#define HEIGHT_PERSON_LABEL     24
#define X_PERSON_LABEL          60

+ (CGFloat)getHeight:(NSArray *)personList
{
    if ([personList count] > 0) {
        return [personList count] * HEIGHT_PERSON_LABEL;
    }
    return HEIGHT_PERSON_LABEL;
}

+ (PersonsView *)createCheckInPersonLabels:(NSArray *)personList type:(PersonListType)type
{
    PersonsView *returnPersonsView = [[[PersonsView alloc] init] autorelease];
    
    int index = 0;
    for (Person *person in personList) {
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(X_PERSON_LABEL, index * HEIGHT_PERSON_LABEL, 208, HEIGHT_PERSON_LABEL)] autorelease];
        label.textColor = [UIColor colorWithRed:18.0/255.0 green:140.0/255.0 blue:192.0/255.0 alpha:1];
        if (type == PersonListTypePassenger) {
            NSString *ageType = person.ageType == PersonAgeTypePersonAgeChild ? NSLS(@"儿童") : NSLS(@"成人");
            
            if ([person hasCardNumber] && person.cardNumber != nil && [person.cardNumber length] != 0) {
                label.text = [NSString stringWithFormat:@"%@ (%@) , %@", person.name, ageType, person.cardNumber];
            } else {
                label.text = [NSString stringWithFormat:@"%@ (%@)", person.name, ageType];
            }

        } else {
            label.text = [NSString stringWithFormat:@"%@", person.name];
        }
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        [returnPersonsView addSubview:label];
        
        index ++;
    }
    if (index == 0) {
        index = 1;
    }
    
    returnPersonsView.frame = CGRectMake(0, 0, WIDTH_PERSONSVIEW, HEIGHT_PERSON_LABEL * index);
    
    return returnPersonsView;
}

@end
