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

@protocol RouteIntroductionControllerDelegate <NSObject>

@optional
- (void)didClickBookButton:(int)packageId;
- (void)didSelectedPlace:(int)placeId;
- (void)didClickFlight:(int)packageId;

@end

@interface RouteIntroductionController : PPTableViewController <RelatedPlaceCellDelegate, PackageCellDelegate>

- (id)initWithRoute:(TouristRoute *)route routeType:(int)routeType;

@property (assign, nonatomic) id<RouteIntroductionControllerDelegate> aDelegate;

@property (retain, nonatomic) IBOutlet UIView *titleHolerView;
@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *routeIdLabel;


@property (retain, nonatomic) IBOutlet UIView *imagesHolderView;
@property (retain, nonatomic) IBOutlet UILabel *agencyNameLabel;

@property (retain, nonatomic) IBOutlet UIView *agencyInfoHolderView;

- (void)showInView:(UIScrollView *)superView;

@end
