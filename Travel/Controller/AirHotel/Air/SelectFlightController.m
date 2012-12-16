//
//  SelectFlightController.m
//  Travel
//
//  Created by haodong on 12-12-7.
//
//

#import "SelectFlightController.h"
#import "FlightCell.h"
#import "AirHotel.pb.h"
#import "FontSize.h"
#import "ImageManager.h"
#import "AppManager.h"
#import "TimeUtils.h"

@interface SelectFlightController ()
@property (assign, nonatomic) int departCityId;
@property (assign, nonatomic) int destinationCityId;
@property (retain, nonatomic) NSDate *flightDate;
@property (assign, nonatomic) FlightType flightType;
@property (retain, nonatomic) NSString *flightNumber;
@property (retain, nonatomic) NSString *leftName;
@property (retain, nonatomic) NSString *rightName;
@property (assign, nonatomic) id<FlightDetailControllerDelegate> delegate;

@end

@implementation SelectFlightController

- (void)dealloc
{
    [_topImageView release];
    [_buttomImageView release];
    [_flightDate release];
    [_flightNumber release];
    [_timeFilterButton release];
    [_priceFilterButton release];
    [_flightDateLabel release];
    [_cityLabel release];
    [_countLabel release];
    [_leftName release];
    [_rightName release];
    [super dealloc];
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (id)initWithDepartCityId:(int)departCityId
         destinationCityId:(int)destinationCityId
                flightDate:(NSDate *)flightDate
                flightType:(FlightType)flightType
              flightNumber:(NSString *)flightNumber
                  delegate:(id<FlightDetailControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.departCityId = departCityId;
        self.destinationCityId = destinationCityId;
        self.flightDate = flightDate;
        self.flightType = flightType;
        self.flightNumber = flightNumber;
        self.delegate = delegate;
        
        if (_flightType == FlightTypeGo || _flightType == FlightTypeGoOfDouble) {
            self.leftName = [[AppManager defaultManager] getAirCityName:_departCityId];
            self.rightName = [[AppManager defaultManager] getAirCityName:_destinationCityId];
        } else {
            self.leftName = [[AppManager defaultManager] getAirCityName:_destinationCityId];
            self.rightName = [[AppManager defaultManager] getAirCityName:_departCityId];
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_flightType == FlightTypeGo || _flightType == FlightTypeGoOfDouble) {
        self.title =NSLS(@"去程航班");
    } else if (_flightType == FlightTypeBack || _flightType == FlightTypeBackOfDouble){
        self.title =NSLS(@"返程航班");
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.topImageView.image = [[ImageManager defaultManager] flightListTopBgImage];
    self.buttomImageView.image = [[ImageManager defaultManager] flightListBottomBgImage];
    
    self.flightDateLabel.text =  dateToChineseStringByFormat(_flightDate, @"yyyy-MM-dd");
    
    self.cityLabel.text = [NSString stringWithFormat:@"%@ - %@",_leftName,_rightName];
    self.countLabel.text = nil;
    
    [self testData];
    //[self findFlights];
}

- (void)findFlights
{
    [self showActivityWithText:NSLS(@"数据加载中......")];
    
    if (_flightType == FlightTypeGo || _flightType == FlightTypeGoOfDouble) {
        [[AirHotelService  defaultService] findFlightsWithDepartCityId:_departCityId
                                                     destinationCityId:_destinationCityId
                                                            departDate:_flightDate
                                                            flightType:_flightType
                                                          flightNumber:_flightNumber
                                                              delegate:self];
    } else {
        [[AirHotelService  defaultService] findFlightsWithDepartCityId:_destinationCityId
                                                     destinationCityId:_departCityId
                                                            departDate:_flightDate
                                                            flightType:_flightType
                                                          flightNumber:_flightNumber
                                                              delegate:self];
    }
}

- (void)testData
{
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0 ; i < 20; i++) {
        Flight_Builder *builder = [[[Flight_Builder alloc] init] autorelease];
        [builder setFlightNumber:@"CA1893"];
        [builder setAirlineId:1];
        [builder setPlaneType:@"大型机"];
        [builder setPrice:@"1189"];
        [builder setDepartAirport:@"新白云机场"];
        [builder setArriveAirport:@"首都机场"];
        
        
        NSMutableArray *seats = [[[NSMutableArray alloc] init] autorelease];
        for (int j = 0 ; j < 3; j++) {
            FlightSeat_Builder *seatBuilder = [[[FlightSeat_Builder alloc] init] autorelease];
            [seatBuilder setCode:[NSString stringWithFormat:@"%d",j]];
            [seatBuilder setName:@"经济舱"];
            [seatBuilder setRemainingCount:@"10"];
            [seatBuilder setTicketPrice:@"200"];
            [seatBuilder setPrice:@"800"];
            [seatBuilder setRefundNote:@"退票规则"];
            [seatBuilder setChangeNote:@"改签规则"];
            
            FlightSeat *seat = [seatBuilder build];
            [seats addObject:seat];
        }
        [builder addAllFlightSeats:seats];
        Flight *flight = [builder build];
        [mutableArray addObject:flight];
    }
    
    self.dataList = mutableArray;
}

#pragma mark -
#pragma AirHotelServiceDelegate methods
- (void)findFlightsDone:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo flightList:(NSArray *)flightList
{
    [self hideActivity];
    self.dataList = flightList;
    self.countLabel.text = [NSString stringWithFormat:@"共%d条",[dataList count]];
    [dataTableView reloadData];
}


#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [FlightCell getCellIdentifier];
    FlightCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [FlightCell createCell:self];
    }
    Flight *flight = [dataList objectAtIndex:indexPath.row];
    
    [cell setCellWithFlight:flight];
    
    return cell;
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FlightCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlightDetailController *controller;
    
    Flight *flight = [dataList objectAtIndex:indexPath.row];
    controller = [[FlightDetailController alloc] initWithFlight:flight
                                                     flightType:_flightType
                                                 departCityName:_leftName
                                                 arriveCityName:_rightName
                                                       delegate:_delegate];

    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)viewDidUnload {
    [self setTopImageView:nil];
    [self setButtomImageView:nil];
    [self setTimeFilterButton:nil];
    [self setPriceFilterButton:nil];
    [self setFlightDateLabel:nil];
    [self setCityLabel:nil];
    [self setCountLabel:nil];
    [super viewDidUnload];
}

- (IBAction)clickTimeFilterButton:(id)sender {
    
}

- (IBAction)clickPriceFilterButton:(id)sender {
    
}


@end
