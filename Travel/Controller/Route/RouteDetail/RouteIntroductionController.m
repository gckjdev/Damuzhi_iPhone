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
#import "CharacticsCell.h"
#import "BookingCell.h"
#import "SlideImageView.h"
#import "ImageName.h"
#import "RankView.h"
#import "PPNetworkRequest.h"
#import "UIViewUtils.h"
#import "RouteStorage.h"
#import "AnimationManager.h"
#import "ReferenceCell.h"
#import "ImageManager.h"
#import "UIImageUtil.h"

#define TAG_ARROW_IMAGE_VIEW 101 

#define CELL_IDENTIFY_CHARACTICS @"CharacticsCell"

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
@property (assign, nonatomic) CGFloat referenceHeight;

@property (retain, nonatomic) NSMutableDictionary *sectionHeaderViews;
@property (assign, nonatomic) CGRect bookingCellFrame;
@property (retain, nonatomic) MonthViewController *monthViewController;

- (RankView *)headerRankView;

@end

@implementation RouteIntroductionController

@synthesize aDelegate = _aDelegate;
@synthesize sectionStat = _sectionStat;
@synthesize route = _route;
@synthesize routeType = _routeType;
@synthesize sectionInfo = _sectionInfo;
@synthesize referenceHeight = _referenceHeight;
@synthesize sectionHeaderViews = _sectionHeaderViews;
@synthesize titleHolerView;
@synthesize imagesHolderView;
@synthesize departCityLabel = _departCityLabel;
@synthesize agencyInfoHolderView;
@synthesize followButton;
@synthesize bookingCellFrame = _bookingCellFrame;
@synthesize monthViewController = _monthViewController;

- (void)dealloc {
    [_sectionStat release];
    [_route release];
    [_sectionInfo release];
    [titleHolerView release];
    [imagesHolderView release];
    [agencyInfoHolderView release];
    [followButton release];
    [_sectionHeaderViews release];
    [_departCityLabel release];
    [_monthViewController release];
    [super dealloc];
}

//- (id)initWithRoute:(TouristRoute *)route routeType:(int)routeType
//{
//    if (self = [super init]) {
//        self.route = route;
//        self.routeType = routeType;
//    }
//    
//    return self;
//}

- (void)updateWithRoute:(TouristRoute *)route routeType:(int)routeType
{
    self.route = route;
    self.routeType = routeType;
    
    // Do any additional setup after loading the view from its nib
    
    self.monthViewController = [[[MonthViewController alloc] initWithBookings:_route.bookingsList routeType:_routeType] autorelease];
    self.monthViewController.aDelegate = self;
    
    //    // the following view is used here just to get its frame.
    //    TKCalendarMonthView *view = [[[TKCalendarMonthView alloc] initWithSundayAsFirst:NO 
    //                                                                           date:[NSDate date]
    //                                                           hasMonthYearAndArrow:NO 
    //                                                               hasTopBackground:NO
    //                                                                      hasShadow:NO 
    //                                                        userInteractionEnable:YES] autorelease];
    //    self.bookingCellFrame = view.frame;
    
    
    self.sectionHeaderViews = [NSMutableDictionary dictionary];
    [titleHolerView setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] routeDetailTitleBgImage]]];
    
    [agencyInfoHolderView setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] routeDetailAgencyBgImage]]];
    
    [self setAgencyInfoHolderViewAppearance];
    
    self.dataTableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1];
    
    SlideImageView *slideImageView = [[[SlideImageView alloc] initWithFrame:imagesHolderView.bounds] autorelease];
    slideImageView.defaultImage = IMAGE_PLACE_DETAIL;
    
//    slideImageView.defaultImage = @"all_page_bg2.jpg";
//    imagesHolderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]];

    [slideImageView.pageControl setPageIndicatorImageForCurrentPage:[UIImage strectchableImageName:@"point_pic3.png"] forNotCurrentPage:[UIImage strectchableImageName:@"point_pic4.png"]];
    [slideImageView setImages:_route.detailImagesList];
    
    [imagesHolderView addSubview:slideImageView];
    
    [self updateFollowButton];
    
    [self initSectionStat];
    
    self.referenceHeight = 0;
    
    PPDebug(@"agencyInfoHolderView height:%f", self.agencyInfoHolderView.frame.size.height);
    
    
    [self.dataTableView reloadData];
}

- (int)sectionCount
{
    return [self.sectionInfo count];
}

- (void)initSectionStat
{
    self.sectionStat = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i = 0; i < [self sectionCount]; i++) {
        if ([[self titleForSection:i] isEqualToString:SECTION_TITLE_REFERENCE]) {
            [_sectionStat addObject:[NSNumber numberWithBool:NO]];
        } else {
            [_sectionStat addObject:[NSNumber numberWithBool:YES]];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
//    self.monthViewController = [[[MonthViewController alloc] initWithBookings:_route.bookingsList routeType:_routeType] autorelease];
//    self.monthViewController.aDelegate = self;
//    
////    // the following view is used here just to get its frame.
////    TKCalendarMonthView *view = [[[TKCalendarMonthView alloc] initWithSundayAsFirst:NO 
////                                                                           date:[NSDate date]
////                                                           hasMonthYearAndArrow:NO 
////                                                               hasTopBackground:NO
////                                                                      hasShadow:NO 
////                                                        userInteractionEnable:YES] autorelease];
////    self.bookingCellFrame = view.frame;
//    
//    
//    self.sectionHeaderViews = [NSMutableDictionary dictionary];
//    [titleHolerView setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] routeDetailTitleBgImage]]];
//    
//    [agencyInfoHolderView setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] routeDetailAgencyBgImage]]];
//    
//    [self setAgencyInfoHolderViewAppearance];
//    
//    self.dataTableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1];
//    
//    SlideImageView *slideImageView = [[[SlideImageView alloc] initWithFrame:imagesHolderView.bounds] autorelease];
//    slideImageView.defaultImage = IMAGE_PLACE_DETAIL;
//    [slideImageView.pageControl setPageIndicatorImageForCurrentPage:[UIImage strectchableImageName:@"point_pic3.png"] forNotCurrentPage:[UIImage strectchableImageName:@"point_pic4.png"]];
//    [slideImageView setImages:_route.detailImagesList];
//    
// 
//    
//    
//    
//    [imagesHolderView addSubview:slideImageView];
//    
//    [self updateFollowButton];
//    
//    [self initSectionStat];
//    
//    self.referenceHeight = 0;
//    
//    PPDebug(@"agencyInfoHolderView height:%f", self.agencyInfoHolderView.frame.size.height);
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
                [dic setObject:package.name forKey:[NSNumber numberWithInt:row++]];
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
//    [self setAgencyNameLabel:nil];
    [self setFollowButton:nil];
    [self setDepartCityLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#define HEIGHT_PRICE_LABEL 20
#define HEIGHT_PRICE_SUFFIX_LABEL 20

- (void)setAgencyInfoHolderViewAppearance
{
    
//    [agencyNameLabel setText:[[AppManager defaultManager] getAgencyShortName:_route.agencyId]];
    NSString *string = [[AppManager defaultManager]  getDepartCityName:_route.departCityId];
    
    NSString *departCityName = [NSString stringWithFormat:@"出发 : %@",string];
    [_departCityLabel setText:departCityName];

    
    //CGSize agencyNameSize = [agencyNameLabel.text sizeWithFont:agencyNameLabel.font forWidth:160 lineBreakMode:UILineBreakModeWordWrap];
    
//    CGFloat origin_x;
//    CGFloat origin_y;

    UILabel *priceLabel;
    UILabel *priceSuffixLabel;
    UIButton *bookButton;
    


    priceLabel = [self genPriceLabelWithFrame:CGRectMake(123, 12, 80, HEIGHT_PRICE_LABEL)];
    [agencyInfoHolderView addSubview:priceLabel];
    

    priceSuffixLabel = [self genPriceSuffixLabelWithFrame:CGRectMake(205 , 13, 15, HEIGHT_PRICE_SUFFIX_LABEL)];
    [agencyInfoHolderView addSubview:priceSuffixLabel];
    

    bookButton = [self genBookBttonWithFrame:CGRectMake(215 , 0, 100, 40)];
    [agencyInfoHolderView addSubview:bookButton];
}

- (UILabel *)genPriceLabelWithFrame:(CGRect)frame
{
    UILabel *priceLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [priceLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:0 alpha:1]];
    [priceLabel setTextAlignment:UITextAlignmentRight];
    [priceLabel setFont:[UIFont systemFontOfSize:16]];
    [priceLabel setText:_route.price];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    
    return priceLabel;
}

- (UILabel *)genPriceSuffixLabelWithFrame:(CGRect)frame
{
    UILabel *suffixLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [suffixLabel setFont:[UIFont systemFontOfSize:9]];
    suffixLabel.textColor = COLOR_CONTENT;
    [suffixLabel setText:NSLS(@"起")];
    [suffixLabel setBackgroundColor:[UIColor clearColor]];
    
    return suffixLabel;
}

- (UIButton *)genBookBttonWithFrame:(CGRect)frame
{
    UIButton *bookButton = [[[UIButton alloc] initWithFrame:frame] autorelease];
    [bookButton setImage:[[ImageManager defaultManager] bookButtonImage] forState:UIControlStateNormal];
    
    [bookButton addTarget:self action:@selector(clickBookButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return bookButton;
}

- (void)showInView:(UIView *)superView
{
//    [superView removeAllSubviews];
    
//    superView.contentSize = self.view.bounds.size;
    [superView addSubview:self.view];
}


- (void)clickBookButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int selectPackageId = button.tag;
    if ([_aDelegate respondsToSelector:@selector(didClickBookButton:)]) {
        [_aDelegate didClickBookButton:selectPackageId];
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
    
    NSString *title = [self titleForSection:section];
    
    if ([title isEqualToString:SECTION_TITLE_RELATED_PLACE]) {
        return [_route.relatedplacesList count]; 
    }
    else if ([title isEqualToString:SECTION_TITLE_DAILY_SCHEDULE]) {
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

    NSString *title = [self titleForSection:indexPath.section];
    PPDebug(@"title: %@", title);

    if ([title isEqualToString:SECTION_TITLE_CHARACTICS]) {
        cell = [self cellForCharacticsWithIndex:indexPath tableView:tableView];
    }else if ([title isEqualToString:SECTION_TITLE_DAILY_SCHEDULE]) {
        cell = [self cellForDailyScheduleWithIndex:indexPath tableView:tableView];
    }else if ([title isEqualToString:SECTION_TITLE_BOOKING]) {
        cell = [self cellForBookingWithIndex:indexPath tableView:tableView];
    }else if ([title isEqualToString:SECTION_TITLE_RELATED_PLACE]) {
        cell = [self cellForRelatedPlaceWithIndex:indexPath tableView:tableView];
    }else if ([title isEqualToString:SECTION_TITLE_REFERENCE]) {
        cell = [self cellForReferenceWithIndex:indexPath tableView:tableView];
    }else{
        for (TravelPackage *package in _route.packagesList) {
            if ([title isEqualToString:package.name]) {
                cell = [self cellForPackageWithIndex:indexPath tableView:tableView];
            }
        }
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
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

- (UITableViewCell *)cellForReferenceWithIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[ReferenceCell getCellIdentifier]];
    
    if (cell == nil) {
        cell = [ReferenceCell createCell:self];	
    }
    
    ReferenceCell *referenceCell = (ReferenceCell *)cell;
   
    NSURL *requestUrl = [NSURL URLWithString:_route.reference];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    referenceCell.contentWebView.alpha = 0.0;
    referenceCell.contentWebView.delegate = self;
    [referenceCell.contentWebView loadRequest:request];
    
    PPDebug(@"<RouteIntroductionController> reference:%@",_route.reference);
    
    return cell;
}

- (CGFloat)cellHeightForReferenceWithIndex:(NSIndexPath *)indexPath
{
    return _referenceHeight;
}

- (UITableViewCell *)cellForDailyScheduleWithIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DailyScheduleCell getCellIdentifier]];
    
    if (cell == nil) {
        cell = [DailyScheduleCell createCell:self];	
        
    }
    
    DailyScheduleCell *dailySchedulesCell = (DailyScheduleCell *)cell;
    dailySchedulesCell.aDelegate = self;
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
//    bookingCell.bookingBgImageView.image = [[ImageManager defaultManager] bookingBgImage];
    
//    [bookingCell setCellData:NO bookings:_route.bookingsList routeType:_routeType];
    [bookingCell setCellData:_monthViewController];
    
    return cell;
}

- (CGFloat)cellHeightForBookingWithIndex:(NSIndexPath *)indexPath
{   
    return _bookingCellFrame.size.height;    
//    return [BookingCell getCellHeight];
}

- (void)didChangeFrame:(CGRect)frame
{
    self.bookingCellFrame = frame;
    [dataTableView reloadData];
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

- (UITableViewCell *)cellForPackageWithIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PackageCell getCellIdentifier]];
    
    if (cell == nil) {
        cell = [PackageCell createCell:self];				            
        
    }
    
    PackageCell *packageCell = (PackageCell *)cell;
    
    [packageCell setCellData:[_route.packagesList objectAtIndex:indexPath.row]];
    
    packageCell.aDelegate = self;
    
    return cell;
}

- (CGFloat)cellHeightForPackageWithIndex:(NSIndexPath *)indexPath
{
    TravelPackage *package = [[_route packagesList] objectAtIndex:indexPath.row];
    
    CGFloat height = 0;
    if ([package.accommodationsList count] > 0) {
        height = 96 + 28 * [package.accommodationsList count];
    } else {
        height = 96 + 28;
    }
    
    //CGFloat height = 5 + 32 + (HEIGHT_ACCOMODATION_VIEW + EDGE) * [package.accommodationsList count];
    
    return height;
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
    
    NSString *title = [self titleForSection:indexPath.section];
    if ([title isEqualToString:SECTION_TITLE_CHARACTICS]) {
        height = [self cellHeightForCharacticsWithIndex:indexPath];
    }else if ([title isEqualToString:SECTION_TITLE_DAILY_SCHEDULE]) {
        height = [self cellHeightForDailyScheduleWithIndex:indexPath];
    }else if ([title isEqualToString:SECTION_TITLE_BOOKING]) {
        height = [self cellHeightForBookingWithIndex:indexPath];
    }else if ([title isEqualToString:SECTION_TITLE_RELATED_PLACE]) {
        height = [self cellHeightForRelatedPlaceWithIndex:indexPath];
    }else if ([title isEqualToString:SECTION_TITLE_REFERENCE]) {
         height = [self cellHeightForReferenceWithIndex:indexPath];
    }else{
        for (TravelPackage *package in _route.packagesList) {
            if ([title isEqualToString:package.name]) {
                height = [self cellHeightForPackageWithIndex:indexPath];
            }
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
    return HEIGHT_FOOTER_VIEW * [self isSectionOpen:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = (UIView *)[_sectionHeaderViews objectForKey:[NSNumber numberWithInt:section]];
    if (view == nil) {
        view = [self headerViewForSection:section];
        [_sectionHeaderViews setObject:view forKey:[NSNumber numberWithInt:section]];
    }
    
    return view;
}

- (NSString *)titleForSection:(NSInteger)section
{    
    return [self.sectionInfo objectForKey:[NSNumber numberWithInt:section]];
}


#define WIDTH_FOLLOW_BUTTON 92
#define HEIGHT_FOLLOW_BUTTOn 29

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self isSectionOpen:section]) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_FOOTER_VIEW);
    UIView *view = [[[UIView alloc] initWithFrame:rect] autorelease];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (RankView *)headerRankView
{
    RankView *rankView = [[[RankView alloc] initWithGoodImage:[[ImageManager defaultManager] rankGoodImage] 
                                                    badImage:[[ImageManager defaultManager] rankBadImage]  
                                                   imageSize:CGSizeMake(11, 16) 
                                                       space:3 
                                                    maxCount:3 
                                                        rank:_route.averageRank] autorelease];
    rankView.frame = CGRectMake(74, 7, rankView.frame.size.width, rankView.frame.size.height);
    return rankView;
}

- (UILabel *)headerNote
{
    UILabel *note = [[[UILabel alloc] initWithFrame:CGRectMake(74, 1, 80, 30)] autorelease];
    note.backgroundColor = [UIColor clearColor];
    note.textColor = [UIColor colorWithRed:75.0/255.0 green:75.0/255.0 blue:76.0/255.0 alpha:1];
    note.font = [UIFont systemFontOfSize:11];
    
    return note;
}

- (UIView *)headerViewForSection:(NSInteger)section
{
    UIView *headerView = [self headerView:section];
    headerView.tag = section;
    
    UILabel *label = [self headerTitle];
    label.text = [self titleForSection:section];
    [headerView addSubview:label];
    
    
    
    if ([label.text isEqualToString:SECTION_TITLE_CHARACTICS]) {
        RankView * rankView = [self headerRankView];
        [headerView addSubview:rankView];
    }
    
    
    if (_routeType == OBJECT_LIST_ROUTE_UNPACKAGE_TOUR){
        //自由行
        
        for (TravelPackage * package in _route.packagesList) {
            
            if ([label.text isEqualToString:package.name]) {
                UILabel *noteLabel = [self headerNote];
                if (package.note && [package.note length] >0) {
                    noteLabel.text = [NSString  stringWithFormat:@"(%@)", package.note];
                }
                //noteLabel.text = @"(机票+酒店)";
                CGSize labelTextSize = [label.text sizeWithFont:label.font];
                noteLabel.frame = CGRectMake(label.frame.origin.x + labelTextSize.width + 5, noteLabel.frame.origin.y, noteLabel.frame.size.width, noteLabel.frame.size.height);
                [headerView addSubview:noteLabel];
                
                break;
            }
        }
    }
    
    
    //出发日期
    if([label.text isEqualToString:SECTION_TITLE_BOOKING]) {
        UILabel *noteLabel = [self headerNote];
        if (_route.bookingNote && [_route.bookingNote length] >0) {
            noteLabel.text = [NSString  stringWithFormat:@"(%@)", _route.bookingNote];
        }
        //noteLabel.text = @"提前10天";
        [headerView addSubview:noteLabel];
    }
        
    return headerView;
}

- (UIView *)headerView:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_HEADER_VIEW);
    UIButton *headerView = [[[UIButton alloc] initWithFrame:rect] autorelease];
    [headerView setBackgroundImage:[[ImageManager defaultManager] lineListBgImage] forState:UIControlStateNormal];
    [headerView addTarget:self action:@selector(clickSectionHeaderView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(280 + 8, HEIGHT_HEADER_VIEW/2-22/2 + 1, 22 - 2, 22)];
    arrowImageView.tag = TAG_ARROW_IMAGE_VIEW;

    arrowImageView.image = [[ImageManager defaultManager] arrowImage];
    [headerView addSubview:arrowImageView];
    
    int angle = [self isSectionOpen:section] ? (0) : (-90);
    arrowImageView.transform = CGAffineTransformRotate(arrowImageView.transform, M_PI/180*angle);

    [arrowImageView release];
    
    return headerView;
}

- (UILabel *)headerTitle
{
//    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(13, 0, 80, HEIGHT_HEADER_VIEW)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, HEIGHT_HEADER_VIEW)] autorelease];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.textColor = [UIColor colorWithRed:37.0/255.0 green:66.0/255.0 blue:80.0/255.0 alpha:1];
    headerTitle.font = FONT_SECTION_TITLE;
    headerTitle.textColor = COLOR_SECTION_TITLE;
//    headerTitle.backgroundColor = [UIColor redColor];
    return headerTitle;
}

- (NSString *)packageIdentifier:(NSString *)packageName 
                        section:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@%d", packageName, section];
}


- (void)clickSectionHeaderView:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL open = [self isSectionOpen:button.tag];
    [self setSection:button.tag Open:!open];
    
    UIView *arrowImageView = [button viewWithTag:TAG_ARROW_IMAGE_VIEW];
    [CATransaction begin];
    [CATransaction setAnimationDuration:2];
    int angle = open ? (-90) : (90);
    arrowImageView.transform = CGAffineTransformRotate(arrowImageView.transform, M_PI/180*angle);
    [CATransaction commit];
}

- (void)didSelectedRelatedPlace:(int)placeId
{
    if ([_aDelegate respondsToSelector:@selector(didSelectedPlace:)]) {
        [_aDelegate didSelectedPlace:placeId];
    }
}

#define FAVORITES_OK_VIEW 777
- (IBAction)clickFollowRoute:(id)sender
{
    CGRect rect = CGRectMake(0, 0, 109, 52);
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.tag = FAVORITES_OK_VIEW;
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"favorites_ok.png"]];
    [button setTitle:NSLS(@"关注成功") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-8, 20, 0, 0)];
    CGPoint fromPosition = CGPointMake(320/2, 283);
    CGPoint toPosition = CGPointMake(320/2, 283);
    [self.view addSubview:button];
    [button release];
    
    [AnimationManager alertView:button fromPosition:fromPosition toPosition:toPosition interval:2 delegate:self];
    
    
    [[RouteService defaultService] followRoute:_route routeType:_routeType viewController:self];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView *view = [self.view viewWithTag:FAVORITES_OK_VIEW];
    [view removeFromSuperview];
}

- (void)didClickFlight:(int)packageId
{
    if ([_aDelegate respondsToSelector:@selector(didClickFlight:)]) {
        [_aDelegate didClickFlight:packageId];
    }
}

- (void)didClickAccommodation:(int)hotelId
{
    if ([_aDelegate respondsToSelector:@selector(didSelectedPlace:)]) {
        [_aDelegate didSelectedPlace:hotelId];
    }
}

- (void)didClickHotel:(int)hotelId
{
    if ([_aDelegate respondsToSelector:@selector(didSelectedPlace:)]) {
        [_aDelegate didSelectedPlace:hotelId];
    }
}

- (void)updateFollowButton
{
    if ([[RouteStorage followManager:_routeType] isExistRoute:_route.routeId]) {
        [followButton setTitle:NSLS(@"已关注") forState:UIControlStateNormal];
        [followButton setEnabled:NO];
    }
    else {
        [followButton setTitle:NSLS(@"关注线路") forState:UIControlStateNormal];
        [followButton setEnabled:YES];
    }
}

#pragma mark - RouteServiceDelegate method
- (void)followRouteDone:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    [self updateFollowButton]; 
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    webView.alpha = 1.0;
    
    PPDebug(@"<RouteIntroductionController> referenceHeight:%f",_referenceHeight);
    
    if (self.referenceHeight != newFrame.size.height) {
        self.referenceHeight = newFrame.size.height;
        [self.dataTableView reloadData];
    }
}


@end
