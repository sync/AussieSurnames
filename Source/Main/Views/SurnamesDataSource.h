#import <UIKit/UIKit.h>
#import "BaseTableViewDataSource.h"

#define ShowMorePlaceholder @"Load More Surnames..."

@interface SurnamesDataSource : BaseTableViewDataSource {

}

- (Surname *)surnameForIndexPath:(NSIndexPath *)indexPath;

@end
