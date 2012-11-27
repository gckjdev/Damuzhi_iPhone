
//  MoreController.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "MoreController.h"
#import "LocaleUtils.h"
#import "HistoryController.h"
#import "AppDelegate.h"
#import "FeekbackController.h"
#import "CommonWebController.h"
#import "AppUtils.h"
#import "PPDebug.h"
#import "RecommendedAppsControllerViewController.h"
#import "MobClickUtils.h"
#import "UserManager.h"
#import "LoginController.h"
#import "OrderManagerController.h"
#import "FavoriteController.h"
#import "ShareToSinaController.h"
#import "ShareToQQController.h"
#import "UserInfoController.h"
#import "FontSize.h"
#import "FollowLocalRouteController.h"
#import "ImageManager.h"

@interface MoreController ()

@property (retain, nonatomic) UIButton *loginoutButton;

@property (retain, nonatomic) NSMutableDictionary *dataDictionary;
@property (nonatomic, retain) UISwitch *showImageSwitch;

@end

@implementation MoreController

@synthesize loginoutButton = _loginoutButton;
@synthesize dataDictionary;
@synthesize showImageSwitch;

#define CITIES              NSLS(@"已开通城市")
#define VERSION             NSLS(@"版本更新")
#define ABOUT               NSLS(@"应用帮助")
#define PRAISE              NSLS(@"给我一个好评吧")
#define SHOW_IMAGE          NSLS(@"列表中显示图片")

#define ORDER_NON_MEMBER    NSLS(@"非会员订单查询")
#define USER_INFO           NSLS(@"个人资料")
#define ORDER_MANAGER       NSLS(@"订单管理")
#define MY_FOLLOW           NSLS(@"关注线路")
//#define MY_FAVORITE         NSLS(@"我的收藏")
#define SHARE               NSLS(@"推荐给好友")


- (void)dealloc
{
    [_loginoutButton release];
    [showImageSwitch release];
    [dataDictionary release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLS(@"更多");
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(206, 8, 79, 27)];
    aSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [aSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    self.showImageSwitch = aSwitch;
    [aSwitch release];
    showImageSwitch.on = [AppUtils isShowImage];
    
    [self updateDataSource];
    
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
    
    [self updateDataSource];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [self hideTabBar:YES];
    [super viewDidDisappear:animated];
}


- (void)updateDataSource
{
    
    int kShowPraise = [MobClickUtils getIntValueByKey:@"kShowPraise" defaultValue:0];
    int kShowRecommendApp = [MobClickUtils getIntValueByKey:@"kShowRecommendApp" defaultValue:0];

    
    int i = 0;
    self.dataDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dataDictionary setObject:CITIES forKey:[NSNumber numberWithInt:i++]];
    
    if ([[UserManager defaultManager] isLogin]) {
        [self setNavigationRightButton:NSLS(@"退出登录") 
                              fontSize:FONT_SIZE
                             imageName:@"topmenu_btn2.png"
                                action:@selector(clickLogout:)];
        
        [dataDictionary setObject:USER_INFO forKey:[NSNumber numberWithInt:i++]];
        [dataDictionary setObject:ORDER_MANAGER forKey:[NSNumber numberWithInt:i++]];
        
    }else {
        [self setNavigationRightButton:NSLS(@"会员登录") 
                              fontSize:FONT_SIZE
                             imageName:@"topmenu_btn2.png"
                                action:@selector(clickLogin:)];
        
        [dataDictionary setObject:ORDER_NON_MEMBER forKey:[NSNumber numberWithInt:i++]];
    }
    
    //[dataDictionary setObject:HISTORY forKey:[NSNumber numberWithInt:i++]];
    
    [dataDictionary setObject:ABOUT forKey:[NSNumber numberWithInt:i++]];
    [dataDictionary setObject:MY_FOLLOW forKey:[NSNumber numberWithInt:i++]];
    
//    [dataDictionary setObject:MY_FAVORITE forKey:[NSNumber numberWithInt:i++]];
    
    [dataDictionary setObject:FEEDBACK forKey:[NSNumber numberWithInt:i++]];
    [dataDictionary setObject:VERSION forKey:[NSNumber numberWithInt:i++]];
    [dataDictionary setObject:SHARE forKey:[NSNumber numberWithInt:i++]];
    
    if (kShowPraise == 1) {
        [dataDictionary setObject:PRAISE forKey:[NSNumber numberWithInt:i++]];
    }
    [dataDictionary setObject:SHOW_IMAGE forKey:[NSNumber numberWithInt:i++]];

    if (kShowRecommendApp == 1) {
        [dataDictionary setObject:RECOMMENDED_APP forKey:[NSNumber numberWithInt:i++]];
    }
}

- (void)viewDidUnload
{
    [self setShowImageSwitch:nil];
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


#pragma mark Table View Delegate

#define MORE_TABLE_CELL_HEIGHT  44

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return MORE_TABLE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataDictionary count];			// default implementation
}

#define TAG_CITY_LABEL 70 
#define TAG_SHOW_IMAGE_SWITCH 71
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.imageView setImage:[UIImage imageNamed:@"more_icon.png"]];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
	}
	
	// set text label
	int row = [indexPath row];	
	int count = [dataDictionary count];
	if (row >= count){
		PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
    
    UILabel *cityLabel = (UILabel*)[cell.contentView viewWithTag:TAG_CITY_LABEL];
    [cityLabel removeFromSuperview];
    
    if ([CITIES isEqualToString:[dataDictionary objectForKey:[NSNumber numberWithInt:row]]]) {
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 2, 122, MORE_TABLE_CELL_HEIGHT-4)];
        cityLabel.tag = TAG_CITY_LABEL;
        cityLabel.text = [[AppManager defaultManager] getCurrentCityName];
        cityLabel.font = [UIFont boldSystemFontOfSize:16];
        cityLabel.textAlignment = UITextAlignmentRight;
        cityLabel.textColor = [UIColor colorWithRed:35.0/255.0 green:110.0/255.0 blue:216.0/255.0 alpha:1.0];
        [cell.contentView addSubview:cityLabel];
        [cityLabel release];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.accessoryView = nil;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIImage* image = [[ImageManager defaultManager] accessoryImage];
        UIImageView* cellAccessoryView = [[UIImageView alloc] initWithImage:image];
        cell.accessoryView = cellAccessoryView;
        [cellAccessoryView release];
    }
    
    if ([SHOW_IMAGE isEqualToString:[dataDictionary objectForKey:[NSNumber numberWithInt:row]]]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        showImageSwitch.tag = TAG_SHOW_IMAGE_SWITCH;
        [cell.contentView addSubview:showImageSwitch];
    }else {
        UISwitch *switchView = (UISwitch *)[cell.contentView viewWithTag:TAG_SHOW_IMAGE_SWITCH];
        [switchView removeFromSuperview];
    }
    
    cell.textLabel.text = [dataDictionary objectForKey:[NSNumber numberWithInt:row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
	
	return cell;
}

- (void)showCityManagment
{
    CityManagementController *controller = [CityManagementController getInstance];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showHistory
{
    HistoryController *hc = [[HistoryController alloc] init];
    [self.navigationController pushViewController:hc animated:YES];
    [hc release];
}

- (void)showFeekback
{
    FeekbackController *controller = [[FeekbackController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)queryVersion
{
    [[UserService defaultService] queryVersion:self];
}

#pragma -mark UserServiceDelegate
- (void)queryVersionFinish:(NSString *)version dataVersion:(NSString *)dataVersion title:(NSString *)title content:(NSString *)content
{
    if (version && dataVersion) {
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        float versionFloat = [version floatValue];
        float localVersionFloat = [localVersion floatValue];
        if (localVersionFloat >= versionFloat) {
            [self popupHappyMessage:NSLS(@"isNewVersion") title:nil];
        }else {
            [UIUtils openApp:kAppId];
        }
    }
    else {
        [self popupUnhappyMessage:NSLS(@"查询版本失败") title:nil];
    }
}

- (void)showAbout
{
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:[AppUtils getHelpHtmlFilePath]];
    controller.navigationItem.title = ABOUT;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)showRecommendedApps
{
    RecommendedAppsControllerViewController *controller = [[RecommendedAppsControllerViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([CITIES isEqualToString:[dataDictionary objectForKey:[NSNumber numberWithInt:indexPath.row]]]) {
        [self showCityManagment];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    NSString *title = [dataDictionary objectForKey:[NSNumber numberWithInt:indexPath.row]];
    
    if ([title isEqualToString:CITIES]) {
        [self showCityManagment];
    }
    else if ([title isEqualToString:HISTORY]) {
        [self showHistory];
    }
    else if ([title isEqualToString:FEEDBACK]) {
        [self showFeekback];
    }
    else if ([title isEqualToString:VERSION]) {
        [self queryVersion];
    }
    else if ([title isEqualToString:ABOUT]) {
        [self showAbout];
    }
    else if ([title isEqualToString:PRAISE]) {
        [UIUtils gotoReview:kAppId];
    }
    else if ([title isEqualToString:RECOMMENDED_APP]) {
        [self showRecommendedApps];
    }
    else if ([title isEqualToString:ORDER_NON_MEMBER] || [title isEqualToString:ORDER_MANAGER]) {
        [self showOrderManager];
    }
    else if ([title isEqualToString:USER_INFO]) {
        [self showUserInfo];
    }
//    else if ([title isEqualToString:MY_FAVORITE]) {
//        [self showFavorite];
//    }
    else if ([title isEqualToString:SHARE]) {
        [self showShare];
    }
    else if ([title isEqualToString:MY_FOLLOW]) {
        [self showMyFollow];
    }
    else
    {
    }
}

- (void)clickSwitch:(id)sender
{
    UISwitch *currentSwitch = (UISwitch *)sender;
    [AppUtils enableImageShow:currentSwitch.on];
}

- (void)clickLogin:(id)sender
{
    LoginController *controller = [[[LoginController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showOrderManager
{
    OrderManagerController *controller  = [[OrderManagerController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)showUserInfo
{
    UserInfoController *controller = [[UserInfoController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)showFavorite
{
//    FavoriteController *fc = [[FavoriteController alloc] init];
//    [self.navigationController pushViewController:fc animated:YES];
//    [fc release];
}

- (void)showShare
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLS(@"取消") destructiveButtonTitle:NSLS(@"通过短信") otherButtonTitles:NSLS(@"分享到新浪微博"), NSLS(@"分享到腾讯微博"), nil];
    //[shareSheet showInView:self.view];
    [shareSheet showFromTabBar:self.tabBarController.tabBar];
    [shareSheet release];
}

- (void)clickLogout:(id)sender
{
    self.loginoutButton = (UIButton *)sender;
    _loginoutButton.enabled = NO;
    
    [[UserService defaultService] logout:self];
}

- (void)loginoutDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    _loginoutButton.enabled = YES;
    
    [self updateDataSource];
    [dataTableView reloadData];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self sendSms:nil body:[NSString stringWithFormat:NSLS(@"kShareContent"),[MobClick getConfigParams:@"download_website"]]];
            break;
        }
        case 1:
        {
            ShareToSinaController *sc = [[ShareToSinaController alloc] init];
            [self.navigationController pushViewController:sc animated:YES];
            [sc release];
            break;
        }
        case 2:
        {
            ShareToQQController *shareToQQ = [[ShareToQQController alloc] init];
            [self.navigationController pushViewController:shareToQQ animated:YES];
            [shareToQQ release];
            break;
        }
        case 3:
            break;
        default:
            break;
    }
}

- (void)showMyFollow
{
    FollowLocalRouteController *controller  = [[FollowLocalRouteController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma CommonDialogDelegate methods
- (void)didClickOkButton
{
    
}

- (void)didClickCancelButton
{
    
}

@end
