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
#import "PlaceService.h"

@protocol SelectHotelControllerDelegate <NSObject>

@optional
- (void)didClickFinish:(Place *)hotel roomInfos:(NSArray *)roomInfos;

@end


@interface SelectHotelController : PPTableViewController<AirHotelServiceDelegate,HotelHeaderViewDelegate,RoomCellDelegate, PlaceServiceDelegate>

- (id)initWithCheckInDate:(NSDate *)checkInDate
             checkOutDate:(NSDate *)checkOutDate
                 delegate:(id<SelectHotelControllerDelegate>)delegate;

@end
