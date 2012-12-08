//
//  SelectPersonController.h
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "PPTableViewController.h"
#import "SelectPersonCell.h"
#import "PersonManager.h"

@protocol SelectPersonControllerDelegate <NSObject>

@optional
- (void)finishSelectPerson:(PersonType)personType objectList:(NSArray *)objectList;
 
@end


@interface SelectPersonController : PPTableViewController <SelectPersonCellDelegate>

- (id)initWithType:(PersonType)personType
  isMultipleChoice:(BOOL)isMultipleChoice
          delegate:(id<SelectPersonControllerDelegate>)delegate;

@end
