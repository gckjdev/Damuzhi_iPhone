//
//  CityImageController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-22.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityImageController.h"
#import "AppManager.h"

#define EACH_COUNT 40

@interface CityImageController ()

@property (assign, nonatomic) int start;
@property (assign, nonatomic) int totalCount;

@end

@implementation CityImageController

@synthesize start = _start;
@synthesize totalCount = _totalCount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[CityOverviewService defaultService] findCityImages:[[AppManager defaultManager] getCurrentCityId] 
                                                   start:_start
                                                   count:EACH_COUNT 
                                                delegate:self];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)findRequestDone:(int)result totalCount:(int)totalCount cityImages:(NSArray *)cityImages
{
    
}

@end
