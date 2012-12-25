//
//  SelectPersonController.h
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "PPTableViewController.h"
#import "SelectPersonCell.h"


@protocol SelectPersonControllerDelegate <NSObject>

@optional
- (void)finishSelectPerson:(SelectPersonViewType)type objectList:(NSArray *)objectList;
 
@end




@interface SelectPersonController : PPTableViewController <SelectPersonCellDelegate>
@property (retain, nonatomic) IBOutlet UILabel *headeTitleLabel;

- (id)initWithType:(SelectPersonViewType)type
  isMultipleChoice:(BOOL)isMultipleChoice
          delegate:(id<SelectPersonControllerDelegate>)delegate
             title:(NSString *)title;

@end
