#import "APIServices+Parsing.h"
#import "APIServices+Utils.h"
#import "NSObject+JSONSerializableSupport.h"
#import "ObjectiveResourceDateFormatter.h"

@implementation APIServices (parsing)

- (void)parseSurnames:(ASIHTTPRequest *)request;
{
	if ([request.responseData length] != 0)  {
		
		//	"surname": {
		//		"name": "AAZAMI",
		//		"amount": 2,
		//		"id": 142
		//	}
		
		[ObjectiveResourceDateFormatter setSerializeFormat:DateTime];
		NSArray *content = [NSArray fromJSONData:request.responseData];
		
		
		NSDictionary *info = request.userInfo;
		[self notifyDone:request object:[NSDictionary dictionaryWithObjectsAndKeys:
										 content, @"surnames",
										 [info valueForKey:@"object"], @"object",
										 nil
										 ]];
	}
}

@end
