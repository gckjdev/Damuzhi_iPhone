//
//  PlaceCell.h
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonPlaceCell.h"
#import "HJManagedImageV.h"

@interface PlaceCell : CommonPlaceCell<HJManagedImageVDelegate>

@property (retain, nonatomic) IBOutlet UIView *summaryView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLable;
@property (retain, nonatomic) IBOutlet UILabel *distanceLable;
@property (retain, nonatomic) IBOutlet UILabel *areaLable;
@property (retain, nonatomic) IBOutlet UILabel *categoryLable;
@property (retain, nonatomic) IBOutlet HJManagedImageV *imageView;
@property (retain, nonatomic) IBOutlet UIImageView *praise1View;
@property (retain, nonatomic) IBOutlet UIImageView *praise2View;
@property (retain, nonatomic) IBOutlet UIImageView *praise3View;
@property (retain, nonatomic) IBOutlet UIImageView *favoritesView;

+ (PlaceCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;

@end
