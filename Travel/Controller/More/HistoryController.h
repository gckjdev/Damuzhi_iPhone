//
//  HistoryController.h
//  Travel
//
//  Created by haodong qiu on 12年3月29日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "PlaceListController.h"

#define HISTORY             NSLS(@"浏览记录")

@interface HistoryController : PPViewController

@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;

@end
