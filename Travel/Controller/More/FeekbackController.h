//
//  FeekbackController.h
//  Travel
//
//  Created by 小涛 王 on 12-4-8.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPViewController.h"
#import "UserService.h"
#import "UIPlaceholderTextView.h"

#define FEEDBACK            NSLS(@"意见反馈")

@interface FeekbackController : PPViewController <UITextViewDelegate, UITextFieldDelegate, UserServiceDelegate>

@property (assign, nonatomic) CGPoint viewCenter;

@property (retain, nonatomic) IBOutlet UIPlaceholderTextView *feekbackTextView;

@property (retain, nonatomic) IBOutlet UITextField *contactWayTextField;

@property (retain, nonatomic) IBOutlet UILabel *contactWayLabel;


- (CGFloat)getMoveDistance:(CGRect)frame keyboardHeight:(CGFloat)keyboardHeight;

@end
