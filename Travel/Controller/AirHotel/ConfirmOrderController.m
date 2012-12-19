//
//  ConfirmOrderController.m
//  Travel
//
//  Created by haodong on 12-11-26.
//
//

#import "ConfirmOrderController.h"
#import "FontSize.h"
#import "AirHotel.pb.h"
#import "MakeOrderHeader.h"
#import "AirHotelManager.h"
#import "UserManager.h"

@interface ConfirmOrderController ()

@property (retain, nonatomic) AirHotelOrder_Builder *airHotelOrderBuilder;
@property (retain, nonatomic) NSArray *airOrderBuilders;
@property (retain, nonatomic) NSArray *hotelOrderBuilders;
@property (retain, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation ConfirmOrderController

- (void)dealloc
{
    [_airHotelOrderBuilder release];
    [_airOrderBuilders release];
    [_hotelOrderBuilders release];
    [_currentIndexPath release];
    [_contactPersonButton release];
    [_paymentButton release];
    [super dealloc];
}

- (id)initWithAirOrderBuilders:(NSArray *)airOrderBuilders
            hotelOrderBuilders:(NSArray *)hotelOrderBuilders
{
    self = [super init];
    if (self) {
        self.airHotelOrderBuilder = [[[AirHotelOrder_Builder alloc] init] autorelease];
        self.airOrderBuilders = airOrderBuilders;
        self.hotelOrderBuilders = hotelOrderBuilders;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"确认预订");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.view.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:239.0/255.0 blue:247.0/255.0 alpha:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (IBAction)clickOrderButton:(id)sender {
    NSArray *airOrderList = [[AirHotelManager defaultManager] airOrderListFromBuilderList:_airOrderBuilders];
    NSArray *hotelOrderList = [[AirHotelManager defaultManager] hotelOrderListFromBuilderList:_hotelOrderBuilders];
    
    [_airHotelOrderBuilder addAllAirOrders:airOrderList];
    [_airHotelOrderBuilder addAllHotelOrders:hotelOrderList];
    [_airHotelOrderBuilder setUserId:[[UserManager defaultManager] getUserId]];
    
    AirHotelOrder *order = [_airHotelOrderBuilder build];
    [[AirHotelService defaultService] order:order delegate:self];
}

#pragma mark - 
#pragma AirHotelServiceDelegate methods
- (void)orderDone:(int)result
       resultInfo:(NSString *)resultInfo
{
    PPDebug(@"orderDone result:%d, resultInfo:%@", result, resultInfo);
    
    if (result == 0) {
        [self popupMessage:NSLS(@"预订成功") title:nil];
    }
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.section < [[_builder airOrdersList] count]) {
    if (indexPath.section < [_airOrderBuilders count]) {
        return [ConfirmAirCell getCellHeight];
    } else {
        return [ConfirmHotelCell getCellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [MakeOrderHeader getHeaderViewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MakeOrderHeader *header = [MakeOrderHeader createHeaderView];
    if (section < [_airOrderBuilders count]) {
        [header setViewWithDelegate:nil
                            section:section
                 airHotelHeaderType:AirHeader
                 isHideFilterButton:YES
                selectedButtonIndex:0
                  isHideCloseButton:YES
                            isClose:YES];
    } else {
        [header setViewWithDelegate:nil
                            section:section
                 airHotelHeaderType:HotelHeader
                 isHideFilterButton:YES
                selectedButtonIndex:0
                  isHideCloseButton:YES
                            isClose:YES];
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
    return [_airOrderBuilders count] + [_hotelOrderBuilders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [_airOrderBuilders count]) {
        NSString *identifier = [ConfirmAirCell getCellIdentifier];
        ConfirmAirCell *cell = (ConfirmAirCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [ConfirmAirCell createCell:self];
        }
        return cell;
    } else{
        NSString *identifier = [ConfirmHotelCell getCellIdentifier];
        ConfirmHotelCell *cell = (ConfirmHotelCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [ConfirmHotelCell createCell:self];
        }
        
        HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [_airOrderBuilders count]];
        [cell setCellWith:builder indexPath:indexPath];
        return cell;
    }
}

- (IBAction)clickContactPersonButton:(id)sender {
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:PersonTypeContact isMultipleChoice:YES delegate:self title:NSLS(@"联系人选择")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickPaymentButton:(id)sender {
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:PersonTypeCreditCard isMultipleChoice:YES delegate:self title:NSLS(@"信用卡支付")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma ConfirmHotelCellDelegate method
- (void)didClickCheckInPersonButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:PersonTypeCheckIn isMultipleChoice:YES delegate:self title:NSLS(@"入住人选择")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma SelectPersonControllerDelegate method
- (void)finishSelectPerson:(PersonType)personType objectList:(NSArray *)objectList
{
    if (personType == PersonTypeContact) {
        Person *person = (Person *)[objectList objectAtIndex:0];
        [_airHotelOrderBuilder setContactPerson:person];
        
        [_contactPersonButton setTitle:person.name forState:UIControlStateNormal];
    } else if (personType == PersonTypeCreditCard) {
        CreditCard *creditCard = (CreditCard *)[objectList objectAtIndex:0];
        
        PaymentInfo_Builder *pib = [[[PaymentInfo_Builder alloc] init] autorelease];
        [pib setPaymentType:PaymentTypeCreditCard];
        [pib setCreditCard:creditCard];
        PaymentInfo *paymentInfo = [pib build];
        [_airHotelOrderBuilder setPaymentInfo:paymentInfo];
        
        [_paymentButton setTitle:creditCard.name forState:UIControlStateNormal];
    } else if (PersonTypeCheckIn) {
        HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:_currentIndexPath.section - [_airOrderBuilders count]];
        [builder addAllCheckInPersons:objectList];
    }
}

- (void)viewDidUnload {
    [self setContactPersonButton:nil];
    [self setPaymentButton:nil];
    [super viewDidUnload];
}
@end
