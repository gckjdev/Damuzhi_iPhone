//
//  SelectFlightController.h
//  Travel
//
//  Created by haodong on 12-12-7.
//
//

#import "PPTableViewController.h"
#import "AirHotelService.h"
#import "AirHotelManager.h"
#import "FlightDetailController.h"

@interface SelectFlightController : PPTableViewController <AirHotelServiceDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *topImageView;

@property (retain, nonatomic) IBOutlet UIImageView *buttomImageView;
@property (retain, nonatomic) IBOutlet UIButton *timeFilterButton;
@property (retain, nonatomic) IBOutlet UIButton *priceFilterButton;

@property (retain, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *cityLabel;
@property (retain, nonatomic) IBOutlet UILabel *countLabel;


- (id)initWithDepartCityId:(int)departCityId
         destinationCityId:(int)destinationCityId
                flightDate:(NSDate *)flightDate
                flightType:(FlightType)flightType
              flightNumber:(NSString *)flightNumber
                  delegate:(id<FlightDetailControllerDelegate>)delegate;

@end
