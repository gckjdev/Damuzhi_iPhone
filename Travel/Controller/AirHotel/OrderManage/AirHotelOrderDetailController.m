//
//  AirHotelOrderDetailController.m
//  Travel
//
//  Created by haodong on 12-12-27.
//
//

#import "AirHotelOrderDetailController.h"
#import "AirHotelOrderDetailTopCell.h"
#import "AirOrderDetailCell.h"
#import "HotelOrderDetailCell.h"
#import "AirHotel.pb.h"
#import "FontSize.h"
#import "PlaceService.h"
#import "CommonPlaceDetailController.h"

@interface AirHotelOrderDetailController ()
@property (retain, nonatomic) AirHotelOrder *airHotelOrder;
@end

@implementation AirHotelOrderDetailController

- (void)dealloc
{
    [_airHotelOrder release];
    [super dealloc];
}

- (id)initWithOrder:(AirHotelOrder *)airHotelOrder
{
    self = [super init];
    if (self) {
        self.airHotelOrder = airHotelOrder;
    }
    return self;
}

#define MARK_TOP_SECTON     @"top"
#define MARK_AIR_SECTION    @"air"
#define MARK_HOTEL_SECTION  @"hotel"

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"机+酒订单");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.view.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:239.0/255.0 blue:247.0/255.0 alpha:1];
    
    //set dataList
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    [mutableArray addObject:MARK_TOP_SECTON];
    if ([self hasAir:_airHotelOrder]) {
        [mutableArray addObject:MARK_TOP_SECTON];
    }
    if ([self hasHotel:_airHotelOrder]) {
        [mutableArray addObject:MARK_HOTEL_SECTION];
    }
    self.dataList = mutableArray;
}

- (BOOL)hasAir:(AirHotelOrder *)order
{
    if ([[order airOrdersList] count] > 0)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)hasHotel:(AirHotelOrder *)order
{
    if ([[order hotelOrdersList] count] > 0)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark = [dataList objectAtIndex:indexPath.row];
    if ([mark isEqualToString:MARK_TOP_SECTON]) {
        NSString *identifier = [AirHotelOrderDetailTopCell getCellIdentifier];
        AirHotelOrderDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [AirHotelOrderDetailTopCell createCell:self];
        }
        [cell setCellWithOrder:_airHotelOrder];
        return cell;
    }
    
    else if ([mark isEqualToString:MARK_AIR_SECTION]){
        NSString *identifier = [AirOrderDetailCell getCellIdentifier];
        AirOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [AirOrderDetailCell createCell:self];
        }
        [cell setCellWithOrther:_airHotelOrder];
        return cell;
    }
    
    else if ([mark isEqualToString:MARK_HOTEL_SECTION]){
        NSString *identifier = [HotelOrderDetailCell getCellIdentifier];
        HotelOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [HotelOrderDetailCell createCell:self];
        }
        [cell setCellWithOrther:_airHotelOrder];
        return cell;
    }
    
    return nil;
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark = [dataList objectAtIndex:indexPath.row];
    if ([mark isEqualToString:MARK_TOP_SECTON]) {
        return [AirHotelOrderDetailTopCell getCellHeight:_airHotelOrder] + 10;
    }
    
    else if ([mark isEqualToString:MARK_AIR_SECTION]){
        return [AirOrderDetailCell getCellHeight] + 10;
    }
    
    else if ([mark isEqualToString:MARK_HOTEL_SECTION]){
        return [HotelOrderDetailCell getCellHeight:_airHotelOrder] + 10;
    }
    
    return 0;
}

#pragma mark -
#pragma OrderHotelViewDelegate method
- (void)didClickHotelButton:(int)hotelId
{
    [self showActivityWithText:NSLS(@"数据加载中...")];
    [[PlaceService defaultService] findPlace:hotelId viewController:self];
}


- (void)findRequestDone:(int)resultCode
                 result:(int)result
             resultInfo:(NSString *)resultInfo
                  place:(Place *)place
{
    [self hideActivity];
    if (resultCode != 0) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    if (result != 0) {
        [self popupMessage:resultInfo title:nil];
        return;
    }
    
    CommonPlaceDetailController *controller = [[[CommonPlaceDetailController alloc] initWithPlace:place] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
