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
#import "StringUtil.h"
#import "App.pb.h"
#import "AppManager.h"

@interface SelectAirCityController ()
@property (retain, nonatomic) NSMutableArray *searchResultList;
@property (assign, nonatomic) id<SelectAirCityControllerDelegate> delegate;
@property (retain, nonatomic) NSArray *sectionTitleList;
@property (retain, nonatomic) NSMutableDictionary *sectionTitleAndCitys;

@end

@implementation SelectAirCityController

- (void)dealloc {
    [_searchResultList release];
    [_sectionTitleList release];
    [_sectionTitleAndCitys release];
    [super dealloc];
}

- (id)initWithDelegate:(id<SelectAirCityControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.searchResultList = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidUnload {
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
    
    [self createDataSorce];
}

- (void)createDataSorce
{
    //create citys
    self.sectionTitleList = [[AppManager defaultManager] getAirDepartCitySectionTitles];
    
    self.sectionTitleAndCitys  = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSString *letter in self.sectionTitleList) {
        NSArray *citys = [[AppManager defaultManager] getAirDepartCitys:letter];
        [_sectionTitleAndCitys setObject:citys forKey:letter];
    }
}


#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    } else {
        return [_sectionTitleList count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    } else {
        return [_sectionTitleList objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [_searchResultList count];
    } else {
        NSString *pinyin = [_sectionTitleList objectAtIndex:section];
        NSArray *citys = [_sectionTitleAndCitys objectForKey:pinyin];
        return [citys count];
    }
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
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        AirCity *city = [_searchResultList objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityName;
    } else {
        NSString *pinyin = [_sectionTitleList objectAtIndex:indexPath.section];
        NSArray *citys = [_sectionTitleAndCitys objectForKey:pinyin];
        AirCity *city = [citys objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityName;
    }
    
    return cell;
}


#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AirCity *city = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        city = [_searchResultList objectAtIndex:indexPath.row];
    } else {
        NSString *pinyin = [_sectionTitleList objectAtIndex:indexPath.section];
        NSArray *citys = [_sectionTitleAndCitys objectForKey:pinyin];
        city = [citys objectAtIndex:indexPath.row];
    }
    
    if ([_delegate respondsToSelector:@selector(didSelectCity:)]) {
        [_delegate didSelectCity:city];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.dataTableView) {
        return _sectionTitleList;
    }else {
        return nil;
    }
}


#pragma mark -
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText
{
	[self.searchResultList removeAllObjects];
    
    for (NSString *letter in _sectionTitleList) {
        NSArray *citys = [_sectionTitleAndCitys objectForKey:letter];
        for (AirCity *city in citys) {
            
            if ([searchText isEqualToString:@"x"] && [city.cityName isEqualToString:@"厦门"])
            {
                [self.searchResultList addObject:city.cityName];
                continue;
            }
            
            int cityLocation = [city.cityName rangeOfString:searchText].location;
            if (cityLocation < [city.cityName length] || [searchText isEqualToString:city.cityName.pinyinFirstLetter]) {
                [self.searchResultList addObject:city];
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

@end
