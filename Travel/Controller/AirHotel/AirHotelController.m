//
//  AirHotelController.m
//  Travel
//
//  Created by kaibin on 12-9-21.
//
//  变量说明：
//  机票订单保存在airOrderBuilderList
//  goAirOrderBuiler是指向airOrderBuilderList中的去程航班
//  backAirOrderBuiler指向airOrderBuilderList中的回程航班
//

#import "AirHotelController.h"
#import "AppDelegate.h"
#import "AirHotel.pb.h"
#import "ConfirmOrderController.h"
#import "AirHotelManager.h"
#import "SelectCityController.h"
#import "AppManager.h"
#import "UserManager.h"
#import "CommonWebController.h"
#import "TravelLoadingView.h"

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
@property (retain, nonatomic) TravelLoadingView *travelLoadingView;

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
    [_memberButton release];
    [_nonMemberButton release];
    [_tipsView release];
    [_travelLoadingView release];
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
        
        self.travelLoadingView = [TravelLoadingView createTravelLoadingView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];
    
    [self clickGoAndBackButton:nil];
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
    [self setMemberButton:nil];
    [self setNonMemberButton:nil];
    [self setTipsView:nil];
    [super viewDidUnload];
}

- (void)hideTabBar:(BOOL)isHide
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:isHide];
}

//创建默认数据
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
        
        if (builder1.flightType == FlightTypeBack || builder1.flightType == FlightTypeBackOfDouble){
            [_airOrderBuilderList insertObject:builder2 atIndex:0];
        } else{
            [_airOrderBuilderList addObject:builder2];
        }
    }
    
    self.goAirOrderBuiler = [_airOrderBuilderList objectAtIndex:0];
    self.backAirOrderBuiler = [_airOrderBuilderList objectAtIndex:1];
    
    [self updateAirTypeToBuilder];
    
    [self setDefaultFlightDate];
}

- (void)setDefaultFlightDate
{
    if ([_goAirOrderBuiler hasFlightDate] == NO) {
        [_goAirOrderBuiler setFlightDate:[[NSDate date] timeIntervalSince1970] + 24 * 60 * 60];
    }
    
    if ([_backAirOrderBuiler hasFlightDate] == NO) {
        [_backAirOrderBuiler setFlightDate:[[NSDate date] timeIntervalSince1970] + 2 * 24 * 60 * 60];
    }
}

- (void)setDefaultDepartCity
{
    if (_departCity == nil) {
        NSString *currentCityName = [[AppService defaultService] currentCityChineseName];
        CLLocation *userCurrentLocation = [[AppService defaultService] currentLocation];
        
        self.departCity = [_manager getDefaultDepartCity:currentCityName latitude:userCurrentLocation.coordinate.latitude longitude:userCurrentLocation.coordinate.longitude];
    }
}

#define MEMBER_BUTTON_FRAME CGRectMake(26, 8, 121, 38)
#define MEMBER_BUTTON_CENTER_FRAME CGRectMake(100, 8, 121, 38)

- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillAppear:animated];
    
    [self createTitleView:NSLS(@"机票")];
    [self createDefaultData];
    
    if ([[UserManager defaultManager] isLogin]) {
        self.nonMemberButton.hidden = YES;
        self.memberButton.frame = MEMBER_BUTTON_CENTER_FRAME;
    } else {
        self.nonMemberButton.hidden = NO;
        self.memberButton.frame = MEMBER_BUTTON_FRAME;
    }
    
    if ([[AppManager defaultManager] getCurrentCity].hasAirport == NO) {
        self.tipsView.hidden = NO;
    } else {
        self.tipsView.hidden = YES;
    }
    
    [self setDefaultDepartCity];
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
        [self.dataTableView reloadData];
    }
    
    [self updateAirTypeToBuilder];
}

#pragma mark -
- (void)currentCityDidChange:(int)newCityId
{
    for (AirOrder_Builder *builder in _airOrderBuilderList) {
        [_manager clearAirOrderBuilder:builder];
    }
    
    for (HotelOrder_Builder *builder in _hotelOrderBuilderList) {
        [_manager clearHotelOrderBuilder:builder];
    }
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setSeletedTabbarIndex:0];
}

#pragma mark -
#pragma UITableViewDelegate methods
#define SECTION_AIR     0
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == SECTION_AIR) {
//        return [MakeOrderHeader getHeaderViewHeight];
//    } else {
//        return [MakeOrderHeader getHeaderViewHeight];
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    MakeOrderHeader *header = [MakeOrderHeader createHeaderView];;
//    if (section == SECTION_AIR) {
//        [header setViewWithDelegate:self
//                            section:section
//                 airHotelHeaderType:AirHeader
//                 isHideFilterButton:NO
//                selectedButtonIndex:_airType
//                  isHideCloseButton:NO
//                            isClose:![self isSectionOpen:section]
//                 isHideDeleteButton:YES];
//    } else {
//        BOOL isHideDelete = ([_hotelOrderBuilderList count] > 1 ? NO : YES );
//        
//        [header setViewWithDelegate:self
//                            section:section
//                 airHotelHeaderType:HotelHeader
//                 isHideFilterButton:YES
//                selectedButtonIndex:AirNone
//                  isHideCloseButton:!isHideDelete
//                            isClose:![self isSectionOpen:section]
//                 isHideDeleteButton:isHideDelete];
//    }
//    
//    return header;
//}

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 * [self isSectionOpen:section];
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

- (BOOL)isCanOrder
{
    //取出有效的订单
    NSArray *validAirList = nil;
    if (_airType == AirGo) {
        validAirList = [_manager validAirOrderBuilders:[NSArray arrayWithObject:_goAirOrderBuiler]];
    } else if (_airType == AirBack) {
        validAirList = [_manager validAirOrderBuilders:[NSArray arrayWithObject:_backAirOrderBuiler]];
    } else {
        validAirList = [_manager validAirOrderBuilders:_airOrderBuilderList];
    }
    NSArray *validHotelList = [_manager validHotelOrderBuilders:_hotelOrderBuilderList];
    if ([validAirList count] == 0 && [validHotelList count] == 0) {
        [self popupMessage:NSLS(@"请先选择机票") title:nil];
        return NO;
    } else {
        self.airOrderBuilderList = [NSMutableArray arrayWithArray:validAirList];
        self.hotelOrderBuilderList = [NSMutableArray arrayWithArray:validHotelList];
        return YES;
    }
}

- (void)order:(BOOL)isMember
{
    ConfirmOrderController *controller = [[[ConfirmOrderController alloc] initWithAirOrderBuilders:_airOrderBuilderList hotelOrderBuilders:_hotelOrderBuilderList departCityId:_departCity.cityId isMember:isMember] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickNonMemberButton:(id)sender {
    if ([self isCanOrder]) {
        [self order:NO];
    }
}

- (IBAction)clickMemberButton:(id)sender {
    if ([self isCanOrder]) {
        if (![[UserManager defaultManager] isLogin]) {
            LoginController *controller = [[LoginController alloc] init];
            controller.delegate = self;
            controller.isAutoPop = NO;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } else {
            [self order:YES];
        }
    }
}

- (IBAction)clickAddHotelButton:(id)sender {
    HotelOrder_Builder *builder = [_manager createDefaultHotelOrderBuilder];
    [_hotelOrderBuilderList addObject:builder];
    [self updateSectionStatWithSectionCount:1+[_hotelOrderBuilderList count]];
    
    [dataTableView reloadData];
}

- (NSDate *)getGoDate
{
    if ([_goAirOrderBuiler hasFlightDate]) {
        return [NSDate dateWithTimeIntervalSince1970:_goAirOrderBuiler.flightDate];
    }
    return nil;
}

- (NSDate *)getBackDate
{
    if ([_backAirOrderBuiler hasFlightDate]) {
        return [NSDate dateWithTimeIntervalSince1970:_backAirOrderBuiler.flightDate];
    }
    return nil;
}

//获取最早的入住时间
- (NSDate *)getCheckInDate
{
    int timeInterval = 0;
    for (HotelOrder_Builder *builder in _hotelOrderBuilderList) {
        if (timeInterval == 0 && [builder hasCheckInDate]) {
            timeInterval = builder.checkInDate;
        }
        
        if (builder.checkInDate < timeInterval ) {
            timeInterval = builder.checkInDate;
        }
    }
    
    if (timeInterval > 0) {
        return [NSDate dateWithTimeIntervalSince1970:timeInterval];
    } else{
        return nil;
    }
}

//获取最迟的退房时间
- (NSDate *)getCheckOutDate
{
    int timeInterval = 0;
    for (HotelOrder_Builder *builder in _hotelOrderBuilderList) {
        if (timeInterval == 0 && [builder hasCheckOutDate]) {
            timeInterval = builder.checkOutDate;
        }
        
        if (builder.hasCheckOutDate > timeInterval ) {
            timeInterval = builder.checkOutDate;
        }
    }
    
    if (timeInterval > 0) {
        return [NSDate dateWithTimeIntervalSince1970:timeInterval];
    } else{
        return nil;
    }
}

- (NSDate *)maxDate:(NSArray *)dateList
{
    if ([dateList count] == 0) {
        return nil;
    }
    
    NSDate *maxDate = [dateList objectAtIndex:0];
    
    for (NSDate *oneDate in dateList) {
        if ([maxDate compare:oneDate] == NSOrderedAscending) {
            maxDate = oneDate;
        }
    }
    
    return maxDate;
}

- (NSDate *)minDate:(NSArray *)dateList
{
    if ([dateList count] == 0) {
        return nil;
    }
    
    NSDate *minDate = [dateList objectAtIndex:0];
    for (NSDate *oneDate in dateList) {
        if ([minDate compare:oneDate] == NSOrderedDescending) {
            minDate = oneDate;
        }
    }
    
    return minDate;
}

#pragma mark -
#pragma MakeHotelOrderCellDelegate methods
- (void)didClickCheckInButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    self.currentDateTag = CHECK_IN_DATE;
    HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:indexPath.section - 1];
    
    //入住时间一定要在退房时间之前，超出去程和返程的时间段要给出提示
    NSDate *checkOutDate = (builder.hasCheckOutDate ? [NSDate dateWithTimeIntervalSince1970:builder.checkOutDate] : nil);
    NSDate *endDate = (builder.hasCheckOutDate ? [checkOutDate dateByAddingTimeInterval:-24 * 60 * 60]: nil);
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self customStartDate:nil customEndDate:endDate monthCount:12 title:NSLS(@"入住日期")] autorelease];
    controller.suggestStartDate = [self getGoDate];
    controller.suggestEndDate = [self getBackDate];
    controller.suggestStartTips = NSLS(@"确定入住日期要早于去程日期？");
    controller.suggestEndTips = NSLS(@"确定入住日期要迟于回程日期？");
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickCheckOutButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    self.currentDateTag = CHECK_OUT_DATE;
    HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:indexPath.section - 1];
    
    //退房时间一定要在入住时间之后，超出去程和返程的时间段要给出提示
    NSDate *checkInDate = (builder.hasCheckInDate ? [NSDate dateWithTimeIntervalSince1970:builder.checkInDate] : nil);
    NSDate *startDate = (builder.hasCheckInDate ? [checkInDate dateByAddingTimeInterval:24 * 60 * 60] : [NSDate dateWithTimeIntervalSinceNow:24*60*60]);
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self customStartDate:startDate customEndDate:nil monthCount:12 title:NSLS(@"退房日期")] autorelease];
    controller.suggestStartDate = [self getGoDate];
    controller.suggestEndDate = [self getBackDate];
    controller.suggestStartTips = NSLS(@"确定退房日期要早于去程日期？");
    controller.suggestEndTips = NSLS(@"确定退房日期要迟于回程日期？");
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickHotelButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:indexPath.section - 1];
    if (![builder hasCheckInDate]) {
        [self popupMessage:@"未选择入住时间" title:nil];
        return;
    }
    
    if (![builder hasCheckOutDate]) {
        [self popupMessage:@"未选择退房时间" title:nil];
        return;
    }
    
    SelectHotelController *controller =[[[SelectHotelController alloc] initWithHotelOrderBuilder:builder delegate:self] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma CommonMonthControllerDelegate methods
- (void)didSelectDate:(NSDate *)date
{
    if (_currentDateTag == GO_DATE) {
        if ([date timeIntervalSince1970] != _goAirOrderBuiler.flightDate) {
            [_manager clearFlight:_goAirOrderBuiler];
        }
        [_goAirOrderBuiler setFlightDate:[date timeIntervalSince1970]];
        
        if ([_backAirOrderBuiler hasFlightDate] && _backAirOrderBuiler.flightDate < _goAirOrderBuiler.flightDate) {
            [_backAirOrderBuiler setFlightDate:[date timeIntervalSince1970] + 24 * 60 * 60];
        }
        return;
        
    } else if (_currentDateTag == BACK_DATE) {
        if ([date timeIntervalSince1970] != _backAirOrderBuiler.flightDate) {
            [_manager clearFlight:_backAirOrderBuiler];
        }
        [_backAirOrderBuiler setFlightDate:[date timeIntervalSince1970]];
        return;
    }
    
    if (_currentIndexPath.section > SECTION_AIR) {
        HotelOrder_Builder *builder = [_hotelOrderBuilderList objectAtIndex:_currentIndexPath.section - 1];
        
        if (_currentDateTag == CHECK_IN_DATE) {
            
            if ([date timeIntervalSince1970] != builder.checkInDate) {
                [_manager clearHotel:builder];
            }
            [builder setCheckInDate:[date timeIntervalSince1970]];
            if ([builder hasCheckOutDate] && builder.checkOutDate < builder.checkInDate) {
                [builder setCheckOutDate:[date timeIntervalSince1970] + 24 * 60 * 60];
            }
            
        } else if (_currentDateTag == CHECK_OUT_DATE) {
            
            if ([date timeIntervalSince1970] != builder.checkOutDate) {
                [_manager clearHotel:builder];
            }
            [builder setCheckOutDate:[date timeIntervalSince1970]];
        }
        
        [dataTableView reloadData];
    }
}

#pragma mark -
#pragma SelectHotelControllerDelegate methods
- (void)didClickFinish:(Place *)hotel roomInfos:(NSArray *)roomInfos
{
    [dataTableView reloadData];
}

#pragma mark -
#pragma MakeOrderHeaderDelegate methods
//- (void)didClickCloseButton:(NSInteger)section
//{
//    BOOL isOpen = [self isSectionOpen:section];
//    [self setSection:section Open:!isOpen];
//}
//
//- (void)didClickGoButton
//{
//    [self changeAirType:AirGo];
//}
//
//- (void)didClickGoAndBackButton
//{
//    [self changeAirType:AirGoAndBack];
//}
//
//- (void)didClickBackButton
//{
//    [self changeAirType:AirBack];
//}
//
//- (void)didClickDeleteButton:(NSInteger)section
//{
//    if (section > 0 ) {
//        [_hotelOrderBuilderList removeObjectAtIndex:section - 1];
//        [self updateSectionStatWithSectionCount:1+[_hotelOrderBuilderList count]];
//        [dataTableView reloadData];
//    }
//}

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
    //去程时间必须在回程时间之前
    NSDate *checkInDate = [self getCheckInDate];
    NSDate *checkOutDate = [self getCheckOutDate];
    NSDate *suggestDate = nil;
    NSString *suggestTips = nil;
    if (checkInDate) {
        suggestDate = checkInDate;
        suggestTips = NSLS(@"确定去程日期在酒店入住日期之后？");
    } else if (checkOutDate) {
        suggestDate  = checkOutDate;
        suggestTips =  NSLS(@"确定去程日期在酒店退房日期之后？");
    }
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self customStartDate:nil customEndDate:nil monthCount:12 title:NSLS(@"出发日期")] autorelease];
    controller.suggestEndDate = suggestDate;
    controller.suggestEndTips = suggestTips;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickBackDateButton
{
    self.currentDateTag = BACK_DATE;
    //回程时间必须去程时间之后
    NSDate *checkInDate = [self getCheckInDate];
    NSDate *checkOutDate = [self getCheckOutDate];
    NSDate *suggestDate = nil;
    NSString *suggestTips = nil;
    if (checkOutDate) {
        suggestDate  = checkOutDate;
        suggestTips =  NSLS(@"确定回程日期要早于退房日期之前？");
    } else if (checkInDate) {
        suggestDate = checkInDate;
        suggestTips = NSLS(@"确定回程日期在酒店入住日期之前？");
    }
    
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:self customStartDate:[self getGoDate] customEndDate:nil monthCount:12 title:NSLS(@"回程日期")] autorelease];
    controller.suggestStartDate = suggestDate;
    controller.suggestStartTips = suggestTips;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickGoFlightButton
{
    if (_departCity == nil) {
        [self popupHappyMessage:NSLS(@"请选择出发城市") title:nil];
        return;
    }
    
    if ([_goAirOrderBuiler hasFlightDate] == NO) {
        [self popupHappyMessage:NSLS(@"请选择出发日期") title:nil];
        return;
    }
    
    if ([_departCity.cityName isEqualToString:[[AppManager defaultManager] getCurrentCityName]]) {
        [self popupHappyMessage:NSLS(@"出发城市和到达城市不能相同") title:nil];
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
    [_travelLoadingView showLoading:NSLS(@"正在加载航班信息...")];
    [[AirHotelService defaultService] findFlightsWithDepartCityId:_departCity.cityId
                                                destinationCityId:destinationCityId
                                                       departDate:flightDate
                                                       flightType:flightType
                                                     flightNumber:nil
                                                         delegate:self];
}

- (void)didClickBackFlightButton
{
    if (_departCity == nil) {
        [self popupHappyMessage:NSLS(@"请选择出发城市") title:nil];
        return;
    }
    
    if ([_backAirOrderBuiler hasFlightDate] == NO) {
        [self popupHappyMessage:NSLS(@"请选择回程日期") title:nil];
        return;
    }
    
    if (_airType == AirGoAndBack ) {
        if ([_goAirOrderBuiler hasFlightNumber] == NO)
        {
            [self popupHappyMessage:NSLS(@"请先选择去程航班") title:nil];
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
    [_travelLoadingView showLoading:NSLS(@"正在加载航班信息...")];
    [[AirHotelService defaultService] findFlightsWithDepartCityId:_departCity.cityId
                                                destinationCityId:destinationCityId
                                                       departDate:flightDate
                                                       flightType:flightType
                                                     flightNumber:nil
                                                         delegate:self];
}

//#define TAG_ACTIVITY_BACKGROUND_VIEW    2013032001
//- (void)addActivityBackgroundView
//{
//    UIView *bgView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
//    bgView.backgroundColor = [UIColor blackColor];
//    bgView.alpha = 0.5;
//    bgView.tag = TAG_ACTIVITY_BACKGROUND_VIEW;
//    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
//    [bgView release];
//}
//
//- (void)removeActivityBackgroundView
//{
//    UIView *bgView = [[UIApplication sharedApplication].keyWindow viewWithTag:TAG_ACTIVITY_BACKGROUND_VIEW];
//    [bgView removeFromSuperview];
//}

- (void)didClickClearDepartCity
{
    self.departCity = nil;
    [dataTableView reloadData];
}

- (void)didClickClearGoDate
{
    [_goAirOrderBuiler clearFlightDate];
    [dataTableView reloadData];
}

- (void)didClickClearBackDate
{
    [_backAirOrderBuiler clearFlightDate];
    [dataTableView reloadData];
}

- (void)didClickClearGoFlight
{
    [_goAirOrderBuiler clearFlight];
    [dataTableView reloadData];
}

- (void)didClickClearBackFlight
{
    [_backAirOrderBuiler clearFlight];
    [dataTableView reloadData];
}

#pragma mark -
#pragma SelectAirCityControllerDelegate methods
- (void)didSelectCity:(AirCity *)city
{
    if (_departCity.cityId != city.cityId) {
        for (AirOrder_Builder *builder in _airOrderBuilderList) {
            [_manager clearAirOrderBuilder:builder];
        }
        
        for (HotelOrder_Builder *builder in _hotelOrderBuilderList) {
            [_manager clearHotelOrderBuilder:builder];
        }
    }
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

#pragma mark -
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
    [UIUtils makeCall:phone];
}

#pragma mark -
#pragma mark LoginControllerDelegate methods
- (void)didLogin
{
    [self order:YES];
}


- (void)updateSelectedButton:(int)index
{
    for (int tag = 1; tag <= 3; tag ++) {
        UIButton *button = (UIButton *)[dataTableView.tableHeaderView viewWithTag:tag];
        if (tag == index) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
}

- (IBAction)clickGoButton:(id)sender {
    [self updateSelectedButton:1];
        [self changeAirType:AirGo];
}

- (IBAction)clickGoAndBackButton:(id)sender {
    [self updateSelectedButton:2];
    [self changeAirType:AirGoAndBack];
}

- (IBAction)clickBackButton:(id)sender {
    [self updateSelectedButton:3];
    [self changeAirType:AirBack];
}

- (IBAction)clickSwitchCityButton:(id)sender {
    [self clickTitleView:nil];
}

#pragma mark -
#pragma AirHotelServiceDelegate methods
- (void)findFlightsDone:(int)resultCode
                 result:(int)result
             resultInfo:(NSString *)resultInfo
             flightList:(NSArray *)flightList
             flightDate:(NSDate *)flightDate
             flightType:(int)flightType
{
    [_travelLoadingView hideLoading];
    if (_travelLoadingView.isClickCloseButton == YES) {
        return;
    }
    
    if (result == 0 ) {
        if ([flightList count] > 0) {
            if ([self.navigationController.topViewController isKindOfClass:[SelectFlightController class]]) {
                return;
            }
            
            int destinationCityId = [[AppManager defaultManager] getCurrentCityId];
            SelectFlightController *controller = [[SelectFlightController alloc] initWithDepartCityId:_departCity.cityId destinationCityId:destinationCityId flightDate:flightDate flightType:flightType flightNumber:_goAirOrderBuiler.flightNumber delegate:self flightList:flightList];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } else {
            [self popupMessage:NSLS(@"暂无可预订机票") title:nil];
        }
    } else {
        [self popupMessage:NSLS(@"网络弱，数据加载失败") title:nil];
    }
}

@end
