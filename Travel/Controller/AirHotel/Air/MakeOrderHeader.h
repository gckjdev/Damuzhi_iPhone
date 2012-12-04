//
//  MakeOrderHeader.h
//  Travel
//
//  Created by haodong on 12-11-28.
//
//

#import <UIKit/UIKit.h>

@protocol MakeOrderHeaderDelegate <NSObject>

@optional
- (void)didClickCloseButton:(NSInteger)section;
- (void)didClickGoButton;
- (void)didClickGoAndBackButton;
- (void)didClickBackButton;
@end


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

@interface MakeOrderHeader : UIView

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

+ (id)createHeaderView;
+ (CGFloat)getHeaderViewHeight;

- (void)setViewWithDelegate:(id<MakeOrderHeaderDelegate>)delegate
                    section:(NSInteger)section
         airHotelHeaderType:(AirHotelHeaderType)type
         isHideFilterButton:(BOOL)isHideFilterButton
        selectedButtonIndex:(int)index
          isHideCloseButton:(BOOL)isHideCloseButton
                    isClose:(BOOL)isClose;

@end
