//
//  SpotDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"
#import "PlaceUtils.h"

@implementation HotelDetailViewHandler

#define NO_DETAIL_DATA NSLS(@"暂无")

-(void)addStarLevelViewWith:(NSString*)titleString description:(NSString*)descriptionString starCount:(int32_t)starCount controller:(CommonPlaceDetailController *)controller
{
    CGSize withinSize = CGSizeMake(300, 100000);
    
    NSString *description = descriptionString;
    if ([description length] == 0) {
        description = NO_DETAIL_DATA;
    }
    CGSize size = [description sizeWithFont:SEGAMENT_DESCRIPTION_FONT constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *segmentView = [[[UIView alloc]initWithFrame:CGRectMake(0, controller.detailHeight, 320, size.height + TITLE_VIEW_HEIGHT)] autorelease];
    segmentView.backgroundColor = PRICE_BG_COLOR;
    
    UILabel *title = [controller createTitleView:titleString];
    [segmentView addSubview:title];
    
    UIView *starIconView = [[[UIView alloc]initWithFrame:CGRectMake(10, 26, 15 * starCount, 12.5)] autorelease];

    int32_t i = 0;
    CGRect rect = CGRectMake(0, 0, 12.5, 12);
    for (i = 0; i < starCount; i++) {
        UIImageView *starView = [[UIImageView alloc] initWithFrame:rect];
        UIImage *icon = [UIImage imageNamed:@"star_ico"];
        
        starView.center = CGPointMake(8+i*15, 6); 
        
        [starView setImage:icon];
        [starIconView addSubview:starView];
        [starView release];
    }

    [segmentView addSubview:starIconView];

    UILabel *introductionDescription;
    if (starCount != 0) {
        introductionDescription= [[[UILabel alloc]initWithFrame:CGRectMake(starIconView.frame.origin.x + starIconView.frame.size.width + 10, 26, 300, size.height)] autorelease];
    }
    else
    {
        introductionDescription= [[[UILabel alloc]initWithFrame:CGRectMake(10, 26, 300, size.height)] autorelease];
    }
    
    introductionDescription.lineBreakMode = UILineBreakModeWordWrap;
    introductionDescription.numberOfLines = 0;
    introductionDescription.backgroundColor = [UIColor clearColor];
    introductionDescription.textColor = DESCRIPTION_COLOR;
    introductionDescription.font = SEGAMENT_DESCRIPTION_FONT;
    introductionDescription.text = description;  
    
    
    [segmentView addSubview:introductionDescription];
    [controller.dataScrollView addSubview:segmentView];    
    
    UIView *middleLineView = [controller createMiddleLineView: controller.detailHeight + segmentView.frame.size.height];
    [controller.dataScrollView addSubview:middleLineView];
    
    controller.detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
}


- (void)addDetailViewsToController:(CommonPlaceDetailController*)controller WithPlace:(Place*)place
{
    [controller addIntroductionViewWith: NSLS(@"酒店简介") description:[place introduction]];
    
    [self addStarLevelViewWith: NSLS(@"酒店星级") description:[PlaceUtils hotelStarToString:[place hotelStar]] starCount:[place hotelStar] controller:controller];
    
    //[controller addSegmentViewWith: NSLS(@"推荐理由") description:[[place keywordsList] componentsJoinedByString:@"、"]];
    
    [controller addSegmentViewWith: NSLS(@"房间价格") description:[PlaceUtils getDetailPrice:place]];
    
    [controller addTransportView:place];
}

@end
