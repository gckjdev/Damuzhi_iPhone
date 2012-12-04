//
//  MakeHotelOrderHeader.h
//  Travel
//
//  Created by haodong on 12-11-28.
//
//

#import <UIKit/UIKit.h>

@protocol MakeHotelOrderHeaderDelegate <NSObject>

@optional
- (void)didClickCloseButton:(NSInteger)section;
@end


@interface MakeHotelOrderHeader : UIView
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) id<MakeHotelOrderHeaderDelegate> delegate;

+ (id)createHeaderView;

+ (CGFloat)getHeaderViewHeight;

@end

