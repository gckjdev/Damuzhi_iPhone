//
//  OrderManagerController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "OrderManagerController.h"
#import "ImageManager.h"
#import "TravelNetworkConstants.h"
#import "OrderListController.h"
#import "UIUtils.h"
#import "UserManager.h"
#import "LoginController.h"
#import "AppManager.h"

@interface OrderManagerController ()

@property (retain, nonatomic) NSArray *orderTypeList;
@property (retain, nonatomic) UIButton *loginoutButton;

@end

@implementation OrderManagerController

@synthesize orderTypeList = _orderTypeList;
@synthesize loginoutButton = _loginoutButton;

- (void)dealloc
{
    [_orderTypeList release];
    [_loginoutButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    self.title = @"订单管理";
    [self setBackgroundImageName:@"all_page_bg2.jpg"];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set navigation bar buttons
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];

    [self updateNavButtons];
    
    self.dataList = [NSArray arrayWithObjects:NSLS(@"跟团游订单管理"), NSLS(@"自由行订单管理"), NSLS(@"自定制订单管理"),nil];
    self.orderTypeList = [NSArray arrayWithObjects:[NSNumber numberWithInt:OBJECT_LIST_PACKAGE_TOUR_ORDER], [NSNumber numberWithInt:OBJECT_LIST_UNPACKAGE_TOUR_ORDER], [NSNumber numberWithInt:OBJECT_LIST_SELF_GUIDE_TOUR_ORDER], nil];
    
}

- (void)updateNavButtons
{
    if ([[UserManager defaultManager] isLogin]) {
        [self setNavigationRightButton:NSLS(@"退出登陆") 
                             imageName:@"topmenu_btn2.png"
                                action:@selector(clickLogout:)];
        
    }else {
        [self setNavigationRightButton:NSLS(@"会员登陆") 
                             imageName:@"topmenu_btn2.png"
                                action:@selector(clickLogin:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateNavButtons];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderManagerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.imageView.image = [[ImageManager defaultManager] morePointImage];
        
        UIImage* image = [[ImageManager defaultManager] accessoryImage];
        UIImageView* cellAccessoryView = [[UIImageView alloc] initWithImage:image];
        cell.accessoryView = cellAccessoryView;
        [cellAccessoryView release];
        
        cell.textLabel.textColor = [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
    }
    
	cell.textLabel.text = [dataList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListController *controller = [[OrderListController alloc] initWithOrderType:[[_orderTypeList objectAtIndex:indexPath.row] intValue]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

#define HEIGHT_FOOTER_VIEW 44

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_FOOTER_VIEW;
}


#define CUSTOMER_SERVICE_TELEPHONE @"400-800-888"
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_FOOTER_VIEW)] autorelease];
    
    [button addTarget:self action:@selector(clickCustomerServiceTelephone:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(65, HEIGHT_FOOTER_VIEW/2-8, 16, 16)] autorelease];
    imageView.image = [[ImageManager defaultManager] orderTel];
    [button addSubview:imageView];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(88, 0, 200, HEIGHT_FOOTER_VIEW)] autorelease];
    label.text = [NSString stringWithFormat:NSLS(@"客服电话：%@"), CUSTOMER_SERVICE_TELEPHONE];
    label.textColor = [UIColor colorWithRed:1 green:72.0/255.0 blue:0 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
    return button;
}

- (void)clickCustomerServiceTelephone:(id)sender
{
    NSString *telephone = [CUSTOMER_SERVICE_TELEPHONE stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [UIUtils makeCall:telephone];
}

- (void)clickLogout:(id)sender
{
    self.loginoutButton = (UIButton *)sender;
    _loginoutButton.enabled = NO;
    
    [[UserService defaultService] logout:self];
}

- (void)loginoutDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    _loginoutButton.enabled = YES;
    
    [self updateNavButtons];
}

- (void)clickLogin:(id)sender
{
    LoginController *controller = [[[LoginController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
