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
#import "MakeHotelOrderHeader.h"
#import "MakeOrderHeader.h"

@interface ConfirmOrderController ()

@property (retain, nonatomic) AirHotelOrder_Builder *builder;

@end

@implementation ConfirmOrderController
@synthesize builder = _builder;

- (void)dealloc
{
    [_builder release];
    [super dealloc];
}

- (id)initWithOrderBuilder:(AirHotelOrder_Builder *)builder
{
    self = [super init];
    if (self) {
        self.builder = builder;
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

- (IBAction)clickOrderButton:(id)sender {
    AirHotelOrder *order = [_builder build];
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
    if (indexPath.section == 0) {
        return [ConfirmAirCell getCellHeight];
    } else {
        return [ConfirmHotelCell getCellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < [[_builder airOrdersList] count]) {
        return [MakeHotelOrderHeader getHeaderViewHeight];
    } else {
        return [MakeHotelOrderHeader getHeaderViewHeight];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < [[_builder airOrdersList] count]) {
        MakeOrderHeader *header = [MakeOrderHeader createHeaderView];
        return header;
    } else {
        MakeHotelOrderHeader *header = [MakeHotelOrderHeader createHeaderView];
        return header;
    }
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
    return 2;
    
    //return [[_builder airOrdersList] count] + [[_builder hotelOrdersList] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
        
        return cell;
    }
}



@end
