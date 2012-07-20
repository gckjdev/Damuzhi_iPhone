//
//  CustomTourController.m
//  Travel
//
//  Created by haodong qiu on 12年7月19日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "CustomTourController.h"
#import "AppDelegate.h"

@interface CustomTourController ()

@end

@implementation CustomTourController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLS(@"定制游");
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"djy_page_bg.jpg"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:NO];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:YES];
    [super viewDidDisappear:animated];
}

@end
