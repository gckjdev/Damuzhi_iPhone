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
@property (retain, nonatomic) NSString *serialNumber;
@property (retain, nonatomic) UIViewController *controller;
@property (assign, nonatomic) id<UPPayPluginDelegate> delegate;

@end

@implementation PayView

- (void)dealloc {
    [_activityView release];
    [_tipsLabel release];
    [_serialNumber release];
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
serialNumber:(NSString *)serialNumber
  controller:(UIViewController *)controller
    delegate:(id<UPPayPluginDelegate>)delegate
{
    self.serialNumber = serialNumber;
    self.controller = controller;
    self.delegate = delegate;
    self.tipsLabel.text = tips;

    [self.activityView startAnimating];
    [controller.view addSubview:self];
    [NSTimer scheduledTimerWithTimeInterval: 3.0
                                     target: self
                                   selector: @selector(handleTimer:)
                                   userInfo: serialNumber
                                    repeats: NO];
}

- (void)handleTimer:(NSTimer *)aTimer
{
    [self.activityView stopAnimating];
    [self removeFromSuperview];
    NSString *serialNumber = (NSString *)[aTimer userInfo];
    
    [UPPayPluginUtil startPay:serialNumber
                   sysProvide:UNION_PAY_SYSTEM_PROVIDE
                         spId:UNION_PAY_AP_ID
                         mode:@"01"
               viewController:_controller
                     delegate:_delegate];
}

@end
