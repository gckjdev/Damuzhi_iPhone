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


@interface CommonMonthController : PPViewController <TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource, UIAlertViewDelegate>

@property (retain, nonatomic) NSDate *suggestStartDate;
@property (retain, nonatomic) NSDate *suggestEndDate;
@property (retain, nonatomic) NSString *suggestStartTips;
@property (retain, nonatomic) NSString *suggestEndTips;

- (id)initWithDelegate:(id<CommonMonthControllerDelegate>)delegate
       customStartDate:(NSDate *)customStartDate
         customEndDate:(NSDate *)customEndDate
            monthCount:(NSUInteger)monthCount
                 title:(NSString *)title;

@end
