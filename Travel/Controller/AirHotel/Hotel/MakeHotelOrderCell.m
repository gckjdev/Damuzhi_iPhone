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
#import "LocaleUtils.h"
#import "AirHotelColorConstants.h"

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
    
    NSString *defaultTips = NSLS(@"请选择");
    
    if ([hotelOrderBuilder hasCheckInDate]) {
        [self.checkInButton setTitleColor:COLOR_VALUE forState:UIControlStateNormal];
        [self.checkInButton setTitle:[_manager dateIntToYearMonthDayWeekString:hotelOrderBuilder.checkInDate] forState:UIControlStateNormal];
    } else {
        [self.checkInButton setTitleColor:COLOR_NO_VALUE forState:UIControlStateNormal];
        [self.checkInButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    if ([hotelOrderBuilder hasCheckOutDate]) {
        [self.checkOutButton setTitleColor:COLOR_VALUE forState:UIControlStateNormal];
        [self.checkOutButton setTitle:[_manager dateIntToYearMonthDayWeekString:hotelOrderBuilder.checkOutDate] forState:UIControlStateNormal];
    } else {
        [self.checkOutButton setTitleColor:COLOR_NO_VALUE forState:UIControlStateNormal];
         [self.checkOutButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    if ([hotelOrderBuilder hasHotel]) {
        [self.hotelButton setTitleColor:COLOR_VALUE forState:UIControlStateNormal];
        [self.hotelButton setTitle:hotelOrderBuilder.hotel.name forState:UIControlStateNormal];
    } else {
        [self.hotelButton setTitleColor:COLOR_NO_VALUE forState:UIControlStateNormal];
        [self.hotelButton setTitle:defaultTips forState:UIControlStateNormal];
    }
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
