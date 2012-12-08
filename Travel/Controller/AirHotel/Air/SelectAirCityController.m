//
//  SelectAirCityController.m
//  Travel
//
//  Created by haodong on 12-12-8.
//
//

#import "SelectAirCityController.h"
#import "FontSize.h"
#import "ImageName.h"

@interface SelectAirCityController ()

@end

@implementation SelectAirCityController

- (void)dealloc {
    [_searchBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"出发城市");
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    self.dataList = [NSArray arrayWithObjects:@"北京", @"上海", @"广州", @"深圳", @"成都", @"厦门", @"昆明", @"杭州", @"西安", nil];
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SelectAirCityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        UIImageView *cellBgImageView = [[[UIImageView alloc] init] autorelease];
        [cellBgImageView setImage:[UIImage imageNamed:IMAGE_CITY_CELL_BG]];
        [cell setBackgroundView:cellBgImageView];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
   
    
    cell.textLabel.text = [dataList objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


#pragma mark - searchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    //[self updateHideKeyboardButton];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //[self update:searchBar.text];
    [self.searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //[self updateHideKeyboardButton];
    //[self update:searchBar.text];
    
    //[self showNoSelectRegion];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //[self clickHideKeyboardButton:nil];
}




@end
