//
//  FlightDetailController.h
//  Travel
//
//  Created by haodong on 12-12-10.
//
//

#import "PPViewController.h"
#import "UICustomPageControl.h"
#import "SelectFlightController.h"

@class Flight;

@interface FlightDetailController : PPViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *flightSeatScrollView;
@property (retain, nonatomic) IBOutlet UICustomPageControl *flightSeatPageControl;

@property (retain, nonatomic) IBOutlet UILabel *flightTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *airlineAndFlightNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *departCityLabel;
@property (retain, nonatomic) IBOutlet UILabel *departDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *departAirportLabel;

@property (retain, nonatomic) IBOutlet UILabel *arriveCityLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveAirportLabel;

- (id)initWithFlight:(Flight *)flight
          flightType:(FlightType)flightType
      departCityName:(NSString *)departCityName
      arriveCityName:(NSString *)arriveCityName;

@end
