//
//  AppDelegate.h
//  Travel
//
//  Created by  on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPApplication.h"
#import "UserService.h"
#import "CommonDialog.h"

#define kAppId			@"531266294"

@class MainController;
@class PPTabBarController;

@interface AppDelegate : PPApplication <UIApplicationDelegate, UserServiceDelegate, UITabBarControllerDelegate, CommonDialogDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainController *mainController;

@property (retain, nonatomic) PPTabBarController *tabBarController;

- (void)hideTabBar:(BOOL)isHide;

- (void) setSeletedTabbarIndex:(NSInteger)index;

@end
