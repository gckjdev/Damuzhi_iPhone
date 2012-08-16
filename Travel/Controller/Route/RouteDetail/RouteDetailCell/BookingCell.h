//
//  BookingCell.h
//  Travel
//
//  Created by 小涛 王 on 12-6-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"
#import "TKCalendarMonthView.h"
#import "MonthViewController.h"


@interface BookingCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *bookingBgImageView;
@property (retain, nonatomic) IBOutlet UIView *monthHolderView;

//- (void)setCellData:(BOOL)sundayFirst bookings:(NSArray*)bookings routeType:(int)routeType;
- (void)setCellData:(MonthViewController *)monthViewController;



@end
