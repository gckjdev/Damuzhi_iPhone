//
//  PayView.h
//  Travel
//
//  Created by haodong on 13-1-29.
//
//

#import <UIKit/UIKit.h>
#import "Umpay.h"

@interface PayView : UIView
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (retain, nonatomic) IBOutlet UILabel *tipsLabel;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;

+ (id)createPayView;

- (void)show:(NSString *)tips
serialNumber:(NSString *)serialNumber
  controller:(UIViewController *)controller
    delegate:(id<UmpayDelegate>)delegate;

@end
