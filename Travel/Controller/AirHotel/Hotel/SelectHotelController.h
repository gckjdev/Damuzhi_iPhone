//
//  SelectHotelController.h
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "PPTableViewController.h"
#import "RoomCell.h"
#import "HotelHeaderView.h"
#import "AirHotelService.h"

@interface SelectHotelController : PPTableViewController<HotelHeaderViewDelegate, AirHotelServiceDelegate>

- (id)initWithCheckInDate:(NSDate *)checkInDate
             checkOutDate:(NSDate *)checkOutDate;

@end
