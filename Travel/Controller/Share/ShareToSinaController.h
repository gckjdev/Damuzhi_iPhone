//
//  ShareToSinaController.h
//  Travel
//
//  Created by haodong qiu on 12年4月6日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "SinaweiboManager.h"

@interface ShareToSinaController : PPViewController<UITextViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>

- (IBAction)backgroundTap:(id)sender;

@end
