//
//  HotelHeaderView.h
//  Travel
//
//  Created by haodong on 12-11-24.
//
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@protocol  HotelHeaderViewDelegate <NSObject>

@optional
- (void)didClickSelectButton:(NSInteger)section;
@end


@class Place;
@interface HotelHeaderView : UIView <HJManagedImageVDelegate>

@property (retain, nonatomic) IBOutlet UIButton *selectButton;
@property (retain, nonatomic) IBOutlet HJManagedImageV *iconView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *starLabel;
@property (retain, nonatomic) IBOutlet UIView *rankView;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UIImageView *hotelListBgImageView;


@property (assign, nonatomic) id<HotelHeaderViewDelegate> delegate;



+ (id)createHeaderView;

+ (CGFloat)getHeaderViewHeight;

- (void)setViewWith:(Place *)hotel
            section:(NSInteger)section
         isSelected:(BOOL)isSelected;

@end
