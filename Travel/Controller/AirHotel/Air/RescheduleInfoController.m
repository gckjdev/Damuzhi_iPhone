//
//  RescheduleInfoController.m
//  Travel
//
//  Created by haodong on 12-12-19.
//
//

#import "RescheduleInfoController.h"
#import "FontSize.h"
#import "AirHotel.pb.h"

@interface RescheduleInfoController ()

@property (retain, nonatomic) AirOrder_Builder *builder;

@end

@implementation RescheduleInfoController

- (void)dealloc
{
    [_builder release];
    [super dealloc];
}

- (id)initWithAirOrderBuilder:(AirOrder_Builder *)builder
{
    self = [super init];
    if (self) {
        self.builder = builder;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"退改签详情");
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
}


@end
