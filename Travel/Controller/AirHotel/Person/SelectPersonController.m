//
//  SelectPersonController.m
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "SelectPersonController.h"
#import "FontSize.h"
#import "ImageManager.h"

@interface SelectPersonController ()

@end

@implementation SelectPersonController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"信用卡支付");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SelectPersonCell getCellHeight];
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [SelectPersonCell getCellIdentifier];
    SelectPersonCell *cell = (SelectPersonCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [SelectPersonCell createCell:self];
    }
    
    return cell;
}

@end
