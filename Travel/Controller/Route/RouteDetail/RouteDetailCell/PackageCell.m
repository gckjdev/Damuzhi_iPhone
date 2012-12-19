//
//  PackageCell.m
//  Travel
//
//  Created by 小涛 王 on 12-7-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PackageCell.h"
#import "LocaleUtils.h"
#import "PPDebug.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "ImageManager.h"
#import "LocaleUtils.h"

#define FONT_DURATION_LABEL     [UIFont systemFontOfSize:13]
#define COLOR_DURATION_TITLE    [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1]
#define COLOR_DURATION_CONTENT  [UIColor colorWithRed:41.0/255.0 green:65.0/255.0 blue:80.0/255.0 alpha:1]

@interface PackageCell ()

@property (retain, nonatomic) TravelPackage *package;

@end

@implementation PackageCell

@synthesize aDelegate = _aDelegate;
@synthesize flightTitleButton = _flightTitleButton;
@synthesize flightButton = _flightButton;
@synthesize accommodationTitleButton = _accommodationTitleButton;
@synthesize package = _package;

- (void)dealloc {
    [_package release];
    [_flightTitleButton release];
    [_flightButton release];
    [_accommodationTitleButton release];
    [super dealloc];
}

+ (NSString *)getCellIdentifier
{
    return @"PackageCell";
}

- (UIImageView *)createAccessoryImage
{
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[[ImageManager defaultManager] accessoryImage]] autorelease];
    imageView.frame = CGRectMake(_flightButton.frame.size.width - 13, 10, 8, 8);
    
    return imageView;
}


#define TAG_LIGHTLABEL  12080301
- (void)createLightLabel
{
//    NSString *departTitle = NSLS(@"出发:");
//    NSString *departInfo = [NSString stringWithFormat:@"%@%@",_package.departFlight.company, _package.departFlight.flightId];
//    NSString *returnTitle = NSLS(@"回程:");
//    NSString *returnInfo = [NSString stringWithFormat:@"%@%@",_package.returnFlight.company, _package.returnFlight.flightId];
//    NSString *flightInfo = [NSString stringWithFormat:@"%@%@  %@%@",departTitle, departInfo, returnTitle, returnInfo];
//    
//    NSMutableAttributedString *aString = [NSMutableAttributedString attributedStringWithString:flightInfo];
//    NSRange range1 = [flightInfo rangeOfString:departTitle];
//    NSRange range2 = [flightInfo rangeOfString:departInfo];
//    NSRange range3 = [flightInfo rangeOfString:returnTitle];
//    NSRange range4 = [flightInfo rangeOfString:returnInfo];
//    [aString setTextColor:COLOR_DURATION_TITLE range:range1];
//    [aString setTextColor:COLOR_DURATION_TITLE range:range3];
//    [aString setTextColor:COLOR_DURATION_CONTENT range:range2];
//    [aString setTextColor:COLOR_DURATION_CONTENT range:range4];
//    [aString setFont:FONT_DURATION_LABEL];
//    [aString setTextBold:NO range:NSMakeRange(0,[aString length]-1)];
//    [aString setTextAlignment:kCTJustifiedTextAlignment lineBreakMode:kCTLineBreakByTruncatingTail];
//    
//    OHAttributedLabel *flightLabel = (OHAttributedLabel*)[_flightButton viewWithTag:TAG_LIGHTLABEL];
//    [flightLabel removeFromSuperview];
//    flightLabel = [[[OHAttributedLabel alloc] initWithFrame:CGRectMake(8, 6, _flightButton.frame.size.width - 20, _flightButton.frame.size.height)] autorelease];
//    flightLabel.backgroundColor = [UIColor clearColor];
//    flightLabel.tag = TAG_LIGHTLABEL;
//    if (_package.returnFlight.flightId == 0 && _package.departFlight.flightId == 0) {
//        aString =  [NSMutableAttributedString attributedStringWithString:@"                               暂没有信息"];
//        _flightButton.userInteractionEnabled = NO;
//        [aString setFont:FONT_DURATION_LABEL];// do not delete
//        flightLabel.attributedText = aString;
//        [_flightButton addSubview:flightLabel];
//        flightLabel.textColor = COLOR_DURATION_CONTENT;
//
//    }
//    else
//    {
//        flightLabel.attributedText = aString;
//        [_flightButton addSubview:flightLabel];
//        UIImageView *accessoryImage = [self createAccessoryImage];
//        [_flightButton addSubview:accessoryImage];
//    }
//  
}


#define WIDTH_DURATION  86.0
- (UIView *)acommodationViewWithFrame:(CGRect)frame
                        accommodation:(Accommodation *)accommodation 
                               isLast:(BOOL)isLast
{
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    
    [button addTarget:self action:@selector(clickAcommodation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackgroundImage = [[ImageManager defaultManager] accommodationBgImage:isLast];
    [button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    button.tag = accommodation.hotelId;
    
    CGRect durationFrame = CGRectMake(0, 1, WIDTH_DURATION, frame.size.height);
    UILabel *durationLabel = [[[UILabel alloc] init] autorelease];
    durationLabel.frame = CGRectMake(durationFrame.origin.x + 10, durationFrame.origin.y, durationFrame.size.width-10, durationFrame.size.height);
    durationLabel.backgroundColor = [UIColor clearColor];
    durationLabel.textColor = COLOR_DURATION_TITLE;
    durationLabel.font = FONT_DURATION_LABEL;
    durationLabel.text = accommodation.duration;
    [button addSubview:durationLabel];
    
    CGRect hotelFrame = CGRectMake(WIDTH_DURATION, 1, frame.size.width - WIDTH_DURATION, frame.size.height);
    UILabel *hotelLable = [[[UILabel alloc] init] autorelease];
    hotelLable.frame = CGRectMake(hotelFrame.origin.x +8 , hotelFrame.origin.y, hotelFrame.size.width-8, hotelFrame.size.height);
    hotelLable.backgroundColor = [UIColor clearColor];
    hotelLable.textColor = COLOR_DURATION_CONTENT;
    hotelLable.font = FONT_DURATION_LABEL;
    hotelLable.text = accommodation.hotelName;
    [button addSubview:hotelLable];
    
    UIImageView *accessoryImage = [self createAccessoryImage];
    [button addSubview:accessoryImage];
    
    return button;
}


- (void)setCellData:(TravelPackage *)package
{
    self.package = package;
    self.flightTitleButton.enabled = NO;
    self.accommodationTitleButton.enabled = NO;

    [self createLightLabel];
    
    CGFloat originX = _accommodationTitleButton.frame.origin.x + 10;
    CGFloat originY = _accommodationTitleButton.frame.origin.y + _accommodationTitleButton.frame.size.height;    
    CGFloat width = _accommodationTitleButton.frame.size.width;
    CGFloat height = _flightButton.frame.size.height;
    
    CGRect frame = CGRectMake(originX, originY, width, height);
    int count=0;
    for (Accommodation *accommodation in package.accommodationsList) {
        count++;
        BOOL isLast = (count == [package.accommodationsList count] ? YES : NO);
        
        UIView *view = [self acommodationViewWithFrame:frame accommodation:accommodation isLast:isLast];
        [self addSubview:view];
        
        originY += height;
        frame = CGRectMake(originX, originY , width, height);
    }
    
    if (count == 0) {
        UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
        UIImage *image = [UIImage imageNamed:@"line_table_6@2x.png"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:NSLS(@"暂没有信息") forState:UIControlStateNormal];
        [button setTitleColor:COLOR_DURATION_CONTENT forState:UIControlStateNormal];
        button.titleLabel.font = FONT_DURATION_LABEL;
        button.userInteractionEnabled = NO;
        [self addSubview:button];
    }
}

- (void)clickAcommodation:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int hotelId = button.tag;
    
    if ([_aDelegate respondsToSelector:@selector(didClickAccommodation:)]) {
        [_aDelegate didClickAccommodation:hotelId];
    }
}

- (IBAction)clickFilghtButton:(id)sender {
    if ([_aDelegate respondsToSelector:@selector(didClickFlight:)]) {
        [_aDelegate didClickFlight:_package.packageId];
    }
}

@end
