//
//  DepartPlaceMapController.m
//  Travel
//
//  Created by haodong on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DepartPlaceMapController.h"
#import "PlaceMapAnnotation.h"
#import "FontSize.h"

@interface DepartPlaceMapController ()

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (retain, nonatomic) NSString *placeName;
@property (assign, nonatomic) MKCoordinateSpan span;

@end

@implementation DepartPlaceMapController
@synthesize departPlaceMapView;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize placeName = _placeName;
@synthesize span = _span;

- (void)dealloc {
    [departPlaceMapView release];
    [_placeName release];
    [super dealloc];
}

- (id)initWithLatitude:(double)latitude 
             longitude:(double)longitude 
             placeName:(NSString *)placeName;
{
    self = [super init];
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.placeName = placeName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLS(@"出发地点");
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    _span = MKCoordinateSpanMake(0.005, 0.005);
    
    [self addMyLocationButton];
    [self showMapRegion];
    [self addAnnotation];
}

- (void)viewDidUnload
{
    [self setDepartPlaceMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)showMapRegion
{
    MKCoordinateRegion newRegion;
    newRegion.center = CLLocationCoordinate2DMake(_latitude, _longitude);
    newRegion.span = _span;
    [self.departPlaceMapView setRegion:newRegion animated:YES];
}

- (void)addAnnotation
{
    PlaceMapAnnotation *annotation = [[[PlaceMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(_latitude, _longitude)] autorelease];
    annotation.title = _placeName;
    [self.departPlaceMapView addAnnotation:annotation];
    [self.departPlaceMapView selectAnnotation:annotation animated:NO];
}

- (void)clickMyLocationBtn:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    if (button.selected) {
        self.departPlaceMapView.showsUserLocation = YES;
    }else {
        self.departPlaceMapView.showsUserLocation = NO;
        [self showMapRegion];
    }
}

- (void)addMyLocationButton
{
    UIButton *locateButton = [[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-35, self.view.frame.size.height-35, 31, 31)] autorelease];
    
    [locateButton setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [locateButton setImage:[UIImage imageNamed:@"locate_back.png"] forState:UIControlStateSelected];
    
    [locateButton addTarget:self action:@selector(clickMyLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.departPlaceMapView addSubview:locateButton];
}

- (void)selectAnnotation:(id <MKAnnotation>)annotation
{
    [self.departPlaceMapView selectAnnotation:annotation animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"DepartPlaceIdentifier";
    MKPinAnnotationView *customView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (customView == nil) {
        customView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        customView.pinColor = MKPinAnnotationColorRed;
        customView.canShowCallout = YES;
        
        [self performSelector:@selector(selectAnnotation:) withObject:annotation afterDelay:0.3f];
    }
    
    return customView;
}

- (void)mapView:(MKMapView *)mapView1 didUpdateUserLocation:(MKUserLocation *)userLocation
{
    PPDebug(@"current location: %f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    MKCoordinateRegion newRegion;
    newRegion.center = userLocation.location.coordinate;
    newRegion.span = _span;
    [self.departPlaceMapView setRegion:newRegion animated:NO];
}

@end
