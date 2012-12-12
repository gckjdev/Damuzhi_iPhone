//
//  SelectAirCityController.h
//  Travel
//
//  Created by haodong on 12-12-8.
//
//

#import "PPTableViewController.h"
#import "App.pb.h"

@protocol SelectAirCityControllerDelegate <NSObject>

@optional
- (void)didSelectCity:(AirCity *)city;

@end

@interface SelectAirCityController : PPTableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

- (id)initWithCityList:(NSArray *)cityList delegate:(id<SelectAirCityControllerDelegate>)delegate;

@end
