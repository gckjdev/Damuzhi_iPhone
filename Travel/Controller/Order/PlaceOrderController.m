//
//  PlaceOrderController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceOrderController.h"
#import "NSDate+TKCategory.h"
#import "TKCalendarMonthView.h"
#import "AppManager.h"
#import "TimeUtils.h"
#import "ImageManager.h"
#import "UserManager.h"
#import "LoginController.h"

@interface PlaceOrderController ()
{
    int _routeType;
}

@property (retain, nonatomic) TouristRoute *route;
@property (retain, nonatomic) MonthViewController *monthViewController;
@property (retain, nonatomic) NSDate *departDate;
@property (assign, nonatomic) int adult;
@property (assign, nonatomic) int children;
@property (retain, nonatomic) NSMutableArray *selectedAdultIdList;
@property (retain, nonatomic) NSMutableArray *selectedChildrenIdList;
@property (assign, nonatomic) int packageId;
@property (retain, nonatomic) NonMemberOrderController *nonMemberOrderController;

@end

@implementation PlaceOrderController
@synthesize routeNameLabel = _routeNameLabel;
@synthesize routeIdLabel = _routeIdLabel;
@synthesize departCityLabel = _departCityLabel;
@synthesize departDateButton = _departDateButton;
@synthesize adultButton = _adultButton;
@synthesize childrenButton = _childrenButton;
@synthesize priceLabel = _priceLabel;
@synthesize noteLabel = _noteLabel;
@synthesize route = _route;
@synthesize monthViewController = _monthViewController;
@synthesize departDate = _departDate;
@synthesize adult = _adult;
@synthesize children = _children;
@synthesize packageId = _packageId;
@synthesize nonMemberOrderController = _nonMemberOrderController;

@synthesize selectedAdultIdList = _selectedAdultIdList;
@synthesize selectedChildrenIdList = _selectedChildrenIdList;


- (void)dealloc
{
    [_route release];
    [_monthViewController release];
    [_departDate release];
    [_selectedAdultIdList release];
    [_selectedChildrenIdList release];
    
    [_routeNameLabel release];
    [_routeIdLabel release];
    [_departCityLabel release];
    [_priceLabel release];
    [_departDateButton release];
    [_adultButton release];
    [_childrenButton release];
    [_noteLabel release];
    PPRelease(_nonMemberOrderController);
    [super dealloc];
}

- (id)initWithRoute:(TouristRoute *)route 
          routeType:(int)routeType
          packageId:(int)packageId
{
    if (self = [super init]) {
        self.route = route;
        _routeType = routeType;
        self.packageId = packageId;
        self.selectedAdultIdList = [NSMutableArray array];
        self.selectedChildrenIdList = [NSMutableArray array];
        self.adult = 1;
        self.children = 0;

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib. 
    
    self.title = @"线路预订";
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    
    [self.departDateButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];
    [self.adultButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];   
    [self.childrenButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];
    
    self.noteLabel.text = NSLS(@"说明:\n预订成功后，系统将会发送短信通知您订单预订情况，稍后客服会通过电话联系您确认订单");
    
    self.routeNameLabel.text = _route.name;
    self.routeIdLabel.text = [NSString stringWithFormat:@"%d", _route.routeId];
    self.departCityLabel.text = [[AppManager defaultManager] getDepartCityName:_route.departCityId];
    self.priceLabel.text = _route.price;
    
    [_selectedAdultIdList addObject:[NSNumber numberWithInt:_adult]];
    [_selectedChildrenIdList addObject:[NSNumber numberWithInt:_children]];
    
    [self.adultButton setTitle:[NSString stringWithFormat:[NSString stringWithFormat:NSLS(@"成人%d位"), _adult]] forState:UIControlStateNormal];
    [self.childrenButton setTitle:[NSString stringWithFormat:[NSString stringWithFormat:NSLS(@"儿童%d位"), _children]] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];
    [self setRouteIdLabel:nil];
    [self setDepartCityLabel:nil];
    [self setPriceLabel:nil];
    [self setDepartDateButton:nil];
    [self setAdultButton:nil];
    [self setChildrenButton:nil];
    [self setNoteLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)clickDepartDateButton:(id)sender {
    self.monthViewController = [[[MonthViewController alloc] initWithBookings:_route.bookingsList] autorelease];
    _monthViewController.aDelegate = self;
    [_monthViewController.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    [self.navigationController pushViewController:_monthViewController animated:YES];
}

- (IBAction)clickAdultButton:(id)sender {
    
    SelectController *controller = [[SelectController alloc] initWithTitle:NSLS(@"出游人数")
                                                                  itemList:[[AppManager defaultManager] buildAdultItemList]  selectedItemIds:_selectedAdultIdList
                                                              multiOptions:NO 
                                                               needConfirm:NO 
                                                             needShowCount:NO];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickChildrenButton:(id)sender {
    
    SelectController *controller = [[SelectController alloc] initWithTitle:NSLS(@"出游人数")
                                                                  itemList:[[AppManager defaultManager] buildChildrenItemList]  selectedItemIds:_selectedChildrenIdList
                                                              multiOptions:NO 
                                                               needConfirm:NO 
                                                             needShowCount:NO];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickMemberBookButton:(id)sender {
    UserManager *manager = [UserManager defaultManager];
    
    if ([manager isLogin]) {
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *departDateStr = [dateFormatter stringFromDate:self.departDate];
        
        OrderService *service = [OrderService defaultService];
        [service placeOrderUsingLoginId:[manager loginId] 
                                  token:[manager token]
                                routeId:_route.routeId 
                              packageId:_packageId
                             departDate:departDateStr 
                                  adult:_adult 
                               children:_children 
                          contactPerson:nil
                              telephone:nil
                               delegate:self];
    } else {
        LoginController *controller  = [[LoginController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

- (IBAction)clickNonMemberBookButton:(id)sender {
    
    if (_departDate == nil) {
        [self popupMessage:NSLS(@"请选择出发日期") title:nil];
        return;
    }
    
    if (_nonMemberOrderController == nil) {
        NonMemberOrderController *controller = [[NonMemberOrderController alloc] initWithRoute:_route 
                                                                                     departDate:_departDate 
                                                                                          adult:_adult 
                                                                                       children:_children];
        controller.delegate = self;
        self.nonMemberOrderController = controller;
        [controller release];
    }
    
    [self.navigationController pushViewController:_nonMemberOrderController animated:YES];
}

- (void)didSelecteDate:(NSDate *)date
{
    self.departDate = date;
    [self.departDateButton setTitle:dateToChineseString(date) forState:UIControlStateNormal];
    
    [_monthViewController.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectFinish:(NSArray*)selectedItems
{
    self.adult = [[_selectedAdultIdList objectAtIndex:0] intValue];
    self.children = [[_selectedChildrenIdList objectAtIndex:0] intValue];

    [self.adultButton setTitle:[NSString stringWithFormat:[NSString stringWithFormat:NSLS(@"成人%d位"), _adult]] forState:UIControlStateNormal];
    [self.childrenButton setTitle:[NSString stringWithFormat:[NSString stringWithFormat:NSLS(@"儿童%d位"), _children]] forState:UIControlStateNormal];   
}

#pragma mark - OrderServiceDelegate methods
- (void)placeOrderDone:(int)resultCode result:(int)result reusultInfo:(NSString *)resultInfo
{
    if (resultCode == 0) {
        if ( result == 0) {
             [self popupMessage:NSLS(@"预订成功") title:nil];
        } else {
            [self popupMessage:resultInfo title:nil];
        }
    }else {
        [self popupMessage:NSLS(@"网络弱，请稍后再试") title:nil];
    }
}

#pragma mark - NonMemberOrderDelegate
- (void)didclickSubmit:(NSString *)contactPerson telephone:(NSString *)telephone
{
    UserManager *manager = [UserManager defaultManager];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *departDateStr = [dateFormatter stringFromDate:self.departDate];
    
    OrderService *service = [OrderService defaultService];
    [service placeOrderUsingUserId:[manager getUserId]  
                           routeId:_route.routeId  
                         packageId:_packageId 
                        departDate:departDateStr 
                             adult:_adult 
                          children:_children 
                     contactPerson:contactPerson 
                         telephone:telephone 
                          delegate:self];
}

@end
