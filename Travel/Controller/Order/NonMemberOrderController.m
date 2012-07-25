//
//  NONMemberOrder.m
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "NonMemberOrderController.h"
#import "StringUtil.h"
#import "UserManager.h"
#import "PPNetworkRequest.h"
#import "TimeUtils.h"

#define TAG_TEXT_FIELD_CONTACT_PERSON 111
#define TAG_TEXT_FIELD_TELEPHONE 112

@interface NonMemberOrderController ()

@property (retain, nonatomic) TouristRoute *route;
@property (retain, nonatomic) NSDate *departDate;
@property (assign, nonatomic) int adult;
@property (assign, nonatomic) int children;
@property (retain, nonatomic) NSString * contactPersonName;
@property (retain, nonatomic) NSString * contactPhone;

@end

@implementation NonMemberOrderController

@synthesize route = _route;
@synthesize departDate = _departDate;
@synthesize adult = _adult;
@synthesize children = _children;
@synthesize contactPersonName = _contactPersonName;
@synthesize contactPhone = _contactPhone;
@synthesize routeNameLabel;
@synthesize contactPersonTextField;
@synthesize telephoneTextField;
@synthesize delegate;
@synthesize backGroundScrollView;

- (void)dealloc {
    [_route release];
    [_departDate release];
    
    [routeNameLabel release];
    [contactPersonTextField release];
    [telephoneTextField release];
    [backGroundScrollView release];
    [_contactPersonName release];
    [_contactPhone release];
    [super dealloc];
}

- (id)initWithRoute:(TouristRoute *)route
         departDate:(NSDate *)departDate
              adult:(int)adult
           children:(int)children;
{
    if (self = [super init]) {
        self.route = route;
        self.departDate = departDate;
        self.adult = adult;
        self.children = children;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set navigation bar buttons
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    self.navigationItem.title = NSLS(@"确认预订");
    
    [self setNavigationRightButton:NSLS(@"确认") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSubmit:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    
    self.backGroundScrollView.contentSize = CGSizeMake(self.backGroundScrollView.frame.size.width, self.backGroundScrollView.frame.size.height + 1);
    routeNameLabel.text = _route.name;
    
    contactPersonTextField.tag = TAG_TEXT_FIELD_CONTACT_PERSON;
    telephoneTextField.tag = TAG_TEXT_FIELD_TELEPHONE;
    
    contactPersonTextField.delegate = self;
    telephoneTextField.delegate = self;
    
    // Add a single tap Recognizer
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleTapRecognizer.numberOfTapsRequired = 1; // For single tap
    [self.view addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];

    [self setContactPersonTextField:nil];
    [self setTelephoneTextField:nil];
    [self setBackGroundScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [telephoneTextField resignFirstResponder];
    [contactPersonTextField resignFirstResponder];
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField              
{
    switch (textField.tag) {
        case TAG_TEXT_FIELD_CONTACT_PERSON:
            [telephoneTextField becomeFirstResponder];
            break;
            
        case TAG_TEXT_FIELD_TELEPHONE:
            [self hideKeyboard];
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (void)clickSubmit:(id)sender
{
   
    NSString *contactPerson = contactPersonTextField.text;
    NSString *telephone = telephoneTextField.text;
    contactPerson = [contactPerson stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    contactPerson = [contactPerson stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (contactPerson == nil || [contactPerson length] == 0) {
        [self popupMessage:NSLS(@"姓名不能为空，请您重新输入") title:nil];
        return;     
    }
    
    if (!NSStringIsValidChinese(contactPerson) ) {
        [self popupMessage:@"联系人姓名只能用中文，请重新输入" title:nil];
        return;
    }
    
    if (!NSStringIsValidPhone(telephone)) {
        [self popupMessage:NSLS(@"您输入的手机号码有误，请重新输入") title:nil];
        return;
    }
    
//    if ([delegate respondsToSelector:@selector(didclickSubmit:telephone:)]) {
//                    [delegate didclickSubmit:contactPerson telephone:telephone];
//                    [self.navigationController popViewControllerAnimated:YES];       
//    }
    
    self.contactPersonName = contactPerson;
    self.contactPhone = telephone;
    
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:nil message:@"是否预订" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil] autorelease];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView1 didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * str1 = [alertView1 buttonTitleAtIndex:buttonIndex];
    if ([str1 isEqualToString:@"确定"])
    {
        if ([delegate respondsToSelector:@selector(didclickSubmit:telephone:)])
        {
            [delegate didclickSubmit:_contactPersonName telephone:_contactPhone];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
