//
//  RetrievePasswordController.h
//  Travel
//
//  Created by Orange on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPTableViewController.h"
#import "UserService.h"

@interface RetrievePasswordController : PPTableViewController <UserServiceDelegate>
@property (retain, nonatomic) IBOutlet UITextField *loginIdTextField;
@property (retain, nonatomic) IBOutlet UIScrollView *backgroundScrollView;

@end
