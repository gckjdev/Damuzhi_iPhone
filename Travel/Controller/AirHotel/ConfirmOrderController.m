//
//  ConfirmOrderController.m
//  Travel
//
//  Created by haodong on 12-11-26.
//
//

#import "ConfirmOrderController.h"
#import "FontSize.h"
#import "AirHotel.pb.h"


@interface ConfirmOrderController ()

@property (retain, nonatomic) AirHotelOrder_Builder *builder;

@end

@implementation ConfirmOrderController
@synthesize builder = _builder;

- (void)dealloc
{
    [_builder release];
    [super dealloc];
}

- (id)initWithOrderBuilder:(AirHotelOrder_Builder *)builder
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
    self.title = NSLS(@"确认预订");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.view.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:239.0/255.0 blue:247.0/255.0 alpha:1];
}

- (IBAction)clickOrderButton:(id)sender {
    AirHotelOrder *order = [_builder build];
    [[AirHotelService defaultService] order:order delegate:self];

}

#pragma mark - 
#pragma AirHotelServiceDelegate methods
- (void)orderDone:(int)result
       resultInfo:(NSString *)resultInfo
{
    PPDebug(@"orderDone result:%d, resultInfo:%@", result, resultInfo);
    
    if (result == 0) {
        [self popupMessage:NSLS(@"预订成功") title:nil];
    }
}


@end
