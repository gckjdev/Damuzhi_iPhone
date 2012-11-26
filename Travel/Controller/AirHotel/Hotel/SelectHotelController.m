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

@interface SelectHotelController ()

@property (retain, nonatomic) NSMutableArray *hotelList;
@property (retain, nonatomic) NSMutableArray *viewsForSectionHeaders;
@property (retain, nonatomic) NSMutableArray *sectionStatus;



@end

@implementation SelectHotelController
@synthesize hotelList = _hotelList;
@synthesize viewsForSectionHeaders = _viewsForSectionHeaders;
@synthesize sectionStatus = _sectionStatus;

- (void)dealloc
{
    [_hotelList release];
    [_viewsForSectionHeaders release];
    [_sectionStatus release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"酒店列表");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    //test data
    [self testData];
    [self createSectionStatus];
    [dataTableView reloadData];
}

- (void)createSectionStatus
{
    self.sectionStatus = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0 ; i < [_hotelList count] ; i ++) {
        [_sectionStatus addObject:[NSNumber numberWithBool:YES]];
    }
}

- (void)setSection:(NSInteger)section Open:(BOOL)open
{
    if ([_sectionStatus count] > section) {
        [_sectionStatus removeObjectAtIndex:section];
        NSNumber *num = [NSNumber numberWithBool:open];
        [_sectionStatus insertObject:num atIndex:section];
    }
}

- (void)testData
{
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i =0 ; i < 5 ; i ++) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_sectionStatus objectAtIndex:section] boolValue]) {
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
    return [RoomCell getCellHeight];
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
    [headerView setViewWith:hotel section:section];
    
    return headerView;
}

#pragma mark -
#pragma HotelHeaderViewDelegate method
- (void)didClickSelectButton:(NSInteger)section
{
    BOOL isOpen = [[_sectionStatus objectAtIndex:section] boolValue];
    [self setSection:section Open:!isOpen];
    [self.dataTableView reloadData];
}


@end
