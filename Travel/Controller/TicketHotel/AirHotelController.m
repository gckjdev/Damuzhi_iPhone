//
//  AirHotelController.m
//  Travel
//
//  Created by kaibin on 12-9-21.
//
//

#import "AirHotelController.h"
#import "AppDelegate.h"
#import "CommonMonthController.h"

@interface AirHotelController ()

@end

@implementation AirHotelController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLS(@"机+酒");
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"djy_page_bg.jpg"]]];
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

- (IBAction)clickDate:(id)sender
{
    CommonMonthController *controller = [[[CommonMonthController alloc] initWithDelegate:nil monthCount:12 title:NSLS(@"出发日期")] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
