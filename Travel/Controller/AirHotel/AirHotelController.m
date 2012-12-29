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
#import "AirHotelManager.h"
#import "UserManager.h"
#import "LoginController.h"
#import "CommonWebController.h"

enum HOTEL_FLIGHT_DATE_TAG{
    GO_DATE = 0,
    BACK_DATE = 1,
    CHECK_IN_DATE = 2,
    CHECK_OUT_DATE = 3,
};

@interface AirHotelController ()

@property (retain, nonatomic) NSMutableArray *hotelOrderBuilderList;
@property (retain, nonatomic) NSMutableArray *airOrderBuilderList;
@property (retain, nonatomic) AirOrder_Builder *goAirOrderBuiler;
@property (retain, nonatomic) AirOrder_Builder *backAirOrderBuiler;

@property (retain, nonatomic) NSIndexPath *currentIndexPath;
@property (assign, nonatomic) int currentDateTag;
@property (retain, nonatomic) NSMutableArray *sectionStat;
@property (assign, nonatomic) AirType airType;
@property (retain, nonatomic) AirHotelManager *manager;

@property (retain, nonatomic) AirCity *departCity;

@end

@implementation AirHotelController

- (void)dealloc {
    [_hotelOrderBuilderList release];
    [_airOrderBuilderList release];
    [_goAirOrderBuiler release];
    [_backAirOrderBuiler release];
    
    [_currentIndexPath release];
    [_sectionStat release];
    [_manager release];
    
    [_departCity release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.manager = [AirHotelManager defaultManager];
        self.airOrderBuilderList = [[[NSMutableArray alloc] init] autorelease];
        self.hotelOrderBuilderList = [[[NSMutableArray alloc] init] autorelease];
        
        [self createDefaultData];
        self.sectionStat = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];
    self.navigationItem.title = NSLS(@"机+酒");
    
    [self changeAirType:AirGoAndBack];
    
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


- (void)createDefaultData
{
    if ([_hotelOrderBuilderList count] == 0) {
        HotelOrder_Builder *builder = [_manager createDefaultHotelOrderBuilder];
        [_hotelOrderBuilderList addObject:builder];
    }
    
    if ([_airOrderBuilderList count] == 0) {
        AirOrder_Builder *builder1 = [_manager createDefaultAirOrderBuilder];
        AirOrder_Builder *builder2 = [_manager createDefaultAirOrderBuilder];
        [_airOrderBuilderList addObject:builder1];
        [_airOrderBuilderList addObject:builder2];
    }
    
    if ([_airOrderBuilderList count] == 1) {
        AirOrder_Builder *builder1 = [_airOrderBuilderList objectAtIndex:0];
        AirOrder_Builder *builder2 = [_manager createDefaultAirOrderBuilder];
        
        if (builder1.flightType == FlightTypeGo || builder1.flightType == FlightTypeGoOfDouble){
            [_airOrderBuilderList insertObject:builder2 atIndex:0];
        } else{
            [_airOrderBuilderList addObject:builder2];
        }
    }
    
    self.goAirOrderBuiler = [_airOrderBuilderList objectAtIndex:0];
    self.backAirOrderBuiler = [_airOrderBuilderList objectAtIndex:1];
    
    [self updateAirTypeToBuilder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillAppear:animated];
    
    [self createTitleView:NSLS(@"机+酒")];
    
    [self createDefaultData];
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


- (void)updateAirTypeToBuilder
{
    if (_airType == AirGo) {
        [_goAirOrderBuiler setFlightType:FlightTypeGo];
    } else if (_airType == AirGoAndBack) {
        [_goAirOrderBuiler setFlightType:FlightTypeGoOfDouble];
        [_backAirOrderBuiler setFlightType:FlightTypeBackOfDouble];
    } else if (_airType == AirBack) {
        [_backAirOrderBuiler setFlightType:FlightTypeBack];
    }
}

- (void)changeAirType:(AirType)airType
{
    if (_airType != airType) {
        _airType = airType;
        
        [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self updateAirTypeToBuilder];
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
                            isClose:![self isSectionOpen:section]
                 isHideDeleteButton:YES];
    } else {
        BOOL isHideDelete = ([_hotelOrderBuilderList count] > 1 ? NO : YES );
        
        [header setViewWithDelegate:self
                            section:section
                 airHotelHeaderType:HotelHeader
                 isHideFilterButton:YES
                selectedButtonIndex:AirNone
                  isHideCloseButton:!isHideDelete
                            isClose:![self isSectionOpen:section]
                 isHideDeleteButton:isHideDelete];
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
            [cell setCellByDepartCityName:_departCity.cityName goBuilder:_goAirOrderBuiler backBuilder:_backAirOrderBuiler];
            
            return cell;
        } else {
            NSString *identifier = [MakeAirOrderOneCell getCellIdentifier];
            MakeAirOrderOneCell *cell = (MakeAirOrderOneCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [MakeAirOrderOneCell createCell:self];
            }
            
            
            if (_airType == AirGo) {
                [cell setCellWithType:_airType departCityName:_departCity.cityName builder:_goAirOrderBuiler];
            } else if (_airType == AirBack) {
                [cell setCellWithType:_airType departCityName:_departCity.cityName builder:_backAirOrderBuiler];
            }
            
            
            return cell;
        }
        
    }  else {
        NSString *identifier = [MakeHotelOrderCell getCellIdentifier];
        MakeHotelOrderCell *cell = (MakeHotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [MakeHotelOrderCell createCell:self];
        }
        
        HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:indexPath.section - 1];
        [cell setCellByHotelOrder:builder indexPath:indexPath];
        
        return cell;
    }
}


- (void)order:(BOOL)isMember
{
    AirHotelManager *manager = [AirHotelManager defaultManager];
    
    if (_airType == AirGo) {
        [_airOrderBuilderList removeObject:_backAirOrderBuiler];
    } else if (_airType == AirBack) {
        [_airOrderBuilderList removeObject:_goAirOrderBuiler];
    } 
    
    self.airOrderBuilderList = [NSMutableArray arrayWithArray:[manager validAirOrderBuilders:_airOrderBuilderList]];
    self.hotelOrderBuilderList = [NSMutableArray arrayWithArray:[manager validHotelOrderBuilders:_hotelOrderBuilderList]];
    
    
    ConfirmOrderController *controller = [[[ConfirmOrderController alloc] initWithAirOrderBuilders:_airOrderBuilderList hotelOrderBuilders:_hotelOrderBuilderList isMember:isMember] autorelease];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickNonMemberButton:(id)sender {
    [self order:NO];
}

- (IBAction)clickMemberButton:(id)sender {
    
    if (![[UserManager defaultManager] isLogin]) {
        LoginController *controller = [[LoginController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        return;
    }
    
    [self order:YES];
}

- (IBAction)clickAddHotelButton:(id)sender {
    HotelOrder_Builder *builder = [_manager createDefaultHotelOrderBuilder];
    [_hotelOrderBuilderList addObject:builder];
    [self updateSectionStatWithSectionCount:1+[_hotelOrderBuilderList count]];
    
    [dataTableView reloadData];
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
    if (![builder hasCheckInDate]) {
        [self popupMessage:@"未选择入住时间" title:nil];
        return;
    }
    
    if (![builder hasCheckOutDate]) {
        [self popupMessage:@"未选择退房时间" title:nil];
        return;
    }
    
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
        [_goAirOrderBuiler setFlightDate:[date timeIntervalSince1970]];
        return;
        
    } else if (_currentDateTag == BACK_DATE) {
        [_backAirOrderBuiler setFlightDate:[date timeIntervalSince1970]];
        return;
    }
    
    if (_currentIndexPath.section > SECTION_AIR) {
        HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:_currentIndexPath.row];
        
        if (_currentDateTag == CHECK_IN_DATE) {
            [builder setCheckInDate:[date timeIntervalSince1970]];
            PPDebug(@"didSelectDate:%d", builder.checkInDate);
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
    [self changeAirType:AirGo];
}

- (void)didClickGoAndBackButton
{
    [self changeAirType:AirGoAndBack];
}

- (void)didClickBackButton
{
    [self changeAirType:AirBack];
}

- (void)didClickDeleteButton:(NSInteger)section
{
    if (section > 0 ) {
        [_hotelOrderBuilderList removeObjectAtIndex:section - 1];
        [self updateSectionStatWithSectionCount:1+[_hotelOrderBuilderList count]];
        [dataTableView reloadData];
    }
}

#pragma mark -
#pragma MakeAirOrderCellDelegate methods
- (void)didClickDepartCityButton
{
    BOOL hasSelected;
    if (_departCity == nil) {
        hasSelected = NO;
    } else {
        hasSelected = YES;
    }
    
    SelectAirCityController *controller = [[SelectAirCityController alloc] initWithDelegate:self hasSelected:hasSelected selectedCityId:_departCity.cityId];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didClickGoDateButton
{
    self.currentDateTag = GO_DATE;
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self monthCount:12 title:NSLS(@"出发日期")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickBackDateButton
{
    self.currentDateTag = BACK_DATE;
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self monthCount:12 title:NSLS(@"回程日期")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickGoFlightButton
{
    if (_departCity == nil) {
        [self popupHappyMessage:NSLS(@"请选择出发城市") title:nil];
        return;
    }
    
    if (_goAirOrderBuiler.flightDate == 0) {
        [self popupHappyMessage:NSLS(@"请选择出发日期") title:nil];
        return;
    }
    
    NSDate *flightDate = [NSDate dateWithTimeIntervalSince1970:_goAirOrderBuiler.flightDate];
    FlightType flightType;
    if (_airType == AirGoAndBack) {
        flightType = FlightTypeGoOfDouble;
    } else {
        flightType = FlightTypeGo;
    }
    
    int destinationCityId = [[AppManager defaultManager] getCurrentCityId];
    SelectFlightController *controller = [[SelectFlightController alloc] initWithDepartCityId:_departCity.cityId destinationCityId:destinationCityId flightDate:flightDate flightType:flightType flightNumber:nil delegate:self];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didClickBackFlightButton
{
    if (_departCity == nil) {
        [self popupHappyMessage:NSLS(@"请选择出发城市") title:nil];
        return;
    }
    
    if (_backAirOrderBuiler.flightDate == 0) {
        [self popupHappyMessage:NSLS(@"请选择回程日期") title:nil];
        return;
    }
    
    if (_airType == AirGoAndBack ) {
        if (_goAirOrderBuiler.flightNumber == nil)
        {
            PPDebug(@"请选择去程航班");
            [self popupHappyMessage:NSLS(@"请选择去程航班") title:nil];
            return;
        }
    }
    
    NSDate *flightDate = [NSDate dateWithTimeIntervalSince1970:_backAirOrderBuiler.flightDate];
    FlightType flightType;
    if (_airType == AirGoAndBack) {
        flightType = FlightTypeBackOfDouble;
    } else {
        flightType = FlightTypeBack;
    }
    
    
    int destinationCityId = [[AppManager defaultManager] getCurrentCityId];
    
    SelectFlightController *controller = [[SelectFlightController alloc] initWithDepartCityId:_departCity.cityId destinationCityId:destinationCityId flightDate:flightDate flightType:flightType flightNumber:_goAirOrderBuiler.flightNumber delegate:self];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma SelectAirCityControllerDelegate methods
- (void)didSelectCity:(AirCity *)city
{
    self.departCity = city;
}

#pragma mark -
#pragma FlightDetailControllerDelegate method
- (void)didClickSelect:(Flight *)flight
       flightSeatIndex:(int)flightSeatIndex
            flightType:(FlightType)flightType
{
    FlightSeat *seat = [flight.flightSeatsList objectAtIndex:flightSeatIndex];
    
    if (flightType == FlightTypeGo || flightType == FlightTypeGoOfDouble) {
        [_goAirOrderBuiler setFlight:flight];
        [_goAirOrderBuiler setFlightSeat:seat];
        
        [_goAirOrderBuiler setFlightNumber:flight.flightNumber];
        [_goAirOrderBuiler setFlightSeatCode:seat.code];
    } else {
        [_backAirOrderBuiler setFlight:flight];
        [_backAirOrderBuiler setFlightSeat:seat];
        
        [_backAirOrderBuiler setFlightNumber:flight.flightNumber];
        [_backAirOrderBuiler setFlightSeatCode:seat.code];
    }
    
    [dataTableView reloadData];
}

- (IBAction)clickBookNoteButton:(id)sender {
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:[[AppManager defaultManager] getAirHotelBookingNotice]];
    controller.title = @"预订说明";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}


- (IBAction)clickCustomerServiceTelephone:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"是否拨打以下电话") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for(NSString* title in [[AppManager defaultManager] getServicePhoneList]){
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:NSLS(@"返回")];
    [actionSheet setCancelButtonIndex:[[[AppManager defaultManager] getServicePhoneList] count]];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    NSString *phone = [[[AppManager defaultManager] getServicePhoneList] objectAtIndex:buttonIndex];
    //    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [UIUtils makeCall:phone];
}

@end
