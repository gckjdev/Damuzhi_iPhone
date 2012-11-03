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
- (void)didChangeFrame:(CGRect)frame;

@end

@interface MonthViewController : PPViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>

@property (retain, nonatomic) TKCalendarMonthView *monthView;
@property (assign, nonatomic) id<MonthViewControllerDelegate> aDelegate;

@property (retain, nonatomic) IBOutlet UIView *aBgView;

@property (retain, nonatomic) IBOutlet UIButton *currentMonthButton;
@property (retain, nonatomic) IBOutlet UIButton *nextMonthButton;
@property (retain, nonatomic) IBOutlet UIView *monthHolderView;
@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (retain, nonatomic) IBOutlet UIImageView *rightLineImageView;

//- (id)initWithBookings:(NSArray *)bookings;
//- (id)initWithBookings:(NSArray *)bookings routeType:(int)routeType;
- (id)initWithBookings:(NSArray *)bookings currency:(NSString *)currency;

- (void)showInView:(UIView *)superView;

@end
