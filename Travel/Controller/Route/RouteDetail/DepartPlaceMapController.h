//
//  DepartPlaceMapController.h
//  Travel
//
//  Created by haodong on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"
#import <MapKit/MapKit.h>

@interface DepartPlaceMapController : PPViewController<MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *departPlaceMapView;

- (id)initWithLatitude:(double)latitude 
             longitude:(double)longitude 
             placeName:(NSString *)placeName;

@end
