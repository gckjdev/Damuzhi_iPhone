//
//  SpotListFilter.h
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonPlaceListController.h"
#import "SelectController.h"
@interface SpotListFilter : NSObject<PlaceListFilterProtocol,SelectControllerDelegate>

@property (retain, nonatomic) PPTableViewController *controller;

@end
