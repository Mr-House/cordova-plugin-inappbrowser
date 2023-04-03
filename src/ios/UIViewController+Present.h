
#import <UIKit/UIKit.h>

@interface UIViewController (Present)

+ (void)load;

- (void)dy_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

- (UIViewController *)topViewController;

- (UIViewController *)getTopViewController:(UIViewController *)vc;
@end