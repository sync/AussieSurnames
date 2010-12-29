#import <Foundation/Foundation.h>
#import "BaseTableViewRefreshController.h"
#import "SurnamesDataSource.h"

@interface SurnamesViewController : BaseTableViewRefreshController <UISearchBarDelegate> {

}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;

@property (nonatomic, retain) SurnamesDataSource *surnamesDataSource;
@property (nonatomic, readonly) NSMutableArray *surnames;

@property (nonatomic) NSInteger page;

@end
