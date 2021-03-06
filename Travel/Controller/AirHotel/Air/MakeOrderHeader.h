//
//  MakeOrderHeader.h
//  Travel
//
//  Created by haodong on 12-11-28.
//
//

#import <UIKit/UIKit.h>


typedef enum{
    AirHeader = 0,
    HotelHeader = 1
} AirHotelHeaderType;

typedef enum{
    AirNone = 0,
    AirGo = 1,
    AirGoAndBack = 2,
    AirBack = 3,
} AirType;




/***************************************************/
@protocol MakeAirOrderCellDelegate <NSObject>
@optional
- (void)didClickDepartCityButton;
- (void)didClickGoDateButton;
- (void)didClickBackDateButton;
- (void)didClickGoFlightButton;
- (void)didClickBackFlightButton;

- (void)didClickClearDepartCity;
- (void)didClickClearGoDate;
- (void)didClickClearBackDate;
- (void)didClickClearGoFlight;
- (void)didClickClearBackFlight;
@end



/***************************************************/
@protocol MakeOrderHeaderDelegate <NSObject>

@optional
- (void)didClickCloseButton:(NSInteger)section;
- (void)didClickDeleteButton:(NSInteger)section;
- (void)didClickGoButton;
- (void)didClickGoAndBackButton;
- (void)didClickBackButton;

@end


@interface MakeOrderHeader : UIView

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;

+ (id)createHeaderView;
+ (CGFloat)getHeaderViewHeight;

- (void)setViewWithDelegate:(id<MakeOrderHeaderDelegate>)delegate
                    section:(NSInteger)section
         airHotelHeaderType:(AirHotelHeaderType)type
         isHideFilterButton:(BOOL)isHideFilterButton
        selectedButtonIndex:(int)index
          isHideCloseButton:(BOOL)isHideCloseButton
                    isClose:(BOOL)isClose
         isHideDeleteButton:(BOOL)isHideDeleteButton;

@end
