//
//  SelectFlightController.h
//  Travel
//
//  Created by haodong on 12-12-7.
//
//

#import "PPTableViewController.h"
#import "AirHotelService.h"

@interface SelectFlightController : PPTableViewController

@property (retain, nonatomic) IBOutlet UIImageView *topImageView;

@property (retain, nonatomic) IBOutlet UIImageView *buttomImageView;

- (id)initWithTitle:(NSString *)title;

@end
