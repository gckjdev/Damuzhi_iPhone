//
//  TravelLoadingView.m
//  Travel
//
//  Created by haodong on 13-3-21.
//
//

#import "TravelLoadingView.h"
#import "AutoCreateViewByXib.h"

@interface TravelLoadingView()

@end


@implementation TravelLoadingView

AUTO_CREATE_VIEW_BY_XIB(TravelLoadingView);

+ (id)createTravelLoadingView
{
    TravelLoadingView *view = [self createView];
    return view;
}

- (void)showLoading:(NSString *)text
{
    self.isClickCloseButton = NO;
    self.tipsLabel.text = text;
    [self.activityView startAnimating];
    
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hideLoading
{
    [self.activityView stopAnimating];
    [self removeFromSuperview];
}

- (IBAction)clickCloseButton:(id)sender {
    self.isClickCloseButton = YES;
    
    [self hideLoading];
}

- (void)dealloc {
    [_tipsLabel release];
    [_activityView release];
    [super dealloc];
}

@end
