//
//  FlightDetailController.m
//  Travel
//
//  Created by haodong on 12-12-10.
//
//

#import "FlightDetailController.h"
#import "FlightSeatView.h"
#import "FontSize.h"
#import "AirHotel.pb.h"
#import "TimeUtils.h"
#import "AppManager.h"

@interface FlightDetailController ()

@property (retain, nonatomic) Flight *flight;
@property (assign, nonatomic) FlightType flightType;
@property (retain, nonatomic) NSString *departCityName;
@property (retain, nonatomic) NSString *arriveCityName;

@end

@implementation FlightDetailController

- (void)dealloc {
    [_flightSeatScrollView release];
    [_flightSeatPageControl release];
    [_flight release];
    [_flightTypeLabel release];
    [_flightDateLabel release];
    [_airlineAndFlightNumberLabel release];
    [_departCityLabel release];
    [_departDateLabel release];
    [_departAirportLabel release];
    [_arriveCityLabel release];
    [_arriveDateLabel release];
    [_arriveAirportLabel release];
    
    [_departCityName release];
    [_arriveCityName release];
    [super dealloc];
}

- (id)initWithFlight:(Flight *)flight
          flightType:(FlightType)flightType
      departCityName:(NSString *)departCityName
      arriveCityName:(NSString *)arriveCityName
{
    self = [super init];
    if (self) {
        self.flight = flight;
        self.flightType = flightType;
        self.departCityName = departCityName;
        self.arriveCityName= arriveCityName;
    }
    return self;
}

- (void)viewDidUnload {
    [self setFlightSeatScrollView:nil];
    [self setFlightSeatPageControl:nil];
    [self setFlightTypeLabel:nil];
    [self setFlightDateLabel:nil];
    [self setAirlineAndFlightNumberLabel:nil];
    [self setDepartCityLabel:nil];
    [self setDepartDateLabel:nil];
    [self setDepartAirportLabel:nil];
    [self setArriveCityLabel:nil];
    [self setArriveDateLabel:nil];
    [self setArriveAirportLabel:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"航班详情");
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    
    self.flightSeatScrollView.pagingEnabled = YES;
    self.flightSeatScrollView.showsHorizontalScrollIndicator = NO;
    self.flightSeatPageControl.enabled = NO;
    [self.flightSeatPageControl setPageIndicatorImageForCurrentPage:[UIImage imageNamed:@"flight_point_on.png"] forNotCurrentPage:[UIImage imageNamed:@"flight_point_off.png"]];
    [self createSeatViewList];
    
    [self setHeaderContent];
}

#define FLIGHT_TIME_FORMAT @"hh:mm"

- (void)setHeaderContent
{
    if (_flightType == FlightTypeGo || _flightType == FlightTypeGoOfDouble) {
        self.flightTypeLabel.text = NSLS(@"去程");
    } else {
        self.flightTypeLabel.text = NSLS(@"回程");
    }
    
    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:_flight.departDate];
    NSDate *arriveDate = [NSDate dateWithTimeIntervalSince1970:_flight.arriveDate];
    
    self.flightDateLabel.text = dateToChineseStringByFormat(departDate, @"yyyy-MM-dd");
    
    
    NSString *airlineName = [[AppManager defaultManager] getAirlineName:_flight.airlineId];
    self.airlineAndFlightNumberLabel.text = [NSString stringWithFormat:@"%@ %@", airlineName, _flight.flightNumber];
    
    self.departCityLabel.text = _departCityName;
    self.departDateLabel.text = dateToChineseStringByFormat(departDate, FLIGHT_TIME_FORMAT);
    self.departAirportLabel.text = _flight.departAirport;
    
    
    self.arriveCityLabel.text = _arriveCityName;
    self.arriveDateLabel.text = dateToChineseStringByFormat(arriveDate, FLIGHT_TIME_FORMAT);
    self.arriveAirportLabel.text = _flight.arriveAirport;
}

- (void)createSeatViewList
{
    //test data
    for (int i = 0 ; i < [_flight.flightSeatsList count]; i++) {
        FlightSeatView *flightSeatView = [FlightSeatView createFlightSeatView];
        FlightSeat *flightSeat = [_flight.flightSeatsList objectAtIndex:i];
        //flightSeatView
        
        flightSeatView.frame = CGRectMake(flightSeatView.frame.size.width * i, 0, flightSeatView.frame.size.width, flightSeatView.frame.size.height);
        [self.flightSeatScrollView addSubview:flightSeatView];
    }
    
    self.flightSeatScrollView.contentSize = CGSizeMake(320 * 5, self.flightSeatScrollView.contentSize.height);
    self.flightSeatPageControl.numberOfPages = 5;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    [_flightSeatPageControl setCurrentPage:offset.x / scrollView.frame.size.width];
}

@end
