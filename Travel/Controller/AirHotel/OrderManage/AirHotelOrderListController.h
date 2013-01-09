//
//  AirHotelOrderListController.h
//  Travel
//
//  Created by haodong on 12-12-27.
//
//

#import "PPTableViewController.h"
#import "AirHotelService.h"

@protocol AirHotelOrderListControllerDelegate <NSObject>
@optional
- (void)didClickBackButton;
@end

@interface AirHotelOrderListController : PPTableViewController<AirHotelServiceDelegate>
@property (assign, nonatomic) id<AirHotelOrderListControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isPopToRoot;

@end
