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
#import "AirHotelManager.h"
#import "SelectCityController.h"
#import "AppManager.h"

enum HOTEL_FLIGHT_DATE_TAG{
    GO_DATE = 0,
    BACK_DATE = 1,
    CHECK_IN_DATE = 2,
    CHECK_OUT_DATE = 3,
};

@interface AirHotelController ()

@property (retain, nonatomic) NSMutableArray *hotelOrderBuilderList;
@property (retain, nonatomic) NSMutableArray *hotelOrderList;
@property (retain, nonatomic) AirOrder_Builder *goAirOrderBuiler;
@property (retain, nonatomic) AirOrder_Builder *backAirOrderBuiler;

@property (retain, nonatomic) NSIndexPath *currentIndexPath;
@property (assign, nonatomic) int currentDateTag;
@property (retain, nonatomic) NSMutableArray *sectionStat;
@property (assign, nonatomic) AirType airType;
@property (retain, nonatomic) AirHotelManager *manager;

@end

@implementation AirHotelController
@synthesize hotelOrderBuilderList = _hotelOrderBuilderList;
@synthesize hotelOrderList = _hotelOrderList;
@synthesize goAirOrderBuiler = _goAirOrderBuiler;
@synthesize backAirOrderBuiler = _backAirOrderBuiler;

@synthesize currentIndexPath = _currentIndexPath;
@synthesize currentDateTag = _currentDateTag;
@synthesize airType = _airType;
@synthesize manager = _manager;

- (void)dealloc {
    [_hotelOrderBuilderList release];
    [_hotelOrderList release];
    [_goAirOrderBuiler release];
    [_backAirOrderBuiler release];
    
    [_currentIndexPath release];
    [_sectionStat release];
    [_manager release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.goAirOrderBuiler = [[[AirOrder_Builder alloc] init] autorelease];
        self.backAirOrderBuiler = [[[AirOrder_Builder alloc] init] autorelease];
        
        self.manager = [AirHotelManager defaultManager];
        self.hotelOrderBuilderList = [[[NSMutableArray alloc] init] autorelease];
        HotelOrder_Builder *builder = [_manager createDefaultHotelOrderBuilder];
        [_hotelOrderBuilderList addObject:builder];
        
        self.sectionStat = [[[NSMutableArray alloc] init] autorelease];
        self.airType = AirGoAndBack;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];
    self.navigationItem.title = NSLS(@"机+酒");
    
    [self updateSectionStatWithSectionCount:1+[_hotelOrderBuilderList count]];
}

- (void)updateSectionStatWithSectionCount:(int)sectionCount
{
    [_sectionStat removeAllObjects];
    for (int i = 0; i < sectionCount; i++) {
        [_sectionStat addObject:[NSNumber numberWithBool:YES]];
    }
}

- (BOOL)isSectionOpen:(NSInteger)section
{
    if ([_sectionStat count] > section) {
        return [[_sectionStat objectAtIndex:section] boolValue];
    }
    
    return NO;
}

- (void)setSection:(NSInteger)section Open:(BOOL)open
{
    if ([_sectionStat count] > section) {
        [_sectionStat removeObjectAtIndex:section];
        NSNumber *num = [NSNumber numberWithBool:open];
        [_sectionStat insertObject:num atIndex:section];
        
        [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }
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
    
    if (_hotelOrderList) {
        self.hotelOrderBuilderList = [NSMutableArray arrayWithArray: [_manager hotelOrderBuilderListFromOrderList:_hotelOrderList]] ;
    }
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



#define SECTION_AIR     0


#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_AIR) {
        if (_airType == AirGoAndBack) {
            return [MakeAirOrderTwoCell getCellHeight];
        } else {
            return [MakeAirOrderOneCell getCellHeight];
        }
    }  else {
        return [MakeHotelOrderCell getCellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_AIR) {
        return [MakeOrderHeader getHeaderViewHeight];
    } else {
        return [MakeOrderHeader getHeaderViewHeight];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MakeOrderHeader *header = [MakeOrderHeader createHeaderView];;
    if (section == SECTION_AIR) {
        [header setViewWithDelegate:self
                            section:section
                 airHotelHeaderType:AirHeader
                 isHideFilterButton:NO
                selectedButtonIndex:_airType
                  isHideCloseButton:NO
                            isClose:![self isSectionOpen:section]];
    } else {
        [header setViewWithDelegate:self
                            section:section
                 airHotelHeaderType:HotelHeader
                 isHideFilterButton:YES
                selectedButtonIndex:AirNone
                  isHideCloseButton:NO
                            isClose:![self isSectionOpen:section]];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    return footer;
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + [_hotelOrderBuilderList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 * [[_sectionStat objectAtIndex:section] boolValue];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_AIR) {
        
        if (_airType == AirGoAndBack) {
            NSString *identifier = [MakeAirOrderTwoCell getCellIdentifier];
            MakeAirOrderTwoCell *cell = (MakeAirOrderTwoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [MakeAirOrderTwoCell createCell:self];
            }
            return cell;
        } else {
            NSString *identifier = [MakeAirOrderOneCell getCellIdentifier];
            MakeAirOrderOneCell *cell = (MakeAirOrderOneCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [MakeAirOrderOneCell createCell:self];
            }
            [cell setCellWithType:_airType];
            
            return cell;
        }

        
    }  else {
        NSString *identifier = [MakeHotelOrderCell getCellIdentifier];
        MakeHotelOrderCell *cell = (MakeHotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [MakeHotelOrderCell createCell:self];
        }
        
        HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:indexPath.row];
        [cell setCellByHotelOrder:builder indexPath:indexPath];
        
        return cell;
    }
}

- (IBAction)clickMemberButton:(id)sender {
//    AirHotelOrder_Builder *builder = [[[AirHotelOrder_Builder alloc] init] autorelease];
//    self.hotelOrderList = [NSMutableArray arrayWithArray: [_manager hotelOrderListFromBuilderList:_hotelOrderBuilderList]] ;
//    [builder addAllAirOrders:_hotelOrderList];
//    
//    ConfirmOrderController *controller = [[[ConfirmOrderController alloc] initWithOrderBuilder:builder] autorelease];
    
    ConfirmOrderController *controller = [[[ConfirmOrderController alloc] initWithOrderBuilder:nil] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
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
    self.currentIndexPath = indexPath;
    
    HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:indexPath.row];
    NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970:builder.checkInDate];
    NSDate *checkOutDate = [NSDate dateWithTimeIntervalSince1970:builder.checkOutDate];
    
    SelectHotelController *controller =[[[SelectHotelController alloc] initWithCheckInDate:checkInDate checkOutDate:checkOutDate delegate:self] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma CommonMonthControllerDelegate methods
- (void)didSelectDate:(NSDate *)date
{
    if (_currentDateTag == GO_DATE) {

    }
    
    if (_currentIndexPath.section > SECTION_AIR) {
        HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:_currentIndexPath.row];
        
        if (_currentDateTag == CHECK_IN_DATE) {
            [builder setCheckInDate:[date timeIntervalSince1970]];
        } else if (_currentDateTag == CHECK_OUT_DATE) {
            [builder setCheckOutDate:[date timeIntervalSince1970]];
        }
        
        [dataTableView reloadData];
    }
}

#pragma mark -
#pragma SelectHotelControllerDelegate methods
- (void)didClickFinish:(Place *)hotel roomInfos:(NSArray *)roomInfos
{
    HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:_currentIndexPath.row];
    [builder setHotelId:hotel.placeId];
    [builder setHotel:hotel];
    [builder clearRoomInfosList];
    [builder addAllRoomInfos:roomInfos];
    
    
    [dataTableView reloadData];
}

#pragma mark -
#pragma MakeOrderHeaderDelegate methods
- (void)didClickCloseButton:(NSInteger)section
{
    BOOL isOpen = [self isSectionOpen:section];
    [self setSection:section Open:!isOpen];
}

- (void)didClickGoButton
{
    _airType = AirGo;
    [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didClickGoAndBackButton
{
    _airType = AirGoAndBack;
    [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didClickBackButton
{
    _airType = AirBack;
    [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -
#pragma MakeAirOrderCellDelegate methods
- (void)didClickDepartCityButton
{
    SelectAirCityController *controller = [[[SelectAirCityController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickGoDateButton
{
    self.currentDateTag = GO_DATE;
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self monthCount:12 title:NSLS(@"入住日期")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickBackDateButton
{
    self.currentDateTag = BACK_DATE;
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self monthCount:12 title:NSLS(@"入住日期")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickGoFlightButton
{
    SelectFlightController *controller = [[[SelectFlightController alloc] initWithTitle:NSLS(@"去程航班")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickBackFlightButton
{
    
}


@end
