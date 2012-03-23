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
#import "CommonPlace.h"
#import "ImageName.h"
#import "UIImageUtil.h"
#import "PlaceMapViewController.h"

@implementation CommonPlaceDetailController
@synthesize buttonHolerView;
@synthesize imageHolderView;
@synthesize dataScrollView;
@synthesize place;
@synthesize helpIcon;
@synthesize praiseIcon1;
@synthesize praiseIcon2;
@synthesize praiseIcon3;
@synthesize handler;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id<CommonPlaceDetailDataSourceProtocol>)createPlaceHandler:(Place*)onePlace
{
    if ([onePlace categoryId] == PLACE_TYPE_SPOT){
        return [[[SpotDetailViewHandler alloc] init] autorelease];
    }
    return nil;
}

- (id)initWithPlace:(Place *)onePlace
{
    self = [super init];
    self.place = onePlace;    
    self.handler = [self createPlaceHandler:onePlace];     
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)setRankImage:(int32_t)rank
{
    self.praiseIcon1.image = [UIImage imageNamed:IMAGE_GOOD2];
    self.praiseIcon2.image = [UIImage imageNamed:IMAGE_GOOD2];
    self.praiseIcon3.image = [UIImage imageNamed:IMAGE_GOOD2];
    
    switch (rank) {
        case 1:
            [praiseIcon1 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        case 2:
            [praiseIcon1 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praiseIcon2 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        case 3:
            [praiseIcon1 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praiseIcon2 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praiseIcon3 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        default:
            break;
    }
    
    return;
}

- (void)clickMap:(id)sender
{
    NSLog(@"click map");
    PlaceMapViewController* controller = [[PlaceMapViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller gotoLocation:self.place];
    [controller release];
}

- (void)clickTelephone:(id)sender
{
    NSLog(@"click telephone");
}

- (void)clickFavourite:(id)sender
{
    NSLog(@"click favourite");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationLeftButton:NSLS(@"返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"") 
                         imageName:@"map_po.png" 
                            action:@selector(clickMap:)];
    
    buttonHolerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topmenu_bg2"]];
    
    [self setRankImage:[self.place rank]];
    

    SlideImageView* slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    [imageHolderView addSubview:slideImageView];  
    
//    // add image array
//    NSArray* imagePathArray = [self.place imagesList];
//    NSMutableArray* images = [[[NSMutableArray alloc] init] autorelease];
//    for (NSString* imagePath in imagePathArray){
//        NSLog(@"%@", imagePath);
//        [images addObject:[UIImage imageNamed:imagePath]];
//    }
//    [slideImageView setImages:images];
        
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 3)];
    paddingView.backgroundColor = [UIColor colorWithRed:40/255.0 green:123/255.0 blue:181/255.0 alpha:1.0];
    [dataScrollView addSubview:paddingView];
    [paddingView release];
    
    [self.handler addDetailViews:dataScrollView WithPlace:self.place];
    
    float detailHeight = [self.handler detailHeight];
    dataScrollView.backgroundColor = [UIColor clearColor];
    [dataScrollView setContentSize:CGSizeMake(320, detailHeight + 266)];

    //电话
    UIView *telephoneView = [[UIView alloc]initWithFrame:CGRectMake(0, detailHeight, 320, 32)];
    telephoneView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"t_bg"]];
    UILabel *telephoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 4, 250, 20)];
    telephoneLabel.backgroundColor = [UIColor clearColor];
    telephoneLabel.textColor = [UIColor colorWithRed:89/255.0 green:112/255.0 blue:129/255.0 alpha:1.0];
    telephoneLabel.font = [UIFont boldSystemFontOfSize:12];
    NSString *tel = [[[NSString alloc]initWithFormat:@"电话:"] autorelease];
    NSArray *telephoneList = [self.place telephoneList];
    for (NSString* telephone in telephoneList) {
        tel = [tel stringByAppendingFormat:@" ", telephone];
    }
    telephoneLabel.text = tel;
    [telephoneView addSubview:telephoneLabel];
    [telephoneLabel release];
    
    UIButton *telButton = [[UIButton alloc]initWithFrame:CGRectMake(290, 4, 24, 24)];
	[telButton setImage:[UIImage imageNamed:@"t_phone"] forState:UIControlStateNormal];     
    [telButton addTarget:self action:@selector(clickTelephone:) forControlEvents:UIControlEventTouchUpInside];
    
    [telephoneView addSubview:telButton];
    [telButton release];
    
    [dataScrollView addSubview:telephoneView];
    [telephoneView release];
    
    //地址
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, telephoneView.frame.origin.y + telephoneView.frame.size.height, 320, 32)];
    addressView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"t_bg"]];
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 4, 250, 20)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor colorWithRed:89/255.0 green:112/255.0 blue:129/255.0 alpha:1.0];
    addressLabel.font = [UIFont boldSystemFontOfSize:12];
    NSString *addr = [[[NSString alloc]initWithFormat:@"地址:"] autorelease];
    NSArray *addressList = [self.place addressList];
    for (NSString* address in addressList) {
        addr = [addr stringByAppendingFormat:@" ", address];
    }
    addressLabel.text = addr;
    [addressView addSubview:addressLabel];
    [addressLabel release];
    
    UIButton *mapButton = [[UIButton alloc]initWithFrame:CGRectMake(290, 4, 24, 24)];
    [mapButton setImage:[UIImage imageNamed:@"t_map"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(clickMap:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:mapButton];
    [mapButton release];
    
    [dataScrollView addSubview:addressView];
    [addressView release];
    
    //网站
    UIView *websiteView = [[UIView alloc]initWithFrame:CGRectMake(0, addressView.frame.origin.y + addressView.frame.size.height, 320, 32)];
        websiteView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"t_bg"]];
    UILabel *websiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 4, 250, 20)];
    websiteLabel.backgroundColor = [UIColor clearColor];
    websiteLabel.textColor = [UIColor colorWithRed:89/255.0 green:112/255.0 blue:129/255.0 alpha:1.0];
    websiteLabel.font = [UIFont boldSystemFontOfSize:12];
    NSString *website = @"网站: ";
    websiteLabel.text = [website stringByAppendingString:[self.place website]];
    [websiteView addSubview:websiteLabel];
    [websiteLabel release];
    
    [dataScrollView addSubview:websiteView];
    [websiteView release];
    
    UIView *favouritesView = [[UIView alloc]initWithFrame:CGRectMake(0, websiteView.frame.origin.y + websiteView.frame.size.height, 320, 60)];
    favouritesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottombg"]];
    
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 10, 130, 27)];
    [favButton addTarget:self action:@selector(clickFavourite:) forControlEvents:UIControlEventTouchUpInside];
    favButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fov"]];
    [favouritesView addSubview:favButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, 120, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    label.text = @"(已有673人收藏)";
    label.font = [UIFont boldSystemFontOfSize:13];
    [favouritesView addSubview:label];
    
    [dataScrollView addSubview:favouritesView];
    [label release];
    [favButton release];
    [favouritesView release];
}

- (void)viewDidUnload
{
    [self setImageHolderView:nil];
    [self setDataScrollView:nil];
    [self setPlace:nil];
    [self setButtonHolerView:nil];
    [self setHelpIcon:nil];
    [self setPraiseIcon1:nil];
    [self setPraiseIcon2:nil];
    [self setPraiseIcon3:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [imageHolderView release];
    [dataScrollView release];
    [place release];
    [buttonHolerView release];
    [helpIcon release];
    [praiseIcon1 release];
    [praiseIcon2 release];
    [praiseIcon3 release];
    [super dealloc];
}
@end
