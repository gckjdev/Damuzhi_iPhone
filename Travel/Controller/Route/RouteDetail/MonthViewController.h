//
//  MonthViewController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPViewController.h"
#import "TKCalendarMonthView.h"

@protocol MonthViewControllerDelegate <NSObject>

@optional
- (void)didSelecteDate:(NSDate *)date;

@end

@interface MonthViewController : PPViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>

@property (assign, nonatomic) id<MonthViewControllerDelegate> aDelegate;

@property (retain, nonatomic) IBOutlet UIView *aBgView;

@property (retain, nonatomic) IBOutlet UIButton *currentMonthButton;
@property (retain, nonatomic) IBOutlet UIButton *nextMonthButton;
@property (retain, nonatomic) IBOutlet UIView *monthHolderView;
@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;

- (id)initWithBookings:(NSArray *)bookings routeType:(int)routeType;
- (void)showInView:(UIView *)superView;

@end
