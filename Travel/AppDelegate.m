//
//  AppDelegate.m
//  Travel
//
//  Created by  on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LocaleUtils.h"
#import "MainController.h"
#import "UINavigationBarExt.h"
#import "DeviceDetection.h"
#import "AppService.h"
#import "UserService.h"
#import "LocalCityManager.h"
#import "AppConstants.h"
#import "MobClick.h"
#import "AppUtils.h"
#import "ResendService.h"
#import "ImageManager.h"

#import "PPTabBarController.h"
#import "CommonRouteListController.h"
#import "UnPackageTourListFilter.h"
#import "PackageTourListFilter.h"
#import "MoreController.h"
#import "HappyTourController.h"
#import "AirHotelController.h"
#import "LocalRouteListController.h"
#import "UserManager.h"

typedef enum{
    NotificationTypeNone = 0,
    NotificationTypeNormal,
    NotificationTypeNewVersion,
    NotificationTypeUpdateOfflineCity
}NotificationType;

#define UMENG_KEY @"4fb377b35270152b5a0000fe"
#define SPLASH_VIEW_TAG 20120506


@implementation AppDelegate

@synthesize window = _window;
@synthesize mainController = _mainController;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_mainController release];
    [_tabBarController release];
    [super dealloc];
}

- (void)hideTabBar:(BOOL)isHide
{
    [self.tabBarController hideCustomTabBarView:isHide];
}

- (void)initTabViewControllers
{
    PPTabBarController *tabBarController = [[PPTabBarController alloc] init];
    self.tabBarController = tabBarController;
    [tabBarController release];
    
    _tabBarController.delegate = self;
    
	NSMutableArray* controllers = [[NSMutableArray alloc] init];
    
	self.mainController = (MainController *)[UIUtils addViewController:[MainController alloc]
					 viewTitle:nil
					 viewImage:@"menu_btn1_off.png"
			  hasNavController:YES			
			   viewControllers:controllers];	
//    
//    NSObject<RouteListFilterProtocol>* unPackageFilter = [UnPackageTourListFilter createFilter];
//    CommonRouteListController *unPackageController = [[[CommonRouteListController alloc] initWithFilterHandler:unPackageFilter DepartCityId:7 destinationCityId:0 hasStatisticsLabel:NO] autorelease];
//    
//    [UIUtils addInitViewController:unPackageController 
//                         viewTitle:nil
//                         viewImage:@"menu_btn2_off.png" 
//                  hasNavController:YES 
//                 hideNavigationBar:NO 
//                   viewControllers:controllers];
//    
//    
    
    [UIUtils addViewController:[LocalRouteListController alloc]
                     viewTitle:nil
                     viewImage:@"menu_btn2_off.png" 
              hasNavController:YES 
             hideNavigationBar:NO 
               viewControllers:controllers];
    
//    NSObject<RouteListFilterProtocol>* packageFilter = [PackageTourListFilter createFilter];
//    CommonRouteListController *packageController = [[[CommonRouteListController alloc] initWithFilterHandler:packageFilter DepartCityId:7 destinationCityId:0 hasStatisticsLabel:NO] autorelease];
//    
//    [UIUtils addInitViewController:packageController 
//                         viewTitle:nil
//                         viewImage:@"menu_btn3_off.png" 
//                  hasNavController:YES 
//                 hideNavigationBar:NO 
//                   viewControllers:controllers];
    
    
    [UIUtils addViewController:[AirHotelController alloc]
                     viewTitle:nil
                     viewImage:@"menu_btn3_off.png"
              hasNavController:YES
             hideNavigationBar:NO
               viewControllers:controllers];
    
    
    [UIUtils addViewController:[HappyTourController alloc] 
                         viewTitle:nil
                         viewImage:@"menu_btn4_off.png" 
                  hasNavController:YES 
                 hideNavigationBar:NO 
                   viewControllers:controllers];
    
    [UIUtils addViewController:[MoreController alloc] 
                         viewTitle:nil
                         viewImage:@"menu_btn5_off.png" 
                  hasNavController:YES 
                 hideNavigationBar:NO 
                   viewControllers:controllers];
    
	_tabBarController.viewControllers = controllers;
    [self.tabBarController setSelectedImageArray:[NSArray arrayWithObjects:
                                                  @"menu_btn1_on.png", 
                                                  @"menu_btn2_on.png", 
                                                  @"menu_btn3_on.png", 
                                                  @"menu_btn4_on.png", 
                                                  @"menu_btn5_on.png", nil]];
    
    _tabBarController.selectedIndex = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_arrow.png"]];
    [_tabBarController setTopImageView:imageView down:1.0 animated:YES];
    [imageView release];
    
    PPDebug(@"tabBarController y:%f h:%f",self.tabBarController.tabBar.frame.origin.y ,self.tabBarController.tabBar.frame.size.height);
	
	[controllers release];
}

- (void) setSeletedTabbarIndex:(NSInteger)index
{
    UIButton *button = [_tabBarController.buttons objectAtIndex:index];
    [_tabBarController selectedTab:button];
}

#define EVER_LAUNCHED @"everLaunched"
#define FIRST_LAUNCH @"firstLaunch"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PPDebug(@"didFinishLaunchingWithOptions :%@",launchOptions);
    
    application.applicationIconBadgeNumber = 0;
    //[MobClick startWithAppkey:UMENG_KEY];
    
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:nil];
    //[MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:@"91"];
    //[MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:@"PP"];
    //[MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:@"TongBu"];
    
    
    [MobClick updateOnlineConfig];
    
    if ([DeviceDetection isOS5]){
        [[UINavigationBar appearance] setBackgroundImage:[[ImageManager defaultManager] navigationBgImage] forBarMetrics:UIBarMetricsDefault];
    }
    else{
        GlobalSetNavBarBackground(@"topmenu_bg.png");        
    }        
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // Push Setup
    if (![self isPushNotificationEnable]){
        [self bindDevice];
    }
    
//    //juage if app is firstLaunch
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:EVER_LAUNCHED]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EVER_LAUNCHED];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_LAUNCH];
//    }
//    else{
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FIRST_LAUNCH];
//    }
    
    [self initImageCacheManager];
//    //–insert a delay of 5 seconds before the splash screen disappears–
//    [NSThread sleepForTimeInterval:1.0];
        
    // init app data
    [[AppService defaultService] loadAppData]; 
    
    // update app data from server
    [[AppService defaultService] updateAppData];
    
    // update help html 
    [[AppService defaultService] updateHelpHtmlFile];
    
    //resend favorete place
    [[ResendService defaultService] resendFavorite];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
//    self.mainController = [[[MainController alloc] initWithNibName:@"MainController" bundle:nil] autorelease];
//    
//    UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController:self.mainController] autorelease];
//    self.mainController.navigationItem.title = NSLS(@"大拇指旅行");
//    
//    self.window.rootViewController = navigationController;
//
    
    [self initTabViewControllers];
    [self.window addSubview:_tabBarController.view];

    
    [self.window makeKeyAndVisible];
    
    UIImage *startImage = nil;
    if ([DeviceDetection isIPhone5]) {
        startImage = [UIImage imageNamed:@"Default-568h.png"];
    } else {
        startImage = [UIImage imageNamed:@"Default.png"];
    }
    UIView* splashView = [[UIImageView alloc] initWithImage:startImage];
    splashView.frame = [self.window bounds];
    splashView.tag = SPLASH_VIEW_TAG;
    [self.window addSubview:splashView];
    [splashView release];
    [self performSelector:@selector(removeSplashView) withObject:nil afterDelay:2.0f];
    
    [[UserService defaultService] queryVersion:self];
    
    
    //register user
    if ([[UserManager defaultManager] getUserId] == nil) {
        [self registerUser];
    }

    return YES;
}

- (void)removeSplashView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0f];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
						   forView:self.window
                             cache:YES];
    [UIView commitAnimations];
    [[self.window viewWithTag:SPLASH_VIEW_TAG] removeFromSuperview];
}

- (void)registerUser
{
    [[UserService defaultService] autoRegisterUser:[self getDeviceToken]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [[LocalCityManager defaultManager] save];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
}


#pragma mark - UserServiceDelegate
- (void)queryVersionFinish:(NSString *)version dataVersion:(NSString *)dataVersion title:(NSString *)title content:(NSString *)content
{
    if (version && dataVersion) {
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        float versionFloat = [version floatValue];
        float localVersionFloat = [localVersion floatValue];
        if (localVersionFloat < versionFloat) {            
            if (title == nil || [title length] == 0) {
                title = [NSString stringWithFormat:NSLS(@"大拇指旅行%@发布了"),version];
            }
            
            CommonDialog *dialog = [CommonDialog createDialogWithTitle:NSLS(@"新版本升级提示") subTitle:title content:content OKButtonTitle:NSLS(@"立刻升级") cancelButtonTitle:NSLS(@"稍后提醒") delegate:self];
            [self.window insertSubview:dialog belowSubview:[self.window viewWithTag:SPLASH_VIEW_TAG]];
        }
    }
    else {
        PPDebug(@"query version faild");
    }
}


#pragma mark - Device Notification Delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PPDebug(@"Get token successfully: %@", deviceToken);
    
	[self saveDeviceToken:deviceToken];
    
    [self registerUser];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    PPDebug(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    PPDebug(@"didReceiveRemoteNotification :%@", userInfo);
    
    NSNumber *type = [userInfo objectForKey:@"type"];
    switch (type.intValue) {
        case NotificationTypeNormal:
            break;
        case NotificationTypeNewVersion:{
            [[UserService defaultService] queryVersion:self];
            break;
        }
        case NotificationTypeUpdateOfflineCity:
            break;
        default:
            break;
    }
}

#pragma mark - 
#pragma CommonDialogDelegate methods
- (void)didClickOkButton
{
    [UIUtils openApp:kAppId];
}

- (void)didClickCancelButton
{
    return;
}

@end
