//
//  UIViewController+Travel.h
//  Travel
//
//  Created by haodong on 12-12-12.
//
//

#import <UIKit/UIKit.h>
#import "CityManagementController.h"
#import "AppManager.h"

@interface UIViewController (Travel)<AppManagerProtocol>

- (void)createTitleView:(NSString *)titlePrefix;
- (void)clickTitleView:(id)sender;

@end
