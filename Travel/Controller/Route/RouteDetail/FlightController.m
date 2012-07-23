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
@synthesize backgroundScrollView;



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
    [backgroundScrollView release];
    [super dealloc];
}

- (id)initWithDepartReturnFlight:(Flight *)departFlight returnFlight:(Flight *)returnFlight
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
    
    
    
    PPDebug(@"_departFlight is %@", _departFlight);
    [self.backgroundScrollView setContentSize:CGSizeMake(self.backgroundScrollView.frame.size.width, self.backgroundScrollView.frame.size.height+1)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    


    
    departFlightLabel.text = [NSString stringWithFormat:@"出发 : %@ - %@   %@ %@",
                              _departFlight.departCityName, _departFlight.arriveCityName,
                              _departFlight.company, _departFlight.flightId];    

    departFlightLaunchInfoLabel.text = [NSString stringWithFormat:@"%@ 起飞 %@", _departFlight.departTime, _departFlight.departAirport];
    
    departFlightDescendInfoLabel.text = [NSString stringWithFormat:@"%@ 降落 %@", _departFlight.arriveTime, _departFlight.arriveAirport];
    
    departFlightModeLabel.text = [NSString stringWithFormat:@"%@", _departFlight.mode];
   

    returnFlightLabel.text = [NSString stringWithFormat:@"出发 : %@ - %@   %@ %@",
                              _returnFlight.departCityName, _returnFlight.arriveCityName,
                              _returnFlight.company, _returnFlight.flightId];       
    
    returnFlightLaunchInforLabel.text = [NSString stringWithFormat:@"%@ 起飞 %@", _returnFlight.departTime, _returnFlight.departAirport];

    returnFlightDescendInforLabel.text = [NSString stringWithFormat:@"%@ 降落 %@", _returnFlight.arriveTime, _returnFlight.arriveAirport];
     returnFlightModeLabel.text = [NSString stringWithFormat:@"%@", _returnFlight.mode];    
    
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
    [self setBackgroundScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
