//
//  TravelLoadingView.h
//  Travel
//
//  Created by haodong on 13-3-21.
//
//

#import <UIKit/UIKit.h>

@interface TravelLoadingView : UIView

@property (retain, nonatomic) IBOutlet UILabel *tipsLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (assign, nonatomic) BOOL isClickCloseButton;

+ (id)createTravelLoadingView;

- (void)showLoading:(NSString *)text;
- (void)hideLoading;

@end
