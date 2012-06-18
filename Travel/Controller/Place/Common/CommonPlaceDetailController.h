//
//  CommonPlaceDetailController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012å¹?__MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "PlaceService.h"
#import "NearByRecommendController.h"

@class Place;
@class CommonPlaceDetailController;

#define SEGAMENT_TITLE_FONT [UIFont systemFontOfSize:15]
#define SEGAMENT_DESCRIPTION_FONT [UIFont systemFontOfSize:14]

#define TITLE_VIEW_HEIGHT 34
#define MIDDLE_LINE_HEIGHT 2
#define CGRECT_TITLE CGRectMake(10, 3, 100, 20)
#define TITLE_COLOR [UIColor colorWithRed:37.0/255.0 green:66.0/255.0 blue:80/255.0 alpha:1.0]
#define DESCRIPTION_COLOR [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]
#define INTRODUCTION_BG_COLOR [UIColor colorWithRed:222/255.0 green:239/255.0 blue:247/255.0 alpha:1.0]
#define PRICE_BG_COLOR [UIColor colorWithRed:235/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]

@protocol CommonPlaceDetailDataSourceProtocol <NSObject>

- (void)addDetailViewsToController:(CommonPlaceDetailController*)controller WithPlace:(Place*)place;

@end

@interface SpotDetailViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface HotelDetailViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface RestaurantViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface ShoppingDetailViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface EntertainmentDetailViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface CommonPlaceDetailController : PPViewController<UIActionSheetDelegate,PlaceServiceDelegate>

@property (retain, nonatomic) IBOutlet UIView *buttonHolerView;
@property (retain, nonatomic) IBOutlet UIView *imageHolderView;
@property (retain, nonatomic) IBOutlet UIScrollView *dataScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon1;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon2;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon3;
@property (retain, nonatomic) IBOutlet UIView *serviceHolder;
@property (retain, nonatomic) Place *place;
@property (retain, nonatomic) NSArray *nearbyPlaceList;
@property (retain, nonatomic) NearByRecommendController* nearbyRecommendController;
@property (assign, nonatomic) id<CommonPlaceDetailDataSourceProtocol> handler;
@property (assign, nonatomic) float detailHeight;

- (IBAction)clickHelpButton:(id)sender;
- (id)initWithPlace:(Place*)place;

- (UILabel*)createTitleView:(NSString*)title;
- (UILabel*)createDescriptionView:(NSString*)description height:(CGFloat)height;
- (UIView*)createMiddleLineView:(CGFloat)y;

-(void)addIntroductionViewWith:(NSString*)titleString description:(NSString*)descriptionString;
-(void)addSegmentViewWith:(NSString*)titleString description:(NSString*)descriptionString;
- (void)addTransportView:(Place*)place;

@end
