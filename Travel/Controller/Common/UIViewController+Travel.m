//
//  UIViewController+Travel.m
//  Travel
//
//  Created by haodong on 12-12-12.
//
//

#import "UIViewController+Travel.h"

@implementation UIViewController (Travel)

#define WIDTH_TOP_ARRAW 14
#define HEIGHT_TOP_ARRAW 7
#define WIDTH_BLANK_OF_TITLE 14

- (void)createTitleView:(NSString *)titlePrefix
{
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize withinSize = CGSizeMake(320, CGFLOAT_MAX);
    
    NSString *title = [NSString stringWithFormat:@"%@ — %@", titlePrefix,[[AppManager defaultManager] getCurrentCityName]];
    
    CGSize titleSize = [title sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeTailTruncation];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleSize.width+WIDTH_TOP_ARRAW+WIDTH_BLANK_OF_TITLE, titleSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    [button setImage:[UIImage imageNamed:@"top_arrow.png"] forState:UIControlStateNormal];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+WIDTH_BLANK_OF_TITLE, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -WIDTH_TOP_ARRAW-WIDTH_BLANK_OF_TITLE, 0, 0);
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button addTarget:self action:@selector(clickTitleView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = button;
    
    [button release];
}

- (void)clickTitleView:(id)sender
{
    CityManagementController *controller = [CityManagementController getInstance];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
