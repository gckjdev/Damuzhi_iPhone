//
//  SelectHotelController.m
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "SelectHotelController.h"
#import "Place.pb.h"
#import "HotelHeaderView.h"
#import "FontSize.h"
#import "AppManager.h"
#import "AirHotel.pb.h"

@interface SelectHotelController ()

@property (assign, nonatomic) id<SelectHotelControllerDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *hotelList;
@property (retain, nonatomic) NSMutableArray *viewsForSectionHeaders;
@property (retain, nonatomic) NSDate *checkInDate;
@property (retain, nonatomic) NSDate *checkOutDate;

@property (assign, nonatomic) NSInteger selectedSection;
@property (retain, nonatomic) NSMutableDictionary *roomInfoDic;

@end


#define EACH_COUNT  20

#define SELECTED_SECTION_NONE   -1

@implementation SelectHotelController
@synthesize delegate = _delegate;
@synthesize hotelList = _hotelList;
@synthesize viewsForSectionHeaders = _viewsForSectionHeaders;
@synthesize checkInDate = _checkInDate;
@synthesize checkOutDate = _checkOutDate;
@synthesize selectedSection = _selectedSection;
@synthesize roomInfoDic = _roomInfoDic;

- (void)dealloc
{
    [_hotelList release];
    [_viewsForSectionHeaders release];
    [_checkInDate release];
    [_checkOutDate release];
    [_roomInfoDic release];
    [super dealloc];
}


- (id)initWithCheckInDate:(NSDate *)checkInDate
             checkOutDate:(NSDate *)checkOutDate
                 delegate:(id<SelectHotelControllerDelegate>)delegate;
{
    self = [super init];
    if (self) {
        self.checkInDate = checkInDate;
        self.checkOutDate = checkOutDate;
        self.delegate = delegate;
        
        self.viewsForSectionHeaders = [[[NSMutableArray alloc] init] autorelease];
        self.roomInfoDic = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"酒店列表");
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"确定")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
    _selectedSection = SELECTED_SECTION_NONE;
    
    [self findHotels];
    
    //test data
//    [self testData];
//    [dataTableView reloadData];
}

- (void)clickFinish:(id)sender
{
    //TO DO
    if (_selectedSection == SELECTED_SECTION_NONE) {
        [self popupMessage:NSLS(@"没有选择酒店") title:nil];
        return;
    }
    
    if ([[_roomInfoDic allKeys] count] == 0) {
        return;
    }
    Place *hotel = [_hotelList objectAtIndex:_selectedSection];
    
    NSMutableArray *roomInfos = [[[NSMutableArray alloc] init] autorelease];
    NSArray *roomIds = [_roomInfoDic allKeys];
    for (NSString *roomId in roomIds) {
        NSNumber *count = [_roomInfoDic objectForKey:roomId];
        
        HotelOrderRoomInfo_Builder *builder= [[[HotelOrderRoomInfo_Builder alloc] init] autorelease];
        [builder setRoomId:[roomId intValue]];
        [builder setCount:[count intValue]];
        HotelOrderRoomInfo *roomInfo = [builder build];
        [roomInfos addObject:roomInfo];
    }
    
    if ([_delegate respondsToSelector:@selector(didClickFinish:roomInfos:)]) {
        [_delegate didClickFinish:hotel roomInfos:roomInfos];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)findHotels
{
    [[AirHotelService defaultService] findHotelsWithCityId:[[AppManager defaultManager] getCurrentCityId]
                                               checkInDate:_checkInDate
                                              checkOutDate:_checkOutDate
                                                     start:0
                                                     count:EACH_COUNT
                                                  delegate:self];
}


- (void)testData
{
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i =0 ; i < 30 ; i ++) {
        Place_Builder *builder = [[[Place_Builder alloc] init] autorelease];
        [builder setPlaceId:i];
        [builder setCategoryId:2];
        [builder setSubCategoryId:2];
        [builder setName:@"中国大酒店"];
        [builder setRank:3];
        [builder setLatitude:34.5];
        [builder setLongitude:113.7];
        [builder setIcon:@"http://"];
        [builder setIntroduction:@"Introduction"];
        
        NSMutableArray *roomArray = [[[NSMutableArray alloc] init] autorelease];
        for (int j = 0 ; j < 3; j ++) {
            HotelRoom_Builder *rBuilder = [[[HotelRoom_Builder alloc] init] autorelease];
            
            [rBuilder setRoomId:j];
            [rBuilder setName:@"标准间"];
            [rBuilder setBreakfast:@"有早餐"];
            [rBuilder setPrice:@"168"];
            
            HotelRoom *room = [rBuilder build];
            [roomArray addObject:room];
        }
        
        [builder addAllRooms:roomArray];
        
        Place *hotel = [builder build];
        [mutableArray addObject:hotel];
    }
    
    self.hotelList = mutableArray;
}



- (BOOL)isSelectedRoom:(int)roomId
{
    NSString *roomIdStr = [NSString stringWithFormat:@"%d", roomId];
    
    if ([_roomInfoDic objectForKey:roomIdStr]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)removeAllRooms
{
    [_roomInfoDic removeAllObjects];
}

- (void)removeRoomWith:(int)roomId
{
    NSString *roomIdStr = [NSString stringWithFormat:@"%d", roomId];
    [_roomInfoDic removeObjectForKey:roomIdStr];
}

- (void)setRoomWith:(int)roomId count:(NSUInteger)count
{
    NSString *roomIdStr = [NSString stringWithFormat:@"%d", roomId];
    NSNumber *countNumber = [NSNumber numberWithUnsignedInteger:count];
    
    [_roomInfoDic setValue:countNumber forKey:roomIdStr];
}

- (NSUInteger)getRoomCount:(int)roomId
{
    NSString *roomIdStr = [NSString stringWithFormat:@"%d", roomId];
    NSNumber *countNumber = (NSNumber *)[_roomInfoDic objectForKey:roomIdStr];
    return [countNumber unsignedIntegerValue];
}

#pragma mark - 
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedSection == section) {
        Place *hotel = [_hotelList objectAtIndex:section];
        return [[hotel roomsList] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [RoomCell getCellIdentifier];
    RoomCell *cell = (RoomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [RoomCell createCell:self];
    }
    
    Place *Hotel = [_hotelList objectAtIndex:indexPath.section];
    HotelRoom *room = [[Hotel roomsList] objectAtIndex:indexPath.row];
    
    RoomCellSite site;
    if (indexPath.row == 0) {
        site = RoomCellTop;
    } else if (indexPath.row == [[Hotel roomsList] count] - 1) {
        site = RoomCellBottom;
    } else {
        site = RoomCellMiddle;
    }
    
    if ([self isSelectedRoom:room.roomId]) {
        NSUInteger roomCount = [self getRoomCount:room.roomId];
        [cell setCellWithRoom:room
                        count:roomCount
                    indexPath:indexPath
                   isSelected:YES
                 roomCellSite:site];
    } else {
        [cell setCellWithRoom:room
                        count:1
                    indexPath:indexPath
                   isSelected:NO
                 roomCellSite:site];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_hotelList count];
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place *Hotel = [_hotelList objectAtIndex:indexPath.section];
    NSArray *roomsList = [Hotel roomsList];
    
    RoomCellSite site;
    if (indexPath.row == 0) {
        site = RoomCellTop;
    } else if (indexPath.row == [roomsList count] - 1) {
        site = RoomCellBottom;
    } else {
        site = RoomCellMiddle;
    }
    
    return [RoomCell getCellHeight:site];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [HotelHeaderView getHeaderViewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HotelHeaderView *headerView;
    if (section < [_viewsForSectionHeaders count]) {
        headerView = [_viewsForSectionHeaders objectAtIndex:section];
    } else {
        headerView = [HotelHeaderView createHeaderView];
        headerView.delegate = self;
        [_viewsForSectionHeaders addObject:headerView];
    }
    
    Place *hotel = [_hotelList objectAtIndex:section];
    BOOL isSelected = (section == _selectedSection ? YES : NO);
    [headerView setViewWith:hotel section:section isSelected:isSelected];
    
    return headerView;
}

#pragma mark -
#pragma HotelHeaderViewDelegate method
- (void)didClickSelectButton:(NSInteger)section
{
    [self removeAllRooms];
    
    if (_selectedSection == section) {
        _selectedSection = SELECTED_SECTION_NONE;
    } else {
        _selectedSection = section;
    }
    
    [self.dataTableView reloadData];
}

#pragma mark -
#pragma RoomCellDelegate methods
- (void)didClickSelectRoomButton:(int)roomId isSelected:(BOOL)isSelected  count:(NSUInteger)count indexPath:(NSIndexPath *)aIndexPath
{
    if (NO == isSelected) {
        [self removeRoomWith:roomId];
    } else {
        [self setRoomWith:roomId count:count];
    }
    
    [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:aIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didClickMinusButton:(int)roomId count:(NSUInteger)count indexPath:(NSIndexPath *)aIndexPath
{
    if ([self isSelectedRoom:roomId]) {
        [self setRoomWith:roomId count:count];
        [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:aIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)didClickPlusButton:(int)roomId count:(NSUInteger)count indexPath:(NSIndexPath *)aIndexPath
{
    if ([self isSelectedRoom:roomId]) {
        [self setRoomWith:roomId count:count];
        [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:aIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark -
#pragma AirHotelServiceDelegate method
- (void)findHotelsDone:(int)resultCode
                result:(int)result
            resultInfo:(NSString *)resultInfo
            totalCount:(int)totalCount
             hotelList:(NSArray*)hotelList
{
    PPDebug(@"hotelList count:%d", [hotelList count]);
    self.hotelList = [NSMutableArray arrayWithArray:hotelList];
    
    [dataTableView reloadData];
}

@end
