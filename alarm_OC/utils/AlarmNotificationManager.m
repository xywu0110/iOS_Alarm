//
//  AlarmNotificationManager.m
//  alarm_OC
//
//  Created by xywu on 2024/1/21.
//

#import "AlarmNotificationManager.h"
#import "utils.h"

@implementation AlarmNotificationManager

+ (instancetype)defaultManager
{
    static AlarmNotificationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AlarmNotificationManager new];
    });
    return manager;
}

- (void)scheduleAlarmNotification:(AlarmInfo *)alarmInfo
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Alarm";
    content.body = alarmInfo.label ?: @"Time's up";
    content.sound = [UNNotificationSound defaultCriticalSound];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = alarmInfo.hour;
    components.minute = alarmInfo.minute;
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"alarm_notification" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Fail to send notification: %@", error.localizedDescription ? : @"unknown error");
        } else {
            NSLog(@"Send notification successfully");
        }
    }];
}

@end
