//
//  FeekbackController.m
//  Travel
//
//  Created by 小涛 王 on 12-4-8.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "FeekbackController.h"
#import "PPDebug.h"
#import "ImageName.h"
#import "UIImageUtil.h"

@implementation FeekbackController
@synthesize viewCenter = _viewCenter;
@synthesize feekbackTextView;
@synthesize contactWayTextField;


#pragma mark -
#pragma mark: for view action

- (void)viewDidLoad
{
    // This method must be called before super viewDidLoad.
    [self setBackgroundImageName:@"all_page_bg2.jpg"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set feekback text view delegate.
    self.feekbackTextView.delegate = self;
    self.feekbackTextView.placeholder = NSLS(@"请输入您的建议或意见!");
    self.feekbackTextView.placeholderColor = [UIColor lightGrayColor];
    
    // Set navigation bar buttons
    [self setNavigationLeftButton:NSLS(@"返回") imageName:IMAGE_NAVIGATIONBAR_BACK_BTN action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"提交") imageName:@"topmenu_btn_right.png" action:@selector(clickSubmit:)];
        
    // Add a single tap Recognizer
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleTapRecognizer.numberOfTapsRequired = 1; // For single tap
    [self.view addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];
    
    // Save view center point
    _viewCenter = self.view.center;
    
    // Set text field delegate
    self.contactWayTextField.delegate = self;
}

- (void)viewDidUnload
{
    [self setFeekbackTextView:nil];
    [self setContactWayTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerKeyboardNotification];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self deregsiterKeyboardNotification];
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [feekbackTextView release];
    [contactWayTextField release];
    [super dealloc];
}

// Text view event queue.
//2012-04-09 11:34:22.215 Travel[29246:15b03] textViewShouldBeginEditing
//2012-04-09 11:34:22.217 Travel[29246:15b03] textViewDidChangeSelection
//2012-04-09 11:34:22.294 Travel[29246:15b03] textViewDidBeginEditing
//2012-04-09 11:34:22.298 Travel[29246:15b03] textViewDidChangeSelection
//2012-04-09 11:34:43.100 Travel[29246:15b03] textViewShouldEndEditing
//2012-04-09 11:34:43.103 Travel[29246:15b03] textViewDidEndEditing

#pragma mark -
#pragma mark: implementation of text view delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.tag = 1;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.tag = 0;
}

#pragma mark -
#pragma mark: implementation of text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.tag = 1;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.tag = 0;
    return YES;
}

#pragma mark -
#pragma mark: implementation of user action

#define MAX_LENGTH_OF_FEEKBACK 250
#define MAX_LENGTH_OF_CONTACT 80
- (void)clickSubmit:(id)sender
{
    NSString *contact = [self.contactWayTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *feekback = [self.feekbackTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([feekback compare:@""] == 0) {
        [self popupMessage:NSLS(@"请输入意见或建议") title:nil];
        return;
    }
    
    if ([contact compare:@""] == 0) {
        [self popupMessage:NSLS(@"请输入联系方式") title:nil];
        return;
    }
    
    if ([feekback lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > MAX_LENGTH_OF_FEEKBACK) {
        [self popupMessage:NSLS(@"反馈意见字数太长") title:nil];
        return;
    }
    
    if ([contact lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > MAX_LENGTH_OF_CONTACT) {
        [self popupMessage:NSLS(@"联系方式字数太长") title:nil];
        return;
    }
    
    [self hideKeyboard];
    PPDebug(@"contact = %@, feekback = %@", contact, feekback);
    [[UserService defaultService] submitFeekback:self feekback:feekback contact:contact];
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
    [self hideKeyboard];
}

- (IBAction)DidEndEditingTextField:(id)sender {
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.feekbackTextView resignFirstResponder];
    [self.contactWayTextField resignFirstResponder];
}

#pragma mark -
#pragma mark: implementation of user service delegate method
- (void)submitFeekbackDidFinish:(BOOL)success
{
    if (success) {
        [self popupMessage:NSLS(@"提交成功") title:nil];
    }
    else {
        [self popupMessage:NSLS(@"提交失败") title:nil];
    }
}


#pragma mark -
#pragma mark: implementation of keyboard action

- (void)keyboardDidShowWithRect:(CGRect)keyboardRect
{
}

- (void)keyboardDidShow:(NSNotification *)notification
{
	// adjust current view frame
    PPDebug(@"keyboardDidShow");

	// get keyboard frame
	NSDictionary* info = [notification userInfo];
	NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];	
    CGRect keyboardRect;
    [value getValue:&keyboardRect];
    
    CGRect frame = [self.view viewWithTag:1].frame;
    CGFloat height = keyboardRect.size.height;
    
    CGFloat y = [self getMoveDistance:frame
                       keyboardHeight:height];
    
    CGPoint newCenter = CGPointMake(_viewCenter.x, _viewCenter.y+y);
    
    [self moveView:self.view toCenter:newCenter needAnimation:YES];
}

- (CGFloat)getMoveDistance:(CGRect)frame keyboardHeight:(CGFloat)keyboardHeight
{
    return (self.view.frame.size.height-frame.origin.y-frame.size.height)-keyboardHeight-2;
}

- (void)moveView:(UIView*)view toCenter:(CGPoint)center needAnimation:(BOOL)need
{
    if (need) {
        [UIView beginAnimations:nil context:nil];
        [UIImageView setAnimationDuration:0.5];
        [view setCenter:center];
        [UIImageView commitAnimations];        
    }else{
        [view setCenter:center];        
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    PPDebug(@"keyboardDidHide");
    [self moveView:self.view toCenter:_viewCenter needAnimation:YES];
}

- (void)registerKeyboardNotification
{
	// create notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)deregsiterKeyboardNotification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];	
}

@end
