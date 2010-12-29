// Timeout Request
#define RequestTimeOutSeconds 30.0

// URL
#define BASE_URL @"http://australian-surnames.heroku.com"
#define BASEURL(base, path) [NSString stringWithFormat:@"%@%@", base, path]
// 
#define SURNAMES_PATH @"/"
#define SURNAMESURL(base, path, page) [NSString stringWithFormat:@"%@?page=%d", BASEURL(base, path), page]
#define SEARCHURL(base, path, searchString, page) [NSString stringWithFormat:@"%@?q=%@&page=%d", BASEURL(base, path), searchString, page]

// Notifications
#define SurnamesShouldReloadContentNotification @"SurnamesShouldReloadContentNotification"
