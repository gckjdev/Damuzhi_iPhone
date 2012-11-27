//
//  RouteController.m
//  Travel
//
//  Created by 小涛 王 on 12-4-10.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteController.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "UIImageUtil.h"
#import "PPDebug.h"
#import "RouteCell.h"
#import "AppConstants.h"
#import "RouteDetailController.h"
#import "PPNetworkRequest.h"
#import "FontSize.h"
#import "ImageManager.h"

#define TABLE_VIEW_CELL_HEIGHT 75
@implementation RouteController


- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    [self.navigationItem setTitle:NSLS(@"线路推荐")];
        
    [[TravelTipsService defaultService] findTravelTipList:[[AppManager defaultManager] getCurrentCityId] type:TravelTipTypeRoute viewController:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat orginY = (tableView.contentSize.height <= tableView.frame.size.height) ? tableView.frame.size.height : tableView.contentSize.height;
    orginY = orginY - 1;
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, orginY, 320, 250)] autorelease];
    [imageView setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
    [tableView addSubview:imageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
//    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return TABLE_VIEW_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [theTableView dequeueReusableCellWithIdentifier:[RouteCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteCell createCell:self];				
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        // Customize the appearance of table view cells at first time
        UIImageView *view = [[UIImageView alloc] init];
        [view setImage:[UIImage imageNamed:@"list_tr_bg2.png"]];
        [cell setBackgroundView:view];
        [view release];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    int row = [indexPath row];	
    int count = [dataList count];
    if (row >= count){
        PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
        return cell;
    }
    RouteCell* routeCell = (RouteCell*)cell;
    [routeCell setCellData:[dataList objectAtIndex:row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTravelTip *tip = [dataList objectAtIndex:indexPath.row];
    RouteDetailController *controller = [[RouteDetailController alloc] initWithDataSource:tip];
    [controller setTitle:self.navigationItem.title];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


#pragma mark -
#pragma mark: implementation of TravelTipsServiceDelegate

- (void)findRequestDone:(int)resulteCode tipList:(NSArray*)tipList
{
    if (resulteCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"网络弱，数据加载失败") title:nil];
        return;
    }
    
    self.dataList = tipList;
    [self.dataTableView reloadData];
}

@end
