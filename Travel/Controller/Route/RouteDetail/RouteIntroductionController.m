//
//  RouteIntroductionController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteIntroductionController.h"
#import "TravelNetworkConstants.h" 
#import "AppManager.h"
#import "ImageManager.h"
#import "TravelNetworkConstants.h"
#import "DailyScheduleCell.h"
#import "CharacticsCell.h"
#import "BookingCell.h"
#import "SlideImageView.h"
#import "ImageName.h"

#define CELL_IDENTIFY_CHARACTICS @"CharacticsCell"

//#define SECTION_COUNT 4

#define SECTION_OPEN 1
#define SECTION_CLOSE 0

#define SECTION_TITLE_CHARACTICS NSLS(@"线路特色")
#define SECTION_TITLE_DAILY_SCHEDULE NSLS(@"行程安排")
#define SECTION_TITLE_BOOKING NSLS(@"出发日期")
#define SECTION_TITLE_RELATED_PLACE NSLS(@"相关景点")
#define SECTION_TITLE_REFERENCE NSLS(@"参考行程")


#define FONT_SECTION_TITLE [UIFont boldSystemFontOfSize:14]
#define COLOR_SECTION_TITLE [UIColor colorWithRed:37.0/255.0 green:66.0/255.0 blue:80.0/255.0 alpha:1]

#define COLOR_CONTENT [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1]



#define HEIGHT_DAILY_SCHEDULE_TITLE_LABEL 36

#define HEIGHT_HEADER_VIEW 30
#define HEIGHT_FOOTER_VIEW 8

#define HEIGHT_BOOK_BUTTON 22
#define WIDTH_BOOK_BUTTON 70

@interface RouteIntroductionController ()

@property (retain, nonatomic) NSMutableArray *sectionStat;
@property (retain, nonatomic) TouristRoute *route;
@property (assign, nonatomic) int routeType;
@property (retain, nonatomic) NSMutableDictionary *sectionInfo;

@end

@implementation RouteIntroductionController

@synthesize aDelegate = _aDelegate;
@synthesize sectionStat = _sectionStat;
@synthesize route = _route;
@synthesize routeType = _routeType;
@synthesize sectionInfo = _sectionInfo;

@synthesize titleHolerView;
@synthesize routeNameLabel;
@synthesize routeIdLabel;
@synthesize imagesHolderView;
@synthesize agencyNameLabel;
@synthesize agencyInfoHolderView;

- (void)dealloc {
    [_sectionStat release];
    [_route release];
    [_sectionInfo release];
    [titleHolerView release];
    [imagesHolderView release];
    [agencyInfoHolderView release];
    [agencyNameLabel release];
    [routeNameLabel release];
    [routeIdLabel release];
    [super dealloc];
}

- (id)initWithRoute:(TouristRoute *)route routeType:(int)routeType
{
    if (self = [super init]) {
        self.route = route;
        self.routeType = routeType;
    }
    
    return self;
}

- (int)sectionCount
{
    return [self.sectionInfo count];
}

- (void)initSectionStat
{
    self.sectionStat = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i = 0; i < [self sectionCount]; i++) {
        [_sectionStat addObject:[NSNumber numberWithBool:YES]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    [titleHolerView setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] routeDetailTitleBgImage]]];
    
    [routeNameLabel setText:_route.name];
    [routeIdLabel setText:[NSString stringWithFormat:NSLS(@"编号：%d"), _route.routeId]];
    
    [agencyInfoHolderView setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] routeDetailAgencyBgImage]]];
    [self setAgencyInfoHolderViewAppearance];
    
    self.dataTableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1];
    
    SlideImageView *slideImageView = [[SlideImageView alloc] initWithFrame:imagesHolderView.bounds];
    slideImageView.defaultImage = IMAGE_PLACE_DETAIL;
    [slideImageView setImages:_route.detailImagesList];
    [imagesHolderView addSubview:slideImageView];
    
    [self initSectionStat];
}

- (NSMutableDictionary *)sectionInfo
{
    if (_sectionInfo == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        int row = 0;
        [dic setObject:SECTION_TITLE_CHARACTICS forKey:[NSNumber numberWithInt:row++]];

        if (_routeType == OBJECT_LIST_ROUTE_PACKAGE_TOUR) {
            [dic setObject:SECTION_TITLE_DAILY_SCHEDULE forKey:[NSNumber numberWithInt:row++]];
            [dic setObject:SECTION_TITLE_BOOKING forKey:[NSNumber numberWithInt:row++]];
        }else {
            for (TravelPackage * package in _route.packagesList) {
//                [dic setObject:package.name forKey:[NSNumber numberWithInt:row++]];
            }
            [dic setObject:SECTION_TITLE_BOOKING forKey:[NSNumber numberWithInt:row++]];
            [dic setObject:SECTION_TITLE_REFERENCE forKey:[NSNumber numberWithInt:row++]];
        }
        
        [dic setObject:SECTION_TITLE_RELATED_PLACE forKey:[NSNumber numberWithInt:row++]];

        return dic;
    }
    
    return _sectionInfo;
}

- (void)viewDidUnload
{
    [self setTitleHolerView:nil];
    [self setImagesHolderView:nil];
    [self setAgencyInfoHolderView:nil];
    [self setAgencyNameLabel:nil];
    [self setRouteNameLabel:nil];
    [self setRouteIdLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#define HEIGHT_PRICE_LABEL 20
#define HEIGHT_PRICE_SUFFIX_LABEL 20

- (void)setAgencyInfoHolderViewAppearance
{
    [agencyNameLabel setText:[[AppManager defaultManager] getAgencyName:_route.agencyId]];
    
    CGFloat origin_x;
    CGFloat origin_y;

    UILabel *priceLabel;
    UILabel *priceSuffixLabel;
    UIButton *bookButton;
    
    switch (_routeType) {
        case OBJECT_LIST_ROUTE_PACKAGE_TOUR:
            origin_x = agencyNameLabel.frame.origin.x + agencyNameLabel.frame.size.width + 15;
            origin_y = agencyNameLabel.frame.size.height/2 - HEIGHT_PRICE_LABEL/2; 
            priceLabel = [self genPriceLabelWithFrame:CGRectMake(origin_x, origin_y, 40, HEIGHT_PRICE_LABEL)];
            [agencyInfoHolderView addSubview:priceLabel];
            
            origin_x = priceLabel.frame.origin.x + priceLabel.frame.size.width + 1;
            origin_y = agencyNameLabel.frame.size.height/2 - HEIGHT_PRICE_SUFFIX_LABEL/2 + 1; 
            priceSuffixLabel = [self genPriceSuffixLabelWithFrame:CGRectMake(origin_x, origin_y, 15, HEIGHT_PRICE_SUFFIX_LABEL)];
            [agencyInfoHolderView addSubview:priceSuffixLabel];
            
            origin_x = priceSuffixLabel.frame.origin.x + priceSuffixLabel.frame.size.width + 20;
            origin_y = agencyNameLabel.frame.size.height/2 - 22/2; 
            bookButton = [self genBookBttonWithFrame:CGRectMake(origin_x, origin_y, 70, 22)];
            [agencyInfoHolderView addSubview:bookButton];
            
            break;
            
        default:
            break;
    }
}

- (UILabel *)genPriceLabelWithFrame:(CGRect)frame
{
    UILabel *priceLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [priceLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:0 alpha:1]];
    [priceLabel setTextAlignment:UITextAlignmentRight];
    [priceLabel setFont:[UIFont systemFontOfSize:16]];
    [priceLabel setText:[NSString stringWithFormat:@"%d元", [_route.price intValue]]];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    
    return priceLabel;
}

- (UILabel *)genPriceSuffixLabelWithFrame:(CGRect)frame
{
    UILabel *suffixLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [suffixLabel setFont:[UIFont systemFontOfSize:12]];
    suffixLabel.textColor = COLOR_CONTENT;
    [suffixLabel setText:NSLS(@"起")];
    [suffixLabel setBackgroundColor:[UIColor clearColor]];
    
    return suffixLabel;
}

- (UIButton *)genBookBttonWithFrame:(CGRect)frame
{
    UIButton *bookButton = [[[UIButton alloc] initWithFrame:frame] autorelease];
    [bookButton setImage:[[ImageManager defaultManager] bookButtonImage] forState:UIControlStateNormal];
    
    [bookButton addTarget:self action:@selector(clickBookButton) forControlEvents:UIControlEventTouchUpInside];
    
    return bookButton;
}

- (void)showInView:(UIScrollView *)superView
{
    superView.contentSize = self.view.bounds.size;
    [superView addSubview:self.view];
}


- (void)clickBookButton
{
    if ([_aDelegate respondsToSelector:@selector(didClickBookButton)]) {
        [_aDelegate didClickBookButton];
    }
}


// Table vew delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self sectionCount];		// default implementation
}

- (BOOL)isSectionOpen:(NSInteger)section
{
    if ([_sectionStat count] > section) {
        return [[_sectionStat objectAtIndex:section] boolValue];
    }
    
    return NO;
}

- (void)setSection:(NSInteger)section Open:(BOOL)open
{
    if ([_sectionStat count] > section) {
        [_sectionStat removeObjectAtIndex:section];
        NSNumber *num = [NSNumber numberWithBool:open];
        [_sectionStat insertObject:num atIndex:section];
        
        [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }    
}

- (int)cellCountForSection:(NSInteger)section
{
    if (![self isSectionOpen:section]) {
        return 0;
    }
    
    NSString *title = [self.sectionInfo objectForKey:[NSNumber numberWithInt:section]];
    
    if (title == SECTION_TITLE_RELATED_PLACE) {
        return [_route.relatedplacesList count]; 
    }
    else if (title == SECTION_TITLE_DAILY_SCHEDULE) {
        return [_route.dailySchedulesList count];
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self cellCountForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionCount = [self sectionCount];
    if (indexPath.section >= sectionCount) {
        PPDebug(@"indexPath.section is out of range!");
        return nil;
    }
    
    if (indexPath.row >= [self cellCountForSection:indexPath.section]) {
        PPDebug(@"indexPath.row is out of range!");
        return nil;
    }
    
    UITableViewCell *cell = nil;

    if (_routeType == OBJECT_LIST_ROUTE_PACKAGE_TOUR) {
        NSString *title = [self.sectionInfo objectForKey:[NSNumber numberWithInt:indexPath.section]];
        if (title == SECTION_TITLE_CHARACTICS) {
            cell = [self cellForCharacticsWithIndex:indexPath tableView:tableView];
        }else if (title == SECTION_TITLE_DAILY_SCHEDULE) {
            cell = [self cellForDailyScheduleWithIndex:indexPath tableView:tableView];
        }else if (title == SECTION_TITLE_BOOKING) {
            cell = [self cellForBookingWithIndex:indexPath tableView:tableView];
        }else if (title == SECTION_TITLE_RELATED_PLACE) {
            cell = [self cellForRelatedPlaceWithIndex:indexPath tableView:tableView];
        }
    }
    
    return cell;
}

- (UITableViewCell *)cellForCharacticsWithIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CharacticsCell getCellIdentifier]];
    
    if (cell == nil) {
        cell = [CharacticsCell createCell:self];	
        
    }
    
    CharacticsCell *characticsCell = (CharacticsCell *)cell;
    characticsCell.characticsLabel.textColor = COLOR_CONTENT;
    [characticsCell setCellData:_route.characteristic];
    
    return cell;
}

- (CGFloat)cellHeightForCharacticsWithIndex:(NSIndexPath *)indexPath
{
    CGSize withinSize = CGSizeMake(WIDTH_CHARACTICS_LABEL, MAXFLOAT);
    CGSize size = [_route.characteristic sizeWithFont:FONT_CHARACTICS_LABEL constrainedToSize:withinSize lineBreakMode:LINE_BREAK_MODE_CHARACTICS_LABEL];
    
    return size.height + 5;
}

- (UITableViewCell *)cellForDailyScheduleWithIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DailyScheduleCell getCellIdentifier]];
    
    if (cell == nil) {
        cell = [DailyScheduleCell createCell:self];	
        
    }
    
    DailyScheduleCell *dailySchedulesCell = (DailyScheduleCell *)cell;
    
    [dailySchedulesCell setCellData:[[_route dailySchedulesList] objectAtIndex:indexPath.row] rowNum:indexPath.row rowCount:[self cellCountForSection:indexPath.section]];
    
    return cell;
}

- (CGFloat)cellHeightForDailyScheduleWithIndex:(NSIndexPath *)indexPath
{
    int count = [[[_route.dailySchedulesList objectAtIndex:indexPath.row] placeToursList] count];
    
    CGFloat placeToursheight = MAX(count, 1)* HEIGHT_PLACE_TOUR_LABEL + EDGE_TOP + EDGE_BOTTOM;

    return HEIGHT_DAILY_SCHEDULE_TITLE_LABEL + placeToursheight + HEIGHT_DINING_LABEL + HEIGHT_HOTEL_LABEL;
}


- (UITableViewCell *)cellForBookingWithIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BookingCell getCellIdentifier]];
    
    if (cell == nil) {
        cell = [BookingCell createCell:self];	
        
    }
    
    BookingCell *bookingCell = (BookingCell *)cell;
    bookingCell.bookingBgImageView.image = [[ImageManager defaultManager] bookingBgImage];
    
    [bookingCell setCellData:NO bookings:_route.bookingsList];
    
    return cell;
}

- (CGFloat)cellHeightForBookingWithIndex:(NSIndexPath *)indexPath
{
    return [BookingCell getCellHeight];
}

- (UITableViewCell *)cellForRelatedPlaceWithIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RelatedPlaceCell getCellIdentifier]];
    
    if (cell == nil) {
        cell = [RelatedPlaceCell createCell:self];				            

    }

    RelatedPlaceCell *relatedPlaceCell = (RelatedPlaceCell *)cell;
    
    [relatedPlaceCell setCellData:[[_route relatedplacesList] objectAtIndex:indexPath.row] rowNum:indexPath.row rowCount:[self cellCountForSection:indexPath.section]];
    [relatedPlaceCell.relatedPlaceButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    
    relatedPlaceCell.aDelegate = self;
        
    return cell;
}

- (CGFloat)cellHeightForRelatedPlaceWithIndex:(NSIndexPath *)indexPath
{
    return [RelatedPlaceCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int sectionCount = [self sectionCount];
    if (indexPath.section >= sectionCount) {
        PPDebug(@"indexPath.section is out of range!");
        return 0;
    }
    
    if (indexPath.row >= [self cellCountForSection:indexPath.section]) {
        PPDebug(@"indexPath.row is out of range!");
        return 0;
    }
    
    CGFloat height = 0;
    if (_routeType == OBJECT_LIST_ROUTE_PACKAGE_TOUR) {
        NSString *title = [self.sectionInfo objectForKey:[NSNumber numberWithInt:indexPath.section]];
        if (title == SECTION_TITLE_CHARACTICS) {
            height = [self cellHeightForCharacticsWithIndex:indexPath];
        }else if (title == SECTION_TITLE_DAILY_SCHEDULE) {
            height = [self cellHeightForDailyScheduleWithIndex:indexPath];
        }else if (title == SECTION_TITLE_BOOKING) {
            height = [self cellHeightForBookingWithIndex:indexPath];
        }else if (title == SECTION_TITLE_RELATED_PLACE) {
            height = [self cellHeightForRelatedPlaceWithIndex:indexPath];
        }
    }
        
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_HEADER_VIEW;
}

#define HEIGHT_FOLLOW_VIEW 53

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [self sectionCount] - 1) {
        return HEIGHT_FOLLOW_VIEW;
    }
    
    return HEIGHT_FOOTER_VIEW;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerViewForSection:section];
}

- (NSString *)titleForSection:(NSInteger)section
{
    NSNumber *row = [NSNumber numberWithInt:section];
    NSString *title = [self.sectionInfo objectForKey:row];
    
    return title;
}


#define WIDTH_FOLLOW_BUTTON 92
#define HEIGHT_FOLLOW_BUTTOn 29

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self isSectionOpen:section]) {
        return nil;
    }
    
    CGRect rect;
    UIView *view = [[[UIView alloc] initWithFrame:rect] autorelease];
    view.backgroundColor = [UIColor clearColor];
    
//    PPDebug(@"section count: %d", [self sectionCount]);
//    PPDebug(@"section = %d", section);
    if (section == [self sectionCount] - 1) {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_FOLLOW_VIEW);
        UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(self.dataTableView.frame.size.width/2 - WIDTH_FOLLOW_BUTTON/2, 53/2 - HEIGHT_FOLLOW_BUTTOn/2, WIDTH_FOLLOW_BUTTON, HEIGHT_FOLLOW_BUTTOn)] autorelease];
        [button addTarget:self action:@selector(clickFollowRoute:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:NSLS(@"关注路线") forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"favorites.png"] forState:UIControlStateNormal];
        [view addSubview:button];
    }

    view.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_FOOTER_VIEW);
    
    return view;
}

- (UIView *)headerViewForSection:(NSInteger)section
{
    UIView *headerView = [self headerView];
    headerView.tag = section;
    
    UILabel *label = [self headerTitle];
    label.text = [self titleForSection:section];
    [headerView addSubview:label];
    
    // 特殊处理
    
    
    return headerView;
}

- (UIView *)headerView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_HEADER_VIEW);
    UIButton *headerView = [[[UIButton alloc] initWithFrame:rect] autorelease];
    [headerView setBackgroundImage:[[ImageManager defaultManager] lineListBgImage] forState:UIControlStateNormal];
    [headerView addTarget:self action:@selector(clickSectionHeaderView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, HEIGHT_HEADER_VIEW/2-22/2, 22, 22)];
    arrowImageView.image = [[ImageManager defaultManager] arrowImage];
    [headerView addSubview:arrowImageView];
    [arrowImageView release];
    
    return headerView;
}

- (UILabel *)headerTitle
{
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(13, 0, 80, HEIGHT_HEADER_VIEW)] autorelease];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.textColor = [UIColor colorWithRed:37.0/255.0 green:66.0/255.0 blue:80.0/255.0 alpha:1];
    headerTitle.font = FONT_SECTION_TITLE;
    headerTitle.textColor = COLOR_SECTION_TITLE;
    
    return headerTitle;
}


- (void)clickSectionHeaderView:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL open = [self isSectionOpen:button.tag];
    [self setSection:button.tag Open:!open];
}

- (void)didSelectedRelatedPlace:(PlaceTour *)placeTour
{
    [self popupMessage:@"待实现" title:nil];
}

- (void)clickFollowRoute:(id)sender
{
    [self popupMessage:@"待实现" title:nil]; 
}

@end
