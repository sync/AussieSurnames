#import "APIServices.h"
#import "APIServices+Utils.h"
#import "APIServices+Parsing.h"

@implementation APIServices

SYNTHESIZE_SINGLETON_FOR_CLASS(APIServices)

#pragma mark -
#pragma mark Surnames

- (void)refreshSurnamesForPage:(NSInteger)page
{
	NSString *notificationName = SurnamesShouldReloadContentNotification;
	NSString *path = @"surnames";
	
	NSString *url = SURNAMESURL(BASE_URL, SURNAMES_PATH, page);
	[self downloadContentForUrl:url withObject:[NSNumber numberWithInteger:page] path:path notificationName:notificationName];
}

- (void)refreshSurnamesForSearchString:(NSString *)searchString page:(NSInteger)page;
{
	NSString *notificationName = SurnamesShouldReloadContentNotification;
	NSString *path = @"surnamesForSearchString";
	
	if (!searchString) {
		return;
	}
	
	NSString *url = SEARCHURL(BASE_URL, SURNAMES_PATH, [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], page);
	[self downloadContentForUrl:url withObject:[NSNumber numberWithInteger:page] path:path notificationName:notificationName];
}

#pragma mark -
#pragma mark Content Management

- (void)downloadContentForUrl:(NSString *)url withObject:(id)object path:(NSString *)path notificationName:(NSString *)notificationName
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  path, @"path",
							  notificationName, @"notificationName",
							  object, @"object",
							  nil];
	
	ASIHTTPRequest *request = [self requestWithUrl:url];
	request.userInfo = userInfo;
	request.delegate = self;
	
	[self.networkQueue addOperation:request];
	[self.networkQueue go];
	[[BaseLoadingViewCenter sharedBaseLoadingViewCenter]didStartLoadingForKey:[self notificationNameForRequest:request]];
}

#pragma mark -
#pragma mark ASIHTTPRequest delegate

- (void)fetchStarted:(ASIHTTPRequest *)request
{
	DLog(@"fetch started for url: %@", request.url);
}

- (void)fetchCompleted:(ASIHTTPRequest *)request
{
	NSError *error = request.error;
	if (error) {
		DLog(@"wserror: %@", error);
		[[BaseLoadingViewCenter sharedBaseLoadingViewCenter]showErrorMsg:[error localizedDescription] forKey:[self notificationNameForRequest:request]];
	} else {
		NSDictionary *info = request.userInfo;
		NSString *path = [info valueForKey:@"path"];
		
		if ([path isEqualToString:@"surnames"] ||
			[path isEqualToString:@"surnamesForSearchString"]) {
			[self parseSurnames:request];
		}
	}
	
	DLog(@"fetch completed for url: %@ error:%@", request.originalURL, [request.error localizedDescription]);
}

- (void)fetchFailed:(ASIHTTPRequest *)request
{
	DLog(@"fetch failed for url: %@ error:%@", request.originalURL, [request.error localizedDescription]);
	
	[[BaseLoadingViewCenter sharedBaseLoadingViewCenter]showErrorMsg:[request.error localizedDescription] forKey:[self notificationNameForRequest:request]];
	[[BaseLoadingViewCenter sharedBaseLoadingViewCenter]didStopLoadingForKey:[self notificationNameForRequest:request]];
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
	DLog(@"queue finished for service: %@", NSStringFromClass([self class]));
	
}

@end
