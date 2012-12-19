//
//  RouteFeekbackController.m
//  Travel
//
//  Created by Orange on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RouteFeekbackController.h"

#import "PPTableViewController.h"   //(have not found the exact header for using NSLS)
#import "PPNetworkRequest.h"
#import "UIViewUtils.h"
#import "FontSize.h"
#import "ImageManager.h"

#define MAX_LENGTH_OF_FEEKBACK 160

@interface RouteFeekbackController ()
{
    int _rank;
}

@property (retain, nonatomic) Order *order;

@end

@implementation RouteFeekbackController

@synthesize order = _order;
@synthesize backgroundImageButton1;
@synthesize backgroundImageButton2;
@synthesize backgroundImageButton3;

@synthesize feekbackTextView;
@synthesize feekbackImageView;
@synthesize backgroundScrollView;

#pragma mark - View lifecycle


- (void)dealloc {
    [backgroundImageButton1 release];
    [backgroundImageButton2 release];
    [backgroundImageButton3 release];
    
    [feekbackTextView release];
    [feekbackImageView release];
    [_order release];
    [backgroundScrollView release];
    [super dealloc];
}

- (id)initWithOrder:(Order *)order
{
    if (self = [super init]) {
        self.order = order;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"评价");
    [self setNavigationRightButton:NSLS(@"发送")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"  
                            action:@selector(clickSubmit:)];
    
    self.backgroundScrollView.contentSize = CGSizeMake(self.backgroundScrollView.frame.size.width, self.backgroundScrollView.frame.size.height + 1);
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    // Set feekback text view delegate.
    self.feekbackTextView.text = _order.feedback;
    self.feekbackTextView.delegate = self;
    self.feekbackTextView.placeholder = NSLS(@"请输入您的评价!");
    self.feekbackTextView.font = [UIFont systemFontOfSize:13];

    self.feekbackTextView.placeholderColor = [UIColor lightGrayColor];    
    
    _rank = _order.praiseRank;
    [self updateRankView];
}

-(void) clickSubmit: (id) sender
{

    NSString *feekback = [self.feekbackTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; 
    feekback = [feekback stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([feekback compare:@""] == 0) {
        [self popupMessage:NSLS(@"请输入意见或建议") title:nil];
        return;
    }
    
    if ([feekback lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > MAX_LENGTH_OF_FEEKBACK) {
        [self popupMessage:NSLS(@"反馈意见字数太长") title:nil];
        return;
    }
  
    [feekbackTextView resignFirstResponder];
    [[RouteService defaultService] routeFeedbackWithRouteId:_order.routeId 
                                                    orderId:_order.orderId
                                                       rank:_rank 
                                                    content:feekback 
                                             viewController:self];
}

-(void) routeFeekBackDidSend:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，发送失败") title:nil];
        return;
    }
    
    if (result != 0) {
        NSString *str = [NSString stringWithFormat:NSLS(@"发送失败：%@"), resultInfo];
        [self popupMessage:str title:nil];
        return;
    }
    
    [self popupMessage:NSLS(@"提交成功，感谢您的评价") title:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setBackgroundImageButton1:nil];
    [self setBackgroundImageButton2:nil];
    [self setBackgroundImageButton3:nil];
    [self setFeekbackTextView:nil];
    [self setFeekbackImageView:nil];
    [self setBackgroundScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickChangeBackgroundButton1:(id)sender {
    _rank = 1;
    [self updateRankView];
}

- (IBAction)clickChangeBackgroundButton2:(id)sender {
    _rank = 2;
    [self updateRankView];
}

- (IBAction)clickChangeBackgroundButton3:(id)sender {
    _rank = 3;
    [self updateRankView];
}

- (IBAction)clickLeftCornerButton:(id)sender {
    _rank = 0;
    [self updateRankView];
}

- (void)updateRankView
{
    switch (_rank) {
        case 0:
            backgroundImageButton1.selected = NO;
            backgroundImageButton2.selected = NO;
            backgroundImageButton3.selected = NO;
            break;
        case 1:
            backgroundImageButton1.selected = YES;
            backgroundImageButton2.selected = NO;
            backgroundImageButton3.selected = NO;
            break;
        case 2:
            backgroundImageButton1.selected = YES;
            backgroundImageButton2.selected = YES;
            backgroundImageButton3.selected = NO;
            break;
        case 3:
            backgroundImageButton1.selected = YES;
            backgroundImageButton2.selected = YES;
            backgroundImageButton3.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)hideKeyboardButton:(id)sender {
    [feekbackTextView resignFirstResponder];
}


@end
