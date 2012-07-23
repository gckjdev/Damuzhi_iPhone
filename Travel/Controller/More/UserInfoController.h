//
//  UserInfoController.h
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPTableViewController.h"
#import "UserInfoCell.h"
#import "UserService.h"

@interface UserInfoController : PPTableViewController <UserInfoCellDelegate, UserServiceDelegate>

@end
