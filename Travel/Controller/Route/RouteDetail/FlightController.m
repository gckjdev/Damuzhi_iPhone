//
//  FlightController.m
//  Travel
//
//  Created by 小涛 王 on 12-7-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "FlightController.h"
#import "PPDebug.h"
#import "TouristRoute.pb.h"
#import "ImageManager.h"
#import "UIImageUtil.h"
@interface FlightController ()

@property (retain, nonatomic) Flight *departFlight;
@property (retain, nonatomic) Flight *returnFlight;
@end

@implementation FlightController

@synthesize departFlight = _departFlight;
@synthesize returnFlight = _returnFlight;
@synthesize departFlightLabel;
@synthesize departFlightLaunchInfoLabel;
@synthesize departFlightDescendInfoLabel;
@synthesize departFlightModeLabel;
@synthesize returnFlightLabel;
@synthesize returnFlightLaunchInforLabel;
@synthesize returnFlightDescendInforLabel;
@synthesize returnFlightModeLabel;
@synthesize returnFlightBackgroundImage;
@synthesize returnFlightBackgroundImage2;



- (void)dealloc {
    [_departFlight release];

    [returnFlightBackgroundImage release];
    [returnFlightBackgroundImage2 release];
    [departFlightLabel release];
    [departFlightLaunchInfoLabel release];
    [departFlightDescendInfoLabel release];
    [departFlightModeLabel release];
    [returnFlightLabel release];
    [returnFlightLaunchInforLabel release];
    [returnFlightDescendInforLabel release];
    [returnFlightModeLabel release];
    [super dealloc];
}

- (id)initWithDepartFlight:(Flight *)departFlight returnFlight:(Flight *)returnFlight
{
    if (self = [super init]) {
        self.departFlight = departFlight;
        self.returnFlight = returnFlight;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    self.navigationItem.title = NSLS(@"机票详情");
    
    
    
    
//    UIImage *background = [UIImage strectchableImageName:@"line_table_4a@2x.png"leftCapWidth:20];
//    returnFlightBackgroundImage.image = background;
    
    UIImage *returnBackground = [UIImage imageNamed:@"line_table_4a@2x.png"];
    UIImage *stretchBackgroundImage = [returnBackground stretchableImageWithLeftCapWidth:12 topCapHeight:0]; 
    returnFlightBackgroundImage.image = stretchBackgroundImage;
    
//    
//    UIImage *returnBackground2 = [UIImage strectchableImageName:@"line_table_4b@2x.png" leftCapWidth:20 topCapHeight:20];
//    returnFlightBackgroundImage.image = returnBackground2;  
    
    
    
    PPDebug(@"_departFlight is %@", _departFlight);
    
    
//    departFlightLabel.text = _departFlight.note;
    departFlightLabel.text = NSLS(@"出发 : 北京 - 泰国   南航 NF102");
    departFlightLaunchInfoLabel.text = NSLS(@"20:45 起飞 首都国际机场");
    departFlightDescendInfoLabel.text = NSLS(@"22:45 降落 曼谷机场");
    departFlightModeLabel.text = NSLS(@"波音747");
    returnFlightLabel.text = NSLS(@"回程 : 泰国 - 北京   泰国航空 TG0103");
    returnFlightLaunchInforLabel.text = NSLS(@"20:45 起飞 曼谷机场");
    returnFlightDescendInforLabel.text = NSLS(@"22.55 降落 首都国际机场");
    returnFlightModeLabel.text = NSLS(@"机型待定");
    
}  

- (void)viewDidUnload
{    
   
    [self setReturnFlightBackgroundImage:nil];
    [self setReturnFlightBackgroundImage2:nil];
    [self setDepartFlightLabel:nil];
    [self setDepartFlightLaunchInfoLabel:nil];
    [self setDepartFlightDescendInfoLabel:nil];
    [self setDepartFlightModeLabel:nil];
    [self setReturnFlightLabel:nil];
    [self setReturnFlightLaunchInforLabel:nil];
    [self setReturnFlightDescendInforLabel:nil];
    [self setReturnFlightModeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
