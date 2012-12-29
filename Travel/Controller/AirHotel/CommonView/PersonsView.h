//
//  PersonsView.h
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import <UIKit/UIKit.h>

@interface PersonsView : UIView

+ (CGFloat)getHeight:(NSArray *)personList;
+ (PersonsView *)createCheckInPersonLabels:(NSArray *)personList;

@end
