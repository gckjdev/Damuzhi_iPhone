//
//  MapUtils.h
//  Travel
//
//  Created by gckj on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Place.pb.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapUtils : NSObject

+ (BOOL)isValidLatitude:(CGFloat)latitude 
              Longitude:(CGFloat)longitude;

+ (void)setMapSpan:(MKMapView*)mapView span:(MKCoordinateSpan)span;
+ (void)gotoLocation:(MKMapView*)mapView 
            latitude:(CLLocationDegrees)latitude 
           longitude:(CLLocationDegrees)longitude 
                span:(MKCoordinateSpan)span
;

//+ (UIButton*)createAnnotationViewWith:(Place*)place placeList:(NSArray*)placeList;
+ (void) showCallout:(MKAnnotationView*)annotationView imageName:(NSString*)imageName tag:(NSInteger)tag target:(id)target;
@end
