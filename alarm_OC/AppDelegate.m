//
//  AppDelegate.m
//  alarm_OC
//
//  Created by xywu on 2023/12/10.
//

#import "AppDelegate.h"
#import "utils.h"
#import "AlarmViewController.h"
#import "StopWatchViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self setupTabBarController];
    [self registerNotification];
    [self setupAudioSession];
    [self.window makeKeyAndVisible];

    return YES;
}

- (UITabBarController *)setupTabBarController
{
    AlarmViewController* alarmVC = [[AlarmViewController alloc] init];
    UIImage *unselectedIcon = [UIImage imageNamed:@"alarm_gray"];
    UIImage *selectedIcon = [UIImage imageNamed:@"alarm_orange"];
    alarmVC.tabBarItem = [self setupTabBarItemWithTitle:@"Alarms" defaultIcon:unselectedIcon selectedIcon:selectedIcon];
    UINavigationController * alarmNavController = [[UINavigationController alloc]initWithRootViewController:alarmVC];
    [alarmNavController.navigationBar setTranslucent:NO];
    alarmNavController.navigationBar.backgroundColor = [UIColor blackColor];
    
    StopWatchViewController* stopWatchVC = [[StopWatchViewController alloc] init];
    unselectedIcon = [UIImage imageNamed:@"stopwatch_gray"];
    selectedIcon = [UIImage imageNamed:@"stopwatch_orange"];
    stopWatchVC.tabBarItem = [self setupTabBarItemWithTitle:@"StopWatch" defaultIcon:unselectedIcon selectedIcon:selectedIcon];
    UINavigationController * stopWatchNavController = [[UINavigationController alloc]initWithRootViewController:stopWatchVC];
    stopWatchNavController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UITabBarController* tabController = [[UITabBarController alloc] init];
    NSArray* vcArray = [NSArray arrayWithObjects:alarmNavController, stopWatchNavController, nil];
    tabController.viewControllers = vcArray;
    tabController.tabBar.translucent = NO;
    tabController.tabBar.tintColor = UIColorFromHexString(0xFFA500);    // orange
    tabController.tabBar.unselectedItemTintColor = UIColorFromHexString(0xBFBFBF);  // gray
    
    return tabController;
}

- (UITabBarItem *)setupTabBarItemWithTitle:(NSString *)title defaultIcon:(UIImage *)unselectedIcon selectedIcon:(UIImage *)selectedIcon
{
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:nil tag:0];
    UIImage *unselectedImage = resizeImage(unselectedIcon, CGSizeMake(26, 26));
    UIImage *selectedImage = resizeImage(selectedIcon, CGSizeMake(26, 26));
    tabBarItem.image =[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.selectedImage =[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return tabBarItem;
}

- (void)setupAudioSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

- (void)registerNotification
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error && granted) {
            NSLog(@"notification request authorization approved");
        } else {
            NSLog(@"notification request authorization denied");
        }
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

@end
