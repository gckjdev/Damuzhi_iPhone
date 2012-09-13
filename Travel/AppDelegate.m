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
#import "CustomTourController.h"

#import "LocalRouteListController.h"
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
    
    [UIUtils addViewController:[[LocalRouteListController alloc]initWithCityId:[[AppManager defaultManager]getCurrentCityId]]
                     viewTitle:nil
                     viewImage:@"all_page_bg2.jpg" 
              hasNavController:YES 
             hideNavigationBar:NO 
               viewControllers:controllers];
    
    
    
    NSObject<RouteListFilterProtocol>* packageFilter = [PackageTourListFilter createFilter];
    CommonRouteListController *packageController = [[[CommonRouteListController alloc] initWithFilterHandler:packageFilter DepartCityId:7 destinationCityId:0 hasStatisticsLabel:NO] autorelease];
    
    [UIUtils addInitViewController:packageController 
                         viewTitle:nil
                         viewImage:@"menu_btn3_off.png" 
                  hasNavController:YES 
                 hideNavigationBar:NO 
                   viewControllers:controllers];
    
    [UIUtils addViewController:[CustomTourController alloc] 
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
//    [self.tabBarController setSelectedImageArray:[NSArray arrayWithObjects:
//                                                  @"menu_btn1_on.png", 
//                                                  @"menu_btn2_on.png", 
//                                                  @"menu_btn3_on.png", 
//                                                  @"menu_btn4_on.png", 
//                                                  @"menu_btn5_on.png", nil]];
    
    [self.tabBarController setSelectedImageArray:[NSArray arrayWithObjects:
                                                  @"menu_btn1_on.png", 
                                                  @"all_page_bg2.jpg", 
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
    application.applicationIconBadgeNumber = 0;
    //[MobClick startWithAppkey:UMENG_KEY];
//    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:@"91"];
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:nil];

    [MobClick updateOnlineConfig];
    
    if ([DeviceDetection isOS5]){
        [[UINavigationBar appearance] setBackgroundImage:[[ImageManager defaultManager] navigationBgImage] forBarMetrics:UIBarMetricsDefault];
    }
    else{
        GlobalSetNavBarBackground(@"topmenu_bg.png");        
    }        
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
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
    
    //register user
    //[[UserService defaultService] autoRegisterUser:@"123"];
    [[UserService defaultService] autoRegisterUser:[self getDeviceToken]];
    
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
//    UIView* splashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
//    splashView.frame = [self.window bounds];
//    splashView.tag = SPLASH_VIEW_TAG;
//    [self.window.rootViewController.view addSubview:splashView];
//    [splashView release];
//    
//    [self performSelector:@selector(removeSplashView) withObject:nil afterDelay:2.0f];
    
    
    [self initTabViewControllers];
    [self.window addSubview:_tabBarController.view];
    
    [self.window makeKeyAndVisible];
    
    [[UserService defaultService] queryVersion:self];

    return YES;
}

- (void)removeSplashView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0f];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
						   forView:self.window.rootViewController.view 
                             cache:YES];
    [UIView commitAnimations];
    [[self.window.rootViewController.view viewWithTag:SPLASH_VIEW_TAG] removeFromSuperview];
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
- (void)queryVersionFinish:(NSString *)version dataVersion:(NSString *)dataVersion
{
    if (version && dataVersion) {
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        float versionFloat = [version floatValue];
        float localVersionFloat = [localVersion floatValue];
        if (localVersionFloat < versionFloat) {
            UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:nil message:NSLS(@"有新版本，是否更新？") delegate:self cancelButtonTitle:NSLS(@"稍后更新") otherButtonTitles:@"立即更新", nil];
            [alertView show];
            [alertView release];
        }
    }
    else {
        PPDebug(@"query version faild");
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return ;
    }else if(buttonIndex == 1)
    {
        [UIUtils openApp:kAppId];
    }
}


@end
