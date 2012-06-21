//
//  BookingCell.h
//  Travel
//
//  Created by 小涛 王 on 12-6-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"
#import "TKCalendarMonthView.h"

@interface BookingCell : PPTableViewCell <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>
@property (retain, nonatomic) IBOutlet UIImageView *bookingBgImageView;
@property (retain, nonatomic) IBOutlet UIView *monthHolderView;

@property (retain, nonatomic) IBOutlet UIButton *currentMonthButton;
@property (retain, nonatomic) IBOutlet UIButton *nextMonthButton;

- (void)setCellData:(BOOL)sundayFirst bookings:(NSArray*)bookings;

@end
