#import "SurnamesDataSource.h"

@implementation SurnamesDataSource

- (Surname *)surnameForIndexPath:(NSIndexPath *)indexPath
{
	return [self objectForIndexPath:indexPath];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
#define SurnamesCellIdentifier @"SurnamesCellIdentifier"
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SurnamesCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SurnamesCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
	Surname *surname = [self surnameForIndexPath:indexPath];
	
	cell.textLabel.text = surname.name;
	
	if (surname.surnameId.integerValue == NSNotFound) {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	} else {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", surname.amount];
	}
	
    return cell;
}

@end
