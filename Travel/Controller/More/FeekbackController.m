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
#import "StringUtil.h"
#import "PPNetworkRequest.h"
#import "UIViewUtils.h"
#import "ImageManager.h"

#import "UserManager.h"
#import "FontSize.h"
@implementation FeekbackController
@synthesize viewCenter = _viewCenter;
@synthesize feekbackTextView;
@synthesize contactWayTextField;
@synthesize contactWayLabel;


#pragma mark -
#pragma mark: for view action

- (void)viewDidLoad
{
    // This method must be called before super viewDidLoad.
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:FEEDBACK];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    // Set feekback text view delegate.
    self.feekbackTextView.delegate = self;
    self.feekbackTextView.placeholder = NSLS(@"请输入您的建议或意见!");
    self.feekbackTextView.placeholderColor = [UIColor lightGrayColor];
    
    // Set navigation bar buttons
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"提交") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSubmit:)];
        
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
    
    
    if ([[UserManager defaultManager] isLogin]) {
        self.contactWayLabel.hidden = YES;
        self.contactWayTextField.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [self setFeekbackTextView:nil];
    [self setContactWayTextField:nil];
    [self setContactWayLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
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
    PPRelease(feekbackTextView);
    PPRelease(contactWayTextField);
    [contactWayLabel release];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.tag = 1;
//    PPDebug(@"textView.tag = 1");
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    textView.tag = 0;
//    PPDebug(@"textView.tag = 0");
    return YES;

}

#pragma mark -
#pragma mark: implementation of text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.tag = 1;
    PPDebug(@"textField.tag = 1");
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.tag = 0;
    PPDebug(@"textField.tag = 0");
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
    
    if ([contact compare:@""] == 0 && ![[UserManager defaultManager] isLogin]) {
        [self popupMessage:NSLS(@"请输入联系方式") title:nil];
        return;
    }
    
    if ((!((NSStringIsValidEmail(contact)) || (NSStringIsValidPhone(contact)))) && ![[UserManager defaultManager] isLogin]) {
        [self popupMessage:NSLS(@"请输入正确的Email或手机号码") title:nil];
        return;
    }
    
    PPDebug(@"feekback content length:%d",[feekback length]);
    
    if ([feekback length] > MAX_LENGTH_OF_FEEKBACK) {
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
- (void)submitFeekbackDidFinish:(int)resultCode
{
    if (resultCode == ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"提交成功，感谢您的意见和建议") title:nil];
        self.feekbackTextView.text = @"";
        self.contactWayTextField.text = @"";
    }
    else {
        [self popupMessage:NSLS(@"网络不稳定，提交失败") title:nil];
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
    
    PPDebug(@"feekbackTextView.tag=%d, textField.tag=%d", feekbackTextView.tag, contactWayTextField.tag);
    PPDebug(@"moveDistance=%f", y);
    
    [self.view moveTtoCenter:newCenter needAnimation:YES animationDuration:0.5];
    
    if (self.view.frame.origin.y > 0) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (CGFloat)getMoveDistance:(CGRect)frame keyboardHeight:(CGFloat)keyboardHeight
{
    return (self.view.frame.size.height-frame.origin.y-frame.size.height)-keyboardHeight-2;
}

//- (void)moveView:(UIView*)view toCenter:(CGPoint)center needAnimation:(BOOL)need
//{
//    if (need) {
//        [UIView beginAnimations:nil context:nil];
//        [UIImageView setAnimationDuration:0.5];
//        [view setCenter:center];
//        [UIImageView commitAnimations];        
//    }else{
//        [view setCenter:center];        
//    }
//}

- (void)keyboardDidHide:(NSNotification *)notification
{
    PPDebug(@"keyboardDidHide");
    [self.view moveTtoCenter:_viewCenter needAnimation:YES animationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
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
