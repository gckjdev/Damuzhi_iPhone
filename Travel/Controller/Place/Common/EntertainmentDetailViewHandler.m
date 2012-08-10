//
//  EntertainmentDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"
#import "PlaceUtils.h"

@implementation EntertainmentDetailViewHandler

- (void)addDetailViewsToController:(CommonPlaceDetailController*)controller WithPlace:(Place*)place
{
    [controller addIntroductionViewWith: NSLS(@"商家简介") description:[place introduction]];
    
    [controller addSegmentViewWith: NSLS(@"营业时间") description: [place openTime]];
    
    [controller addSegmentViewWith:NSLS(@"人均消费") description:[PlaceUtils getDetailPrice:place]];
    
    //[controller addSegmentViewWith: NSLS(@"推荐理由") description:[place.keywordsList componentsJoinedByString:@"、"]];
    
    [controller addSegmentViewWith: NSLS(@"交通信息") description:[place transportation]];
    
    [controller addSegmentViewWith: NSLS(@"玩乐贴士") description:[place tips]]; 
}

@end
