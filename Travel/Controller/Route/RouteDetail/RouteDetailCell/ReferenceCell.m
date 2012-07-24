//
//  ReferenceCell.m
//  Travel
//
//  Created by haodong qiu on 12年7月24日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ReferenceCell.h"

@implementation ReferenceCell
@synthesize contentWebView;

- (void)dealloc {
    [contentWebView release];
    [super dealloc];
}

+ (NSString *)getCellIdentifier
{
    return @"ReferenceCell";
}


@end
