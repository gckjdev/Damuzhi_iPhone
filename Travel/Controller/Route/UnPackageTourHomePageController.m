//
//  UnPackageTourHomePageController.m
//  Travel
//
//  Created by 小涛 王 on 12-7-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "UnPackageTourHomePageController.h"
#import "LocaleUtils.h"
#import "FontSize.h"
@interface UnPackageTourHomePageController ()

@end

@implementation UnPackageTourHomePageController

- (void)viewDidLoad
{
    self.title = NSLS(@"自由行");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Init UI Interface
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
