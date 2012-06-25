//
//  MonthViewController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPViewController.h"
#import "TKCalendarMonthView.h"

@interface MonthViewController : PPViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>

@property (retain, nonatomic) IBOutlet UIButton *currentMonthButton;
@property (retain, nonatomic) IBOutlet UIButton *nextMonthButton;
@property (retain, nonatomic) IBOutlet UIView *monthHolderView;

- (id)initWithBookings:(NSArray *)bookings;
- (void)showInView:(UIView *)superView;

@end
