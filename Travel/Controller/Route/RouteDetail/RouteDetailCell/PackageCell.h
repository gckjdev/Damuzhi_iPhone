//
//  PackageCell.h
//  Travel
//
//  Created by 小涛 王 on 12-7-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"
#import "TouristRoute.pb.h"

#define EDGE 5
#define HEIGHT_ACCOMODATION_VIEW 42

@protocol PackageCellDelegate <NSObject>

@optional
- (void)didClickFlight:(int)packageId;
- (void)didClickAccommodation:(int)hotelId;

@end

@interface PackageCell : PPTableViewCell

@property (assign, nonatomic) id<PackageCellDelegate> aDelegate;
@property (retain, nonatomic) IBOutlet UIButton *flightTitleButton;
@property (retain, nonatomic) IBOutlet UIButton *flightButton;
@property (retain, nonatomic) IBOutlet UIButton *accommodationTitleButton;

- (void)setCellData:(TravelPackage *)package;
- (IBAction)clickFilghtButton:(id)sender;

@end
