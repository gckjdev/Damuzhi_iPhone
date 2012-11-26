//
//  ConfirmOrderController.m
//  Travel
//
//  Created by haodong on 12-11-26.
//
//

#import "ConfirmOrderController.h"
#import "FontSize.h"

@interface ConfirmOrderController ()

@end

@implementation ConfirmOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"确认约定");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
}

@end
