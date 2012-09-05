//
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

@interface MoreController ()

@property (retain, nonatomic) NSMutableDictionary *dataDictionary;
@property (nonatomic, retain) UISwitch *showImageSwitch;

@end

@implementation MoreController
@synthesize dataDictionary;
@synthesize showImageSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define CITIES              NSLS(@"已开通城市")
#define VERSION             NSLS(@"版本更新")
#define ABOUT               NSLS(@"关于大拇指旅行")
#define PRAISE              NSLS(@"给我一个好评吧")
#define SHOW_IMAGE          NSLS(@"列表中显示图片")


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"更多");
    

    
    
//    if ([[UserManager defaultManager] isLogin]) {
//        [self setNavigationRightButton:NSLS(@"退出登陆") 
//                             imageName:@"topmenu_btn2.png"
//                                action:@selector(clickLogout:)];
//    }else {
//
//        [self setNavigationRightButton:NSLS(@"会员登陆") 
//                             imageName:@"topmenu_btn2.png"
//                                action:@selector(clickLogin:)];
//
//    }
    
    int kShowPraise = [MobClickUtils getIntValueByKey:@"kShowPraise" defaultValue:0];
    
    int i = 0;
    self.dataDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dataDictionary setObject:CITIES forKey:[NSNumber numberWithInt:i++]];
    [dataDictionary setObject:HISTORY forKey:[NSNumber numberWithInt:i++]];
    [dataDictionary setObject:FEEDBACK forKey:[NSNumber numberWithInt:i++]];
    [dataDictionary setObject:VERSION forKey:[NSNumber numberWithInt:i++]];
    [dataDictionary setObject:ABOUT forKey:[NSNumber numberWithInt:i++]];
    if (kShowPraise == 1) {
        [dataDictionary setObject:PRAISE forKey:[NSNumber numberWithInt:i++]];
    }
    [dataDictionary setObject:SHOW_IMAGE forKey:[NSNumber numberWithInt:i++]];
    [dataDictionary setObject:RECOMMENDED_APP forKey:[NSNumber numberWithInt:i++]];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1]];
    
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(206, 8, 79, 27)];
    aSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [aSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    self.showImageSwitch = aSwitch;
    [aSwitch release];
    showImageSwitch.on = [AppUtils isShowImage];
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

- (void)dealloc
{
    [showImageSwitch release];
    [dataDictionary release];
    [super dealloc];
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


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
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
    
    if ([CITIES isEqualToString:[dataDictionary objectForKey:[NSNumber numberWithInt:row]]]) {
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 2, 122, MORE_TABLE_CELL_HEIGHT-4)];
        cityLabel.text = [[AppManager defaultManager] getCurrentCityName];
        cityLabel.font = [UIFont boldSystemFontOfSize:16];
        cityLabel.textAlignment = UITextAlignmentRight;
        cityLabel.textColor = [UIColor colorWithRed:35.0/255.0 green:110.0/255.0 blue:216.0/255.0 alpha:1.0];
        [cell.contentView addSubview:cityLabel];
        [cityLabel release];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    }
    
    if ([SHOW_IMAGE isEqualToString:[dataDictionary objectForKey:[NSNumber numberWithInt:row]]]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:showImageSwitch];
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
- (void)queryVersionFinish:(NSString *)version dataVersion:(NSString *)dataVersion
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
    else {
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

    
//    [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickLogout:(id)sender
{
    [[UserManager defaultManager] logout];
}

@end
