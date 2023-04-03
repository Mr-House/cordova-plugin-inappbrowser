
#import "UIViewController+Present.h"
#import <objc/runtime.h>
@implementation UIViewController (Present)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(dy_presentViewController:animated:completion:));
        
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

- (void)dy_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {

    UIViewController *currentVc = [self topViewController];
    if ([currentVc  isKindOfClass:[UIAlertController class]]) {
        [self dy_presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [[self topViewController] dy_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    
}
- (UIViewController *)topViewController {
    
    UIViewController *topVC;

    topVC = [self getTopViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];

    while (topVC.presentedViewController) {
      topVC = [self getTopViewController:topVC.presentedViewController];
    }

    return topVC;
    
}
- (UIViewController *)getTopViewController:(UIViewController *)vc {
    
    if (![vc isKindOfClass:[UIViewController class]]) {
      return nil;
    }    
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
      return [self getTopViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
      return [self getTopViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
      return vc;
    }
    
}
@end