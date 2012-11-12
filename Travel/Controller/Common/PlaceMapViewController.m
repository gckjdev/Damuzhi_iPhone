/*
     File: MapViewController.m 
 Abstract: The primary view controller containing the MKMapView, adding and removing both MKPinAnnotationViews through its toolbar. 
  Version: 1.0 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "PlaceMapViewController.h"
#import "PlaceMapAnnotation.h"
#import "Place.pb.h"
#import "CommonPlaceDetailController.h"
#import "AppUtils.h"
#import "UIImageUtil.h"
#import "MapUtils.h"
#import "AppUtils.h"
#import "UIViewUtils.h"
#import "FontSize.h"
@interface PlaceMapViewController ()
{
    MKCoordinateSpan _span;
}


@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSArray* placeList;
@property (nonatomic, assign) UINavigationController* superNavigationController;


- (void)loadAllAnnotations;

@end

@implementation PlaceMapViewController

@synthesize mapView = _mapView;
@synthesize placeList = _placeList;
@synthesize superNavigationController = _superNavigationController;

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;   
    _mapView.showsUserLocation = NO;
    
    _span = MKCoordinateSpanMake(0.028, 0.028);
    [MapUtils setMapSpan:_mapView span:_span];
    
    [self addMyLocationBtnTo:self.view];
}

- (void)viewDidUnload
{
    self.mapView = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
    PPRelease(_placeList);
    PPRelease(_mapView); 
    [super dealloc];
}

- (id)initWithSuperNavigationController:(UINavigationController*)superNavigationController
{
    self = [super init];
    if (self) {
        self.superNavigationController = superNavigationController;
    }
    
    return self;
}

- (void)showInView:(UIView*)superView 
{   
    [superView removeAllSubviews];
    
    [self.view setFrame:superView.bounds];
    [superView addSubview:self.view];
}

- (void)setPlaces:(NSArray*)placeList
{
    if (placeList == _placeList) {
        return;
    }
    
    self.placeList = placeList;

    if ([_placeList count] != 0) {
        Place *place = [_placeList objectAtIndex:0];
        [MapUtils gotoLocation:_mapView
                      latitude:place.latitude 
                     longitude:place.longitude
                          span:_span];
    }
    
    [self loadAllAnnotations];
}

- (void)loadAllAnnotations
{    
    NSMutableArray *mapAnnotations = [[NSMutableArray alloc] init];
    if (_placeList && _placeList.count > 0) {
        for (Place *place in _placeList) {
            if ([MapUtils isValidLatitude:[place latitude] Longitude:[place longitude]]) {
                PlaceMapAnnotation *placeAnnotation = [[PlaceMapAnnotation alloc]initWithPlace:place];
                [mapAnnotations addObject:placeAnnotation];
                [placeAnnotation release];
            }
        } 
    }
    
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:mapAnnotations];
    [mapAnnotations release];
}

- (void)showUserLocation:(BOOL)isShow
{
    _mapView.showsUserLocation = isShow;
}

- (void)clickMyLocationBtn:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    if (button.selected) {
        _mapView.showsUserLocation = YES;       
    }else {
        _mapView.showsUserLocation = NO;
        Place *place = [_placeList objectAtIndex:0];
        [MapUtils gotoLocation:_mapView latitude:place.latitude longitude:place.longitude span:_span];
    }
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.028, 0.028);
    [MapUtils setMapSpan:_mapView span:span];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView1 didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [MapUtils gotoLocation:mapView1 latitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude span:_span];
}

//The event handling method
- (void)notationAction:(id)sender
{        
    UIButton *button = sender;
    NSInteger index = button.tag;
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc]initWithPlace:[_placeList objectAtIndex:index]];
    [_superNavigationController pushViewController:controller animated:YES];
    [controller release];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our custom annotations
    if([annotation isKindOfClass:[PlaceMapAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* annotationIdentifier = @"mapAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
        if (pinView == nil)
        {
            MKAnnotationView* annotationView = [[[MKAnnotationView alloc]
                                                 initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
            PlaceMapAnnotation *placeAnnotation = (PlaceMapAnnotation*)annotation;
            
            NSInteger tag = [_placeList indexOfObject:placeAnnotation.place];
            NSString *fileName = [AppUtils getCategoryPinIcon:placeAnnotation.place.categoryId];
            [MapUtils showCallout:annotationView imageName:fileName tag:tag target:self];

            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
            
        }
        return pinView;

    }
    
    return nil;
}

- (void)addMyLocationBtnTo:(UIView*)view
{
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-31, view.frame.size.height-31, 31, 31)];  
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-35, 342, 31, 31)];            

//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];            

    [button setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"locate_jt.png"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickMyLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button release];
}

@end
