//
//  FlightDetailController.h
//  Travel
//
//  Created by haodong on 12-12-10.
//
//

#import "PPViewController.h"
#import "UICustomPageControl.h"

@interface FlightDetailController : PPViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *flightSeatScrollView;
@property (retain, nonatomic) IBOutlet UICustomPageControl *flightSeatPageControl;

@end
