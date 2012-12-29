//
//  PersonsView.m
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import "PersonsView.h"
#import "AirHotel.pb.h"

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

+ (PersonsView *)createCheckInPersonLabels:(NSArray *)personList
{
    PersonsView *returnPersonsView = [[[PersonsView alloc] init] autorelease];
    
    int index = 0;
    for (Person *person in personList) {
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(X_PERSON_LABEL, index * HEIGHT_PERSON_LABEL, 208, HEIGHT_PERSON_LABEL)] autorelease];
        label.textColor = [UIColor colorWithRed:18.0/255.0 green:140.0/255.0 blue:192.0/255.0 alpha:1];
        label.text = [NSString stringWithFormat:@"%@", person.name];
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
