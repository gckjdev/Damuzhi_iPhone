//
//  NonMemberOrderController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPViewController.h"
#import "TouristRoute.pb.h"
#import "OrderService.h"


@interface NonMemberOrderController : PPViewController <UITextFieldDelegate,UIAlertViewDelegate, OrderServiceDelegate>

@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UITextField *contactPersonTextField;
@property (retain, nonatomic) IBOutlet UITextField *telephoneTextField;

@property (retain, nonatomic) IBOutlet UIScrollView *backGroundScrollView;

- (id)initWithLocalRoute:(LocalRoute *)localRoute
               routeType:(int)routeType 
           departPlaceId:(int)departPlaceId
              departDate:(NSDate *)departDate
                   adult:(int)adult
                children:(int)children;

- (id)initWithRoute:(TouristRoute *)route
          routeType:(int)routeType
         departDate:(NSDate *)departDate
              adult:(int)adult
           children:(int)children 
          packageId:(int)packageId;

@end
