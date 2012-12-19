//
//  CommonMonthController.h
//  Travel
//
//  Created by haodong on 12-11-21.
//
//

#import "PPViewController.h"
#import "TKCalendarMonthView.h"

@class TKCalendarMonthView;
@protocol TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource;


@protocol CommonMonthControllerDelegate <NSObject>
@optional
- (void)didSelectDate:(NSDate *)date;
@end


@interface CommonMonthController : PPViewController <TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource>

- (id)initWithDelegate:(id<CommonMonthControllerDelegate>)delegate
            monthCount:(NSUInteger)monthCount
                 title:(NSString *)title;

@end
