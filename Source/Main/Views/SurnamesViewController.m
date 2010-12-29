#import "SurnamesViewController.h"

@interface SurnamesViewController (private)

- (void)refreshSurnames;
- (void)reloadSurnames:(NSArray *)newPlaces removeCache:(BOOL)removeCache showMore:(BOOL)showMore;

@end

@implementation SurnamesViewController

@synthesize surnamesDataSource, searchBar, errorLabel, page, surnames;

#pragma mark -
#pragma mark Initialisation

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Australian Surnames";
	
	[self.searchBar becomeFirstResponder];
	
	self.page = 1;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	self.searchBar = nil;
	self.errorLabel = nil;
}

#pragma mark -
#pragma mark Setup

- (void)setupDataSource
{
	[super setupDataSource];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReloadContent:) name:SurnamesShouldReloadContentNotification object:nil];
	[[BaseLoadingViewCenter sharedBaseLoadingViewCenter]addObserver:self forKey:SurnamesShouldReloadContentNotification];
	
	self.surnamesDataSource = [[[SurnamesDataSource alloc]init]autorelease];
	self.tableView.dataSource = self.surnamesDataSource;
	[self refreshSurnames];
}

#pragma mark -
#pragma mark Content reloading

- (void)shouldReloadContent:(NSNotification *)notification
{
	NSDictionary *dict = [notification object];
	
	NSNumber *currentPage = [dict valueForKey:@"object"];
	self.page = currentPage.integerValue;
	
	NSArray *newSurnames = [dict valueForKey:@"surnames"];
	[self reloadSurnames:newSurnames removeCache:(self.page == 1) showMore:newSurnames.count == 100];
}

- (NSMutableArray *)surnames
{
	if (!surnames) {
		surnames = [[NSMutableArray alloc]init];
	}
	
	return surnames;
}

- (void)reloadSurnames:(NSArray *)newSurnames removeCache:(BOOL)removeCache showMore:(BOOL)showMore
{
	[self.surnamesDataSource resetContent];
	
	if (removeCache) {
		[self.surnames removeAllObjects];
	}
	
	if (newSurnames) {
		[self.surnames addObjectsFromArray:newSurnames];
	}
	
	[self.surnamesDataSource.content addObjectsFromArray:self.surnames];
	
	if (showMore) {
		Surname *showMoreSurnames = [[[Surname alloc]init]autorelease];
		showMoreSurnames.surnameId = [NSNumber numberWithInt:NSNotFound];
		showMoreSurnames.name = ShowMorePlaceholder;
		[self.surnamesDataSource.content addObject:showMoreSurnames];
	}
	
	[self.tableView reloadData];
	
	self.errorLabel.text = @"No Matches!";
	self.errorLabel.hidden = (self.surnames.count != 0);
}

#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	Surname *surname  = [self.surnamesDataSource surnameForIndexPath:indexPath];
	
	if (surname.surnameId.integerValue == NSNotFound) {
		self.page += 1;
		if (self.searchString.length > 0) {
			[[APIServices sharedAPIServices]refreshSurnamesForSearchString:self.searchString page:self.page];
		} else {
			[[APIServices sharedAPIServices]refreshSurnamesForPage:self.page];
		}
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[super scrollViewDidScroll:scrollView];
	
	if (!scrollView.dragging || scrollView.decelerating) {
		return;
	}
	
	[self.searchBar resignFirstResponder];
}

- (void)showRefreshHeaderView
{
	[super showRefreshHeaderView];
	
	self.searchString = self.searchBar.text;
	if (self.searchString.length > 0) {
		[self filterContentForSearchText:self.searchString scope:nil];
	} else {
		[self refreshSurnames];
	}
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
	if ([aSearchBar.text isEqualToString:self.searchString]) {
		return;
	}
	[self filterContentForSearchText:aSearchBar.text scope:nil];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[self.searchBar resignFirstResponder];
	self.searchString = searchText;
	
	self.page = 1;
	[[APIServices sharedAPIServices]refreshSurnamesForSearchString:self.searchString page:self.page];
}


#pragma mark -
#pragma mark Actions

- (void)refreshSurnames
{
	self.page = 1;
	
	[[APIServices sharedAPIServices]refreshSurnamesForPage:self.page];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[BaseLoadingViewCenter sharedBaseLoadingViewCenter]removeObserver:self forKey:SurnamesShouldReloadContentNotification];
	
	[surnames release];
	[errorLabel release];
	[searchBar release];
	[surnamesDataSource release];
	
	[super dealloc];
}

@end
