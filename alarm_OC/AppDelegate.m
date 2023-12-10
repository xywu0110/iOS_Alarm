//
//  AppDelegate.m
//  alarm_OC
//
//  Created by XiaoyangWu on 2023/12/10.
//

#import "AppDelegate.h"
#import "MainPageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:[[MainPageViewController alloc] init]];
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
