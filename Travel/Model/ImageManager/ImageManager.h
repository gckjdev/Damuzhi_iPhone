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

- (UIImage *)rankGoodImage;
- (UIImage *)rankBadImage;

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
- (UIImage *)arrowRightImage;

//- (UIImage *)bookingBgImage;

- (UIImage *)signUpBgImage;
- (UIImage *)selectDownImage;

- (UIImage *)morePointImage;
- (UIImage *)accessoryImage;

- (UIImage *)orderListHeaderView:(int)rowNum rowCount:(int)rowCount open:(BOOL)open;
- (UIImage *)orderListCellBgImage:(int)rowNum rowCount:(int)rowCount;

- (UIImage *)orangePoint;
- (UIImage *)orderTel;

- (UIImage *)routeFeekbackBgImage1;
- (UIImage *)routeFeekbackBgImage2;

- (UIImage *)routeClassifyButtonBgImage1WithRow:(int)row
                                         column:(int)column
                                      totalRows:(int)totalRows  
                                    totalColumn:(int)totalColumn;

- (UIImage *)routeClassifyButtonBgImage2WithRow:(int)row
                                         column:(int)column
                                      totalRows:(int)totalRows  
                                    totalColumn:(int)totalColumn;

- (UIImage *)flyImage;
- (UIImage *)accommodationBgImage:(BOOL)isLast;

- (UIImage *)placeTourBgImage;
- (UIImage *)placeTourBtnBgImage;

- (UIImage *)allBackgroundImage;

- (UIImage *)hotelListBgImage;
- (UIImage *)flightListTopBgImage;
- (UIImage *)flightListBottomBgImage;

@end
