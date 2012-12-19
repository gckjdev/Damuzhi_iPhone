//
//  CommonPlaceDetailController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "SlideImageView.h"
#import "Place.pb.h"
#import "ImageName.h"
#import "UIImageUtil.h"
#import "UIUtils.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "PlaceStorage.h"
#import "NearByRecommendController.h"
#import "AnimationManager.h"
#import "CommonWebController.h"
#import "ImageName.h"
#import "PPNetworkRequest.h"
#import "PlaceUtils.h"
#import "AppService.h"
#import "MapUtils.h"
#import "UIImageUtil.h"
#import "FontSize.h"

#define NO_DETAIL_DATA NSLS(@"暂无")

#define WIDTH_NEARBY_PLACE_BUTTON  300
#define HEIGHT_NEARBY_PLACE_BUTTON 30

#define WIDTH_NEARBY_PLACE_NAME_LABEL 150
#define HEIGHT_NEARBY_PLACE_NAME_LABEL 14

#define WIDTH_TRANSPORTATION_TABLE_ROW 300
#define HEIGHT_TRANSPORTATION_TABLE_ROW 30

#define WIDTH_TRANSPORTATION_NAME_LABEL 150
#define HEIGHT_TRANSPORTATION_NAME_LABEL 14

#define WIDTH_TRANSPORTATION_DISTANCE_LABEL 65
#define HEIGHT_TRANSPORTATION_DISTANCE_LABEL 14

#define MAX_NUM_PLACES_NEARBY 10

#define TAG_NEARBY_VIEW 5268
#define TAG_TELEPHONE_VIEW 5269
#define TAG_ADDRESS_VIEW 5270
#define TAG_WEBSITE_VIEW 5271

#define TAG_FAVORITE_VIEW 5272
#define TAG_FAVORITE_BUTTON 22221
#define TAG_FAVORITE_COUNT_LABEL 22222

@implementation CommonPlaceDetailController
@synthesize buttonHolerView;
@synthesize imageHolderView;
@synthesize dataScrollView;
@synthesize place = _place;
@synthesize nearbyPlaceList = _nearbyPlaceList;
@synthesize praiseIcon1;
@synthesize praiseIcon2;
@synthesize praiseIcon3;
@synthesize serviceHolder;
@synthesize handler;
@synthesize detailHeight = _detailHeight;
@synthesize nearbyRecommendController = _nearbyRecommendController;


- (id<CommonPlaceDetailDataSourceProtocol>)createPlaceHandler:(Place*)onePlace
{
    if ([onePlace categoryId] == PlaceCategoryTypePlaceSpot){
        return [[[SpotDetailViewHandler alloc] init] autorelease];

    }
    else if ([onePlace categoryId] == PlaceCategoryTypePlaceHotel)
    {
        return [[[HotelDetailViewHandler alloc] init] autorelease];

    }
    else if ([onePlace categoryId] == PlaceCategoryTypePlaceRestraurant)
    {
        return [[[RestaurantViewHandler alloc] init] autorelease];
    }
    else if ([onePlace categoryId] == PlaceCategoryTypePlaceShopping)
    {
        return [[[ShoppingDetailViewHandler alloc] init] autorelease];
    }
    else if ([onePlace categoryId] == PlaceCategoryTypePlaceEntertainment)
    {
        return [[[EntertainmentDetailViewHandler alloc] init] autorelease];
    }
    return nil;
}

- (id)initWithPlace:(Place *)place
{
    self = [super init];
    if (self) {
        self.place = place;  
    }
    
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)setRankImage:(int32_t)rank
{
    UIImage *goodImage = [UIImage imageNamed:IMAGE_GOOD];
    UIImage *good2Image = [UIImage imageNamed:IMAGE_GOOD2];
    
    switch (rank) {
        case 1:
            praiseIcon1.image = goodImage;
            praiseIcon2.image = good2Image;
            praiseIcon3.image = good2Image;
            break;
            
        case 2:
            praiseIcon1.image = goodImage;
            praiseIcon2.image = goodImage;
            praiseIcon3.image = good2Image;
            break;
            
        case 3:
            praiseIcon1.image = goodImage;
            praiseIcon2.image = goodImage;
            praiseIcon3.image = goodImage;
            break;
            
        default:
            break;
    }

    return;
}

- (void)clickHelpButton:(id)sender
{
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:[AppUtils getHelpHtmlFilePath]];
    controller.navigationItem.title = NSLS(@"帮助");
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)clickHomeButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clickMap:(id)sender
{
    if (_nearbyRecommendController == nil) {
            self.nearbyRecommendController = [[[NearByRecommendController alloc] initWithPlace:_place] autorelease];
    }

    [self.navigationController pushViewController:_nearbyRecommendController animated:YES];
}

- (void)clickTelephone:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"是否拨打以下电话") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for(NSString* title in self.place.telephoneList){
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:NSLS(@"返回")];
    [actionSheet setCancelButtonIndex:[self.place.telephoneList count]];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

- (void)makeCall:(NSString*) phone
{
    [UIUtils makeCall:phone];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    PPDebug(@"make call number:%@",[self.place.telephoneList objectAtIndex:buttonIndex]);
    [self performSelector:@selector(makeCall:) withObject:[self.place.telephoneList objectAtIndex:buttonIndex]];
}


- (void)clickFavourite:(id)sender
{
    PlaceService* placeService = [PlaceService defaultService];
    [placeService addPlaceIntoFavorite:self place:self.place];
}

#define FAVORITES_OK_VIEW 2012040817
- (void)finishAddFavourite:(NSNumber*)resultCode count:(NSNumber*)count
{
    [self updateAddFavoriteButton];
    UIView *favoriteView = [dataScrollView viewWithTag:TAG_FAVORITE_VIEW];
    
    if (count != nil) {
        UILabel *favoriteCountLabel = (UILabel*)[favoriteView viewWithTag:TAG_FAVORITE_COUNT_LABEL];
        favoriteCountLabel.text = [NSString stringWithFormat:NSLS(@"已有%d人收藏"), count.intValue];
    }
    
    CGRect rect = CGRectMake(0, 0, 109, 52);
    
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"favorites_ok.png"]];
    [button setTitle:NSLS(@"收藏成功") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = FAVORITES_OK_VIEW;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-8, 20, 0, 0)];
    
    CGPoint fromPosition = CGPointMake(320/2, -18);
    CGPoint toPosition = CGPointMake(320/2, -18);
    
    [favoriteView addSubview:button];
    [button release];
    
    [AnimationManager alertView:button fromPosition:fromPosition toPosition:toPosition interval:2 delegate:self];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView *view = [self.view viewWithTag:FAVORITES_OK_VIEW];
    [view removeFromSuperview];
}

- (void)didGetPlaceData:(int)placeId count:(int)placeFavoriteCount;
{
    UILabel *favorteCountLabel = (UILabel*)[[dataScrollView viewWithTag:TAG_FAVORITE_VIEW] viewWithTag:TAG_FAVORITE_COUNT_LABEL];
    favorteCountLabel.text = [NSString stringWithFormat:NSLS(@"已有%d人收藏"),placeFavoriteCount];
}

#define DESTANCE_BETWEEN_SERVICE_IMAGES 25
#define WIDTH_OF_SERVICE_IMAGE 21
#define HEIGHT_OF_SERVICE_IMAGE 21

-(void)setServiceIcons
{
    self.serviceHolder.backgroundColor = [UIColor clearColor];
    int i = 0;

    for (NSNumber *providedServiceId in [_place providedServiceIdList]) {
        UIImageView *serviceIconView = [[UIImageView alloc] initWithFrame:CGRectMake((i++)*DESTANCE_BETWEEN_SERVICE_IMAGES, 0, WIDTH_OF_SERVICE_IMAGE, HEIGHT_OF_SERVICE_IMAGE)];
        UIImage *icon = [[UIImage alloc] initWithContentsOfFile:[AppUtils getProvidedServiceIconPath:[providedServiceId intValue]]];
        [serviceIconView setImage:icon];
        [serviceHolder addSubview:serviceIconView];
        [icon release];
        [serviceIconView release];
    }
    
}

- (UILabel*)createTitleView:(NSString*)title
{
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRECT_TITLE]autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TITLE_COLOR;
    label.font = SEGAMENT_TITLE_FONT;
    label.text  = title;
    return label;
}

- (UILabel*)createDescriptionView:(NSString*)description height:(CGFloat)height
{
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(10, 26, 300, height)] autorelease];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = DESCRIPTION_COLOR;
    label.font = SEGAMENT_DESCRIPTION_FONT;
    label.text = description; 
    return label;
}

- (UIView*)createMiddleLineView:(CGFloat)y
{
    
    UIView *middleLineView = [[[UIView alloc]initWithFrame:CGRectMake(0, y, 320, MIDDLE_LINE_HEIGHT)] autorelease];
    middleLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_line"]];
    return middleLineView;
}

-(void)addIntroductionViewWith:(NSString*)titleString description:(NSString*)descriptionString
{
    CGSize withinSize = CGSizeMake(300, CGFLOAT_MAX);
    
    NSString *description = [NSString stringWithFormat:@"       %@",[descriptionString stringByReplacingOccurrencesOfString:@"\n" withString:@"\n       "]];
    
    if ([description length] == 0) {
        description = NO_DETAIL_DATA;
    }
    CGSize size = [description sizeWithFont:SEGAMENT_DESCRIPTION_FONT constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.detailHeight, 320, size.height + TITLE_VIEW_HEIGHT + 10)];
    segmentView.backgroundColor = INTRODUCTION_BG_COLOR;
        
    UILabel *title = [[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, TITLE_VIEW_HEIGHT)]autorelease];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = TITLE_COLOR;
    title.font = SEGAMENT_TITLE_FONT;
    title.text  = titleString;
    [segmentView addSubview:title];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 34)];
    [shadowView setImage:[UIImage strectchableImageName:@"detail_shadow"]];
    [segmentView addSubview:shadowView];
    [segmentView sendSubviewToBack:shadowView];
    [shadowView release];
    
    UILabel *introductionDescription = [[UILabel alloc]initWithFrame:CGRectMake(10, shadowView.frame.size.height + 4, 300, size.height)];
    introductionDescription.lineBreakMode = UILineBreakModeWordWrap;
    introductionDescription.numberOfLines = 0;
    introductionDescription.backgroundColor = [UIColor clearColor];
    introductionDescription.textColor = DESCRIPTION_COLOR;
    introductionDescription.font = SEGAMENT_DESCRIPTION_FONT;
    
    introductionDescription.text = description;
        
    [segmentView addSubview:introductionDescription];
    [introductionDescription release];
    [dataScrollView addSubview:segmentView];    
    [segmentView release];
    
    UIView *middleLineView = [self createMiddleLineView: _detailHeight + segmentView.frame.size.height];
    [dataScrollView addSubview:middleLineView];
    
    _detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
}

-(void)addSegmentViewWith:(NSString*)titleString description:(NSString*)descriptionString
{
    CGSize withinSize = CGSizeMake(300, CGFLOAT_MAX);
    
    NSString *description = [descriptionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([description length] == 0) {
        description = NO_DETAIL_DATA;
    }
    
    CGSize size = [description sizeWithFont:SEGAMENT_DESCRIPTION_FONT constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, 320, size.height + TITLE_VIEW_HEIGHT)];
    segmentView.backgroundColor = PRICE_BG_COLOR;
    
    UILabel *title = [self createTitleView:titleString];
    [segmentView addSubview:title];
    
    UILabel *introductionDescription = [self createDescriptionView:description height:size.height];    
    [segmentView addSubview:introductionDescription];
    [dataScrollView addSubview:segmentView];  
    [segmentView release];
    
    UIView *middleLineView = [self createMiddleLineView: _detailHeight + segmentView.frame.size.height];
    [dataScrollView addSubview:middleLineView];
    
    _detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
        
}

- (void) clickNearbyRow:(id)sender
{
    UIButton *button = sender;
    NSInteger index = button.tag;
    
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc] initWithPlace:[_nearbyPlaceList objectAtIndex:index]];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void) addNearbyView
{
    UIView *nearbyView = [[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, self.view.frame.size.width , MAX_NUM_PLACES_NEARBY*HEIGHT_NEARBY_PLACE_BUTTON+30+10)];
    nearbyView.tag = TAG_NEARBY_VIEW;
    nearbyView.backgroundColor = PRICE_BG_COLOR;
    
    UILabel *title = [self createTitleView:NSLS(@"周边推荐")];
    [nearbyView addSubview:title];
    
    [dataScrollView addSubview:nearbyView];    
    [nearbyView release];
    
    _detailHeight = nearbyView.frame.origin.y + nearbyView.frame.size.height;
    
    //get nearby placelist data
    [[PlaceService defaultService] findPlacesNearby:PlaceCategoryTypePlaceAll place:_place num:MAX_NUM_PLACES_NEARBY viewController:self];
}

- (void)setNearbyTaleRowBgImage:(UIButton*)button row:(int)row totoalRows:(int)totoalRows
{
    if (row < 1 || totoalRows <1 || row > totoalRows) {
        return;
    }
    
    switch (totoalRows) {
        case 1:
            [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_top.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_top.png"] forState:UIControlStateHighlighted];
            break;
            
        case 2:
            if (row == 1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_top.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_top.png"] forState:UIControlStateHighlighted];
            }
            else {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_down.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_down.png"] forState:UIControlStateHighlighted];
            }
            break;

        default:
            if (row == 1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_top.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_top.png"] forState:UIControlStateHighlighted];
            }
            else if (row >1 && row <totoalRows) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_center.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_center.png"] forState:UIControlStateHighlighted];
            }
            else {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_down.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_down.png"] forState:UIControlStateHighlighted];
            }
            break;
    }
}

- (void)reLayoutViewBelowView:(UIView*)view
{
    _detailHeight = view.frame.origin.y + view.frame.size.height;
    
    UIView *telephoneView = [dataScrollView viewWithTag:TAG_TELEPHONE_VIEW];
    if (telephoneView != nil) {
        [telephoneView setFrame:CGRectMake(telephoneView.frame.origin.x, _detailHeight, telephoneView.frame.size.width, telephoneView.frame.size.height)];
        _detailHeight = telephoneView.frame.origin.y + telephoneView.frame.size.height;
    }

    UIView *addressView = [dataScrollView viewWithTag:TAG_ADDRESS_VIEW];
    if (addressView != nil) {
        [addressView setFrame:CGRectMake(addressView.frame.origin.x, _detailHeight, addressView.frame.size.width, addressView.frame.size.height)];
        _detailHeight = addressView.frame.origin.y + addressView.frame.size.height;
    }

    UIView *websiteView = [dataScrollView viewWithTag:TAG_WEBSITE_VIEW];
    if (websiteView != nil) {
        [websiteView setFrame:CGRectMake(websiteView.frame.origin.x, _detailHeight, websiteView.frame.size.width, websiteView.frame.size.height)];
        _detailHeight = websiteView.frame.origin.y + websiteView.frame.size.height;
    }

    UIView *favouritesView = [dataScrollView viewWithTag:TAG_FAVORITE_VIEW];
    if (favouritesView != nil) {
        [favouritesView setFrame:CGRectMake(favouritesView.frame.origin.x, _detailHeight, favouritesView.frame.size.width, favouritesView.frame.size.height)];
        _detailHeight = favouritesView.frame.origin.y + favouritesView.frame.size.height;
    }

    [dataScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _detailHeight)];
}

- (void)addBottomImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, dataScrollView.contentSize.height, 320, 250)];
    [imageView setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
    [dataScrollView addSubview:imageView];
    [imageView release];
}

//request done after get nearby placelist
- (void)findRequestDone:(int)result placeList:(NSArray *)placeList
{
    if (result == ERROR_SUCCESS) {
        
        self.nearbyPlaceList = placeList;
        
        UIView *nearbyView = [dataScrollView viewWithTag:TAG_NEARBY_VIEW];
        
        [nearbyView setFrame:CGRectMake(nearbyView.frame.origin.x, nearbyView.frame.origin.y, self.view.frame.size.width, [placeList count]*HEIGHT_NEARBY_PLACE_BUTTON+30+10)];
        [self reLayoutViewBelowView:nearbyView];

        CLLocation *loc = [[CLLocation alloc] initWithLatitude:_place.latitude longitude:_place.longitude];
        int i = 0;
        for (Place *nearbyPlace in _nearbyPlaceList)
        {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:nearbyPlace.latitude longitude:nearbyPlace.longitude];
            [location release];
            
            UIButton *rowView = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-WIDTH_NEARBY_PLACE_BUTTON)/2, 30 + HEIGHT_NEARBY_PLACE_BUTTON*(i++), WIDTH_NEARBY_PLACE_BUTTON, HEIGHT_NEARBY_PLACE_BUTTON)];
            rowView.tag = [_nearbyPlaceList indexOfObject:nearbyPlace];
            
            [self setNearbyTaleRowBgImage:rowView row:i totoalRows:[_nearbyPlaceList count]];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 14, 14)];
            
            NSString *imageName = [AppUtils getCategoryIcon:[nearbyPlace categoryId]];
            UIImage *image = [UIImage imageNamed:imageName];
            [imageView setImage:image];
            [rowView addSubview:imageView];
            [imageView release];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+6, 8, WIDTH_NEARBY_PLACE_NAME_LABEL, HEIGHT_NEARBY_PLACE_NAME_LABEL)];
            nameLabel.text = [nearbyPlace name];
            nameLabel.font = SEGAMENT_DESCRIPTION_FONT;
            nameLabel.textColor = DESCRIPTION_COLOR;
            
            nameLabel.backgroundColor = [UIColor clearColor];
            [rowView addSubview:nameLabel];
            [nameLabel release];
            
            //add rankImage
            UIView *rankView = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+8, 9, 40, 14)];
            
            for (int i=0;i<[nearbyPlace rank];i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14*i, 0, 9, 13)];
                UIImage *image = [UIImage imageNamed:IMAGE_GOOD2];
                [imageView setImage:image];
                [rankView addSubview:imageView];
                [imageView release];
            }
            rankView.backgroundColor = [UIColor clearColor];
            [rowView addSubview:rankView];
            [rankView release];

            
            UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(rankView.frame.origin.x+rankView.frame.size.width+8, 8, 40, 14)];            
            NSString* distanceString = [PlaceUtils getDistanceString:nearbyPlace currentLocation:loc];
            distanceLabel.text = distanceString;
            distanceLabel.textAlignment = UITextAlignmentRight;
            distanceLabel.font = SEGAMENT_DESCRIPTION_FONT;
            distanceLabel.textColor = DESCRIPTION_COLOR;
            distanceLabel.backgroundColor = [UIColor clearColor];
            [rowView addSubview:distanceLabel];
            [distanceLabel release];
            
            UIImageView *goView = [[UIImageView alloc] initWithFrame:CGRectMake(distanceLabel.frame.origin.x+distanceLabel.frame.size.width+8, 8, 7, 14)];
            
            UIImage *goImage = [UIImage imageNamed:@"go_btn"];
            [goView setImage:goImage];
            [rowView addSubview:goView];
            [goView release];
            
            [rowView addTarget:self action:@selector(clickNearbyRow:) forControlEvents:UIControlEventTouchUpInside];
            [nearbyView addSubview:rowView];
            [rowView release];
        }    
        [loc release];
    }
    else {
        [self popupMessage:@"加载周边推荐数据失败！" title:nil];
    }
}



- (void)setTransportTaleRowBgImage:(UIButton*)button row:(int)row totoalRows:(int)totoalRows
{
    if (row < 1 || totoalRows < 2 || row > totoalRows) {
        return;
    }
    
    switch (totoalRows) {
        case 2:
            if (row == 1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_top.png"] forState:UIControlStateNormal];
                
            }
            else {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_down.png"] forState:UIControlStateNormal];
            }
            break;
            
        default:
            if (row == 1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_top.png"] forState:UIControlStateNormal];
            }
            else if (row >1 && row <totoalRows) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_center.png"] forState:UIControlStateNormal];
            }
            else {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_down.png"] forState:UIControlStateNormal];            }
            break;
    }
}

- (void)addTransportView:(Place*)place
{
    NSMutableString * transportation = [NSMutableString stringWithString:place.transportation];
    [transportation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([transportation length] == 0) {
        [self addSegmentViewWith:NSLS(@"交通信息") description:@"暂无"];
    }
    else {
        NSString *str = [NSString stringWithFormat:@"位置:距酒店;%@",transportation];
        NSArray *array1 = [str componentsSeparatedByString:@";"];

        // remove unused ":" and last object which is whitespace
        //香港国际机场:约35公里;:;:;:; 
        PPDebug(@"-------%@", str);
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:array1];
        NSRange range=NSMakeRange(0,[array count]);
        [array removeObject:@":" inRange:range];
        [array removeLastObject];
        
        UIView *segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, self.view.frame.size.width, ([array count]+1)*HEIGHT_TRANSPORTATION_TABLE_ROW+10)];

        segmentView.backgroundColor = PRICE_BG_COLOR;
        
        UILabel *title = [self createTitleView:NSLS(@"交通信息")];
        [segmentView addSubview:title];
        
        [dataScrollView addSubview:segmentView];    
        _detailHeight = segmentView.frame.origin.y + segmentView.frame.size.height;
        
        for (int i=1; i <= [array count]; i++)
        {
            NSArray *subArray = [[array objectAtIndex:(i-1)] componentsSeparatedByString:@":"];
            UIButton *rowView = [[UIButton alloc] initWithFrame:CGRectMake(10, 30 + HEIGHT_TRANSPORTATION_TABLE_ROW*(i-1), WIDTH_TRANSPORTATION_TABLE_ROW, HEIGHT_TRANSPORTATION_TABLE_ROW)];
            
            [rowView setUserInteractionEnabled:NO];
            
            [self setTransportTaleRowBgImage:rowView row:i totoalRows:[array count]];

            if ([subArray objectAtIndex:0] != nil) {
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, WIDTH_TRANSPORTATION_NAME_LABEL, HEIGHT_TRANSPORTATION_NAME_LABEL)];
                nameLabel.text = [subArray objectAtIndex:0];
                nameLabel.font = SEGAMENT_DESCRIPTION_FONT;
                nameLabel.textColor = DESCRIPTION_COLOR;
                nameLabel.backgroundColor = [UIColor clearColor];
                [rowView addSubview:nameLabel];
                [nameLabel release];
            }
            
            if ([subArray objectAtIndex:1] != nil) {
                UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(rowView.frame.size.width-6-WIDTH_TRANSPORTATION_DISTANCE_LABEL, 6, WIDTH_TRANSPORTATION_DISTANCE_LABEL, HEIGHT_TRANSPORTATION_DISTANCE_LABEL)];
                
                distanceLabel.text = [subArray objectAtIndex:1];
                distanceLabel.font = SEGAMENT_DESCRIPTION_FONT;
                distanceLabel.textColor = DESCRIPTION_COLOR;
                distanceLabel.backgroundColor = [UIColor clearColor];
                [rowView addSubview:distanceLabel];
                [distanceLabel release];
            }
                        
            [segmentView addSubview:rowView];
            [rowView release];
        }
        [segmentView release];
        [array release];
        
        UIView *middleLineView = [self createMiddleLineView: _detailHeight];
        [dataScrollView addSubview:middleLineView];
        _detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
    }
}

//创建电话、地址、网站 的通用方法
- (UIView*)createRowView:(NSString*) title detail:(NSString*)detail
{    
    int width = 235;
    CGSize withinSize = CGSizeMake(width, CGFLOAT_MAX);
    UIView* rowView;
    CGSize size = [detail sizeWithFont:SEGAMENT_TITLE_FONT constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    int height = 0;
    if ([detail length] == 0) {
        rowView = [[[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, 320, 42)] autorelease];
        height = 42;
    }
    else
    {
        rowView = [[[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, 320, size.height + 26)] autorelease];
        height = size.height + 26;
    }
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    [bgImageView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1]];
    
    bgImageView.image = [UIImage imageNamed:@"t_bg.png"];
    [rowView addSubview:bgImageView];
    [rowView sendSubviewToBack:bgImageView];
    [bgImageView release];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, ceilf((height - 20)/2), 40, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:79/255.0 green:102/255.0 blue:119/255.0 alpha:1.0];
    label.font = SEGAMENT_TITLE_FONT;
    label.text = title;
    [rowView addSubview:label];
    [label release];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 0, width, height)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.lineBreakMode = UILineBreakModeWordWrap;
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = [UIColor colorWithRed:89/255.0 green:112/255.0 blue:129/255.0 alpha:1.0];
    detailLabel.font = SEGAMENT_TITLE_FONT;
    if ([detail length] == 0) {
        detailLabel.text = NSLS(@" 暂无");
    }else
    {
        detailLabel.text = detail;
    }
    [rowView addSubview:detailLabel];
    [detailLabel release];
    
    return rowView;
}

- (void)addTelephoneView
{
    UIView *telephoneView = [self createRowView:NSLS(@"电话: ") detail:[self.place.telephoneList componentsJoinedByString:@" "]];
    telephoneView.tag = TAG_TELEPHONE_VIEW;
    
    if ([self.place.telephoneList count] != 0) {
        UIImageView *phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(290, 6, 29, 29)];
        [phoneImage setImage:[UIImage imageNamed:@"t_phone"]];
        [phoneImage setCenter:CGPointMake(300, telephoneView.frame.size.height/2)];
        [telephoneView addSubview:phoneImage];
        [phoneImage release];
        
        UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, telephoneView.frame.size.width, telephoneView.frame.size.height)];
        telButton.backgroundColor =[UIColor clearColor];
        [telButton addTarget:self action:@selector(clickTelephone:) forControlEvents:UIControlEventTouchUpInside];
        [telephoneView addSubview:telButton];
        [telButton release];
    }
    
    [dataScrollView addSubview:telephoneView];
    _detailHeight = telephoneView.frame.origin.y + telephoneView.frame.size.height;
}

- (void)addAddressView
{
    UIView *addressView = [self createRowView:NSLS(@"地址: ") detail:[[_place addressList] componentsJoinedByString:@" "]];
    addressView.tag = TAG_ADDRESS_VIEW;
    
    int height = addressView.frame.size.height;
    
    UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 20)/2, 29, 29)];
    [mapImageView setImage:[UIImage imageNamed:@"t_map"]];
    [mapImageView setCenter:CGPointMake(300, addressView.frame.size.height/2)];
    [addressView addSubview:mapImageView];
    [mapImageView release];
    
    UIButton *mapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, addressView.frame.size.width, addressView.frame.size.height)];
    mapButton.backgroundColor =[UIColor clearColor];
    [mapButton addTarget:self action:@selector(clickMap:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:mapButton];
    [mapButton release];
    
    [dataScrollView addSubview:addressView];
    
    _detailHeight = _detailHeight + addressView.frame.size.height;
}

- (void)addWebsiteView
{
    NSString* websiteUrl = [self.place website];
    if ([websiteUrl length] > 0) {
        UIView *websiteView = [self createRowView:NSLS(@"网站: ") detail:[self.place website]];
        [dataScrollView addSubview:websiteView];
        websiteView.tag = TAG_WEBSITE_VIEW;
        _detailHeight = _detailHeight + websiteView.frame.size.height;
    }
}

- (void)updateAddFavoriteButton
{
    UIButton *favoriteButton = (UIButton*)[[dataScrollView viewWithTag:TAG_FAVORITE_VIEW] viewWithTag:TAG_FAVORITE_BUTTON];
    if ([[PlaceStorage favoriteManager] isPlaceInFavorite:self.place.placeId]) {
        [favoriteButton setTitle:NSLS(@"已收藏") forState:UIControlStateNormal];
        [favoriteButton setEnabled:NO];
    }
    else {
        [favoriteButton setTitle:NSLS(@"收藏本页") forState:UIControlStateNormal];
        [favoriteButton setEnabled:YES];
    }
}

- (void)addBottomView
{
    UIView *favouritesView = [[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, self.view.frame.size.width, 60)];
    favouritesView.tag = TAG_FAVORITE_VIEW;

    favouritesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottombg.png"]];
    
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-93)/2, 5, 93, 29)];
    favButton.tag = TAG_FAVORITE_BUTTON;
    [favButton addTarget:self action:@selector(clickFavourite:) forControlEvents:UIControlEventTouchUpInside];
    favButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"favorites.png"]];
    [favButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [favButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
    [favouritesView addSubview:favButton];
    [favButton release];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((320-120)/2, 40, 120, 15)];
    label.tag = TAG_FAVORITE_COUNT_LABEL;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    [[PlaceService defaultService] getPlaceFavoriteCount:self placeId:self.place.placeId];
    label.font = [UIFont boldSystemFontOfSize:14];
    [favouritesView addSubview:label];
    [label release];
    
    [dataScrollView addSubview:favouritesView];
    [favouritesView release];
    
    [self updateAddFavoriteButton];
    
    _detailHeight = favouritesView.frame.origin.y + favouritesView.frame.size.height;
}

- (void)addHeaderView
{
    buttonHolerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage strectchableImageName:@"topmenu_bg2"]];
    [self setRankImage:[self.place rank]];
    [self setServiceIcons];
}

- (void)addSlideImageView
{
    NSMutableArray *imagePathList = [[NSMutableArray alloc] init];

    if ([AppUtils isShowImage]) {
        //handle imageList, if there has local data, each image is a relative path, otherwise, it is a absolute URL.
        for (NSString *image in self.place.imagesList) {
            NSString *path = [AppUtils getAbsolutePath:[AppUtils getCityDir:[[AppManager defaultManager] getCurrentCityId]] string:image];
            [imagePathList addObject:path];
        }
    }
    else {
        [imagePathList addObject:IMAGE_PLACE_DETAIL];
    }
    
    SlideImageView* slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    slideImageView.defaultImage = IMAGE_PLACE_DETAIL;
    
    [slideImageView.pageControl setPageIndicatorImageForCurrentPage:[UIImage strectchableImageName:@"point_pic3.png"] forNotCurrentPage:[UIImage strectchableImageName:@"point_pic4.png"]];
    [slideImageView setImages:imagePathList];
    [self.imageHolderView addSubview:slideImageView];
    
    [imagePathList release];
    [slideImageView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    UIView *rightBarView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 73, 32)] autorelease];
    UIButton *homeButon = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)] autorelease];
    UIButton *mapButon = [[[UIButton alloc] initWithFrame:CGRectMake(40, 0, 32, 32)] autorelease];
    
    [homeButon setImage:[UIImage imageNamed:@"home_po.png"] forState:UIControlStateNormal];
    [mapButon setImage:[UIImage imageNamed:@"map_po.png"] forState:UIControlStateNormal];
    [homeButon addTarget:self action:@selector(clickHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    [mapButon addTarget:self action:@selector(clickMap:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBarView addSubview:homeButon];
    [rightBarView addSubview:mapButon];
    
    UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightBarView] autorelease];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    [self setTitle:[self.place name]];
    
    self.handler = [self createPlaceHandler:_place];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -250, 320, 250)];
    [imageView setImage:[UIImage imageNamed:@"detail_bg_up.png"]];
    [dataScrollView addSubview:imageView];
    [imageView release];
    
    [self addHeaderView];
    
    [self addSlideImageView];
    
    _detailHeight = imageHolderView.frame.size.height;
    
    [self.handler addDetailViewsToController:self WithPlace:self.place];
        
    [self addNearbyView];
    
    [self addTelephoneView];
    
    [self addAddressView];
    
    [self addWebsiteView];
        
    [self addBottomView];
    
    [dataScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _detailHeight)];
    
    [self addBottomImage];
    
    //[[PlaceStorage historyManager] addPlace:self.place];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setButtonHolerView:nil];
    [self setImageHolderView:nil];
    [self setDataScrollView:nil];
    [self setPraiseIcon1:nil];
    [self setPraiseIcon2:nil];
    [self setPraiseIcon3:nil];
    [self setServiceHolder:nil];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [buttonHolerView release];
    [imageHolderView release];
    [dataScrollView release];
    [praiseIcon1 release];
    [praiseIcon2 release];
    [praiseIcon3 release];
    [serviceHolder release];
    PPRelease(_place);
    PPRelease(_nearbyPlaceList);
    PPRelease(_nearbyRecommendController);
    [super dealloc];
}
@end
