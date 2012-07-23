//
//  SignUpController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "UserService.h"
#import "UserInfoCell.h"
@interface SignUpController : PPTableViewController <UserServiceDelegate,UserInfoCellDelegate>

@end
