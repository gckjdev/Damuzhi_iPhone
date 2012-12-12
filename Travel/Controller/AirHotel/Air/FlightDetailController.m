//
//  FlightDetailController.m
//  Travel
//
//  Created by haodong on 12-12-10.
//
//

#import "FlightDetailController.h"
#import "FlightSeatView.h"
#import "FontSize.h"

@interface FlightDetailController ()
@property (retain, nonatomic) NSMutableArray *seatViewList;
@end

@implementation FlightDetailController

- (void)dealloc {
    [_flightSeatScrollView release];
    [_flightSeatPageControl release];
    [_seatViewList release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.seatViewList = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidUnload {
    [self setFlightSeatScrollView:nil];
    [self setFlightSeatPageControl:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"航班详情");
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    
    self.flightSeatScrollView.pagingEnabled = YES;
    self.flightSeatScrollView.showsHorizontalScrollIndicator = NO;
    self.flightSeatPageControl.enabled = NO;
    [self.flightSeatPageControl setPageIndicatorImageForCurrentPage:[UIImage imageNamed:@"flight_point_on.png"] forNotCurrentPage:[UIImage imageNamed:@"flight_point_off.png"]];
    [self createSeatViewList];
}

- (void)createSeatViewList
{
    //test data
    for (int i = 0 ; i < 5; i++) {
        FlightSeatView *view = [FlightSeatView createFlightSeatView];
        
        view.frame = CGRectMake(view.frame.size.width * i, 0, view.frame.size.width, view.frame.size.height);
        [self.flightSeatScrollView addSubview:view];
    }
    
    self.flightSeatScrollView.contentSize = CGSizeMake(320 * 5, self.flightSeatScrollView.contentSize.height);
    self.flightSeatPageControl.numberOfPages = 5;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    [_flightSeatPageControl setCurrentPage:offset.x / scrollView.frame.size.width];
}

@end
