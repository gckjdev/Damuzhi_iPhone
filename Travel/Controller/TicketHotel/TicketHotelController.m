//
//  TicketHotelController.m
//  Travel
//
//  Created by kaibin on 12-9-21.
//
//

#import "TicketHotelController.h"
#import "AppDelegate.h"

@interface TicketHotelController ()

@end

@implementation TicketHotelController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLS(@"机+酒");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)hideTabBar:(BOOL)isHide
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:isHide];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self hideTabBar:NO];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [self hideTabBar:YES];
    [super viewDidDisappear:animated];
}

@end
