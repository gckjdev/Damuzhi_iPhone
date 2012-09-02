//
//  FavoriteController.h
//  Travel
//
//  Created by haodong qiu on 12年3月28日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "PlaceListController.h"
#import "PlaceService.h"

@class PlaceListController;

@interface FavoriteController : PPViewController <PlaceListControllerDelegate, PlaceServiceDelegate, UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *myFavPlaceListView;
@property (retain, nonatomic) IBOutlet UIView *topFavPlaceListView;

@end
