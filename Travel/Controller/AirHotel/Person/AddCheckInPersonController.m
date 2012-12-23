//
//  AddCheckInPersonController.m
//  Travel
//
//  Created by haodong on 12-12-24.
//
//

#import "AddCheckInPersonController.h"
#import "FontSize.h"
#import "ImageManager.h"

@interface AddCheckInPersonController ()

@end

@implementation AddCheckInPersonController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    self.title = NSLS(@"添加入住人");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"确定")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
}



@end
