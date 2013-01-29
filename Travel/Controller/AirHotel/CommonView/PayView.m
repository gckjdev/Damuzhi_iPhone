//
//  PayView.m
//  Travel
//
//  Created by haodong on 13-1-29.
//
//

#import "PayView.h"
#import "UPPayPluginUtil.h"
#import "TravelNetworkConstants.h"

@interface PayView()
@property (retain, nonatomic) NSString *paymentInfo;
@property (retain, nonatomic) UIViewController *controller;
@property (assign, nonatomic) id<UPPayPluginDelegate> delegate;

@end

@implementation PayView

- (void)dealloc {
    [_activityView release];
    [_tipsLabel release];
    [_paymentInfo release];
    [_controller release];
    [super dealloc];
}

+ (id)createPayView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PayView" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create PayView but cannot find Nib");
        return nil;
    }
    return  (PayView *)[topLevelObjects objectAtIndex:0];
}

- (void)show:(NSString *)tips
 paymentInfo:(NSString *)paymentInfo
  controller:(UIViewController *)controller
    delegate:(id<UPPayPluginDelegate>)delegate
{
    self.paymentInfo = paymentInfo;
    self.controller = controller;
    self.delegate = delegate;
    
    self.tipsLabel.text = tips;
    [self.activityView startAnimating];
    [controller.view addSubview:self];
    [NSTimer scheduledTimerWithTimeInterval: 3.0
                                     target: self
                                   selector: @selector(handleTimer:)
                                   userInfo: paymentInfo
                                    repeats: NO];
}

- (void)handleTimer:(NSTimer *)aTimer
{
    [self.activityView stopAnimating];
    [self removeFromSuperview];
    NSString *paymentInfo = (NSString *)[aTimer userInfo];
    [UPPayPluginUtil test:paymentInfo SystemProvide:UNION_PAY_SYSTEM_PROVIDE SPID:UNION_PAY_AP_ID withViewController:_controller Delegate:_delegate];
}

@end
