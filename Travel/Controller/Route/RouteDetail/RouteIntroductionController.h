//
//  RouteIntroductionController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "TouristRoute.pb.h"
#import "RelatedPlaceCell.h"
#import "PackageCell.h"
#import "DailyScheduleCell.h"
#import "RouteService.h"
#import "MonthViewController.h"

@protocol RouteIntroductionControllerDelegate <NSObject>

@optional
- (void)didClickBookButton:(int)packageId;
- (void)didSelectedPlace:(int)placeId;
- (void)didClickFlight:(int)packageId;

@end


@interface RouteIntroductionController : PPTableViewController <RelatedPlaceCellDelegate, DailyScheduleCellDelegate, PackageCellDelegate, RouteServiceDelegate, UIWebViewDelegate, MonthViewControllerDelegate>


@property (assign, nonatomic) id<RouteIntroductionControllerDelegate> aDelegate;

@property (retain, nonatomic) IBOutlet UIView *titleHolerView;

@property (retain, nonatomic) IBOutlet UIView *imagesHolderView;

@property (retain, nonatomic) IBOutlet UILabel *departCityLabel;

@property (retain, nonatomic) IBOutlet UIView *agencyInfoHolderView;
@property (retain, nonatomic) IBOutlet UIButton *followButton;


//- (id)initWithRoute:(TouristRoute *)route routeType:(int)routeType;
- (void)updateWithRoute:(TouristRoute *)route routeType:(int)routeType;
- (void)showInView:(UIView *)superView;

@end
