//
//  MakeHotelOrderCell.m
//  Travel
//
//  Created by haodong on 12-11-22.
//
//

#import "MakeHotelOrderCell.h"

@implementation MakeHotelOrderCell

- (void)dealloc {
    [_checkInButton release];
    [_checkOutButton release];
    [_hotelButton release];
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"MakeHotelOrderCell";
}

+ (CGFloat)getCellHeight
{
    return 110.0f;
}

- (IBAction)clickCheckInButton:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didClickCheckInButton:)]) {
        [delegate didClickCheckInButton:self.indexPath];
    }
}

- (IBAction)clickCheckOutButton:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didClickCheckOutButton::)]) {
        [delegate didClickCheckInButton:self.indexPath];
    }
}

- (IBAction)clickHotelButton:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didClickHotelButton::)]) {
        [delegate didClickCheckInButton:self.indexPath];
    }
}

@end
