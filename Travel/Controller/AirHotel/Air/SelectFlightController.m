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

@interface SelectFlightController ()
@end

@implementation SelectFlightController

- (void)dealloc
{
    [_topImageView release];
    [_buttomImageView release];
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.topImageView.image = [[ImageManager defaultManager] flightListTopBgImage];
    self.buttomImageView.image = [[ImageManager defaultManager] flightListBottomBgImage];
    
    [self testData];
    
//    [[AirHotelService  defaultService] findFlightsWithDepartCityId:<#(int)#>
//                                                 destinationCityId:<#(int)#>
//                                                        departDate:<#(NSDate *)#>
//                                                        flightType:<#(int)#>
//                                                      flightNumber:<#(NSString *)#>];
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
        
        Flight *flight = [builder build];
        [mutableArray addObject:flight];
    }
    
    self.dataList = mutableArray;
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
    return cell;
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FlightCell getCellHeight];
}


- (void)viewDidUnload {
    [self setTopImageView:nil];
    [self setButtomImageView:nil];
    [super viewDidUnload];
}
@end
