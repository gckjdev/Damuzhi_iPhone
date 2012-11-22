//
//  AirHotelController.m
//  Travel
//
//  Created by kaibin on 12-9-21.
//
//

#import "AirHotelController.h"
#import "AppDelegate.h"
#import "CommonMonthController.h"
#import "AirHotel.pb.h"

@interface AirHotelController ()

@property (retain, nonatomic) NSArray *hotelOrderList;

@end

@implementation AirHotelController
@synthesize hotelOrderList = _hotelOrderList;

- (void)dealloc {
    [_makeOrderView release];
    [_orderNoteView release];
    [_totalControl release];
    [_hotelOrderList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLS(@"机+酒");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"djy_page_bg.jpg"]]];
    
    [self updateTotalControl];
}

- (void)updateTotalControl
{
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [_totalControl setTitleTextAttributes:attributes
                                 forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setMakeOrderView:nil];
    [self setOrderNoteView:nil];
    [self setTotalControl:nil];
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

//- (IBAction)clickDate:(id)sender
//{
//    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:nil monthCount:12 title:NSLS(@"出发日期")] autorelease];
//    [self.navigationController pushViewController:controller animated:YES];
//}

- (IBAction)changeTitle:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl*)sender;
    
    if ([segmentedControl selectedSegmentIndex] == 0) {
        _makeOrderView.hidden = NO;
        _orderNoteView.hidden = YES;
    } else {
        _makeOrderView.hidden = YES;
        _orderNoteView.hidden = NO;
    }
}


#define SECTION_AIR     0
#define SECTION_HOTEL   1

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_AIR) {
        return 0;
    }  else if (indexPath.section == SECTION_HOTEL) {
        return [MakeHotelOrderCell getCellHeight];
    }
    
    return 0;
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_AIR) {
        return 1;
    } else if (section == SECTION_HOTEL) {
        return [_hotelOrderList count];
    }
    
    return 0;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == SECTION_AIR) {
//        return nil;
//    }  else if (indexPath.section == SECTION_HOTEL) {
//        NSString *identifier = [MakeHotelOrderCell getCellIdentifier];
//        MakeHotelOrderCell *cell = (MakeHotelOrderCell *)[tableView  dequeueReusableCellWithIdentifier:identifier];
//        if (cell == nil) {
//            cell = [MakeHotelOrderCell createCell:self];
//        }
//        
//        return cell;
//    }
//    
//    return nil;
//}


#pragma mark -
#pragma MakeHotelOrderCellDelegate methods
- (void)didClickCheckInButton:(NSIndexPath *)indexPath
{
    
}

- (void)didClickCheckOutButton:(NSIndexPath *)indexPath
{
    
}

- (void)didClickHotelButton:(NSIndexPath *)indexPath
{
    
}


@end
