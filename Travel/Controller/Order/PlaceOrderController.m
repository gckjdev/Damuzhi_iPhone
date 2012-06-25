//
//  PlaceOrderController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceOrderController.h"
#import "NSDate+TKCategory.h"
#import "TKCalendarMonthView.h"

@interface PlaceOrderController ()

@property (retain, nonatomic) TKCalendarMonthView *monthView;


@end

@implementation PlaceOrderController

@synthesize monthView = _monthView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)clickDepartDateButton:(id)sender {

    
}
@end
