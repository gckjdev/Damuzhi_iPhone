//
//  RecommendedAppsControllerViewController.m
//  Travel
//
//  Created by 小涛 王 on 12-5-5.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RecommendedAppsControllerViewController.h"
#import "RecommendedAppCell.h"
#import "AppService.h"
#import "PPDebug.h"
#import "CommonWebController.h"
#import "UIUtils.h"
#import "MobClick.h"
#import "FontSize.h"
#define UM_EVENT_CLICK_RECOMMENDED_APP  @"click_recommended_app"

@implementation RecommendedAppsControllerViewController

- (void)viewDidLoad
{
    [self setBackgroundImageName:@"all_page_bg2.jpg"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self.navigationItem setTitle:RECOMMENDED_APP];
    
    self.dataList = [[[AppManager defaultManager] app] recommendedAppsList];
}

- (void)viewDidUnload
{
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
	return 75;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [theTableView dequeueReusableCellWithIdentifier:[RecommendedAppCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RecommendedAppCell createCell:self];				
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
    RecommendedAppCell* appCell = (RecommendedAppCell*)cell;
    [appCell setCellData:[dataList objectAtIndex:row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendedApp *app = [dataList objectAtIndex:indexPath.row];
    [MobClick event:UM_EVENT_CLICK_RECOMMENDED_APP label:app.name];
//    PPDebug(@"appId ＝ %@", app.appId);
    [UIUtils openApp:app.appId];
}

@end
