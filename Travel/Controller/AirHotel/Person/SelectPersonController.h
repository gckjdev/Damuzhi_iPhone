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
@property (retain, nonatomic) IBOutlet UIView *headerHolderView;
@property (retain, nonatomic) IBOutlet UILabel *headeTitleLabel;

- (id)initWithType:(SelectPersonViewType)type
       selectCount:(NSUInteger)selectCount
          delegate:(id<SelectPersonControllerDelegate>)delegate
             title:(NSString *)title
          isSelect:(BOOL)isSelect
          isMember:(BOOL)isMember;

@end
