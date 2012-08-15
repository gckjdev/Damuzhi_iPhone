//
//  BookingCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "BookingCell.h"
#import "NSDate+TKCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "PPDebug.h"
#import "LocaleUtils.h"
#import "TimeUtils.h"
#import "TouristRoute.pb.h"

@interface BookingCell ()
{
    BOOL _showInView;
}
@property (retain, nonatomic) MonthViewController *monthViewcontroller;

@end

@implementation BookingCell

@synthesize bookingBgImageView = _bookingBgImageView;

@synthesize monthHolderView = _monthHolderView;
@synthesize monthViewcontroller = _monthViewcontroller;

+ (NSString*)getCellIdentifier
{
    return @"BookingCell";
}

+ (CGFloat)getCellHeight
{
    return 390;
}

- (void)dealloc
{
    [_monthHolderView release];
    [_bookingBgImageView release];
    [_monthViewcontroller release];
    
    [super dealloc];
}

//- (void)setCellData:(BOOL)sundayFirst bookings:(NSArray*)bookings routeType:(int)routeType
//{    
//    
//    self.monthViewcontroller = [[[MonthViewController alloc] initWithBookings:bookings routeType:routeType] autorelease];
//    [_monthViewcontroller showInView:self.monthHolderView];
//}

- (void)setCellData:(MonthViewController *)monthViewController
{    
    if (!_showInView) {
        _showInView = YES;
        [monthViewController showInView:self.monthHolderView];
    }
}

@end
