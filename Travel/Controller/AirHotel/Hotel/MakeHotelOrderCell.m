//
//  MakeHotelOrderCell.m
//  Travel
//
//  Created by haodong on 12-11-22.
//
//

#import "MakeHotelOrderCell.h"
#import "AirHotel.pb.h"
#import "AirHotelManager.h"

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
    return 120.0f;
}

- (void)setCellByHotelOrder:(HotelOrder_Builder *)hotelOrderBuilder indexPath:(NSIndexPath *)aIndexPath
{
    self.indexPath = aIndexPath;
    AirHotelManager *_manager = [AirHotelManager defaultManager];
    
    [self.checkInButton setTitle:[_manager dateIntToYearMonthDayWeekString:hotelOrderBuilder.checkInDate] forState:UIControlStateNormal];
    
    [self.checkOutButton setTitle:[_manager dateIntToYearMonthDayWeekString:hotelOrderBuilder.checkOutDate] forState:UIControlStateNormal];
    
    [self.hotelButton setTitle:hotelOrderBuilder.hotel.name forState:UIControlStateNormal];
}

- (IBAction)clickCheckInButton:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didClickCheckInButton:)]) {
        [delegate didClickCheckInButton:self.indexPath];
    }
}

- (IBAction)clickCheckOutButton:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didClickCheckOutButton:)]) {
        [delegate didClickCheckOutButton:self.indexPath];
    }
}

- (IBAction)clickHotelButton:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didClickHotelButton:)]) {
        [delegate didClickHotelButton:self.indexPath];
    }
}

@end
