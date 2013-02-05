//
//  AirHotelOrderListController.h
//  Travel
//
//  Created by haodong on 12-12-27.
//
//

#import "PPTableViewController.h"
#import "AirHotelService.h"
#import "AirHotelOrderDetailController.h"

@protocol AirHotelOrderListControllerDelegate <NSObject>
@optional
- (void)didClickBackButton;
@end

@interface AirHotelOrderListController : PPTableViewController<AirHotelServiceDelegate, AirHotelOrderDetailControllerDelegate>
@property (assign, nonatomic) id<AirHotelOrderListControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isPopToRoot;

@end
