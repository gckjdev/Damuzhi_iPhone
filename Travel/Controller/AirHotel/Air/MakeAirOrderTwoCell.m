//
//  MakeAirOrderTwoCell.m
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "MakeAirOrderTwoCell.h"

@implementation MakeAirOrderTwoCell

+ (NSString*)getCellIdentifier
{
    return @"MakeAirOrderTwoCell";
}

+ (CGFloat)getCellHeight
{
    return 200.0f;
}

- (IBAction)clickDepartCityButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickDepartCityButton)]) {
        [delegate didClickDepartCityButton];
    }
}

- (IBAction)clickGoDateButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickGoDateButton)]) {
        [delegate didClickGoDateButton];
    }
}

- (IBAction)clickBackDateButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickBackDateButton)]) {
        [delegate didClickBackDateButton];
    }
}

- (IBAction)clickGoFlightButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickGoFlightButton)]) {
        [delegate didClickGoFlightButton];
    }
}

- (IBAction)clickBackFlightButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickBackFlightButton)]) {
        [delegate didClickBackFlightButton];
    }
}

@end
