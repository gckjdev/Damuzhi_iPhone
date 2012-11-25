//
//  SelectHotelController.m
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "SelectHotelController.h"
#import "Place.pb.h"

@interface SelectHotelController ()

@property (retain, nonatomic) NSArray *hotelList;

@end

@implementation SelectHotelController
@synthesize hotelList = _hotelList;

- (void)dealloc
{
    [_hotelList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //test data
    [self testData];
    [dataTableView reloadData];
}


//required int32 placeId = 1;                   // 地点ID，全局唯一

//required int32 categoryId = 3;                // 分类ID，如景点／酒店／...（待确定），参见App.proto // 1,2,3,4,5
//required int32 subCategoryId = 4;             // 子分类ID，不同分类不同，如餐馆有 西餐／自助餐，参见App.proto定义
//required string name = 5;                     // 地点名字
//
//required int32 rank = 6;                      // 大拇指评级，取值从1到3
//required double longitude = 11;               // 地点经度
//required double latitude = 12;                // 地点纬度
//required string icon = 31;                    // 地点小图标文件名
//required string introduction = 33;            // 地点详情

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
    Place *hotel = [_hotelList objectAtIndex:section];
    
    PPDebug(@"numberOfRowsInSection: %d",  [[hotel roomsList] count]);
    
    return [[hotel roomsList] count];
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
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    HotelHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:<#(NSString *)#>];
}

@end
