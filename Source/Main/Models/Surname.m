#import "Surname.h"


@implementation Surname

@synthesize name, amount, surnameId;

- (void)dealloc
{
	[name release];
	[amount release];
	[surnameId release];
	
	[super dealloc];
}

@end
