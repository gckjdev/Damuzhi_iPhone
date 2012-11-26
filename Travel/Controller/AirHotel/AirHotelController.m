//
//  AirHotelController.m
//  Travel
//
//  Created by kaibin on 12-9-21.
//
//

#import "AirHotelController.h"
#import "AppDelegate.h"
#import "AirHotel.pb.h"
#import "ConfirmOrderController.h"

@interface AirHotelController ()

@property (retain, nonatomic) NSMutableArray *hotelOrderBuilderList;
@property (retain, nonatomic) NSIndexPath *currentIndexPath;
@property (assign, nonatomic) int currentDateTag;

@end

@implementation AirHotelController
@synthesize hotelOrderBuilderList = _hotelOrderBuilderList;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize currentDateTag = _currentDateTag;

enum FLIGHT_DATE_TAG{
    DEPART_DATE = 0,
};

enum HOTEL_DATE_TAG{
    CHECK_IN_DATE = 0,
    CHECK_OUT_DATE = 1,
};


- (void)dealloc {
    [_hotelOrderBuilderList release];
    [_currentIndexPath release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.hotelOrderBuilderList = [[[NSMutableArray alloc] init] autorelease];
        [self createHotelOrder];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLS(@"机+酒");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"djy_page_bg.jpg"]]];
}

- (void)createHotelOrder
{
    HotelOrder_Builder *builder = [[[HotelOrder_Builder alloc] init] autorelease];
    [builder setCheckInDate:[[NSDate date] timeIntervalSince1970]];
    [builder setCheckOutDate:[[NSDate date] timeIntervalSince1970] + 60*60*24];
    [_hotelOrderBuilderList addObject:builder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)hideTabBar:(BOOL)isHide
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:isHide];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self hideTabBar:NO];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [self hideTabBar:YES];
    [super viewDidDisappear:animated];
}


enum {
    SECTION_AIR = 0,
    SECTION_HOTEL = 1,
    SECTION_COUNT = 2
};

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_AIR) {
        return [MakeAirOrderTwoCell getCellHeight];
    }  else if (indexPath.section == SECTION_HOTEL) {
        return [MakeHotelOrderCell getCellHeight];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_AIR) {
        return 1;
    } else if (section == SECTION_HOTEL) {
        return [_hotelOrderBuilderList count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_AIR) {
        NSString *identifier = [MakeAirOrderTwoCell getCellIdentifier];
        MakeAirOrderTwoCell *cell = (MakeAirOrderTwoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [MakeAirOrderTwoCell createCell:self];
        }
        
        return cell;
        
    }  else if (indexPath.section == SECTION_HOTEL) {
        NSString *identifier = [MakeHotelOrderCell getCellIdentifier];
        MakeHotelOrderCell *cell = (MakeHotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [MakeHotelOrderCell createCell:self];
        }
        
        HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:indexPath.row];
        [cell setCellByHotelOrder:builder];
        cell.indexPath = indexPath;
        
        return cell;
    }
    
    return nil;
}

#pragma mark -
#pragma MakeHotelOrderCellDelegate methods
- (void)didClickCheckInButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    self.currentDateTag = CHECK_IN_DATE;
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self monthCount:12 title:NSLS(@"入住日期")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickCheckOutButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    self.currentDateTag = CHECK_OUT_DATE;
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self monthCount:12 title:NSLS(@"退房日期")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickHotelButton:(NSIndexPath *)indexPath
{
    SelectHotelController *controller =[[[SelectHotelController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma CommonMonthControllerDelegate methods
- (void)didSelectDate:(NSDate *)date
{
    if (_currentIndexPath.section == SECTION_HOTEL) {
        HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:_currentIndexPath.row];
        
        if (_currentDateTag == CHECK_IN_DATE) {
            [builder setCheckInDate:[date timeIntervalSince1970]];
        } else if (_currentDateTag == CHECK_OUT_DATE) {
            [builder setCheckOutDate:[date timeIntervalSince1970]];
        }
        
        [dataTableView reloadData];
    }
}

- (IBAction)clickMemberButton:(id)sender {
    ConfirmOrderController *controller = [[[ConfirmOrderController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
