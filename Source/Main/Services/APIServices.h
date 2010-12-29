#import <Foundation/Foundation.h>
#import "BaseServices.h"

@interface APIServices : BaseServices <BaseServicesContentManagement> {

}

+ (APIServices *)sharedAPIServices;

- (void)refreshSurnamesForPage:(NSInteger)page;
- (void)refreshSurnamesForSearchString:(NSString *)searchString page:(NSInteger)page;

@end
