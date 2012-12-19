//
//  FlightDetailController.h
//  Travel
//
//  Created by haodong on 12-12-10.
//
//

#import "PPViewController.h"
#import "UICustomPageControl.h"
#import "FlightSeatView.h"
#import "AirHotelManager.h"

@protocol FlightDetailControllerDelegate <NSObject>

@optional
- (void)didClickSelect:(Flight *)flight
       flightSeatIndex:(int)flightSeatIndex
            flightType:(FlightType)flightType;

@end


@class Flight;

@interface FlightDetailController : PPViewController<UIScrollViewDelegate, FlightSeatViewDelegate>
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
      arriveCityName:(NSString *)arriveCityName
            delegate:(id<FlightDetailControllerDelegate>)delegate;

@end
