//
//  ConfirmHotelCell.m
//  Travel
//
//  Created by haodong on 12-12-1.
//
//

#import "ConfirmHotelCell.h"
#import "AirHotel.pb.h"
#import "TimeUtils.h"

@implementation ConfirmHotelCell

+(NSString *)getCellIdentifier
{
    return @"ConfirmHotelCell";
}

+ (CGFloat)getCellHeight
{
    return 160;
}

- (void)dealloc {
    [_hotelNameLabel release];
    [_dateLabel release];
    [_checkInPersonButton release];
    [super dealloc];
}

- (void)setCellWith:(HotelOrder_Builder *)hotelOrderBuilder indexPath:(NSIndexPath *)aIndexPath
{
    self.indexPath = aIndexPath;
    
    self.hotelNameLabel.text = hotelOrderBuilder.hotel.name;
    
    NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970:hotelOrderBuilder.checkInDate];
    NSDate *checkOutDate = [NSDate dateWithTimeIntervalSince1970:hotelOrderBuilder.checkOutDate];
    NSString *checkInDateString = dateToStringByFormat(checkInDate, @"yyyy年MM月dd日");
    NSString *checkOutDateString = dateToStringByFormat(checkOutDate, @"yyyy年MM月dd日");
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", checkInDateString, checkOutDateString];
    
    if ([[hotelOrderBuilder checkInPersonsList] count] > 0) {
        [self.checkInPersonButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.checkInPersonButton setTitle:@"一间房一位入住人    添加入住人" forState:UIControlStateNormal];
    }
}

- (IBAction)clickCheckInPersonButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickCheckInPersonButton:)]) {
        [delegate didClickCheckInPersonButton:indexPath];
    }
}

@end
