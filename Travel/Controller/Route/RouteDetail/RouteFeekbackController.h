//
//  RouteFeekbackController.h
//  Travel
//
//  Created by Orange on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "RouteService.h"

#import "UIPlaceholderTextView.h"
@interface RouteFeekbackController : PPTableViewController <RouteServiceDelegate,UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *backgroundImageButton1;
@property (retain, nonatomic) IBOutlet UIButton *backgroundImageButton2;
@property (retain, nonatomic) IBOutlet UIButton *backgroundImageButton3;

@property (retain, nonatomic) IBOutlet UIPlaceholderTextView *feekbackTextView;

@property (retain, nonatomic) IBOutlet UIImageView *feekbackImageView;

@property (retain, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
- (id)initWithOrder:(Order *)order;

@end
