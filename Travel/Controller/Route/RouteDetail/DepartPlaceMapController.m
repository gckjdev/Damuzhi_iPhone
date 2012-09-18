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

@end

@implementation DepartPlaceMapController
@synthesize departPlaceMapView;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize placeName = _placeName;


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
    
    MKCoordinateRegion newRegion;
    newRegion.center = CLLocationCoordinate2DMake(_latitude, _longitude);
    newRegion.span = MKCoordinateSpanMake(0.004, 0.004);
    [self.departPlaceMapView setRegion:newRegion animated:YES];
    
    PlaceMapAnnotation *annotation = [[[PlaceMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(_latitude, _longitude)] autorelease];
    annotation.title = _placeName;
    
    [self.departPlaceMapView addAnnotation:annotation];
    
    [self.departPlaceMapView selectAnnotation:annotation animated:YES];
    
}

- (void)viewDidUnload
{
    [self setDepartPlaceMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)selectAnnotation:(id <MKAnnotation>)annotation
{
    [self.departPlaceMapView selectAnnotation:annotation animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
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



@end
