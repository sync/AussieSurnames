#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate, UINavigationBarDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;



+ (AppDelegate *)sharedAppDelegate;

@end

