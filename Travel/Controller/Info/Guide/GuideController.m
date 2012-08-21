//
//  GuideController.m
//  Travel
//
//  Created by haodong qiu on 12年4月11日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "GuideController.h"
#import "AppManager.h"
#import "TravelTips.pb.h"
#import "ImageName.h"
#import "LocaleUtils.h"
#import "AppUtils.h"
#import "CommonWebController.h"
#import "PPNetworkRequest.h"
#import "FontSize.h"

@implementation GuideController
@synthesize scrollView;

- (void)viewDidLoad
{
    [self setBackgroundImageName:@"all_page_bg2.jpg"];
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self.navigationItem setTitle:NSLS(@"游记攻略")];
    
    [[TravelTipsService defaultService] findTravelTipList:[[AppManager defaultManager] getCurrentCityId] type:TravelTipTypeGuide viewController:self];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 280);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -250, 320, 250)];
    [imageView setImage:[UIImage imageNamed:@"detail_bg_up.png"]];
    [scrollView addSubview:imageView];
    [imageView release];
    
    scrollView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:230.0/255.0 alpha:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TravelTipsServiceDelegate
- (void)findRequestDone:(int)resulteCode tipList:(NSArray*)tipList
{
    if (resulteCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"网络弱，数据加载失败") title:nil];
        return;
    }

    self.dataList = tipList;
    [self.dataTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GuideCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.imageView.image = [UIImage imageNamed:IMAGE_GUIDE_CELL];
        
        UIImage* image = [UIImage imageNamed:IMAGE_CITY_CELL_ACCESSORY];
        UIImageView* cellAccessoryView = [[UIImageView alloc] initWithImage:image];
        cell.accessoryView = cellAccessoryView;
        [cellAccessoryView release];
        
        cell.textLabel.textColor = [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
    }
    
	CommonTravelTip *tip = [dataList objectAtIndex:indexPath.row];
	cell.textLabel.text = tip.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CommonTravelTip *tip = [dataList objectAtIndex:indexPath.row];
//    NSLog(@"%@",tip.html);
    CommonTravelTip *tip = [dataList objectAtIndex:indexPath.row];
    NSString *htmlPath = [AppUtils getAbsolutePath:[AppUtils getCityDir:[[AppManager defaultManager] getCurrentCityId]] string:tip.html];
    
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:htmlPath];
    controller.title = tip.name;
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

- (void)dealloc {
    [scrollView release];
    [super dealloc];
}
@end
