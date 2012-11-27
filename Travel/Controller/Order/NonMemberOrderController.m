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
#import "TravelNetworkConstants.h"
#import "OrderListController.h"
#import "FontSize.h"
#import "ImageManager.h"

#define TAG_TEXT_FIELD_CONTACT_PERSON 111
#define TAG_TEXT_FIELD_TELEPHONE 112

@interface NonMemberOrderController ()

@property (retain, nonatomic) TouristRoute *route;
@property (retain, nonatomic) LocalRoute *localRoute;
@property (assign, nonatomic) int routeType;
@property (retain, nonatomic) NSDate *departDate;
@property (assign, nonatomic) int adult;
@property (assign, nonatomic) int children;
@property (retain, nonatomic) NSString * contactPersonName;
@property (retain, nonatomic) NSString * contactPhone;
@property (assign, nonatomic) int packageId;
@property (assign, nonatomic) int departPlaceId;

@end

@implementation NonMemberOrderController

@synthesize route = _route;
@synthesize localRoute = _localRoute;
@synthesize routeType = _routeType;
@synthesize departDate = _departDate;
@synthesize adult = _adult;
@synthesize children = _children;
@synthesize contactPersonName = _contactPersonName;
@synthesize contactPhone = _contactPhone;
@synthesize routeNameLabel;
@synthesize contactPersonTextField;
@synthesize telephoneTextField;
@synthesize backGroundScrollView;
@synthesize packageId = _packageId;
@synthesize departPlaceId = _departPlaceId;

- (void)dealloc {
    [_route release];
    [_localRoute release];
    [_departDate release];
    [routeNameLabel release];
    [contactPersonTextField release];
    [telephoneTextField release];
    [backGroundScrollView release];
    [_contactPersonName release];
    [_contactPhone release];
    [super dealloc];
}

- (id)initWithLocalRoute:(LocalRoute *)localRoute
               routeType:(int)routeType 
           departPlaceId:(int)departPlaceId
              departDate:(NSDate *)departDate
                   adult:(int)adult
                children:(int)children
{
    if (self = [super init]) {
        self.localRoute = localRoute;
        self.routeType = routeType;
        self.departDate = departDate;
        self.adult = adult;
        self.children = children;
        self.departPlaceId = departPlaceId;
    }
    
    return self;
}

- (id)initWithRoute:(TouristRoute *)route
          routeType:(int)routeType
         departDate:(NSDate *)departDate
              adult:(int)adult
           children:(int)children 
          packageId:(int)packageId
{
    if (self = [super init]) {
        self.route = route;
        self.routeType = routeType;
        self.departDate = departDate;
        self.adult = adult;
        self.children = children;
        self.packageId = packageId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set navigation bar buttons
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    self.navigationItem.title = NSLS(@"确认预订");
    
    [self setNavigationRightButton:NSLS(@"确认") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSubmit:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    self.backGroundScrollView.contentSize = CGSizeMake(self.backGroundScrollView.frame.size.width, self.backGroundScrollView.frame.size.height + 1);
    
    if (_routeType == OBJECT_LIST_LOCAL_ROUTE) {
        routeNameLabel.text = _localRoute.name;
    }else {
        routeNameLabel.text = _route.name;
    }
    
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
    
//    if (!NSStringIsValidChinese(contactPerson) ) {
//        [self popupMessage:@"联系人姓名只能用中文，请重新输入" title:nil];
//        return;
//    }
    
    if (!NSStringIsValidPhone(telephone)) {
        [self popupMessage:NSLS(@"您输入的手机号码有误，请重新输入") title:nil];
        return;
    }
    
    self.contactPersonName = contactPerson;
    self.contactPhone = telephone;
    
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:nil message:@"是否预订" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil] autorelease];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView1 didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //PPDebug(@"%@", _DEV_T)
    
    NSString * str1 = [alertView1 buttonTitleAtIndex:buttonIndex];
    if ([str1 isEqualToString:@"确定"])
    {        
        UserManager *manager = [UserManager defaultManager];
        OrderService *service = [OrderService defaultService];
        
        
        if (_routeType == OBJECT_LIST_LOCAL_ROUTE) {
            [service localRouteOrderUsingUserId:[manager getUserId]  
                                        routeId:_localRoute.routeId 
                                  departPlaceId:_departPlaceId 
                                     departDate:_departDate 
                                          adult:_adult 
                                       children:_children 
                                  contactPerson:_contactPersonName 
                                      telephone:_contactPhone 
                                       delegate:self];
        } else {
            [service placeOrderUsingUserId:[manager getUserId]  
                                   routeId:_route.routeId  
                                 packageId:_packageId 
                                departDate:_departDate 
                                     adult:_adult 
                                  children:_children 
                             contactPerson:_contactPersonName 
                                 telephone:_contactPhone
                                  delegate:self];
        }
    }
}


#pragma - mark OrderServiceDelegate methods
- (void)placeOrderDone:(int)resultCode
                result:(int)result
           reusultInfo:(NSString *)resultInfo
{
    if (resultCode != 0) 
    {
        [self popupMessage:NSLS(@"网络弱，请稍后再试") title:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (result != 0) {
        [self popupMessage:resultInfo title:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    int orderType;
    [self popupMessage:NSLS(@"已成功提交意向订单") title:nil];
    switch (_routeType) 
    {
        case OBJECT_LIST_ROUTE_PACKAGE_TOUR:
            orderType = OBJECT_LIST_PACKAGE_TOUR_ORDER;
            break;
        case OBJECT_LIST_ROUTE_UNPACKAGE_TOUR:
            orderType = OBJECT_LIST_UNPACKAGE_TOUR_ORDER;
            break;
        case OBJECT_LIST_ROUTE_SELF_GUIDE_TOUR:
            orderType = OBJECT_LIST_SELF_GUIDE_TOUR_ORDER;
            break;
        case OBJECT_LIST_LOCAL_ROUTE:
            orderType = OBJECT_LIST_LOCAL_ROUTE_ORDER;
        default:
            break;
    }
    
    OrderListController *controller = [[OrderListController alloc] initWithOrderType:orderType];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


@end
