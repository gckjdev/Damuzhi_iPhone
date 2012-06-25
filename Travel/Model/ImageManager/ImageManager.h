//
//  ImageManager.h
//  Travel
//
//  Created by 小涛 王 on 12-6-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

#define POSITION_TOP 1
#define POSITION_MIDDLE 2
#define POSITION_BOTTOM 3
#define POSITION_ONLY_ONE 4

@interface ImageManager : NSObject <CommonManagerProtocol>

- (UIImage *)navigationBgImage;
- (UIImage *)filterBtnsHolderViewBgImage;
- (UIImage *)filgerBtnBgImage;

- (UIImage *)listBgImage;

- (UIImage *)routeRankGoodImage;
- (UIImage *)routeRankBadImage;

- (UIImage *)departIcon;
- (UIImage *)angencyIcon;
- (UIImage *)routeCountIcon;

- (UIImage *)statisticsBgImage;
- (UIImage *)lineImage;

- (UIImage *)routeDetailTitleBgImage;
- (UIImage *)routeDetailAgencyBgImage;
- (UIImage *)bookButtonImage;
- (UIImage *)dailyScheduleTitleBgImageWithRowNum:(int)rowNum rowCount:(int)rowCount;

- (UIImage *)lineNavBgImage;
- (UIImage *)lineListBgImage;
- (UIImage *)tableBgImageWithRowNum:(int)rowNum rowCount:(int)rowCount;
- (UIImage *)tableLeftBgImageWithRowNum:(int)rowNum rowCount:(int)rowCount;
- (UIImage *)tableRightBgImageWithRowNum:(int)rowNum rowCount:(int)rowCount;
- (UIImage *)arrowImage;

- (UIImage *)bookingBgImage;

- (UIImage *)signUpBgImage;

@end
